----------------------------------------------------------------------------------
-- Create Date: 18:42:51 22/11/2007 
-- Design Name: 
-- Module Name: aplicVGA - Behavioral 
-- Project Name: 
-- Target Devices: Spartan 3
-- Tool versions: 
-- Description: Visualización de una letra en pantalla (entrada vector de 8 bits)
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity aplicVGA is
	generic(
		N: integer:= 6;
		M: integer:= 3;
		W: integer:= 8
	);
	port(
		input: in std_logic;
		clk: in std_logic;
		char_in: in std_logic_vector(16 downto 0);
      hsync : out std_logic;
      vsync : out std_logic;
		red_out : out std_logic_vector(2 downto 0);
      grn_out : out std_logic_vector(2 downto 0);
      blu_out : out std_logic_vector(1 downto 0)
		-- bb: out std_logic
	);
	
	attribute loc: string;
			
-- Mapeo de pines para el kit spartan 3E
		attribute loc of input: signal is "B18";
		attribute loc of clk: signal is "B8";
		attribute loc of hsync: signal is "T4";
		attribute loc of vsync: signal is "U3";
		attribute loc of red_out: signal is "R9 T8 R8";
		attribute loc of grn_out: signal is "N8 P8 P6";
		attribute loc of blu_out: signal is "U5 U4";
		
		
end aplicVGA;

architecture Behavioral of aplicVGA is

	component vga_ctrl is
		Port (
			mclk : in std_logic;
         red_i : in std_logic;
         grn_i : in std_logic;
         blu_i : in std_logic;
         hs : out std_logic;
         vs : out std_logic;
         red_o : out std_logic_vector(2 downto 0);
         grn_o : out std_logic_vector(2 downto 0);
         blu_o : out std_logic_vector(1 downto 0);
			pixel_row: out std_logic_vector(9 downto 0);
			pixel_col: out std_logic_vector(9 downto 0)
			);
	end component vga_ctrl;

	component Char_ROM is
		generic(
			N: integer:= 6;
			M: integer:= 3;
			W: integer:= 8
		);
		port(
			char_address: in std_logic_vector(5 downto 0);
			font_row, font_col: in std_logic_vector(M-1 downto 0);
			rom_out: out std_logic
		);
	end component;
	
	component ContBinNBits is
	  generic(N: integer);
	  port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		Q : out std_logic_vector(N-1 downto 0)
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
	
	component Tp2 is
		port(
			input: in std_logic;
			clk: in std_logic;
			reg_out: out std_logic_vector(15 downto 0)
		);

	end component;

	signal rom_out, enable: std_logic;
	signal address: std_logic_vector(5 downto 0);
	signal font_row, font_col: std_logic_vector(M-1 downto 0);
	signal red_in, grn_in, blu_in: std_logic;
	signal pixel_row, pixel_col, pixel_col_aux, pixel_row_aux: std_logic_vector(9 downto 0);
	signal sig_startTX: std_logic;
	signal contOut: std_logic_vector(0 downto 0);
	signal genEnableOut: std_logic;
	signal digito: integer;
	signal reg_out: std_logic_vector(15 downto 0);
	signal num: integer;
	--signal input: std_logic := '0';
	begin
	en: GenEnable generic map(50000000) port map(clk,'0','1',genEnableOut);
	cont: ContBinNBits generic map(1) port map(clk,'0',genEnableOut,contOut);
	
	aaa: vga_ctrl port map(clk, red_in, grn_in, blu_in, hsync, vsync, red_out, grn_out, blu_out, pixel_row, pixel_col);
	ccc: Tp2 port map(input,clk,reg_out);
	
	--address <= pixel_row(8 downto 3);
	font_row <= pixel_row_aux(2 downto 0); --pixel_row(2 downto 0);
	font_col <= pixel_col_aux(2 downto 0);
	
	red_in <= rom_out and enable;
	grn_in <= rom_out and enable;
	blu_in <= '1';

	bbb: Char_ROM port map(address, font_row, font_col, rom_out);

	process(pixel_row, pixel_col)
	begin
		if (pixel_col >= 301 and pixel_col < 309 and pixel_row > 240 and pixel_row < 249) then
			digito<= 0;
			pixel_col_aux <= pixel_col - 302;
			pixel_row_aux <= pixel_row - 241;
			enable <= '1';
			--address <= "000000";
		elsif (pixel_col >= 311 and pixel_col < 319 and pixel_row > 240 and pixel_row < 249) then
			digito<= 1;
			pixel_col_aux <= pixel_col - 311;
			pixel_row_aux <= pixel_row - 241;
			enable <= '1';
		elsif (pixel_col >= 321 and pixel_col < 329 and pixel_row > 240 and pixel_row < 249) then
			digito<= 2;
			pixel_col_aux <= pixel_col - 320;
			pixel_row_aux <= pixel_row - 241;
			enable <= '1';
		elsif (pixel_col >= 331 and pixel_col < 339 and pixel_row > 240 and pixel_row < 249) then
			digito<= 3;
			pixel_col_aux <= pixel_col - 330;
			pixel_row_aux <= pixel_row - 241;
			enable <= '1';
		elsif (pixel_col >= 351 and pixel_col < 359 and pixel_row > 240 and pixel_row < 249) then
			digito<= 5;
			pixel_col_aux <= pixel_col - 350;
			pixel_row_aux <= pixel_row - 241;
			enable <= '1';
		else
			enable <= '0';
		end if;
	end process;
	
	

	process(digito)
	begin
	   if digito = 0 then
			num <= to_integer(unsigned(reg_out(15 downto 12)));
			if num = 0 then address <= "000000";
			elsif num = 1 then address <= "000001";
			elsif num = 2 then address <= "000010";
			elsif num = 3 then address <= "000011";
			elsif num = 4 then address <= "000100";
			elsif num = 5 then address <= "000101";
			elsif num = 6 then address <= "000110";
			elsif num = 7 then address <= "000111";
			elsif num = 8 then address <= "001000";
			elsif num = 9 then address <= "001001";
			end if;
		elsif digito = 2 then
			num <= to_integer(unsigned(reg_out(11 downto 8)));
			if num = 0 then address <= "000000";
			elsif num = 1 then address <= "000001";
			elsif num = 2 then address <= "000010";
			elsif num = 3 then address <= "000011";
			elsif num = 4 then address <= "000100";
			elsif num = 5 then address <= "000101";
			elsif num = 6 then address <= "000110";
			elsif num = 7 then address <= "000111";
			elsif num = 8 then address <= "001000";
			elsif num = 9 then address <= "001001";
			end if;
		elsif digito = 1 then
			address <= "001010";
		elsif digito = 3 then
			num <= to_integer(unsigned(reg_out(7 downto 4)));
			if num = 0 then address <= "000000";
			elsif num = 1 then address <= "000001";
			elsif num = 2 then address <= "000010";
			elsif num = 3 then address <= "000011";
			elsif num = 4 then address <= "000100";
			elsif num = 5 then address <= "000101";
			elsif num = 6 then address <= "000110";
			elsif num = 7 then address <= "000111";
			elsif num = 8 then address <= "001000";
			elsif num = 9 then address <= "001001";
			end if;
		elsif digito = 5 then
			address <= "001011";
			end if;
	end process;

	-- bb <= rom_out;
	
end Behavioral;