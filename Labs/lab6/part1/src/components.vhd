LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

PACKAGE top_pkg IS
COMPONENT top IS
PORT ( 	
  CLOCK_50 : IN  STD_LOGIC;
  KEY      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
  
  -- Outputs
  LEDR     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  ); 
END COMPONENT top; 
END PACKAGE top_pkg;

LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

PACKAGE ram_pkg IS
COMPONENT raminfr IS
PORT(
    CLOCK_50 : IN std_logic;
    reset_n : IN std_logic;
    write_n : IN std_logic;
    address : IN std_logic_vector(11 DOWNTO 0);
    writedata : IN std_logic_vector(31 DOWNTO 0);
    
    -- Outputs
    readdata : OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT raminfr; 
END PACKAGE ram_pkg; 