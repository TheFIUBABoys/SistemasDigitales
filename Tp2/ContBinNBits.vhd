library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ContBinNBits is
  generic(N: integer);
  port(
    clk : in std_logic;
    rst : in std_logic;
    enable : in std_logic;
    Q : out std_logic_vector(N-1 downto 0)
  );
end entity ContBinNBits;
  
architecture arq_ContBinNBits of ContBinNBits is
signal contador: integer;
signal Q_tmp: std_logic_vector(N-1 downto 0);
signal contarHasta: integer := (2**N)-1;

begin

process(clk, rst)
begin
	if (rst='1') then
		contador <= 0;
		Q_tmp <= (others =>'0');
	elsif (rising_edge(clk)) then
		if (enable = '1') then
			contador <= contador + 1;
			Q_tmp <= std_logic_vector(to_unsigned(contador,N));
			if (contador = contarHasta+1) then
				contador <= 0;
				Q_tmp <= (others =>'0');
			end if;
		end if;
	end if;
end process;
Q <= Q_tmp;
end architecture arq_ContBinNBits;
	