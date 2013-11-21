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
signal e_a, e_b: integer;
signal e_a_bits, e_b_bits: std_logic_vector(E-1 downto 0); --exponentes

signal m_a, m_b: std_logic_vector(M-1 downto 0); --mantisas
signal sig_a, sig_b: std_logic_vector(M downto 0); --significands
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

signal loops: integer;

begin
	bias <= (2**E) - 1;

	-- paso 1 de las diapos (swap de operandos)
	 process(restando, restador)
	 variable s_a, s_b: std_logic; --signos
	 variable m_a_var, m_b_var: std_logic_vector(M-1 downto 0); --mantisas
	 variable e_a_bits_var, e_b_bits_var: std_logic_vector(E-1 downto 0); --exponentes
	 variable p_var: std_logic_vector(M downto 0);
	 variable g_temp_var: std_logic;
	 variable g_var, r_var: std_logic;
	 variable s_var: std_logic_vector(M downto 0);
	 begin

	 	if (restando(E+M-1 downto 0) < restador(E+M-1 downto 0)) then
	 		m_a_var := restador(M-1 downto 0);
	 		m_b_var := restando(M-1 downto 0);
	 		s_a := restador(M+E);
	 		s_b := restando(M+E);
	 		-- s_b := not restando(M+E); -- como es una resta basicamente invierto el signo del restador
	 		e_a_bits_var := restador(E+M-1 downto M);
	 		e_b_bits_var := restando(E+M-1 downto M);
	 	else
	 		m_a_var := restando(M-1 downto 0);
	 		m_b_var := restador(M-1 downto 0);
	 		s_a := restando(M+E);
	 		s_b := restador(M+E);
	 		-- s_b := not restador(M+E); -- como es una resta basicamente invierto el signo del restador
	 		e_a_bits_var := restando(E+M-1 downto M);
	 		e_b_bits_var := restador(E+M-1 downto M);
	 	end if;
		
	 	e_a <= to_integer(unsigned(e_a_bits_var))-bias;	
	 	e_b <= to_integer(unsigned(e_b_bits_var))-bias;

	 	resta(E+M-1 downto M) <= e_a_bits; -- exp resultado -> exp operando A
		--paso 2 de las diapos (complemento si b son != signos)

	 	if (s_a /= s_b) then
	 		m_b_var := not m_b_var;
	 		m_b_var := std_logic_vector(unsigned(m_b_var) + 1);
	 	end if;

	 -- paso 3
	 	-- p_var(M) := '1';
		
	 	-- for I in 0 to M-1 loop
	 	-- 	p_var(I) := sig_b(I);
	 	-- end loop;
		
	 	-- if (e_a - e_b) = 1 then
	 	-- 	g_temp_var := p_var(0);
	 	-- 	g_var := p_var(0);
	 	-- end if;
		
	 	-- if (e_a - e_b) = 2 then
	 	-- 	g_temp_var := p_var(1);
	 	-- 	g_var := p_var(1);
	 	-- 	r_var := p_var(0);
	 	-- end if;
		
	 	-- if (e_a - e_b) > 2 then
	 	-- 	g_temp_var := p_var(e_a - e_b - 1);
	 	-- 	g_var := p(e_a - e_b - 1);
	 	-- 	r_var := p(e_a - e_b - 2);
	 	-- 	s_var(e_a - e_b downto 0) := p_var(e_a - e_b downto 0);
	 	-- end if;
		
	 	-- if (not (s_a = s_b)) then
	 	-- 	for I in M to (e_a - e_b) loop
	 	-- 		p_var(I) := '1';
	 	-- 	end loop;
	 	-- else
	 	-- 	for I in M to (e_a - e_b) loop
	 	-- 		p_var(I) := '0';
	 	-- 	end loop;
	 	-- end if;

	 	m_a <= m_a_var;
	 	m_b <= m_b_var;
	 	p <= p_var;	
	 	r <= r_var;
	 	g <= g_var;
	 	s <= s_var;
	end process;

	-- --paso 4
	-- 	temp_result(M downto 0) <= std_logic_vector(signed(sig_b) + signed(p));
	-- 	resta(M-1 downto 0) <= temp_result(M-1 downto 0);
	-- 	c_out <= temp_result(M);
		
	-- 	if (not(s_a = s_b)) and temp_result(M-1) = '1' and c_out = '0' then
	-- 		-- Reemplazo por complemento a dos.
	-- 		for I in 0 to M-1 loop
	-- 			resta(I)<= not temp_result(I);
	-- 		end loop;
	-- 	end if;
	
	-- --paso 5
	-- 	desplazamientos <= 0;
	-- 	temp_result_no_desp <= temp_result;
		
	-- 	if s_a = s_b and c_out = '1' then
	-- 		for I in 1 to M-1 loop
	-- 			temp_result(I - 1) <= temp_result(I);
	-- 		end loop;
	-- 		temp_result(M) <= '1';
	-- 		desplazamientos <= desplazamientos - 1;
	-- 	end if;
		
	-- 	-- Normalize number
	-- 	if temp_result(M) = '0' then
	-- 		for I in 0 to M-2 loop
	-- 			temp_result(I + 1) <= temp_result(I);
	-- 		end loop;
	-- 		temp_result(0) <= p(0);
	-- 		e_a_bits <= std_logic_vector(unsigned(e_a_bits) + 1);
			
	-- 		desplazamientos <= desplazamientos + 1;
	-- 	end if;
		
	-- 	loops <= 0;
	-- 	while temp_result(M) = '0' and loops < M loop
	-- 		for I in 1 to M-1 loop
	-- 			temp_result(I - 1) <= temp_result(I);
	-- 		end loop;
	-- 		desplazamientos <= desplazamientos + 1;
	-- 		loops <= loops + 1;
	-- 	end loop;
	
	-- --paso 6
	-- 	if desplazamientos = -1 then
	-- 		r <= temp_result_no_desp(0);
	-- 		-- s <= g or r or s;
	-- 	end if;
		
	-- 	if desplazamientos = 0 then
	-- 		r <= g_temp;
	-- 		-- s <= r or s;
	-- 	end if;
		
	-- 	if desplazamientos > 1 then
	-- 		r <= '0';
	-- 		s <= (others => '0');
	-- 	end if;
	
	-- --paso 8

	-- 	if (s_a = s_b) then
	-- 		resta(M + E) <= s_a;
	-- 	end if;
	-- end process;
end architecture;
