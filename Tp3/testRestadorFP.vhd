library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity sumador is
     generic(N: integer:= 4);   		 -- valor genérico
     port(
          A: in std_logic_vector(N-1 downto 0);	 -- operando A
          B: in std_logic_vector(N-1 downto 0);	 -- operando B
          Cin: in std_logic;			 -- carry de entrada
          Sal: out std_logic_vector(N-1 downto 0);-- resultado de la operación
          Cout: out std_logic	                    -- carry de salida
     );
end sumador;

architecture sum of sumador is
     -- declaración de una señal auxiliar
     signal Sal_aux: std_logic_vector(N+1 downto 0);
begin
	 Sal_aux <= std_logic_vector(unsigned(('0' & A & Cin)) + unsigned('0' & B & '1'));
     Sal <= Sal_aux(N downto 1);				
     Cout <= Sal_aux(N+1);				
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity sumadorRestador is
     generic(N: integer:= 4);   		 -- valor genérico
     port(
		A: in std_logic_vector(N-1 downto 0);	 -- operando A
		B: in std_logic_vector(N-1 downto 0);	 -- operando B
		Sal: out std_logic_vector(N-1 downto 0);-- resultado de la operación
		Cout: out std_logic;	                    -- carry de salida
		SR: in std_logic
     );
end sumadorRestador;

architecture sumRest of sumadorRestador is
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
     -- declaración de una señal auxiliar
     signal bAux: std_logic_vector(N-1 downto 0);
begin
	inst_sumador: sumador generic map(N) port map(A, bAux, SR, Sal, Cout);

	process(B,SR)
	begin
		for i in 0 to N-1 loop
			bAux(i) <= SR xor B(i);
		end loop;
	end process;
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity shifter is
     generic(N: integer:= 4);   		 -- valor genérico
     port(
		clk, rst, ena: in std_logic;
		bin: in std_logic;
		l_r_select: in std_logic;
		bout: out std_logic;
		R: out std_logic_vector(N-1 downto 0)	 -- operando B
     );
end shifter;

architecture beh of shifter is
    signal D: std_logic_vector(N-1 downto 0) := (others => '0');
begin
	process(clk,rst,l_r_select)
	begin
		if (rst = '1') then
			D <= (others => '0');
		elsif rising_edge(clk) then
			if ena = '1' then
				if l_r_select = '1' then 
					-- LEFT SHIFT
					bout <= D(N-1);
					D(N-1 downto 1) <= D(N-2 downto 0);
					D(0) <= bin;
				else
					bout <= D(0);
					D(N-2 downto 0) <= D(N-1 downto 1);
					D(N-1) <= bin;
				end if;
			end if;
		end if;
	end process;
	R <= D;
end;