library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity restadorFP is
	generic(E:integer:=8; M:integer:=23);  -- m = mantisa, e=exponente
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
signal s_a_signal, s_b_signal: std_logic;

signal e_a, e_b: integer;
signal e_a_bits, e_b_bits: std_logic_vector(E-1 downto 0); --exponentes

signal m_a, m_b: std_logic_vector(M-1 downto 0); --mantisas
signal p: std_logic_vector(M downto 0);
signal p_a: std_logic_vector(M downto 0);
signal temp_result: std_logic_vector(M downto 0);
signal temp_result_no_desp: std_logic_vector(M downto 0);

signal restando_aux: std_logic_vector(E+M downto 0);
signal restador_aux: std_logic_vector(E+M downto 0);

signal bias: integer;
signal todosUnos: std_logic_vector(M-1 downto 0):=(others => '1');

signal desplazamientos_signal: integer;

begin
	bias <= (2**(E - 1)) - 1;

	-- paso 1 de las diapos (swap de operandos)
	 process(restando, restador)
	 variable s_a, s_b: std_logic; --signos
	 variable m_a_var, m_b_var: std_logic_vector(M-1 downto 0); --mantisas
	 variable e_a_var, e_b_var: integer;
	 variable e_a_bits_var, e_b_bits_var: std_logic_vector(E-1 downto 0); --exponentes
	 variable p_var: std_logic_vector(M downto 0);
	 variable p_a_var: std_logic_vector(M downto 0);
	 variable p_var_extrabit: std_logic_vector(M+1 downto 0);
	 variable p_a_var_extrabit: std_logic_vector(M+1 downto 0);
	 variable g_var, r_var: std_logic;
	 variable s_var: std_logic_vector(M downto 0);
	 variable temp_result_var: std_logic_vector(M downto 0);
	 variable temp_result_no_desp_var: std_logic_vector(M downto 0);
	 variable temp_result_with_cout_var: std_logic_vector(M+1 downto 0);
	 variable tmp: integer;
	 variable desplazamientos: integer;
	 variable c_out: std_logic;
	 variable loops: integer;
	 variable operands_swap: std_logic;
	 variable complemented: std_logic;
	 begin

	 	if (restando(E+M-1 downto M) < restador(E+M-1 downto M)) then
	 		m_a_var := restador(M-1 downto 0);
	 		m_b_var := restando(M-1 downto 0);
	 		s_a := restador(M+E);
	 		-- s_b := restando(M+E);
	 		s_b := not restando(M+E); -- como es una resta basicamente invierto el signo del restador
	 		e_a_bits_var := restador(E+M-1 downto M);
	 		e_b_bits_var := restando(E+M-1 downto M);
	 		operands_swap := '0';
	 	else
	 		m_a_var := restando(M-1 downto 0);
	 		m_b_var := restador(M-1 downto 0);
	 		s_a := restando(M+E);
	 		-- s_b := restador(M+E);
	 		s_b := not restador(M+E); -- como es una resta basicamente invierto el signo del restador
	 		e_a_bits_var := restando(E+M-1 downto M);
	 		e_b_bits_var := restador(E+M-1 downto M);
	 		operands_swap := '1';
	 	end if;
		
	 	e_a_var := to_integer(unsigned(e_a_bits_var))-bias;	
	 	e_b_var := to_integer(unsigned(e_b_bits_var))-bias;

		--paso 2 de las diapos (complemento si b son != signos)

		 p_var(M) := '1';
		 p_var(M-1 downto 0) := m_b_var(M-1 downto 0); 

	 	if (s_a /= s_b) then
	 		p_var := not p_var;
	 		p_var := std_logic_vector(unsigned(p_var) + 1);
	 	end if;

		 -- paso 3		 
		 tmp := e_a_var - e_b_var;
		 
		 g_var := '0';
		 
	 	 if tmp = 1 then
	 	 	g_var := p_var(0);
	 	 end if;
		
	 	 if tmp = 2 then
	 	 	g_var := p_var(1);
	 	 	r_var := p_var(0);
	 	 end if;
		
	 	 if tmp > 2 then
	 	 	g_var := p_var(tmp - 1);
	 	 	r_var := p_var(tmp - 2);
	 	 	s_var(tmp downto 0) := p_var(tmp downto 0);	-- sospecho que esto esta mal
	 	 end if;
		
		 -- desplazo a la derecha tmp posiciones
		 for I in tmp to M loop
			p_var(I - tmp) := p_var(I);
		 end loop;
		
		 -- Agrego 0s o 1s a la izquierda segun los signos
	 	 if (s_a /= s_b) then
	 	 	for I in M downto (M - tmp + 1) loop
	 	 		p_var(I) := '1';
	 	 	end loop;
	 	 else
	 	 	for I in M downto (M - tmp + 1) loop
	 	 		p_var(I) := '0';
	 		end loop;
	 	 end if;
		
		--paso 4
		p_a_var(M-1 downto 0) := m_a_var(M-1 downto 0);
		p_a_var(M) := '1';
		
		-- Agrego un bit mas para fijarme el cout
		p_a_var_extrabit(M downto 0) := p_a_var(M downto 0);
		p_a_var_extrabit(M+1) := '0';
		
		p_var_extrabit(M downto 0) := p_var(M downto 0);
		p_var_extrabit(M+1) := '0';
		
	 	temp_result_with_cout_var(M+1 downto 0) := std_logic_vector(signed(p_a_var_extrabit) + signed(p_var_extrabit));
	 	temp_result_var(M downto 0) := temp_result_with_cout_var(M downto 0);	
	 	c_out := temp_result_with_cout_var(M+1);
		
		complemented := '0';
	 	if (s_a /= s_b) and temp_result_var(M-1) = '1' and c_out = '0' then
	 		-- Reemplazo por complemento a dos.
			temp_result_var := not temp_result_var;
			temp_result_var := std_logic_vector(unsigned(temp_result_var) + 1);
			complemented := '1';
	 	end if;
		
		
		--paso 5
	 	desplazamientos := 0;
	 	temp_result_no_desp_var := temp_result_var;
		
	 	if s_a = s_b and c_out = '1' then
	 		for I in 1 to M loop
	 			temp_result_var(I - 1) := temp_result_var(I);
	 		end loop;
	 		temp_result_var(M) := '1';
	 		desplazamientos := desplazamientos - 1;
	 	end if;
		
	 	-- Normalize number
	 	if temp_result_var(M) = '0' then
	 		for I in M-1 downto 0 loop
	 			temp_result_var(I + 1) := temp_result_var(I);
	 		end loop;
	 		temp_result_var(0) := g_var;
			
	 		desplazamientos := desplazamientos + 1;
	 	end if;
		
	 	loops := 0;
	 	while temp_result_var(M) = '0' and loops < M loop
	 		for I in M-1 downto 0 loop
	 			temp_result_var(I + 1) := temp_result_var(I);
	 		end loop;
	 		temp_result_var(0) := '0';
	 		desplazamientos := desplazamientos + 1;
	 		loops := loops + 1;
	 	end loop;
		
		
	 --paso 6
	 	if desplazamientos = -1 then
	 		r_var := temp_result_no_desp_var(0);
	 		-- s <= g or r or s;
	 	end if;
		
	 	if desplazamientos = 0 then
	 		r_var := g_var;
	 		-- s <= r or s;
	 	end if;
	
	 	if desplazamientos > 1 then
	 		r_var := '0';
	 		s_var := (others => '0');
	 	end if;

	
	 --paso 8

	 	if (s_a = s_b) then
	 		resta(M + E) <= s_a;
	 	elsif  (s_a = '0' and s_b = '1') then	-- a+  b-
			if (operands_swap = '1') then
				resta(M + E) <= '1';
			elsif  (complemented = '0') then
				resta(M + E) <= '0';
			else
				resta(M + E) <= '1';
			end if;
		else -- a-  b+
			if (operands_swap = '1') then
				resta(M + E) <= '0';
			elsif (complemented = '0') then
				resta(M + E) <= '1';
			else
				resta(M + E) <= '0';
			end if;
	 	end if;
		
		e_a_bits_var := std_logic_vector(signed(e_a_bits_var) - desplazamientos);

		resta(E+M-1 downto M) <= e_a_bits_var; -- exp resultado -> exp operando A
		resta(M-1 downto 0) <= temp_result_var(M-1 downto 0);
		
		
		e_a <= e_a_var;
		e_b <= e_b_var;
	 	m_a <= m_a_var;
	 	m_b <= m_b_var;
	 	e_a_bits <= e_a_bits_var;
	 	e_b_bits <= e_b_bits_var;
	 	p_a <= p_a_var;
	 	p <= p_var;	
	 	r <= r_var;
	 	g <= g_var;
	 	s <= s_var;
	 	temp_result <= temp_result_var;
	 	temp_result_no_desp <= temp_result_no_desp_var;
	 	s_a_signal <= s_a;
	 	s_b_signal <= s_b;
	 	desplazamientos_signal <= desplazamientos;

	end process;
	
end architecture;
