library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ContBCD is
  port(
---   Entradad del clock
    clk     :   in std_logic;
    reset   :   in std_logic;
    enable  :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q       :   out std_logic_vector(3 downto 0)
  );
end entity ContBCD;
  
architecture arq_ContBCD of ContBCD is
component Cont4b is
	port (
---   Entradad del clock
    clk   	:   in std_logic;
    reset   :   in std_logic;
    enable  :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q     	:   out std_logic_vector(3 downto 0)
	);
end component;
  signal q_tmp 	: std_logic_vector(3 downto 0);
  signal rst	: std_logic;
begin
  
  	inst_Cont4b: Cont4b port map(clk,rst,enable,q_tmp);
  
  	rst <= ( ( q_tmp(3) and not q_tmp(2) ) and ( q_tmp(1) and not q_tmp(0) ) ) or reset;
  	Q <= q_tmp;
	
end architecture arq_ContBCD;

--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity testContBCD is
end;

architecture test_ContBCD of testContBCD is
component ContBCD is
	port (
---   Entradad del clock
    clk   :   in std_logic;
    reset   :   in std_logic;
    enable   :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q     :   out std_logic_vector(3 downto 0)
	); 
end component;
  signal r_t,ck_t,e_t: std_logic := '1';
  signal q_t: std_logic_vector(3 downto 0);
begin
  ck_t <= not ck_t after 10 ns;
  r_t <= '0' after 1 ps;
  e_t <= not e_t after 20 ns;
  
  inst_ContBCD: ContBCD port map(ck_t,r_t,e_t,q_t);
end; 
