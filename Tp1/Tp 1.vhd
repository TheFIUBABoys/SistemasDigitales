
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
signal d: std_logic_vector(0 to 1);
signal q: std_logic_vector(0 to 1);

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
  e_t <= not e_t after 20 ns;
  
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
        q0, q1 : out std_logic
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
	q0 <= cont_temp(20);
	q1 <= cont_temp(19);
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
signal aux: unsigned(3 downto 0);
begin
	process(contadores(0))
	begin
		aux<=unsigned(contadores);
		case to_integer(aux) is
			when 0 => 
				a<='0';b<='0';c<='0';d<='0';e<='0';f<='1';g<='0';
			when 1 => 
				a<='1';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			when 2 => 
				a<='0';b<='0';c<='1';d<='0';e<='0';f<='1';g<='0';
			when 3 => 
				a<='0';b<='0';c<='0';d<='0';e<='1';f<='1';g<='0';
			when 4 => 
				a<='1';b<='0';c<='0';d<='1';e<='1';f<='0';g<='0';
			when 5 => 
				a<='0';b<='1';c<='0';d<='0';e<='1';f<='0';g<='0';
			when 6 => 
				a<='0';b<='1';c<='0';d<='0';e<='0';f<='0';g<='0';
			when 7 => 
				a<='0';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			when 8 => 
				a<='0';b<='0';c<='0';d<='0';e<='0';f<='0';g<='0';
			when 9 => 
				a<='0';b<='0';c<='0';d<='0';e<='1';f<='0';g<='0';
			when others => 
				a<='1';b<='1';c<='1';d<='1';e<='1';f<='1';g<='1';
		end case;
	dp<='1';
	end process;
end architecture;


-- Contador Display
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controladorDisplay is

    port (
        clk, rst, enable: in std_logic;
        cont0: in std_logic_vector(3 downto 0);
		cont1: in std_logic_vector(3 downto 0);
		cont2: in std_logic_vector(3 downto 0);
		cont3: in std_logic_vector(3 downto 0);
		a,b,c,d,e,f,g,dp: out std_logic;
		digitos: out std_logic_vector(3 downto 0)
    );
end controladorDisplay;

architecture controladorDisplay_arq of controladorDisplay is
	signal q: std_logic_vector(0 to 1);
	component cont21b is
	    port (
        clk, rst, enable: in std_logic;
        q0, q1 : out std_logic
    );
	end component;
begin
	inst_cont21b: cont21b port map(clk,rst,enable,q(0),q(1));
	digitos(0) <= q(0) or q(1);
	digitos(1) <= not q(0) or q(1);
	digitos(2) <= q(0) or not q(1);
	digitos(3) <= q(0) nand q(1);
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
        q0, q1: out std_logic
    );
	end component;
	signal r_t, ck_t, e_t: std_logic := '1';
	signal q0_t, q1_t: std_logic;
begin
	ck_t <= not ck_t after 1 ns;
	r_t <= '0' after 1 ps;
	
	inst_cont21b: cont21b port map(ck_t,r_t,e_t,q0_t,q1_t);
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



