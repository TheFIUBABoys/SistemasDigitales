library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity multiplicadorFP is
     generic(E: integer:= 3; B: integer:=9);   		 -- valor genérico
     port(
		clk: in std_logic;
		opA: in std_logic_vector(B-1 downto 0);	 -- operando A
		opB: in std_logic_vector(B-1 downto 0);	 -- operando B
		load: in std_logic := '0';
		Sal: out std_logic_vector(B-1 downto 0)-- resultado de la operación
     );
end multiplicadorFP;

architecture beh of multiplicadorFP is
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
	component multiplicador is
    generic(N: natural:= 5);
		port(
		    OpA: in std_logic_vector(N-1 downto 0);
		    OpB: in std_logic_vector(N-1 downto 0);
		    Load: in std_logic;
		    Clk: in std_logic;
		    Resultado: out std_logic_vector(2*N-1 downto 0)
		);
	end component;

	signal sumExpBin, exp1bin, exp2bin, sumAux: std_logic_vector(E-1 downto 0);

	signal sign1,sign2: std_logic_vector(B-E-1 downto 0);
	signal signo1, signo2, signo: std_logic;
	signal mulSign: std_logic_vector(2*(B-E)-1 downto 0);
	signal Cout, Cin: std_logic:= '0';
	
begin
	exp1bin<= std_logic_vector(signed(opA(B-2 downto B-E-1))-2**(E-1)+1);
	exp2bin<= std_logic_vector(signed(opB(B-2 downto B-E-1))-2**(E-1)+1);

	sign1(B-E-2 downto 0)<= opA(B-E-2 downto 0);
	sign1(B-E-1)<='1';
	sign2(B-E-2 downto 0)<= opB(B-E-2 downto 0);
	sign2(B-E-1)<='1';
	signo1<=opA(B-1);
	signo2<=opB(B-1);
	signo<=signo1 xor signo2;
	inst_sumador: sumador generic map(E) port map(exp1bin, exp2bin, Cin , sumAux, Cout);
	inst_multi: multiplicador generic map (B-E) port map(sign1, sign2, Load, clk, mulSign); 
	sumExpbin <= std_logic_vector(signed(sumAux)+2**(E-1)-1);
	process(mulSign)
	begin
		if mulSign(2*(B-E)-1) = '1' then
			Cin <= '1';
		else
			Cin <= '0';
		end if;
	end process;
	Sal <= signo & sumExpbin & mulSign(2*(B-E)-2 downto B-E);
end;

