--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture testTp2 of test is
component Tp2 is
	port(
		input: in std_logic;
		clk: in std_logic;
		reg_out: out std_logic_vector(15 downto 0)
	);

end component;
	signal clkT: std_logic :='1';
	signal input: std_logic := '1';
	signal reg_outT: std_logic_vector(15 downto 0);
begin
  clkT <= not clkT after 20 ns;
  input <= not input after 1000 ns;
  
  tp_inst: Tp2 port map(input, clkT, reg_outT);
end architecture; 