-----------------------------------------------------------------------
--- Author: Diego Lopez
-----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr IS
 PORT(
   CLOCK_50 : IN std_logic;
   reset_n : IN std_logic;
   write_n : IN std_logic;
   address : IN std_logic_vector(11 DOWNTO 0);
   writedata : IN std_logic_vector(31 DOWNTO 0);
   
   -- Outputs
   readdata : OUT std_logic_vector(31 DOWNTO 0)
 );

END ENTITY raminfr;
ARCHITECTURE rtl OF raminfr IS

 TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
 SIGNAL RAM : ram_type;
 SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);

BEGIN
 RamBlock : PROCESS(CLOCK_50)
 BEGIN
   IF (CLOCK_50'event AND CLOCK_50 = '1') THEN
     IF (reset_n = '0') THEN
       read_addr <= (OTHERS => '0');
    ELSIF (write_n = '0') THEN
      RAM(conv_integer(address)) <= writedata;
    END IF;
      read_addr <= address;
  END IF;
 END PROCESS RamBlock;

readdata <= RAM(conv_integer(read_addr));
END ARCHITECTURE rtl;