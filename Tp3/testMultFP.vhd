--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testMultFPNoArchivos is
end;

architecture testMultFPNoArchivos of testMultFPNoArchivos is
component multiplicadorFP is
     generic(E: integer:= 3; B: integer:=9);  		
     port(
		clk: in std_logic;
		inA: in std_logic_vector(B-1 downto 0);	 -- operando A
		inB: in std_logic_vector(B-1 downto 0);	 -- operando B
		load: in std_logic := '0';
		Sal: out std_logic_vector(B-1 downto 0);-- resultado de la operación
		ready: out std_logic
     );
end component;

	constant B: natural:= 24;	-- tamano de datos
	constant E: natural:= 6;	-- tamanio del exponente

	signal aT, bT, SalT: std_logic_vector(B-1 downto 0);
  	signal load,clk: std_logic := '0';
  	signal ready_t: std_logic:='0';
  	signal aTU: unsigned(B-1 downto 0) := to_unsigned(16456706, B);
  	signal bTU: unsigned(B-1 downto 0) := to_unsigned(12197195, B);
begin
	aT <= std_logic_vector(aTU);
	bT <= std_logic_vector(bTU);
	load <= '1' after 20 ns, '0' after 40 ns;
	clk <= not clk after 10 ns;
	
	mul_inst: multiplicadorFP generic map(E,B) port map(clk, aT, bT, load, SalT, ready_t);
end architecture; 
