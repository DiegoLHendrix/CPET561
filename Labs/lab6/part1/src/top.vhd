LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

ENTITY top IS
PORT ( 	
  CLOCK_50 : IN  STD_LOGIC;
  KEY      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
  
  -- Outputs
  LEDR     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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

  -- Nios component
  component nios_system is
		port (
			clk_clk       : in  std_logic                    := 'X';             -- clk
			key_export    : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			ledr_export   : out std_logic_vector(7 downto 0);                    -- export
			reset_reset_n : in  std_logic                    := 'X'              -- reset_n
		);
	end component nios_system;

BEGIN
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
       keys_d1 <= (OTHERS => '0');
       keys_d3 <= (OTHERS => '0');
     
     ELSIF (RISING_EDGE(CLOCK_50)) THEN
       keys_d1 <= KEY;
       keys_d2 <= keys_d1;
       keys_d3 <= keys_d2;
       keys_sig<= keys_d3;

       END IF;
   END PROCESS synchKeys_proc;

    -- Nios port map
  u0 : component nios_system
  port map (
    clk_clk       => CLOCK_50, -- clk.clk
    key_export    => keys_sig, -- key.export
    ledr_export   => LEDR,     -- ledr.export
    reset_reset_n => reset_n   -- reset.reset_n
  );
	  
END Structure;