library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity testbench is
end entity testbench;

architecture testMulFP of testbench is
	constant TCK: time:= 20 ns; -- periodo de reloj
	constant DELAY: natural:= 20; -- retardo de procesamiento del DUT
	constant N: natural:= 24;	-- tamano de datos
	constant E: natural:= 6;	-- tamanio del exponente

	signal clk: std_logic:= '0';
	signal a_file: unsigned(N-1 downto 0):= (others => '0');
	signal b_file: unsigned(N-1 downto 0):= (others => '0');
	signal z_file: unsigned(N-1 downto 0):= (others => '0');
	signal z_del: unsigned(N-1 downto 0):= (others => '0');
	signal z_dut: unsigned(N-1 downto 0):= (others => '0');

	-- z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(N-1 downto 0):= (others => '0');
	signal z_dut_aux: std_logic_vector(N-1 downto 0):= (others => '0');
	file datos: text open read_mode is "testFiles/test_mul_float_24_6.txt";
	
	component multiplicadorFP is
     generic(E: integer:= 3; B: integer:=9);   		 -- valor genérico
     port(
		clk: in std_logic;
		opA: in std_logic_vector(B-1 downto 0);	 -- operando A
		opB: in std_logic_vector(B-1 downto 0);	 -- operando B
		load: in std_logic := '0';
		Sal: out std_logic_vector(B-1 downto 0)-- resultado de la operación
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

	signal ld_t: std_logic:= '1';

begin
	-- generacion del clock del sistema
	clk <= not(clk) after TCK/ 2; -- reloj

	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			ld_t <= '0';
			wait until rising_edge(clk);
			readline(datos, l); 			-- se lee una linea del archivo de valores de prueba
			read(l, aux); 					-- se extrae un entero de la linea
			a_file <= to_unsigned(aux, N); 	-- se carga el valor del operando A
			read(l, ch); 					-- se lee un caracter (es el espacio)
			read(l, aux); 					-- se lee otro entero de la linea
			b_file <= to_unsigned(aux, N); 	-- se carga el valor del operando B
			read(l, ch); 					-- se lee otro caracter (es el espacio)
			read(l, aux);					-- se lee otro entero
			z_file <= to_unsigned(aux, N); 	-- se carga el valor de salida (resultado)
			ld_t <= '1';
		end loop;
		
		file_close(datos); -- cierra el archivo
		wait for TCK*(DELAY+1); -- se pone el +1 para poder ver los datos
		assert false report -- este assert se pone para abortar la simulacion
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;

	-- instanciacion del DUT (sumador)
	DUT: multiplicadorFP generic map(E, N)
		 port map(
			clk => clk,
			opA => std_logic_vector(a_file),
			opB => std_logic_vector(b_file),
			sal => z_dut_aux,
			Load => ld_t
		 );
			
	del: delay_gen 	generic map(N, DELAY) port map(clk, std_logic_vector(z_file), z_del_aux);
				
	
	
	-- Verificacion de la condicion
	process(clk)
	begin
		if rising_edge(clk) then
			report
				"Iniciando Test...";
			assert to_integer(unsigned(z_del_aux))=to_integer(unsigned(z_dut_aux)) report
				"Error: Salida del DUT no coincide con referencia (A = " &
				integer'image(to_integer(unsigned(a_file))) &
				", B = " &
				integer'image(to_integer(unsigned(b_file))) &
				" salida del dut = " &
				integer'image(to_integer(unsigned(z_dut_aux))) &
				", salida del archivo = " &
				integer'image(to_integer(unsigned(z_del_aux))) & ")"
				severity warning;
			assert not (to_integer(unsigned(z_del_aux))=to_integer(unsigned(z_dut_aux))) report
				"OK: Test OK"
		end if;
	end process;

end architecture; 
