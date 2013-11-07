library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity sumador is
    generic(N: natural:= 8);
    port(
		clk: in std_logic;
        A, B: in std_logic_vector(N-1 downto 0);
        Cin: in std_logic;
        S: out std_logic_vector(N-1 downto 0);
        Cout: out std_logic
    );
end;

-- arquitectura combinacional
architecture arq_comb of sumador is
	signal aux: std_logic_vector(N+1 downto 0);
begin
	aux <= ('0' & A & Cin) + ('0' & B & '1');
	S <= aux(N downto 1);
	Cout <= aux(N+1);
end;

-- arquitectura clockeada
architecture arq_clock of sumador is
		signal aux: std_logic_vector(N+1 downto 0);
begin
	process(clk)
--		variable aux: std_logic_vector(N+1 downto 0);
	begin
		if rising_edge(clk) then
			aux <= ('0' & A & Cin) + ('0' & B & '1');
			S <= aux(N downto 1);
			Cout <= aux(N+1);
		end if;
	end process;
end;