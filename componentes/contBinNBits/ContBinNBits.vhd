library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



--semi bugged	
entity ContBinNBits is
  port(
    clk : in std_logic;
    rst : in std_logic;
    enable : in std_logic;
    Q : out std_logic_vector(15 downto 0) 
  );
end entity ContBinNBits;
  
architecture arq_ContBinNBits of ContBinNBits is
signal contador: integer;
signal Q_tmp: std_logic_vector(15 downto 0);

begin

process(clk, rst)
begin
	if (rst='1') then
		contador <= 0;
		Q_tmp <= (others =>'0');
	elsif (rising_edge(clk)) then
		if (enable = '1') then
			contador <= contador + 1;
			
			if (contador = 33002) then
				contador <= 0;
			end if;
			Q_tmp <= std_logic_vector(to_unsigned(contador,16));
		end if;
	end if;
end process;
Q <= Q_tmp;
end architecture arq_ContBinNBits;
	