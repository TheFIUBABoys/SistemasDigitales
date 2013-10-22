--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture testCont of test is
component ContBinNBits is
    port(
    clk : in std_logic;
    rst : in std_logic;
    enable : in std_logic;
    Q : out std_logic_vector(15 downto 0) 
  );
end component;
	signal qT: std_logic_vector(15 downto 0);
	signal rstT,enaT: std_logic :='1';
	signal clkT: std_logic:='0';
begin
  rstT <= '0';
  enaT <= '1';
  clkT <= not clkT after 20 ns;
  --dT <= not dT after 40 ns;
  
  reg_inst: ContBinNBits port map(clkT, rstT, enaT, qT);
end architecture; 