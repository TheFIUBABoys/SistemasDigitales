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


library IEEE;
use IEEE.std_logic_1164.all;
package cont4b is
component cont4b is
	port (
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end component;

end cont4b;

package body cont4b is
end cont4b;


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