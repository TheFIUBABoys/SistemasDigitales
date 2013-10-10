library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity Tp2 is
	
		

end Tp2;


architecture Tp2_arq of Tp2 is

component registroNBits is
	generic(N: integer:= 4);		-- valor genérico
		port(
			D: in std_logic_vector(N-1 downto 0);	-- entrada del registro
			clk: in std_logic;			-- señal de reloj
			rst: in std_logic;			-- señal de reset
			ena: in std_logic;		-- señal de habilitación
			Q: out std_logic_vector(N-1 downto 0)	-- salida del registro
		);
	end component;
begin	
	
	
	
	
end architecture;