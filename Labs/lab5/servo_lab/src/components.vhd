LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

PACKAGE top_pkg IS
COMPONENT top IS 
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
END COMPONENT top;
END PACKAGE top_pkg;

LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

PACKAGE servo_controller_pkg IS
COMPONENT servo_controller IS
GENERIC (
  max_angle      : IN UNSIGNED(31 DOWNTO 0) := to_unsigned(100000, 32);
  min_angle      : IN UNSIGNED(31 DOWNTO 0) := to_unsigned(50000, 32)
);
PORT (    
  CLOCK_50 : IN  STD_LOGIC;
  reset    : IN  STD_LOGIC;
  write    : IN  STD_LOGIC;
  writedata: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
  address  : IN  STD_LOGIC;
  irq      : OUT STD_LOGIC;  --signal to interrupt the processor
  outwave  : OUT STD_LOGIC
);
END COMPONENT servo_controller;
END PACKAGE servo_controller_pkg;