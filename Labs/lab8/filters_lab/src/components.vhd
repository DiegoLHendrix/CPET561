LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_signed.ALL;

PACKAGE components IS
  COMPONENT top IS
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
  END COMPONENT top;

  COMPONENT high_pass_filter IS
    PORT (
      CLOCK_50  : IN STD_LOGIC; -- 50MHz clock
      reset_n   : IN STD_LOGIC; -- Active low reset
      filter_en : IN STD_LOGIC;
      data_in   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

      -- Outputs
      data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
  END COMPONENT high_pass_filter;

  COMPONENT low_pass_filter IS
    PORT (
      CLOCK_50  : IN STD_LOGIC; -- 50MHz clock
      reset_n   : IN STD_LOGIC; -- Active low reset
      filter_en : IN STD_LOGIC;
      data_in   : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

      -- Outputs
      data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
  END COMPONENT low_pass_filter;

  COMPONENT multiplier IS
    PORT (
      dataa  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      datab  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT multiplier;
END PACKAGE components;
