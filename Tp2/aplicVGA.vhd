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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aplicVGA is
	generic(
		N: integer:= 6;
		M: integer:= 3;
		W: integer:= 8
	);
	port(
		clk: in std_logic;
		char_in: in std_logic_vector(7 downto 0);
		RxRdy: in std_logic;
      hsync : out std_logic;
      vsync : out std_logic;
		red_out : out std_logic;
      grn_out : out std_logic;
      blu_out : out std_logic
		-- bb: out std_logic
	);
end aplicVGA;

architecture Behavioral of aplicVGA is

	component vga_ctrl is
		port(
			mclk : in std_logic;
         red_in : in std_logic;
         grn_in : in std_logic;
         blu_in : in std_logic;
         hs : out std_logic;
         vs : out std_logic;
         red_out : out std_logic;
         grn_out : out std_logic;
         blu_out : out std_logic;
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
	
	signal rom_out, enable: std_logic;
	signal address: std_logic_vector(5 downto 0);
	signal font_row, font_col: std_logic_vector(M-1 downto 0);
	signal red_in, grn_in, blu_in: std_logic;
	signal pixel_row, pixel_col, pixel_col_aux, pixel_row_aux: std_logic_vector(9 downto 0);
	signal sig_startTX: std_logic;
	begin

	aaa: vga_ctrl port map(clk, red_in, grn_in, blu_in, hsync, vsync, red_out, grn_out, blu_out, pixel_row, pixel_col);
	
	--address <= pixel_row(8 downto 3);
	font_row	<= pixel_row_aux(2 downto 0); --pixel_row(2 downto 0);
	font_col <= pixel_col_aux(2 downto 0);
	
	red_in <= rom_out and enable;
	grn_in <= rom_out and enable;
	blu_in <= '1';

	bbb: Char_ROM port map(address, font_row, font_col, rom_out);

	process(pixel_row, pixel_col)
	begin
		if (pixel_col > 300 and pixel_col < 309 and pixel_row > 240 and pixel_row < 249) then
			pixel_col_aux <= pixel_col - 301;
			pixel_row_aux <= pixel_row - 241;
			enable <= '1';
			--address <= "000000";
		else
			enable <= '0';
		end if;
	end process;
	
	process(RxRdy)
	begin
	    if RxRdy ='1'then
	       if char_in > "01000000" and char_in < "01001001" then
			      address <= char_in(5 downto 0) - 1;
		       elsif char_in = "01001110" then -- caracter N
			      address <= "001000";
		       elsif char_in = "01001111" then -- caracter O
			      address <= "001001";
		       else address <= "001010";    -- caracter error
		    end if;
		 end if;
	end process;

	-- bb <= rom_out;
	
end Behavioral;