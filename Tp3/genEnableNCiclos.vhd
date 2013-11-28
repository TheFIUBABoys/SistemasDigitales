library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity GenEnable is
  generic(contarHasta: integer);
  port(
    clk : in std_logic;
    rst : in std_logic;
    enable : in std_logic;
    Q : out std_logic
  );
end entity GenEnable;
  
architecture arq_GenEnable of GenEnable is
signal contador: integer;
signal Q_tmp : std_logic;
begin
process(clk, rst)
begin
	if (rst='1') then
		contador <= 0;
		Q_tmp <= '0';
	elsif (rising_edge(clk)) then
		if (enable = '1') then
			contador <= contador + 1;
			Q_tmp <= '0';
			if (contador = contarHasta) then
				Q_tmp <= '1';
			end if;
		end if;
	end if;
end process;
Q <= Q_tmp;
end architecture arq_GenEnable;
	