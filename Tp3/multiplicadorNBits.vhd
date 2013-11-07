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
     generic(N: integer:= 4);                  -- valor genérico
     port(
        clk, rst, ena, load: in std_logic;
        bin: in std_logic;
        l_r_select: in std_logic;
        bout: out std_logic;
        Rin: in std_logic_vector(N-1 downto 0);
        R: out std_logic_vector(N-1 downto 0)         -- operando B
     );
end shifter;

architecture beh of shifter is
    signal D: std_logic_vector(N-1 downto 0) := (others => '0');
begin
    process(clk,rst,l_r_select)
    begin
        if (rst = '1') then
           	D <= (others => '0');
        elsif load = '1' then
			D <= Rin;
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity multiplicador is
    generic(N: natural:= 5);
    port(
        OpA: in std_logic_vector(N-1 downto 0);
        OpB: in std_logic_vector(N-1 downto 0);
        Load: in std_logic;
        Clk: in std_logic;
        Resultado: out std_logic_vector(2*N-1 downto 0)
    );
end;
architecture beh of multiplicador is

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

component shifter is
     generic(N: integer:= 4);   		 -- valor genérico
     port(
        clk, rst, ena, load: in std_logic;
        bin: in std_logic;
        l_r_select: in std_logic;
        bout: out std_logic;
        Rin: in std_logic_vector(N-1 downto 0);
        R: out std_logic_vector(N-1 downto 0)         -- operando B
     );
end component;

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


signal Breg_in, Breg_out: std_logic_vector(N-1 downto 0) := (others => '0');
signal sum, SumOpB: std_logic_vector(N-1 downto 0) := (others => '0');
signal Areg_out: std_logic_vector(N-1 downto 0);
signal SumOpA: std_logic_vector(N-1 downto 0);
signal rst : std_logic := '1';
signal Bout,Pout,Cout : std_logic;
begin
	rst <= '0';
	loadMux: process(Load)
	begin
		if (Load = '1') then
			Breg_in <= OpB;
		else
			Breg_in <= Breg_out;
		end if;
	end process loadMux;
	
	regB: shifter generic map (N) port map(clk,rst,'1',Load,Pout,'0',Bout,Breg_in,Breg_out);
	regP: shifter generic map (N) port map(clk,rst,'1','1',Cout,'0',Pout,sum,SumOpB);
	
	regA: registro generic map (N) port map(OpA,clk,rst,Load,Areg_out);
	
	mulMux: process(Bout)
	begin
		if (Bout = '1') then
			SumOpA <= Areg_out;
		else
			SumOpA <= (others => '0');
		end if;
	end process mulMux;
	
	sumad: sumador generic map (N) port map(SumOpA,SumOpB,'0',sum,Cout);
	
	Resultado(2*N-1 downto N) <= SumOpB;
	Resultado(N-1 downto 0) <= Breg_out;
	
end;




