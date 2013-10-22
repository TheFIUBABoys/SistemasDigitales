--------------------------------------------------------------------------
-- Modulo: Controlador VGA
-- Descripción: 
-- Autor: Sistemas Digitales (66.17)
--        Universidad de Buenos Aires - Facultad de Ingeniería
--        www.campus.fi.uba.ar
-- Fecha: 16/04/13
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity vga_ctrl is
    Port (
			mclk : in std_logic;
         red_i : in std_logic;
         grn_i : in std_logic;
         blu_i : in std_logic;
         hs : out std_logic;
         vs : out std_logic;
         red_o : out std_logic_vector(2 downto 0);
         grn_o : out std_logic_vector(2 downto 0);
         blu_o : out std_logic_vector(1 downto 0);
			pixel_row: out std_logic_vector(9 downto 0);
			pixel_col: out std_logic_vector(9 downto 0)
			);

			-- attribute loc: string;
			
-- -- Mapeo de pines para el kit spartan 3E
		-- attribute loc of mclk: signal is "B8";
      -- attribute loc of red_i: signal is "H18";
      -- attribute loc of grn_i: signal is "G18";
      -- attribute loc of blu_i: signal is "K18";
		-- attribute loc of hs: signal is "T4";
		-- attribute loc of vs: signal is "U3";
		-- attribute loc of red_o: signal is "R9 T8 R8";
		-- attribute loc of grn_o: signal is "N8 P8 P6";
		-- attribute loc of blu_o: signal is "U5 U4";

-- Mapeo de pines para el kit spartan 3
--         attribute loc of mclk: signal is "T9";
--         attribute loc of red_in: signal is "K13";
--         attribute loc of grn_in: signal is "K14";
--         attribute loc of blu_in: signal is "J13";
--         attribute loc of hs: signal is "R9";
--         attribute loc of vs: signal is "T10";
--         attribute loc of red_out: signal is "R12";
--         attribute loc of grn_out: signal is "T12";
--         attribute loc of blu_out: signal is "R11";

end vga_ctrl;

architecture Behavioral of vga_ctrl is


	constant hpixels		: std_logic_vector(9 downto 0) := "1100100000";	 -- Numero de pixeles en una linea horizontal (800)
	constant vlines		: std_logic_vector(9 downto 0) := "0111000010";	 -- Numero de lineas horizontales en el display (521)
	
	constant hbp			: std_logic_vector(9 downto 0) := "0010010000";	 -- Back porch horizontal (144)
	constant hfp			: std_logic_vector(9 downto 0) := "1100010000";	 -- Front porch horizontal (784)
	constant	vbp			: std_logic_vector(9 downto 0) := "0000011111";	 -- Back porch vertical (31)
	constant vfp			: std_logic_vector(9	downto 0) := "0111111111";	 -- Front porch vertical (511)
	
	signal hc, vc			: std_logic_vector(9 downto 0);						 -- Contadores (horizontal y vertical)
	signal clkdiv_flag	: std_logic;      										 -- Flag para obtener una habilitación cada dos ciclos de clock
	signal vidon			: std_logic;												 -- Habilitar la visualización de datos
	signal vsenable		: std_logic;												 -- Habilita el contador vertical
	

begin
    --This cuts the 50Mhz clock in half
    process(mclk)
    begin
        if rising_edge(mclk) then
            clkdiv_flag <= not clkdiv_flag;
        end if;
    end process;																			

    --Runs the horizontal counter
    process(mclk)
    begin
        if rising_edge(mclk) then
            if clkdiv_flag = '1' then
                if hc = hpixels then														
                    hc <= (others => '0');      -- El cont horiz se resetea cuando alcanza la cuenta máxima de pixeles
                    vsenable <= '1';				-- Habilitación del cont vert
                else
                    hc <= hc + 1;					-- Incremento del cont horiz
                    vsenable <= '0';		      -- El cont vert se mantiene deshabilitado
                end if;
            end if;
        end if;
    end process;

    --Runs the vertical counter
    process(mclk)
    begin
        if rising_edge(mclk) then			 
            if clkdiv_flag = '1' then           -- Flag que habilita la operación una vez cada dos ciclos (25 MHz)
                if vsenable = '1' then          -- Cuando el cont horiz llega al máximo de su cuenta habilita al cont vert
                    if vc = vlines then															 
                        vc <= (others => '0');  -- El cont vert se resetea cuando alcanza la cantidad maxima de lineas
                    else
                        vc <= vc + 1;           -- Incremento del cont vert
                    end if;
                end if;
            end if;
        end if;
    end process;

--    hs <= '1' when (hc(9 downto 7) = "000") else '0';
--    vs <= '1' when (vc(9 downto 1) = "000000000") else '0';
    hs <= '1' when (hc < "0001100001") else '0';   -- Generación de la señal de sincronismo horizontal
    vs <= '1' when (vc < "0000000011") else '0';   -- Generación de la señal de sincronismo vertical

    pixel_col <= hc - 144 when (vidon = '1') else hc;    
    pixel_row <= vc - 31 when (vidon = '1') else vc;
      
    vidon <= '1' when (((hc < hfp) and (hc > hbp)) and ((vc < vfp) and (vc > vbp))) else '0';   -- Habilita la salida de datos por el display
                                                                                                -- cuando se encuentra entre los porches

-- Ejemplos
-- Los colores están comandados por los switches de entrada del kit

    red_o <= "111" when ((hc(9 downto 6) = "0111") and vc(9 downto 6) = "0100" and red_i = '1' and vidon ='1') else "000";	-- Dibuja un cuadrado rojo
    --red_o <= '1' when (hc = "1010101100" and red_i = '1' and vidon ='1') else '0';   -- Dibuja una linea roja (valor específico del contador horizontal
    grn_o <= "111" when (hc = "0100000100" and grn_i = '1' and vidon ='1') else "000";	-- Dibuja una linea verde (valor específico del contador horizontal)
    blu_o <= "11" when (vc = "0000000001" and blu_i = '1' and vidon ='1') else "00";	-- Dibuja una linea azul (valor específico del contador vertical)

--    red_o <= '1' when (red_i = '1' and vidon = '1') else '0';			-- Pinta la pantalla del color formado
--    grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';			-- por la combinación de las entradas
--    blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';			-- red_i, grn_i y blu_i (switches)

end Behavioral;