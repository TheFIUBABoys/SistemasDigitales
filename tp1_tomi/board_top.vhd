--  Universidad de Buenos Aires - Facultad de Ingenieria
--  66.17 - Sistemas Digitales
--  Pagina web de la materia: http://cactus.fi.uba.ar/6617/
--  Tema: Ejemplo de un posible "top-level" para el trabajo practico N°1
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Board_Top is
   port(
      -------------------------------------------
      -- Xilinx/Digilent SPARTAN-3 Starter Kit --
      -------------------------------------------
      -- Board Leds / 7-segment displays:
      s3s_anodes_o     : out std_logic_vector(3 downto 0);
      s3s_segment_a_o  : out std_logic;
      s3s_segment_b_o  : out std_logic;
      s3s_segment_c_o  : out std_logic;
      s3s_segment_d_o  : out std_logic;
      s3s_segment_e_o  : out std_logic;
      s3s_segment_f_o  : out std_logic;
      s3s_segment_g_o  : out std_logic;
      s3s_segment_dp_o : out std_logic;

--      switches_i       : in  std_logic_vector(7 downto 0);  -- hay 8 "slide switches" en la placa.
      buttons_i        : in  std_logic_vector(3 downto 0);    -- hay 4 botones en la placa.
--      leds_o           : out std_logic_vector(7 downto 0);  -- hay 7 leds en la placa.
      xtal_i           : in  std_logic);                      -- cristal, por default es de 50MHz

      attribute LOC  : string;

        -------------------------------------------
        -- Xilinx/Digilent SPARTAN-3 Starter Kit --
        -------------------------------------------
      attribute LOC of xtal_i        : signal is "T9"; -- fijate que con los atributos se asignan los pines de la FPGA a las entradas/salidas de la entidad.
--      attribute LOC of leds_o        : signal is "P11 P12 N12 P13 N14 L12 P14 K12";
      attribute LOC of buttons_i     : signal is "L14 L13 M14 M13";   
--      attribute LOC of switches_i    : signal is "K13 K14 J13 J14 H13 H14 G12 F12";
      attribute LOC of s3s_anodes_o     : signal is "E13 F14 G14 D14";
      attribute LOC of s3s_segment_a_o  : signal is "E14";
      attribute LOC of s3s_segment_b_o  : signal is "G13";
      attribute LOC of s3s_segment_c_o  : signal is "N15";
      attribute LOC of s3s_segment_d_o  : signal is "P15";
      attribute LOC of s3s_segment_e_o  : signal is "R16";
      attribute LOC of s3s_segment_f_o  : signal is "F13";
      attribute LOC of s3s_segment_g_o  : signal is "N16";
      attribute LOC of s3s_segment_dp_o : signal is "P16";
end entity Board_Top;


architecture RTL of Board_Top is
-- SENIALES UTILIZADAS:
signal clk_i : std_logic:='0';                     -- reloj del sistema
begin

-- Ejemplo de asignacion de la entrada del cristal a una senial que defini como "clk_i".
   clk_i <= xtal_i;     

end architecture RTL; -- Entity: Board_Top

