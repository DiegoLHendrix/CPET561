-------------------------------------------------------------------------
-- Author: Jeanne Christman
-- Aug. 18, 2018
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY top is
  port (
    

    ----- CLOCK -----
    CLOCK_50 : IN STD_LOGIC;
	 
    ----- SW -----
    SW : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);

    ----- KEY -----
    KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --for reset
	 
	 ----- LED -----
    LEDR : OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);  --for heartbeat
	
    HEX0 : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)  --for seven segment display

    
  );
END ENTITY top;

ARCHITECTURE rtl OF top IS
  -- signal declarations
 
  SIGNAL reset_n : STD_LOGIC;
  SIGNAL key0_d1 : STD_LOGIC;
  SIGNAL key0_d2 : STD_LOGIC;
  SIGNAL key0_d3 : STD_LOGIC;
  SIGNAL key1_d1 : STD_LOGIC;
  SIGNAL key1_d2 : STD_LOGIC;
  SIGNAL key1_d3 : STD_LOGIC;
  SIGNAL keys_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL cntr : STD_LOGIC_VECTOR(25 DOWNTO 0) := (OTHERS => '0');
  
  -- nios_system component
	COMPONENT nios_system IS
	  PORT (
			clk_clk         : in  std_logic                    := 'X';             -- clk
			hex_export      : out std_logic_vector(6 downto 0);                    -- export
			keys_export     : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
			switches_export : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			leds_export     : out std_logic_vector(7 downto 0)                     -- export
		);
	END COMPONENT nios_system;  
  
BEGIN
  
  ----- Syncronize the pushbuttons/keys
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
  reset_n <= key0_d3;
  keys_sig(1) <= key0_d3;
  
  --- heartbeat counter --------
  counter_proc : PROCESS (CLOCK_50) BEGIN
    IF (RISING_EDGE(CLOCK_50)) THEN
      IF (reset_n = '0') THEN
        cntr <= "00" & x"000000";
      ELSE
        cntr <= cntr + ("00" & x"000001");
      END IF;
    END IF;
  END PROCESS counter_proc;
  
  LEDR(8) <= cntr(24);
  
  u0 : COMPONENT nios_system
    PORT MAP (
	  clk_clk         => CLOCK_50, 		  -- clk.clk
	  reset_reset_n   => reset_n,		  -- reset.reset_n
	  switches_export => SW(7 DOWNTO 0),  -- switches.export
	  keys_export     => keys_sig, 		  -- keys.export
	  hex_export      => HEX0,			  -- hex.export
	  leds_export     => LEDR(7 DOWNTO 0) -- leds.export
    );
END ARCHITECTURE rtl;