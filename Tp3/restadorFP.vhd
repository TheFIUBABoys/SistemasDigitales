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
		resta: out std_logic_vector(E+M downto 0);
		g, r: out std_logic;
		s: out std_logic_vector(M downto 0)
	);
end restadorFP;

architecture beh of restadorFP is
signal e_a, e_b: integer;
signal e_a_bits, e_b_bits: std_logic_vector(E-1 downto 0); --exponentes

signal m_a, m_b: std_logic_vector(M-1 downto 0); --mantisas
signal sig_a, sig_b: std_logic_vector(M downto 0); --significands
signal s_a, s_b: std_logic; --signos
signal p: std_logic_vector(M downto 0);
signal temp_result: std_logic_vector(M downto 0);
signal temp_result_no_desp: std_logic_vector(M downto 0);
signal c_out: std_logic;
signal g_temp: std_logic;

signal restando_aux: std_logic_vector(E+M downto 0);
signal restador_aux: std_logic_vector(E+M downto 0);

signal bias: integer;
signal todosUnos: std_logic_vector(M-1 downto 0):=(others => '1');
signal desplazamientos: integer;

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
		
		resta(M+E-1 downto M) <= e_a_bits; -- exp resultado -> exp operando A
	end process;

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
	process(clk)
	begin
		p(M) <= '1';
		
		for I in 0 to M-1 loop
			p(I)<= sig_b(I);
		end loop;
		
		if (e_a - e_b) = 1 then
			g_temp <= p(0);
			g <= p(0);
		end if;
		
		if (e_a - e_b) = 2 then
			g_temp <= p(1);
			g <= p(1);
			r <= p(0);
		end if;
		
		if (e_a - e_b) > 2 then
			g_temp <= p(e_a - e_b - 1);
			g <= p(e_a - e_b - 1);
			r <= p(e_a - e_b - 2);
			s(e_a - e_b downto 0) <= p(e_a - e_b downto 0);
		end if;
		
		if (not (s_a = s_b)) then
			for I in M to (e_a - e_b) loop
				p(I)<= '1';
			end loop;
		else
			for I in M to (e_a - e_b) loop
				p(I)<= '0';
			end loop;
		end if;
	end process;

--paso 4
	process(clk)
	begin
		temp_result(M downto 0) <= std_logic_vector(signed(sig_b) + signed(p));
		resta(M-1 downto 0) <= temp_result(M-1 downto 0);
		c_out <= temp_result(M);
		
		if (not(s_a = s_b)) and temp_result(E+M-1) = '1' and c_out = '0' then
			-- Reemplazo por complemento a dos.
			for I in 0 to M-1 loop
				resta(I)<= not temp_result(I);
			end loop;
		end if;
	end process;
	
--paso 5
	process(clk)
	begin
		desplazamientos <= 0;
		temp_result_no_desp <= temp_result;
		
		if s_a = s_b and c_out = '1' then
			for I in 1 to M-1 loop
				temp_result(I - 1) <= temp_result(I);
			end loop;
			temp_result(M) <= '1';
			desplazamientos <= desplazamientos - 1;
		end if;
		
		-- Normalize number
		if temp_result(M) = '0' then
			for I in 0 to M-2 loop
				temp_result(I + 1) <= temp_result(I);
			end loop;
			temp_result(0) <= p(0);
			e_a_bits <= std_logic_vector(unsigned(e_a_bits) + 1);
			
			desplazamientos <= desplazamientos + 1;
		end if;
		
		while temp_result(M) = '0' loop
			for I in 0 to M-2 loop
				temp_result(I - 1) <= temp_result(I);
			end loop;
			desplazamientos <= desplazamientos + 1;
		end loop;
	end process;
	
--paso 6
	process(clk)
	begin
		if desplazamientos = -1 then
			r <= temp_result_no_desp(0);
			-- s <= g or r or s;
		end if;
		
		if desplazamientos = 0 then
			r <= g_temp;
			-- s <= r or s;
		end if;
		
		if desplazamientos > 1 then
			r <= '0';
			s <= (others => '0');
		end if;
	end process;
	
--paso 8
	process(clk)
	begin
		if (s_a = s_b) then
			resta(M + E) <= s_a;
		end if;
	end process;
end;
