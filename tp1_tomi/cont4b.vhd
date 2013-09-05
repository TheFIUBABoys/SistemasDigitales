library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cont4b is
  port(
---   Entradad del clock
    clk     :   in std_logic;
    reset   :   in std_logic;
    enable  :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q       :   out std_logic_vector(3 downto 0)
  );
end entity Cont4b;
  
architecture arq_Cont4b of Cont4b is
component Cont2b is
	port (
---   Entradad del clock
    clk   :   in std_logic;
    reset   :   in std_logic;
    enable   :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q     :   out std_logic_vector(1 downto 0)
	);
end component;
  signal q0_tmp: std_logic_vector(1 downto 0);
  signal q1_tmp: std_logic_vector(1 downto 0);
  signal d : std_logic;
begin
  
  inst_Cont2b1: Cont2b port map(clk,reset,enable,q0_tmp);
	inst_Cont2b2: Cont2b port map(d,reset,enable,q1_tmp);
  
  d <= q0_tmp(0) nand q0_tmp(1);
	Q(0) <= q0_tmp(0);
	Q(1) <= q0_tmp(1);
	Q(2) <= q1_tmp(0);
	Q(3) <= q1_tmp(1);
	
end architecture arq_Cont4b;

--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity testCont4b is
end;

architecture test_Cont4b of testCont4b is
component Cont4b is
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
  
  inst_cont4b: cont4b port map(ck_t,r_t,e_t,q_t);
end; 