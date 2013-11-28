library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity testbench is
end entity testbench;

architecture simulacion of testbench is
	signal clk: std_logic:= '0';

	component restadorFP is
		generic(E:integer:=8; M:integer:=23);  -- m = mantisa, e=exponente
		port(
			clk: in std_logic;
			restando: in std_logic_vector(E+M downto 0);
			restador: in std_logic_vector(E+M downto 0);
			resta: out std_logic_vector(E+M downto 0);
			g, r: out std_logic;
			s: out std_logic_vector(M downto 0)
		);
	end component;

	signal valA: std_logic_vector(31 downto 0);
	signal valB: std_logic_vector(31 downto 0);
	signal result: std_logic_vector(31 downto 0);

	signal g_t, r_t: std_logic;
	signal s_t: std_logic_vector(23 downto 0);
begin
	-- generacion del clock del sistema
	clk <= not(clk) after 5ns; -- reloj

	valA <= "00111110110000000000000000000000";
	valB <= "01000010110010000000000000000000";

	-- instanciacion del DUT (sumador)
	DUT: restadorFP generic map(8, 23)
		 port map(clk, valA, valB, result, g_T, r_t, s_t);

end architecture Simulacion; 
