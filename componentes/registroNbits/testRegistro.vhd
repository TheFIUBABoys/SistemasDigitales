--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture testRegistro of test is
component registro is
     generic(N: integer:= 4);		-- valor genérico
     port(
          D: in std_logic_vector(N-1 downto 0);	-- entrada del registro
          clk: in std_logic;			-- señal de reloj
          rst: in std_logic;			-- señal de reset
          ena: in std_logic;		-- señal de habilitación
          Q: out std_logic_vector(N-1 downto 0)	-- salida del registro
     );
end component;
	signal dT, qT: std_logic_vector(5-1 downto 0):="00000";
	signal clkT,rstT,enaT: std_logic :='1';
begin
  dT <= "00101";
  rstT <= '0';
  enaT <= '1';
  clkT <= not clkT after 20 ns;
  --dT <= not dT after 40 ns;
  
  reg_inst: registro generic map(5) port map(dT, clkT, rstT, enaT, qT);
end architecture; 