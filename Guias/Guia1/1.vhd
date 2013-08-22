library IEEE;
use IEEE.std_logic_1164.all;

entity FFD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		d: in std_logic;
		Q: out std_logic
	);
end;

architecture FFD_arq of FFD is
begin
	process(clk, reset)
	  begin
		 if reset = '1' then
			Q <= '0';	
		 elsif rising_edge(clk) then
			Q <= D;
		 end if;
   end process;
end FFD_arq;
	
	
library IEEE;
use IEEE.std_logic_1164.all;
entity cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
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
		Q: out std_logic
	);
end component;

signal d: std_logic_vector(0 to 1);
signal q: std_logic_vector(0 to 1);

begin
	inst_FFD1: FFD port map(clk,reset,d(0),q(0));
	inst_FFD2: FFD port map(clk,reset,d(1),q(1));
	
	d(0)<= not q(0);
	d(1)<= q(0) xor q(1);
	Q0 <= q(0);
	Q1 <= q(1);

end cont2b_arq;
	
-- Banco de Pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture test_arq of test is
	component cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
	end component;
	signal r_t,ck_t: std_logic := '1';
	signal q_t: std_logic_vector(1 downto 0);
begin
	ck_t <= not ck_t after 10 ns;
	r_t <= '0' after 1 ps;
	
	inst_cont2b: cont2b port map(ck_t,r_t,q_t(0),q_t(1));
end;

architecture test_arq2 of test is
	component FFD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		d: in std_logic;
		Q: out std_logic
	);
	end component;
	signal r_t,ck_t, d_t: std_logic := '1';
	signal q_t: std_logic;
begin
	ck_t <= not ck_t after 10 ns;
	r_t <= '0' after 1 ps;
	d_t <= not d_t after 20 ns;
	
	inst_FFD: FFD port map(ck_t,r_t,d_t,q_t);
end;