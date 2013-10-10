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