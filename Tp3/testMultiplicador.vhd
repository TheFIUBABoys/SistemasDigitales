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

architecture testShifter of test is 
component shifter is
     generic(N: integer:= 4);                  -- valor genérico
     port(
        clk, rst, ena, load: in std_logic;
        bin: in std_logic;
        l_r_select: in std_logic;
        bout: out std_logic;
        Rin: in std_logic_vector(N-1 downto 0);
        R: out std_logic_vector(N-1 downto 0)         -- operando B
     );
end component;

signal clk, rst, ena, load, bin_t, bout_t : std_logic  := '0';
signal l_r : std_logic  := '1';
signal R_t: std_logic_vector(7 downto 0);
signal D_t: std_logic_vector(7 downto 0);
begin
	clk <= not clk after 10 ns;
	ena <= not ena after 20 ns;
	rst <= '0' after 10 ns,'1' after 400 ns;
	load <= '1' after 1000 ns, '0' after 1010 ns;
	D_t <= "00000011";
	bin_t <= not bin_t after 15 ns;
	l_r <= not l_r after 2000 ns;
	
	shifter_inst: shifter generic map (8) port map(clk,rst,ena,load,bin_t,l_r,bout_t,D_t,R_t);
end architecture;

architecture testMult of test is 
component multiplicador is
   generic(N: natural:= 5);
    port(
        OpA: in std_logic_vector(N-1 downto 0);
        OpB: in std_logic_vector(N-1 downto 0);
        Load: in std_logic;
        Clk: in std_logic;
        Resultado: out std_logic_vector(2*N-1 downto 0);
        Ready: out std_logic
    );
end component;
signal clk : std_logic  := '1';
signal load : std_logic  := '0';
signal ready_t: std_logic:='0';
signal A_t, B_t: std_logic_vector(6 downto 0);
signal R_t: std_logic_vector(13 downto 0);
begin
	clk <= not clk after 10 ns;
	load <= '1' after 30 ns, '0' after 45 ns;						
	A_t <= "0100000";
	B_t <= "0100000";
	
	mul: multiplicador generic map (7) port map(A_t,B_t,load,clk,R_t,ready_t);
end architecture;
