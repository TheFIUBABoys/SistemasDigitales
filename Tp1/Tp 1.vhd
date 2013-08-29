library IEEE;
use IEEE.std_logic_1164.all;

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
	en_temp <= (q_temp and q2_temp) and enable;	lcont2b2: cont2b port map(clk,reset, en_temp, Q(2), Q(3));
end cont4b_arq;

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
		Q: out std_logic_vector(3 downto 0)
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

architecture test_contador4b of test is
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

architecture test_FFD of test is
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



