--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testMultFPNoArchivos is
end;

architecture testMultFPNoArchivos of testMultFPNoArchivos is
component multiplicadorFP is
     generic(E: integer:= 3; B: integer:=9);  		 -- valor genérico
     port(
		clk: in std_logic;
		opA: in std_logic_vector(B-1 downto 0);	 -- operando A
		opB: in std_logic_vector(B-1 downto 0);	 -- operando B
		load: in std_logic := '0';
		Sal: out std_logic_vector(B-1 downto 0)-- resultado de la operación
     );
end component;

  signal aT, bT, SalT: std_logic_vector(23 downto 0);
  signal load,clk: std_logic := '0';
  signal aTU: unsigned(23 downto 0) := to_unsigned(2485206, 24);
  signal bTU: unsigned(23 downto 0) := to_unsigned(1805351, 24);
begin
	aT <= std_logic_vector(aTU);
	bT <= std_logic_vector(bTU);
	load <= '1' after 20 ns, '0' after 40 ns;
	clk <= not clk after 10 ns;
  
	mul_inst: multiplicadorFP generic map(6,24) port map(clk, aT, bT, load, SalT );
end architecture; 
