library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity testbench is
end entity testbench;

architecture simulacion of testbench is
	constant TCK: time:= 20 ns; -- periodo de reloj
	constant DELAY: natural:= 1; -- retardo de procesamiento del DUT
	constant N: natural:= 23;	-- tamano de datos
	
	signal clk: std_logic:= '0';
	signal a_file: unsigned(N-1 downto 0):= (others => '0');
	signal b_file: unsigned(N-1 downto 0):= (others => '0');
	signal cin_file, cout_file: std_logic:= '0';
	signal z_file: unsigned(N-1 downto 0):= (others => '0');
	signal z_del: unsigned(N-1 downto 0):= (others => '0');
	signal z_dut: unsigned(N-1 downto 0):= (others => '0');
	signal cout_dut: std_logic;
	-- z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(N-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "test_dif_float_23_6.txt";
	
	component restadorFP is
		generic(E:integer:=8; M:integer:=23);  -- m = mantisa, e=exponente
		port(
			clk: in std_logic;
			restando: in std_logic_vector(E+M downto 0);
			restador: in std_logic_vector(E+M downto 0);
			resta: out std_logic_vector(E+M downto 0);
			g, r: out std_logic;
			s: out std_logic_vector(M downto 0)
		);
	end component;
	
	component delay_gen is
		generic(
			N: natural:= 30;
			DELAY: natural:= 0
		);
		port(
			clk: in std_logic;
			A: in std_logic_vector(N-1 downto 0);
			B: out std_logic_vector(N-1 downto 0)
		);
	end component;

	signal g_t, r_t: std_logic;
	signal s_t: std_logic_vector(16 downto 0);

begin
	-- generacion del clock del sistema
	clk <= not(clk) after TCK/ 2; -- reloj

	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			wait until rising_edge(clk);
			readline(datos, l); 			-- se lee una linea del archivo de valores de prueba
			read(l, aux); 					-- se extrae un entero de la linea
			a_file <= to_unsigned(aux, N); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, N); 	-- se carga el valor del operando B
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			if aux = 1 then					-- se carga el valor del Cin
				cin_file <= '1';
			else
				cin_file <= '0';
			end if;
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			z_file <= to_unsigned(aux, N); 	-- se carga el valor de salida (resultado)
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero
			if aux = 1 then					-- se carga el valor del Cout
				cout_file <= '1';
			else
				cout_file <= '0';
			end if;
		end loop;
		
		file_close(datos); -- cierra el archivo
		wait for TCK*(DELAY+1); -- se pone el +1 para poder ver los datos
		assert false report -- este assert se pone para abortar la simulacion
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;

	-- instanciacion del DUT (sumador)
	DUT: restadorFP generic map(6, 16)
		 port map(
			clk => clk,
			restando => std_logic_vector(a_file),
			restador => std_logic_vector(b_file),
			unsigned(resta) => z_dut,
			g => g_T,
			r => r_t,
			s => s_t
		 );
			

	--del: delay_gen 	generic map(23, DELAY)
	--			port map(clk, std_logic_vector(z_file), z_del_aux);
				
	--z_del <= unsigned(z_del_aux);
	z_del <= z_file;
	
	-- Verificacion de la condicion
	verificacion: process(clk)
	begin
		if rising_edge(clk) then
--			report integer'image(to_integer(a_file)) & " " & integer'image(to_integer(b_file)) & " " & integer'image(to_integer(z_file));
			assert to_integer(z_del)=to_integer(z_dut) report
				"Error: Salida del DUT no coincide con referencia (salida del dut = " & 
				integer'image(to_integer(z_dut)) &
				", salida del archivo = " &
				integer'image(to_integer(z_del)) & ")"
				severity warning;
		end if;
	end process;

end architecture Simulacion; 
