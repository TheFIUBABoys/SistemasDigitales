
library IEEE;
use IEEE.std_logic_1164.all;


-- FFD
entity FFD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		d: in std_logic;
		Q: out std_logic;
		enable: in std_logic
	);
end;



architecture FFD_arq of FFD is
begin
	process(clk, reset, enable)
	  begin
		if reset = '1' then
			Q <= '0';	
		elsif rising_edge(clk) then
			if enable ='1' then
				Q <= D;
			end if;
		end if;
   end process;
end FFD_arq;


-- Count2b
library IEEE;
use IEEE.std_logic_1164.all;
entity cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
end;
	
architecture cont2b_arq of cont2b is
component FFD is
	port (
	clk: in std_logic;
	reset: in std_logic;
	d: in std_logic;
	Q: out std_logic;
	enable: in std_logic
	);
end component;
signal d: std_logic_vector(0 to 1):="00";
signal q: std_logic_vector(0 to 1):="00";

begin
	inst_FFD1: FFD port map(clk,reset,d(0),q(0),enable);
	inst_FFD2: FFD port map(clk,reset,d(1),q(1),enable);
	
	d(0)<= not q(0);
	d(1)<= q(0) xor q(1);
	Q0 <= q(0);
	Q1 <= q(1);

end cont2b_arq;


-- Cont4b
library IEEE;
use IEEE.std_logic_1164.all;
entity cont4b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end;

architecture cont4b_arq of cont4b is
component cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
end component;

signal q_temp: std_logic;
signal q2_temp: std_logic;
signal en_temp: std_logic;

begin
	lcont2b1: cont2b port map(clk,reset,enable,q_temp, q2_temp);
	Q(0) <= q_temp;
	Q(1) <= q2_temp;
	en_temp <= (q_temp and q2_temp) and enable;
	lcont2b2: cont2b port map(clk,reset, en_temp, Q(2), Q(3));
end cont4b_arq;


--Banco de pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity testCont4b_2b_FFD is
end;

-- Cont 4b
architecture test_contador4b of testCont4b_2b_FFD is
	component cont4b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
	end component;
	signal r_t,ck_t, e_t: std_logic := '1';
	signal q_t: std_logic_vector( 3 downto 0 );
begin
	ck_t <= not ck_t after 10 ns;
	r_t <= '0' after 1 ps;
	--e_t <= '0' after 1 ns;
	
	lcont4b: cont4b port map(ck_t,r_t,e_t,q_t);
end;


-- FFD
architecture test_FFD of testCont4b_2b_FFD is
	component FFD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		d: in std_logic;
		Q: out std_logic;
		enable: in std_logic
	);
	end component;
	signal r_t,ck_t, d_t, e_t: std_logic := '1';
	signal q_t: std_logic;
begin
	ck_t <= not ck_t after 10 ns;
	r_t <= '0' after 1 ps;
	d_t <= not d_t after 20 ns;
	e_t <= not e_t after 100 ns;
	inst_FFD: FFD port map(ck_t,r_t,d_t,q_t,e_t);
end;


--Cont2b

library IEEE;
use IEEE.std_logic_1164.all;


architecture test_contador2b of testCont4b_2b_FFD is
  component cont2b is
  port (
    clk: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    Q0: out std_logic;
    Q1: out std_logic
  );
  end component;
  signal r_t,ck_t,e_t: std_logic := '1';
  signal q_t: std_logic_vector(1 downto 0);
begin
  ck_t <= not ck_t after 10 ns;
  r_t <= '0' after 1 ps;
  e_t <= '1' after 1 ps;
  
  inst_cont2b: cont2b port map(ck_t,r_t,e_t,q_t(0),q_t(1));
end; 



-- Contador BCD
library IEEE;
use IEEE.std_logic_1164.all;
entity contBCD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end;

architecture contBCD_arq of contBCD is

	component cont4b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		q: out std_logic_vector(3 downto 0)
	);
	end component;
signal r_temp: std_logic;
signal Q_temp: std_logic_vector(3 downto 0);

begin
	lcont4b1: cont4b port map(clk,r_temp,enable,Q_temp);
	
	r_temp <= (( Q_temp(0) nor Q_temp(2) ) and ( Q_temp(3) and Q_temp(1) )) or (reset);
	
	Q<= Q_temp;
end contBCD_arq;


-- Contador 26 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cont26b is
    port (
        clk, rst, enable: in std_logic;
        Q : out std_logic
    );
end cont26b;


architecture cont26b_arq of cont26b is
    signal count_i: unsigned(25 downto 0);

signal cont_temp: std_logic_vector(25 downto 0);	
begin
    process(clk, rst)
    begin
        if rst='1' then
            count_i <= (others => '0');
        elsif rising_edge(clk) then
            if (enable = '1') then
                count_i <= count_i + 1;
            end if;
        end if;
    end process;
    cont_temp <= std_logic_vector(count_i);
	Q <= cont_temp(25);
end architecture;



-- Contador 21 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cont21b is
    port (
        clk, rst, enable: in std_logic;
        q : out std_logic
    );
end cont21b;


architecture cont21b_arq of cont21b is
    signal count_i: unsigned(20 downto 0);

signal cont_temp: std_logic_vector(20 downto 0);	
begin
    process(clk, rst)
    begin
        if rst='1' then
            count_i <= (others => '0');
        elsif rising_edge(clk) then
            if (enable = '1') then
                count_i <= count_i + 1;
            end if;
        end if;
    end process;
    cont_temp <= std_logic_vector(count_i);
	q <= cont_temp(5);

end architecture;

-- Logica de numeracion
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logicaDisplay is
    port (
       contadores: in std_logic_vector(3 downto 0);
	   a,b,c,d,e,f,g,dp: out std_logic
    );
	

end logicaDisplay;

architecture logicaDisplay_arq of logicaDisplay is
begin
	process(contadores)
	begin
		if contadores="0000" then a<='0';b<='0';c<='0';d<='0';e<='0';f<='1';g<='0';
			elsif contadores="0001" then a<='1';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			elsif contadores="0010" then a<='0';b<='0';c<='1';d<='0';e<='0';f<='1';g<='0';
			elsif contadores="0011" then a<='0';b<='0';c<='0';d<='0';e<='1';f<='1';g<='0';
			elsif contadores="0100" then a<='1';b<='0';c<='0';d<='1';e<='1';f<='0';g<='0';
			elsif contadores="0101" then a<='0';b<='1';c<='0';d<='0';e<='1';f<='0';g<='0';
			elsif contadores="0110" then a<='0';b<='1';c<='0';d<='0';e<='0';f<='0';g<='0';
			elsif contadores="0111" then a<='0';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			elsif contadores="1000" then a<='0';b<='0';c<='0';d<='0';e<='0';f<='0';g<='0';
			elsif contadores="1001" then a<='0';b<='0';c<='0';d<='0';e<='1';f<='0';g<='0';
			else a<='1';b<='1';c<='1';d<='1';e<='1';f<='1';g<='1';
		end if;
		dp<='1';
	end process;
end architecture;


-- Conmutador Digitos: conmuta de izquierda a derecha si d va de 00 a 11. Tested OK
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conmutadorDigitos is
    port (
        d: in std_logic_vector(1 downto 0); -- Selector de cual display quiero
		digitos: out std_logic_vector(3 downto 0)
    );
end conmutadorDigitos;

architecture conmutadorDigitos_arq of conmutadorDigitos is
begin
	process(d) begin
		if d="00" then
			digitos <= "0111";
		elsif d="01" then
			digitos <= "1011";
		elsif d="10" then
			digitos <= "1101";
		else 
			digitos <= "1110";
		
		end if;
		
	end process;

end architecture;


-- Contador 9999. Tested OK.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---cuenta de 0000 a 9999
entity contador9999 is
    port (
		clk, rst, enable: in std_logic;
		salida: out std_logic_vector(15 downto 0)
    );
end contador9999;

architecture contador9999_arq of contador9999 is
	component contBCD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		q: out std_logic_vector(3 downto 0)
	);
	end component;
	
	signal aux: std_logic_vector(2 downto 0):="000";
	signal rst_aux: std_logic:='0';
	signal salida_aux: std_logic_vector(15 downto 0);
begin
	inst_contBCD1: contBCD port map(clk,rst_aux,enable,salida_aux(3 downto 0));
	inst_contBCD2: contBCD port map(clk,rst_aux,aux(0),salida_aux(7 downto 4));
	inst_contBCD3: contBCD port map(clk,rst_aux,aux(1),salida_aux(11 downto 8));
	inst_contBCD4: contBCD port map(clk,rst_aux,aux(2),salida_aux(15 downto 12));
	process(clk,rst)
	begin
		if salida_aux(3 downto 0) = "1001" then
			aux(0)<='1';
		else
			aux(0)<='0';
		end if;
		if salida_aux(7 downto 4) = "1001" then
			aux(1)<='1';
		else
			aux(1)<='0';
		end if;
		if salida_aux(11 downto 8) = "1001" then
			aux(2)<='1';
		else
			aux(2)<='0';
		end if;
		
		if unsigned(salida_aux) = 9999 then
			rst_aux <= '1';
		else
			rst_aux <= '0';
		end if;
		
		if rst = '1' then
			rst_aux <='1';
		end if;
	end process;
	salida <= salida_aux;

end architecture;
	
	

-- Controlador Display
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controladorDisplay is
    port (
		clk: in std_logic;
		cont0: in std_logic_vector(3 downto 0);
		cont1: in std_logic_vector(3 downto 0);
		cont2: in std_logic_vector(3 downto 0);
		cont3: in std_logic_vector(3 downto 0);
		selectorDigito: out std_logic_vector(3 downto 0);
		a,b,c,d,e,f,g,dp: out std_logic
    );
end controladorDisplay;

architecture controladorDisplay_arq of controladorDisplay is
	component logicaDisplay is
	port (
       contadores: in std_logic_vector(3 downto 0);
	   a,b,c,d,e,f,g,dp: out std_logic
    );
	end component;
	
	component cont2b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
	end component;
	
	component cont21b is
	port (
        clk, rst, enable: in std_logic;
        q : out std_logic
    );
	end component;
	
	component conmutadorDigitos is
	port (
        d: in std_logic_vector(1 downto 0);
		digitos: out std_logic_vector(3 downto 0)
    );
    end component;
	
	signal outEnable: std_logic:='1';
	signal res: std_logic:='1';
	signal outCont2b: std_logic_vector(1 downto 0):="00";
	signal contActual: std_logic_vector(3 downto 0):="0000";

begin
	res<='0';
	genEnable: cont21b port map(clk,res,'1',outEnable);
	inst_cont2b: cont2b port map(clk,res,outEnable,outCont2b(0),outCont2b(1));
	inst_conm: conmutadorDigitos port map(outCont2b,selectorDigito);
	inst_log: logicaDisplay port map(contActual,a,b,c,d,e,f,g,dp);
	
	-- Multiplexamos los contadores; siendo consistente con conmutadorDigitos,
	-- el digito mas significativo es el primero en mostrarse en el ciclo.
	process(outCont2b)
	begin
		if outCont2b="11" then
			contActual <= cont0;
		elsif outCont2b="10" then
			contActual <= cont1;
		elsif outCont2b="01" then
			contActual <= cont2;
		else
			contActual <= cont3;
		
		end if;
	
	end process;
	

end architecture;




-- Banco de Pruebas
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture test_contador26b of test is
	component cont26b is   
	port (
        clk, rst, enable: in std_logic;
        Q : out std_logic
    );
	end component;
	signal r_t,ck_t,e_t: std_logic := '1';
	signal q_t: std_logic;
begin
	ck_t <= not ck_t after 1 ns;
	r_t <= '0' after 1 ps;
	
	inst_cont26b: cont26b port map(ck_t,r_t,e_t,q_t);
end;



architecture test_contadorBCD of test is
	component contBCD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
	end component;
	signal r_t,ck_t,e_t: std_logic := '1';
	signal q_t: std_logic_vector( 3 downto 0 );
begin
	ck_t <= not ck_t after 10 ns;
	r_t <= '0' after 1 ps;
	
	lcontBCD: contBCD port map(ck_t,r_t,e_t,q_t);
end;


architecture test_contador21b of test is
	component cont21b is   
	port (
        clk, rst, enable: in std_logic;
        q: out std_logic
    );
	end component;
	signal r_t, ck_t, e_t: std_logic := '1';
	signal q_t: std_logic;
begin
	ck_t <= not ck_t after 1 ns;
	r_t <= '0' after 1 ps;
	
	inst_cont21b: cont21b port map(ck_t,r_t,e_t,q_t);
end;


architecture testLogicaDisplay of test is
	component logicaDisplay is   
	port (
       contadores: in std_logic_vector(3 downto 0);
	   a,b,c,d,e,f,g,dp: out std_logic
    );
	end component;
	component contBCD is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
	end component;
	signal r_t,ck_t,e_t: std_logic := '1';
	signal q_t: std_logic_vector(3 downto 0);
	signal outp_t: std_logic_vector(0 to 7);
	
begin
	ck_t <= not ck_t after 10 ns;
	r_t <= '0' after 1 ps;
	
	
	inst_log: logicaDisplay port map(q_t,outp_t(0),outp_t(1),outp_t(2),outp_t(3),outp_t(4),outp_t(5),outp_t(6),outp_t(7));
	lcontBCD: contBCD port map(ck_t,r_t,e_t,q_t);
end;


architecture test_contador9999 of test is
	component contador9999 is   
	port (
		clk, rst, enable: in std_logic;
		salida: out std_logic_vector(15 downto 0)
    );
	end component;
	signal r_t, ck_t, e_t: std_logic := '1';
	signal testOut: std_logic_vector(15 downto 0);
begin
	ck_t <= not ck_t after 1 ns;
	r_t <= '0' after 1 ps;
	
	inst_contador9999b: contador9999 port map(ck_t,r_t,e_t,testOut);
end;



architecture test_conmutador of test is
	component conmutadorDigitos is   
	port (
        d: in std_logic_vector(1 downto 0);
		digitos: out std_logic_vector(3 downto 0)
    );
	end component;
	signal d_t: std_logic_vector(1 downto 0):="00";
	signal digitos_t: std_logic_vector(3 downto 0);
begin
	d_t(0) <= not d_t(0) after 1 ns;
	d_t(1) <= not d_t(1) after 2 ns;
		
	inst_conm: conmutadorDigitos port map(d_t,digitos_t);
end;


architecture test_controladorDisplay of test is
	component controladorDisplay is
	port (
		clk: in std_logic;
		cont0: in std_logic_vector(3 downto 0);
		cont1: in std_logic_vector(3 downto 0);
		cont2: in std_logic_vector(3 downto 0);
		cont3: in std_logic_vector(3 downto 0);
		selectorDigito: out std_logic_vector(3 downto 0);
		a,b,c,d,e,f,g,dp: out std_logic
    );
	end component;
	signal selector_t: std_logic_vector(3 downto 0);
	signal cont0,cont1,cont2,cont3: std_logic_vector(3 downto 0):=(others =>'0');
	signal ck_t: std_logic := '1';
	signal a,b,c,d,e,f,g,dp: std_logic;
begin
	ck_t <= not ck_t after 1 ns;
	cont0(0)<= not cont0(0) after 4 ns;
	cont1(0)<= not cont1(0) after 8 ns;
		
	inst_cont: controladorDisplay port map(ck_t,cont0,cont1,cont2,cont3,selector_t,a,b,c,d,e,f,g,dp);
end;
