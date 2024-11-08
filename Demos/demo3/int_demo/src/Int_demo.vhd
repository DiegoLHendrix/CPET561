-- This is the top_level VHDL file for the timer interrupt demo
-- that is being done as a hands-on demo.  The NIOS System
-- generated from the SOPC builder contains a NIOS II/s processor,
-- a 32k on-chip memory, a JTAG UART, an 8-bit output PIO that will
-- connect to the LEDs and a simple periodic interrupt 
-- generator with a 1 sec. time-out period. 

LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

ENTITY int_demo IS 
PORT ( 	
		KEY : 		IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
		CLOCK_50 : 	IN STD_LOGIC;
		LEDR : 		OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
		); 
END int_demo; 

ARCHITECTURE Structure OF int_demo IS
 
  component nios_system is
    port (
      clk_clk       : in  std_logic                    := 'X'; -- clk
      leds_export   : out std_logic_vector(7 downto 0);        -- export
      reset_reset_n : in  std_logic                    := 'X'  -- reset_n
      );
  end component nios_system;

BEGIN 
-- Instantiate the Nios II system entity generated by the SOPC Builder 

u0 : component nios_system
  port map (
    clk_clk       => CLOCK_50,           -- clk.clk
    leds_export   => LEDR(7 downto 0),   -- leds.export
    reset_reset_n => KEY(0)              -- reset.reset_n
    );
END Structure; 