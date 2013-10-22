library IEEE;
use IEEE.std_logic_1164.all;


-- FFD
entity FFD is
	port (
		clk: in std_logic;
		rst: in std_logic;
		d: in std_logic;
		Q: out std_logic;
		enable: in std_logic
	);
end;



architecture FFD_arq of FFD is
begin
	process(clk, rst, enable)
	  begin
		if rst = '1' then
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
		rst: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
end;
	
architecture cont2b_arq of cont2b is
component FFD is
	port (
	clk: in std_logic;
	rst: in std_logic;
	d: in std_logic;
	Q: out std_logic;
	enable: in std_logic
	);
end component;
signal d: std_logic_vector(0 to 1):="00";
signal q: std_logic_vector(0 to 1):="00";

begin
	inst_FFD1: FFD port map(clk,rst,d(0),q(0),enable);
	inst_FFD2: FFD port map(clk,rst,d(1),q(1),enable);
	
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
		rst: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end;

architecture cont4b_arq of cont4b is
component cont2b is
	port (
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic;
		Q0: out std_logic;
		Q1: out std_logic
	);
end component;

signal q_temp: std_logic;
signal q2_temp: std_logic;
signal en_temp: std_logic;

begin
	lcont2b1: cont2b port map(clk,rst,enable,q_temp, q2_temp);
	Q(0) <= q_temp;
	Q(1) <= q2_temp;
	en_temp <= (q_temp and q2_temp) and enable;
	lcont2b2: cont2b port map(clk,rst, en_temp, Q(2), Q(3));
end cont4b_arq;
	
-- Contador BCD
library IEEE;
use IEEE.std_logic_1164.all;
entity contBCD is
	port (
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end;

architecture contBCD_arq of contBCD is

	component cont4b is
	port (
		clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic;
		q: out std_logic_vector(3 downto 0)
	);
	end component;
signal r_temp: std_logic;
signal Q_temp: std_logic_vector(3 downto 0);

begin
	lcont4b1: cont4b port map(clk,r_temp,enable,Q_temp);
	
	r_temp <= (( Q_temp(0) nor Q_temp(2) ) and ( Q_temp(3) and Q_temp(1) )) or (rst);
	
	Q<= Q_temp;
end contBCD_arq;

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
		rst: in std_logic;
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
		if salida_aux(11 downto 8) = "1001" and aux(1)='1' then
			aux(2)<='1';
		else
			aux(2)<='0';
		end if;
		
		if salida_aux(7 downto 4) = "1001" and aux(0)='1' then
			aux(1)<='1';
		else
			aux(1)<='0';
		end if;
		
		if salida_aux(3 downto 0) = "1001" and enable='1' then
			aux(0)<='1';
		else
			aux(0)<='0';
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
	
	

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity Tp2 is
	port(
		input: in std_logic;
		clk: in std_logic;
		reg_out: out std_logic_vector(15 downto 0)
	);

end Tp2;


architecture Tp2_arq of Tp2 is
	component registro is
	generic(N: integer:= 4);		-- valor genérico
		port(
			D: in std_logic_vector(N-1 downto 0);	-- entrada del registro
			clk: in std_logic;			-- señal de reloj
			rst: in std_logic;			-- señal de reset
			ena: in std_logic;		-- señal de habilitación
			Q: out std_logic_vector(N-1 downto 0)	-- salida del registro
		);
	end component;
	
	component bloqueProcesamientoYControl is
	generic(N: integer:= 4);		-- valor genérico
		port(
			D: in std_logic_vector(N-1 downto 0);	-- entrada del registro
			clk: in std_logic;			-- señal de reloj
			rst: in std_logic;			-- señal de reset
			ena: in std_logic;		-- señal de habilitación
			Q: out std_logic_vector(N-1 downto 0)	-- salida del registro
		);
	end component;
	
	component contador9999 is
    port (
		clk, rst, enable: in std_logic;
		salida: out std_logic_vector(15 downto 0)
    );
	end component;
	
	component ContBinNBits is
	  port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		Q : out std_logic_vector(15 downto 0)
	  );
	end component;
	
	component GenEnable is
	  generic(contarHasta: integer);
	  port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		Q : out std_logic
	  );
	end component;
	
	signal outFF, inAux, inAux2, delay: std_logic_vector(0 downto 0);
	signal inReg: std_logic_vector(15 downto 0);
	signal outBCD, outReg: std_logic_vector(15 downto 0);
	signal resetBCD, enReg: std_logic;
	signal outEn: std_logic;
	signal rst: std_logic:='1';
	signal rstBcd: std_logic:='1';
begin
	inAux(0)<=input;
	rst<= '0';
	rstBcd <= delay(0) or rst;
	ff: registro generic map(1) port map(inAux,clk,rst,'1',outFF);
	bdc: contador9999 port map(clk, rstBcd, outFF(0), outBCD);
	ge: GenEnable generic map (3300) port map(clk,rst,'1',outEn);
	inAux2(0) <= outEn;
	inReg <= outBCD;
	dalay: registro generic map(1) port map(inAux2,clk,rst,'1',delay);
	reg: registro generic map(16) port map(inReg, clk, rst, outEn, outReg);
	reg_out <= outReg;
	
end architecture;