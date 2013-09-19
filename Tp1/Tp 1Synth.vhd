
library IEEE;
use IEEE.std_logic_1164.all;


-- FFD
entity FFD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		d: in std_logic;
		Q: out std_logic;
		enable: in std_logic
	);
end;



architecture FFD_arq of FFD is
begin
	process(clk, reset, enable)
	  begin
		if reset = '1' then
			Q <= '0';	
		elsif rising_edge(clk) then
			if enable ='1' then
				Q <= D;
			end if;
		end if;
   end process;
end FFD_arq;


-- Count2b
library IEEE;
use IEEE.std_logic_1164.all;
entity cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
end;
	
architecture cont2b_arq of cont2b is
component FFD is
	port (
	clk: in std_logic;
	reset: in std_logic;
	d: in std_logic;
	Q: out std_logic;
	enable: in std_logic
	);
end component;
signal d: std_logic_vector(0 to 1):="00";
signal q: std_logic_vector(0 to 1):="00";

begin
	inst_FFD1: FFD port map(clk,reset,d(0),q(0),enable);
	inst_FFD2: FFD port map(clk,reset,d(1),q(1),enable);
	
	d(0)<= not q(0);
	d(1)<= q(0) xor q(1);
	Q0 <= q(0);
	Q1 <= q(1);

end cont2b_arq;


-- Cont4b
library IEEE;
use IEEE.std_logic_1164.all;
entity cont4b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end;

architecture cont4b_arq of cont4b is
component cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
end component;

signal q_temp: std_logic;
signal q2_temp: std_logic;
signal en_temp: std_logic;

begin
	lcont2b1: cont2b port map(clk,reset,enable,q_temp, q2_temp);
	Q(0) <= q_temp;
	Q(1) <= q2_temp;
	en_temp <= (q_temp and q2_temp) and enable;
	lcont2b2: cont2b port map(clk,reset, en_temp, Q(2), Q(3));
end cont4b_arq;


-- Contador BCD
library IEEE;
use IEEE.std_logic_1164.all;
entity contBCD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end;

architecture contBCD_arq of contBCD is

	component cont4b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		q: out std_logic_vector(3 downto 0)
	);
	end component;
signal r_temp: std_logic;
signal Q_temp: std_logic_vector(3 downto 0);

begin
	lcont4b1: cont4b port map(clk,r_temp,enable,Q_temp);
	
	r_temp <= (( Q_temp(0) nor Q_temp(2) ) and ( Q_temp(3) and Q_temp(1) )) or (reset);
	
	Q<= Q_temp;
end contBCD_arq;


-- Contador 26 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cont26b is
    port (
        clk, rst, enable: in std_logic;
        Q : out std_logic
    );
end cont26b;


architecture cont26b_arq of cont26b is
    signal count_i: unsigned(25 downto 0);

signal cont_temp: std_logic_vector(25 downto 0);	
begin
    process(clk, rst)
    begin
        if rst='1' then
            count_i <= (others => '0');
        elsif rising_edge(clk) then
            if (enable = '1') then
                count_i <= count_i + 1;
            end if;
        end if;
    end process;
    cont_temp <= std_logic_vector(count_i);
	Q <= cont_temp(25);
end architecture;



-- Contador 21 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cont21b is
    port (
        clk, rst, enable: in std_logic;
        q : out std_logic
    );
end cont21b;


architecture cont21b_arq of cont21b is
    signal count_i: unsigned(25 downto 0);

signal cont_temp: std_logic_vector(25 downto 0);	
begin
    process(clk, rst)
    begin
        if rst='1' then
            count_i <= (others => '0');
        elsif rising_edge(clk) then
            if (enable = '1') then
                count_i <= count_i + 1;
            end if;
        end if;
    end process;
    cont_temp <= std_logic_vector(count_i);
	q <= cont_temp(20);

end architecture;

-- Logica de numeracion
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logicaDisplay is
    port (
       contadores: in std_logic_vector(3 downto 0);
	   a,b,c,d,e,f,g,dp: out std_logic
    );
	

end logicaDisplay;

architecture logicaDisplay_arq of logicaDisplay is
begin
	process(contadores)
	begin
		if contadores="0000" then a<='0';b<='0';c<='0';d<='0';e<='0';f<='0';g<='1';
			elsif contadores="0001" then a<='1';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			elsif contadores="0010" then a<='0';b<='0';c<='1';d<='0';e<='0';f<='1';g<='0';
			elsif contadores="0011" then a<='0';b<='0';c<='0';d<='0';e<='1';f<='1';g<='0';
			elsif contadores="0100" then a<='1';b<='0';c<='0';d<='1';e<='1';f<='0';g<='0';
			elsif contadores="0101" then a<='0';b<='1';c<='0';d<='0';e<='1';f<='0';g<='0';
			elsif contadores="0110" then a<='0';b<='1';c<='0';d<='0';e<='0';f<='0';g<='0';
			elsif contadores="0111" then a<='0';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			elsif contadores="1000" then a<='0';b<='0';c<='0';d<='0';e<='0';f<='0';g<='0';
			else a<='0';b<='0';c<='0';d<='0';e<='1';f<='0';g<='0';
		end if;
		dp<='1';
	end process;
end architecture;


-- Conmutador Digitos: conmuta de izquierda a derecha si d va de 00 a 11. Tested OK
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conmutadorDigitos is
    port (
        d: in std_logic_vector(1 downto 0); -- Selector de cual display quiero
		digitos: out std_logic_vector(3 downto 0)
    );
end conmutadorDigitos;

architecture conmutadorDigitos_arq of conmutadorDigitos is
begin
	process(d) begin
		if d="00" then
			digitos <= "0111";
		elsif d="01" then
			digitos <= "1011";
		elsif d="10" then
			digitos <= "1101";
		else 
			digitos <= "1110";
		
		end if;
		
	end process;

end architecture;


-- Contador 9999. Tested OK.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---cuenta de 0000 a 9999
entity contador9999 is
    port (
		clk, rst, enable: in std_logic;
		salida: out std_logic_vector(15 downto 0)
    );
end contador9999;

architecture contador9999_arq of contador9999 is
	component contBCD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		q: out std_logic_vector(3 downto 0)
	);
	end component;
	
	signal aux: std_logic_vector(2 downto 0):="000";
	signal rst_aux: std_logic:='0';
	signal salida_aux: std_logic_vector(15 downto 0);
begin
	inst_contBCD1: contBCD port map(clk,rst_aux,enable,salida_aux(3 downto 0));
	inst_contBCD2: contBCD port map(clk,rst_aux,aux(0),salida_aux(7 downto 4));
	inst_contBCD3: contBCD port map(clk,rst_aux,aux(1),salida_aux(11 downto 8));
	inst_contBCD4: contBCD port map(clk,rst_aux,aux(2),salida_aux(15 downto 12));
	process(clk,rst)
	begin
		if salida_aux(11 downto 8) = "1001" and aux(1)='1' then
			aux(2)<='1';
		else
			aux(2)<='0';
		end if;
		
		if salida_aux(7 downto 4) = "1001" and aux(0)='1' then
			aux(1)<='1';
		else
			aux(1)<='0';
		end if;
		
		if salida_aux(3 downto 0) = "1001" and enable='1' then
			aux(0)<='1';
		else
			aux(0)<='0';
		end if;
		
		
		if unsigned(salida_aux) = 9999 then
			rst_aux <= '1';
		else
			rst_aux <= '0';
		end if;
		
		if rst = '1' then
			rst_aux <='1';
		end if;
	end process;
	salida <= salida_aux;

end architecture;
	
	
-- Gen enable
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity GenEnable is
  generic(max: integer);
  port(
--- Entradad del clock
    clk : in std_logic;
    reset : in std_logic;
    enable : in std_logic;
--- Salida del contador. Cuenta en binario
    Q : out std_logic
  );
end entity GenEnable;
  
architecture arq_GenEnable of GenEnable is
signal counter: integer;
signal q_tmp : std_logic;
begin
count_proc: process(clk, reset)
    begin
        if (reset='1') then
            counter <= 0;
q_tmp <= '0';
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                counter <= counter + 1;
q_tmp <= '0';
                if (counter = max) then
counter <= 0;
q_tmp <= '1';
end if;
            end if;
        end if;
    end process count_proc;
Q <= q_tmp;
end architecture arq_GenEnable;
	
	
	
-- Controlador Display
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity controladorDisplay is
    port (
		clk: in std_logic;
		cont0: in std_logic_vector(3 downto 0);
		cont1: in std_logic_vector(3 downto 0);
		cont2: in std_logic_vector(3 downto 0);
		cont3: in std_logic_vector(3 downto 0);
		selectorDigito: out std_logic_vector(3 downto 0);
		a,b,c,d,e,f,g,dp: out std_logic
    );
end controladorDisplay;

architecture controladorDisplay_arq of controladorDisplay is
	component logicaDisplay is
	port (
       contadores: in std_logic_vector(3 downto 0);
	   a,b,c,d,e,f,g,dp: out std_logic
    );
	end component;
	
	component GenEnable is
  generic(max: integer);
  port(
--- Entradad del clock
    clk : in std_logic;
    reset : in std_logic;
    enable : in std_logic;
--- Salida del contador. Cuenta en binario
    Q : out std_logic
  );
end component;
  
  
	component cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
	end component;
	
	component cont21b is
	port (
        clk, rst, enable: in std_logic;
        q : out std_logic
    );
	end component;
	
	component conmutadorDigitos is
	port (
        d: in std_logic_vector(1 downto 0);
		digitos: out std_logic_vector(3 downto 0)
    );
    end component;
	
	signal outEnable: std_logic:='1';
	signal res: std_logic:='1';
	signal enAux:std_logic:='0';
	signal outCont2b: std_logic_vector(1 downto 0):="00";
	signal contActual: std_logic_vector(3 downto 0):="0000";

begin
	res<='0' after 1 ns;
	enAux<='1' after 1 ns;
	instGenEnable: 	GenEnable generic map(50000) port map(clk,res,enAux,outEnable);
	--genEnable: cont21b port map(clk,res,enAux,outEnable);
	inst_cont2b: cont2b port map(clk,res,outEnable,outCont2b(0),outCont2b(1));
	inst_conm: conmutadorDigitos port map(outCont2b,selectorDigito);
	inst_log: logicaDisplay port map(contActual,a,b,c,d,e,f,g,dp);
	
	-- Multiplexamos los contadores; siendo consistente con conmutadorDigitos,
	-- el digito mas significativo es el primero en mostrarse en el ciclo.
	process(outCont2b)
	begin
		if outCont2b="11" then
			contActual <= cont0;
		elsif outCont2b="10" then
			contActual <= cont1;
		elsif outCont2b="01" then
			contActual <= cont2;
		else
			contActual <= cont3;
		
		end if;
	
	end process;
	

end architecture;




-- GLOBAL
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Tp1 is
    port (
		clk: in std_logic;
		boton: in std_logic;
		selectorDigito: out std_logic_vector(3 downto 0);
		a,b,c,d,e,f,g,dp: out std_logic
    );
end Tp1;

architecture Tp1_arq of Tp1 is
	component controladorDisplay is
		port (
			clk: in std_logic;
			cont0: in std_logic_vector(3 downto 0);
			cont1: in std_logic_vector(3 downto 0);
			cont2: in std_logic_vector(3 downto 0);
			cont3: in std_logic_vector(3 downto 0);
			selectorDigito: out std_logic_vector(3 downto 0);
			a,b,c,d,e,f,g,dp: out std_logic
		);
		end component;
	
	component contador9999 is
		port (
			clk, rst, enable: in std_logic;
			salida: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component cont26b is
		port (
			clk, rst, enable: in std_logic;
			Q : out std_logic
		);
	end component;
	
	component GenEnable is
  generic(max: integer);
  port(
--- Entradad del clock
    clk : in std_logic;
    reset : in std_logic;
    enable : in std_logic;
--- Salida del contador. Cuenta en binario
    Q : out std_logic
  );
end component;
  
  
	signal enableAux: std_logic:='0';
	signal res: std_logic:='1';
	signal enablePosta: std_logic:='1';
	signal outContador: std_logic_vector(15 downto 0);
begin
	res<='0';enableAux<='1';
	--inst_enable: cont26b port map(clk,res,enableAux,enablePosta);
	instGenEnable: 	GenEnable generic map(500000) port map(clk,res,enableAux,enablePosta);
	inst_cont: contador9999 port map(clk,boton,enablePosta,outContador);
	inst_disp: controladorDisplay port map(clk,outContador(3 downto 0),outContador(7 downto 4), outContador(11 downto 8),outContador(15	downto 12),selectorDigito,a,b,c,d,e,f,g,dp);
end architecture;

-- GLOBAL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Board_Top is
   port(
      -------------------------------------------
      -- Xilinx/Digilent SPARTAN-3 Starter Kit --
      -------------------------------------------
      -- Board Leds / 7-segment displays:
      s3s_anodes_o     : out std_logic_vector(3 downto 0);
      s3s_segment_a_o  : out std_logic;
      s3s_segment_b_o  : out std_logic;
      s3s_segment_c_o  : out std_logic;
      s3s_segment_d_o  : out std_logic;
      s3s_segment_e_o  : out std_logic;
      s3s_segment_f_o  : out std_logic;
      s3s_segment_g_o  : out std_logic;
      s3s_segment_dp_o : out std_logic;

--      switches_i       : in  std_logic_vector(7 downto 0);  -- hay 8 "slide switches" en la placa.
      buttons_i        : in  std_logic_vector(3 downto 0);    -- hay 4 botones en la placa.
--      leds_o           : out std_logic_vector(7 downto 0);  -- hay 7 leds en la placa.
      xtal_i           : in  std_logic);                      -- cristal, por default es de 50MHz

      attribute LOC  : string;

        -------------------------------------------
        -- Xilinx/Digilent SPARTAN-3 Starter Kit --
        -------------------------------------------
      attribute LOC of xtal_i        : signal is "B8"; -- fijate que con los atributos se asignan los pines de la FPGA a las entradas/salidas de la entidad.
--      attribute LOC of leds_o        : signal is "P11 P12 N12 P13 N14 L12 P14 K12";
      attribute LOC of buttons_i     : signal is "B18 D18 E18 H13";   
--      attribute LOC of switches_i    : signal is "K13 K14 J13 J14 H13 H14 G12 F12";
      attribute LOC of s3s_anodes_o     : signal is "F15 C18 H17 F17";
      attribute LOC of s3s_segment_a_o  : signal is "L18";
      attribute LOC of s3s_segment_b_o  : signal is "F18";
      attribute LOC of s3s_segment_c_o  : signal is "D17";
      attribute LOC of s3s_segment_d_o  : signal is "D16";
      attribute LOC of s3s_segment_e_o  : signal is "G14";
      attribute LOC of s3s_segment_f_o  : signal is "J17";
      attribute LOC of s3s_segment_g_o  : signal is "H14";
      attribute LOC of s3s_segment_dp_o : signal is "C17";
end entity Board_Top;



architecture RTL of Board_Top is
	component Tp1 is
		port (
			clk: in std_logic;
			boton: in std_logic;
			selectorDigito: out std_logic_vector(3 downto 0);
			a,b,c,d,e,f,g,dp: out std_logic
		);
	end component;
-- SENIALES UTILIZADAS:
begin

-- Ejemplo de asignacion de la entrada del cristal a una senial que defini como "clk_i".
	inst_tp1: Tp1 port map(xtal_i, buttons_i(0), s3s_anodes_o, s3s_segment_a_o, s3s_segment_b_o, s3s_segment_c_o, s3s_segment_d_o, s3s_segment_e_o, s3s_segment_f_o, s3s_segment_g_o, s3s_segment_dp_o);

end architecture RTL; -- Entity: Board_Top