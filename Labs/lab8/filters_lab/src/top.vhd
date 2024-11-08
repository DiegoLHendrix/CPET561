LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY WORK;
USE WORK.components.ALL;

ENTITY top IS
  PORT (
    CLOCK_50 : IN STD_LOGIC; -- 50MHz clock
    KEY      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Ram signals
    DRAM_CLK, DRAM_CKE                           : OUT STD_LOGIC;
    DRAM_ADDR                                    : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
    DRAM_BA                                      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
    DRAM_DQ                                      : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DRAM_UDQM, DRAM_LDQM                         : OUT STD_LOGIC;

    -- Audio signals
    AUD_ADCDAT  : IN STD_LOGIC;
    AUD_ADCLRCK : INOUT STD_LOGIC;
    AUD_BCLK    : INOUT STD_LOGIC;
    AUD_DACDAT  : OUT STD_LOGIC;
    AUD_DACLRCK : INOUT STD_LOGIC;
    AUD_XCK     : OUT STD_LOGIC;

    -- the_audio_and_video_config_0
    FPGA_I2C_SCLK : OUT STD_LOGIC;
    FPGA_I2C_SDAT : INOUT STD_LOGIC;

    -- General output/inout signals
    GPIO_0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
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

  SIGNAL data_out_low  : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_out_high : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

  -- Synchronize Reset
  synchReset_proc : PROCESS (CLOCK_50, reset_n)
  BEGIN
    IF (RISING_EDGE(CLOCK_50)) THEN
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
      reset_n <= key0_d3;
    END IF;
  END PROCESS synchReset_proc;

  -- Synchronize Keys
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

  high_pass_top : high_pass_filter
  PORT MAP
  (
    CLOCK_50  => CLOCK_50,
    reset_n   => reset_n,
    filter_en => '0',
    data_in => (OTHERS => '0'),
    data_out  => data_out_high
  );
END Structure;
