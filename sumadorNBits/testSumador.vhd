--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture testSumador of test is
component sumador is
     generic(N: integer:= 4);   		 -- valor genérico
     port(
          A: in std_logic_vector(N-1 downto 0);	 -- operando A
          B: in std_logic_vector(N-1 downto 0);	 -- operando B
          Cin: in std_logic;			 -- carry de entrada
          Sal: out std_logic_vector(N-1 downto 0);-- resultado de la operación
          Cout: out std_logic	                    -- carry de salida
     );
end component;
  signal aT, bT, SalT: std_logic_vector(5-1 downto 0);
  signal CinT, CoutT: std_logic := '0';
begin
  aT <= "00101";
  bT <= "00001";
  CinT <= not CinT after 10 ns;
  
  sum_inst: sumador generic map(5) port map(aT, bT, CinT, SalT, CoutT);
end architecture; 


architecture testSumadorRestador of test is
component sumadorRestador is
	 generic(N: integer:= 4);   		 -- valor genérico
     port(
		A: in std_logic_vector(N-1 downto 0);	 -- operando A
		B: in std_logic_vector(N-1 downto 0);	 -- operando B
		Sal: out std_logic_vector(N-1 downto 0);-- resultado de la operación
		Cout: out std_logic;	                    -- carry de salida
		SR: in std_logic
     );
end component;
	signal aT, bT, SalT: std_logic_vector(5-1 downto 0) := "00000";
	signal SRT, CoutT: std_logic := '1';
begin
  aT <= "00101";
  bT <= "00001";
  
  sum_inst2: sumadorRestador generic map(5) port map(aT, bT, Salt, CoutT, SRT);
end architecture; 