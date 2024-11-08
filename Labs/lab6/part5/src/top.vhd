LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY top IS
  PORT (
    CLOCK_50 : IN STD_LOGIC;
    KEY      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Outputs
    LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END top;

ARCHITECTURE Structure OF top IS

  SIGNAL reset_n : STD_LOGIC := '0';
  SIGNAL key0_d1 : STD_LOGIC;
  SIGNAL key0_d2 : STD_LOGIC;
  SIGNAL key0_d3 : STD_LOGIC;

  SIGNAL keys_d1  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL keys_d2  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL keys_d3  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL keys_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -- Nios component
  COMPONENT nios_system IS
    PORT (
      clk_clk       : IN STD_LOGIC                    := 'X';             -- clk
      key_export    : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => 'X'); -- export
      ledr_export   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);                   -- export
      reset_reset_n : IN STD_LOGIC := 'X'                                 -- reset_n
    );
  END COMPONENT nios_system;

BEGIN
  ----- Synchronize Reset
  synchReset_proc : PROCESS (CLOCK_50)
  BEGIN
    IF (RISING_EDGE(CLOCK_50)) THEN
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
      reset_n <= key0_d3;
    END IF;
  END PROCESS synchReset_proc;

  ----- Synchronize Keys
  synchKeys_proc : PROCESS (CLOCK_50, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      keys_d1 <= (OTHERS => '0');
      keys_d3 <= (OTHERS => '0');

    ELSIF (RISING_EDGE(CLOCK_50)) THEN
      keys_d1  <= KEY;
      keys_d2  <= keys_d1;
      keys_d3  <= keys_d2;
      keys_sig <= keys_d3;

    END IF;
  END PROCESS synchKeys_proc;

  -- Nios port map
  u0 : COMPONENT nios_system
    PORT MAP
    (
      clk_clk       => CLOCK_50, -- clk.clk
      key_export    => keys_sig, -- key.export
      ledr_export   => LEDR,     -- ledr.export
      reset_reset_n => reset_n   -- reset.reset_n
    );

  END Structure;