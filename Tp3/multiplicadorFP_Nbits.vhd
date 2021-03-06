library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity multiplicadorFP is
     generic(E: integer:= 3; B: integer:=9);   		 -- valor genérico
     port(
		clk: in std_logic;
		inA: in std_logic_vector(B-1 downto 0);	 -- operando A
		inB: in std_logic_vector(B-1 downto 0);	 -- operando B
		load: in std_logic := '0';
		Sal: out std_logic_vector(B-1 downto 0);-- resultado de la operación
		ready: out std_logic
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
		    Resultado: out std_logic_vector(2*N-1 downto 0);
		    ready: out std_logic
		);
	end component;

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

	signal sumExpBin, exp1bin, exp2bin, sumAux: std_logic_vector(E-1 downto 0);

	signal sign1,sign2: std_logic_vector(B-E-1 downto 0);
	signal signo1, signo2, signo: std_logic;
	signal mulSign: std_logic_vector(2*(B-E)-1 downto 0); -- size = 2*(B-E)
	signal Cout, Cin: std_logic:= '0';
	signal loadAuxIn, loadAuxOut:std_logic_vector(0 downto 0):="0";

	signal res: std_logic:= '1';
	signal opA, opB: std_logic_vector(B-1 downto 0):=(others => '0');
begin
	res <= '0';
	loadAuxIn(0)<=load;
	regA: registro generic map(B) port map(inA, clk, res, load, opA);
	regB: registro generic map(B) port map(inB, clk, res, load, opB);
	regLoad: registro generic map(1) port map(loadAuxIn, clk, res, '1', loadAuxOut);

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
	inst_multi: multiplicador generic map (B-E) port map(sign1, sign2, loadAuxOut(0), clk, mulSign, ready); 
	sumExpbin <= std_logic_vector(signed(sumAux)+2**(E-1)-1);
	process(mulSign)
	begin
		if mulSign(2*(B-E)-1) = '1' then
			Cin <= '1';
		else
			Cin <= '0';
		end if;
	end process;
	process(sumExpbin,mulsign)
	begin
		--Si alguno es 0
		if to_integer(unsigned(opA(B-E-2 downto 0))) = 0 or to_integer(unsigned(opB(B-E-2 downto 0))) = 0 then
			 Sal <= (others => '0');
		else
			--Normal: signos distintos => no puede haber over/under
			if not exp2bin(E-1) = exp1bin(E-1) then
				Sal <= signo & sumExpbin & mulSign(2*(B-E)-2 downto B-E);
			else
			--Como la suma es complemento a 2, miro sumAux(0) para ver el signo (overflow o underflow)
			--Si hubo underflow pongo todo en 0
				if Cout = '1' and sumAux(E-1) = '1' then
					Sal <= (others => '0');
				else
					--Overflow: signo normal, todo en 1. miro si los 2 exp son positivos y si se fue de rango la suma
					if exp1bin(E-1)='0' and exp2bin(E-1) = '0' and sumAux(E-1)= '1' then
						Sal(B-1 downto B-E)<=(others => '1');
						Sal(B-E-1) <= '0';
						Sal(B-E-2 downto 0)<=(others =>'1');
					else
						--Normal
						Sal <= signo & sumExpbin & mulSign(2*(B-E)-2 downto B-E);
					end if;
				end if;
			end if;
		end if;
	end process;
end;

