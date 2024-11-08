LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

ENTITY top IS
PORT ( 	
  CLOCK_50 : IN  STD_LOGIC; 					          -- 50MHz clock
  KEY      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
  SW 	     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
  HEX0     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
  HEX1     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
  HEX2     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
  HEX4     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
  HEX5     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
  outwave  : OUT STD_LOGIC
  ); 
END top; 

ARCHITECTURE Structure OF top IS

  SIGNAL reset_n : STD_LOGIC := '0';
  SIGNAL key0_d1 : std_logic;
  SIGNAL key0_d2 : std_logic;
  SIGNAL key0_d3 : std_logic;
  
  SIGNAL keys_d1 : std_logic_vector(3 DOWNTO 0);
  SIGNAL keys_d2 : std_logic_vector(3 DOWNTO 0);
  SIGNAL keys_d3 : std_logic_vector(3 DOWNTO 0);
  SIGNAL keys_sig: STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL sw_d1   : std_logic_vector(7 DOWNTO 0);
  SIGNAL sw_d2   : std_logic_vector(7 DOWNTO 0);
  SIGNAL sw_sig  : std_logic_vector(7 DOWNTO 0);
  
  SIGNAL max_angle : UNSIGNED(31 DOWNTO 0);
  SIGNAL min_angle : UNSIGNED(31 DOWNTO 0);
  
  component nios_system is
		port (
			clk_clk           : in  std_logic                    := 'X';             -- clk
			hex0_export       : out std_logic_vector(6 downto 0);                    -- export
			hex1_export       : out std_logic_vector(6 downto 0);                    -- export
			hex2_export       : out std_logic_vector(6 downto 0);                    -- export
			hex4_export       : out std_logic_vector(6 downto 0);                    -- export
			hex5_export       : out std_logic_vector(6 downto 0);                    -- export
			keys_export       : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n     : in  std_logic                    := 'X';             -- reset_n
			servo_ip_outwave  : out std_logic;                                       -- outwave
			switches_export   : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;
BEGIN
-- Instantiate the Nios II system entity generated by the SOPC Builder 

  ----- Synchronize Reset
  synchReset_proc : PROCESS (CLOCK_50)
  BEGIN
    IF (RISING_EDGE(CLOCK_50)) THEN
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
      reset_n  <= key0_d3;
    END IF;
  END PROCESS synchReset_proc;

   ----- Synchronize Keys
   synchKeys_proc : PROCESS (CLOCK_50, reset_n)
   BEGIN
     IF(reset_n = '0') THEN
       sw_d1   <= (OTHERS => '0');
       sw_d2   <= (OTHERS => '0');
       keys_d1 <= (OTHERS => '0');
       keys_d3 <= (OTHERS => '0');
     
     ELSIF (RISING_EDGE(CLOCK_50)) THEN
       sw_d1 <= SW;
       sw_d2 <= sw_d1;
       sw_sig<= sw_d2;
 
       keys_d1 <= KEY;
       keys_d2 <= keys_d1;
       keys_d3 <= keys_d2;
       keys_sig<= keys_d3;
     END IF;
   END PROCESS synchKeys_proc;



  u0 : component nios_system
    port map (
	  clk_clk           => CLOCK_50,-- clk.clk
	  hex0_export       => HEX0,    -- hex0.export
	  hex1_export       => HEX1,	  -- hex1.export
	  hex2_export       => HEX2,	  -- hex2.export
	  hex4_export       => HEX4,    -- hex4.export
	  hex5_export       => HEX5,    -- hex5.export
	  keys_export       => keys_sig,-- keys.export
	  reset_reset_n     => reset_n, -- reset.reset_n
    servo_ip_outwave  => outwave, -- servo_ip.outwave
	  switches_export   => sw_sig   -- switches.export
	  );
	  
END Structure;
