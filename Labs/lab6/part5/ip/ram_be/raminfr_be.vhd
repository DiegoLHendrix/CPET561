-----------------------------------------------------------------------
--- Author: Diego Lopez
-----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr_be IS
  PORT (
    CLOCK_50          : IN STD_LOGIC;
    reset_n           : IN STD_LOGIC;
    writebyteenable_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    address           : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    writedata         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Outputs
    readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );

END ENTITY raminfr_be;
ARCHITECTURE rtl OF raminfr_be IS

  TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL RAM0      : ram_type;
  SIGNAL RAM1      : ram_type;
  SIGNAL RAM2      : ram_type;
  SIGNAL RAM3      : ram_type;
  SIGNAL read_addr : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN
  RamBlock : PROCESS (CLOCK_50)
  BEGIN
    IF (CLOCK_50'event AND CLOCK_50 = '1') THEN
      IF (reset_n = '0') THEN
        read_addr <= (OTHERS => '0');
      ELSE
        IF (writebyteenable_n(0) = '0') THEN
          RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
        END IF;
        IF (writebyteenable_n(1) = '0') THEN
          RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
        END IF;
        IF (writebyteenable_n(2) = '0') THEN
          RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
        END IF;
        IF (writebyteenable_n(3) = '0') THEN
          RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
        END IF;
      END IF;
      read_addr <= address;
    END IF;
  END PROCESS RamBlock;

  readdata <= RAM3(conv_integer(read_addr)) & RAM2(conv_integer(read_addr)) & RAM1(conv_integer(read_addr)) & RAM0(conv_integer(read_addr));
END ARCHITECTURE rtl;