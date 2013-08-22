library IEEE;
use IEEE.std_logic_1164.all;

entity sum1b is
	port (
		a: in std_logic;
		b: in std_logic;
		ci: in std_logic;
		s: out std_logic;
		co: out std_logic
	);
end;

architecture sum1b_arq of sum1b is
begin
	s <= a xor b xor ci;
	co <= (a and b) or (a and ci) or (b and ci);
end;

-- Banco de Pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture test_arq of test is
	component sum1b is
		port (
			a: in std_logic;
			b: in std_logic;
			ci: in std_logic;
			s: out std_logic;
			co: out std_logic
		);
	end component;
	signal a_t, b_t, ci_t: std_logic := '0';
	signal s_t, co_t: std_logic;
begin
	a_t <= not a_t after 10 ns;
	b_t <= not b_t after 20 ns;
	ci_t <= not ci_t after 40 ns;
	
	inst_sum1b: sum1b port map(a_t,b_t,ci_t,s_t,co_t);
end;