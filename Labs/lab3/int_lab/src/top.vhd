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

ENTITY top IS 
PORT ( 	
		KEY : 		IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
		CLOCK_50 : 	IN STD_LOGIC;
		LEDR : 		OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		SW : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)  --for seven segment display
		); 
END top; 

ARCHITECTURE Structure OF top IS

  SIGNAL reset_n : STD_LOGIC;
  SIGNAL key0_d1 : STD_LOGIC;
  SIGNAL key0_d2 : STD_LOGIC;
  SIGNAL key0_d3 : STD_LOGIC;
  SIGNAL key1_d1 : STD_LOGIC;
  SIGNAL key1_d2 : STD_LOGIC;
  SIGNAL key1_d3 : STD_LOGIC;
  SIGNAL keys_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
	component nios_system is
		port (
			clk_clk         : in  std_logic                    := 'X';             -- clk
			keys_export     : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			leds_export     : out std_logic_vector(7 downto 0);                    -- export
			reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
			switches_export : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			hex0_export     : out std_logic_vector(6 downto 0)                     -- export
		);
	end component nios_system;

BEGIN 
-- Instantiate the Nios II system entity generated by the SOPC Builder 

  ----- Syncronize Keys
  synchReset_proc : PROCESS (CLOCK_50) BEGIN
    IF (RISING_EDGE(CLOCK_50)) THEN
	  key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
	  
	  key1_d1 <= KEY(1);
      key1_d2 <= key1_d1;
      key1_d3 <= key1_d2;
    END IF;
  END PROCESS synchReset_proc;
  reset_n 	  <= key0_d3;
  keys_sig(1) <= key1_d3;
  

u0 : component nios_system
  port map (
    clk_clk       	=> CLOCK_50,		 -- clk.clk
	keys_export   	=> keys_sig,	 	 -- keys.export
    leds_export   	=> LEDR(7 downto 0), -- leds.export
    reset_reset_n 	=> reset_n, 		 -- reset.reset_n
	switches_export => SW(7 DOWNTO 0),   -- switches.export
	hex0_export     => HEX0      		 -- hex0.export
	);
END Structure; 
