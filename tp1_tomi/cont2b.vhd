library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cont2b is
  port(
---   Entradad del clock
    clk     :   in std_logic;
    reset   :   in std_logic;
    enable  :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q       :   out std_logic_vector(1 downto 0)
  );
end entity Cont2b;

architecture arq_Cont2b of Cont2b is
component FFD is
	port (
	clk: in std_logic;
	reset: in std_logic;
	d: in std_logic;
	Q: out std_logic;
	enable: in std_logic
	);
end component;
  signal d: std_logic_vector(0 to 1);
  signal q_tmp: std_logic_vector(0 to 1);
begin
  
  inst_FFD1: FFD port map(clk,reset,d(0),q_tmp(0),enable);
	inst_FFD2: FFD port map(clk,reset,d(1),q_tmp(1),enable);

	d(0)<= not q_tmp(0);
	d(1)<= q_tmp(0) xor q_tmp(1);
	Q(0) <= q_tmp(0);
	Q(1) <= q_tmp(1);
	
end architecture arq_Cont2b;

--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity testCont2b is
end;

architecture test_Cont2b of testCont2b is
  component cont2b is
    port(
---   Entradad del clock
    clk   :   in std_logic;
    reset   :   in std_logic;
    enable   :   in std_logic;
---   Salida del contador. Cuenta en binario
    Q     :   out std_logic_vector(1 downto 0)  
    );
  end component;
  signal r_t,ck_t,e_t: std_logic := '1';
  signal q_t: std_logic_vector(1 downto 0);
begin
  ck_t <= not ck_t after 10 ns;
  r_t <= '0' after 1 ps;
  e_t <= not e_t after 20 ns;
  
  inst_cont2b: cont2b port map(ck_t,r_t,e_t,q_t);
end; 