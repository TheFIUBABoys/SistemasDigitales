
library IEEE;
use IEEE.std_logic_1164.all;
use work.cont4b.all;


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



