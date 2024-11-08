LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE components IS
  COMPONENT raminfr_be IS
    PORT (
      CLOCK_50          : IN STD_LOGIC;
      reset_n           : IN STD_LOGIC;
      writebyteenable_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      address           : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      writedata         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

      -- Outputs
      readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT raminfr_be;
END PACKAGE components;