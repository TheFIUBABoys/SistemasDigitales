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



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity restadorFP is
	generic(E:integer:=7; M:integer:=24);  -- m = mantisa, e=exponente
	port(
		clk: in std_logic;
		restando: in std_logic_vector(E+M downto 0);
		restador: in std_logic_vector(E+M downto 0);
		resta: out std_logic_vector(E+M downto 0)
	);
end restadorFP;

architecture beh of restadorFP is
signal e_a, e_b: integer;
signal e_a_bits, e_b_bits: std_logic_vector(E-1 downto 0); --exponentes

signal m_a, m_b: std_logic_vector(M-1 downto 0); --mantisas
signal sig_a, sig_b: std_logic_vector(M downto 0); --significands
signal s_a, s_b: std_logic; --signos

signal restando_aux: std_logic_vector(E+M downto 0);
signal restador_aux: std_logic_vector(E+M downto 0);

signal bias: integer;
signal todosUnos: std_logic_vector(M-1 downto 0):=(others => '1');

begin
	bias <= (2**E) -1;
	e_a_bits <= restando(M+E-1 downto M);
	e_b_bits <= restador(M+E-1 downto M);
	


	-- paso 1 de las diapos (swap de operandos)
	process(clk)
	begin
		e_a <= to_integer(unsigned(e_a_bits))-bias;
		e_b <= to_integer(unsigned(e_b_bits))-bias;

		if (e_a < e_b) then
			m_a <= restador(M-1 downto 0);
			m_b <= restando(M-1 downto 0);
			s_a <= restador(M+E);
			s_b <= not restando(M+E); -- como es una resta basicamente invierto el signo del restador
			e_b_bits <= restando(M+E-1 downto M);
			e_a_bits <= restador(M+E-1 downto M);
			e_a <= to_integer(unsigned(e_a_bits))-bias;
			e_b <= to_integer(unsigned(e_b_bits))-bias;
		else
			m_a <= restando(M-1 downto 0);
			m_b <= restador(M-1 downto 0);
			s_a <= restando(M+E);
			s_b <= not restador(M+E); -- como es una resta basicamente invierto el signo del restador
			-- los exponentes no se tocan
		end if;
	end process;

	resta(M+E-1 downto M)<=e_a_bits; -- exp resultado -> exp operando A (meter en el process?)

	--paso 2 de las diapos (complemento si b son != signos)
	process(clk)
	begin
		if (not (s_a = s_b)) then
			for I in 0 to M-1 loop
				sig_b(I)<= not m_b(I);
			end loop;		
			sig_b(M)<='1';		
		else 
			sig_b(M-1 downto 0)<= m_b;
			sig_b(M)<='1';
		end if;
	end process;

	--paso 3


end;