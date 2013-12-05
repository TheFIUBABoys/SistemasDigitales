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

	signal valA: std_logic_vector(22 downto 0);
	signal valB: std_logic_vector(22 downto 0);
	signal result: std_logic_vector(22 downto 0);
	signal correct_result: std_logic_vector(22 downto 0);

	signal g_t, r_t: std_logic;
	signal s_t: std_logic_vector(16 downto 0);

	signal valAUnsinged: unsigned(22 downto 0) := to_unsigned(5881356,23);
	signal valBUnsinged: unsigned(22 downto 0) := to_unsigned(6039891,23);
	signal resultUnsinged: unsigned(22 downto 0) := to_unsigned(1827619,23);
begin
	-- generacion del clock del sistema
	clk <= not(clk) after 5ns; -- reloj

	valA <= std_logic_vector(valAUnsinged);
	valB <= std_logic_vector(valBUnsinged);
	correct_result <= std_logic_vector(resultUnsinged);

	-- instanciacion del DUT (restador)
	DUT: restadorFP generic map(6, 16)
		 port map(clk, valA, valB, result, g_T, r_t, s_t);

end architecture Simulacion;
