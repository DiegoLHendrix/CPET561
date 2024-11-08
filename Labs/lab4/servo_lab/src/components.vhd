LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all; 

PACKAGE top_pkg IS
COMPONENT top IS 
PORT ( 	
  CLOCK_50  : IN STD_LOGIC; 					-- 50MHz clock
  reset     : IN STD_LOGIC;
  write    : IN  STD_LOGIC;
  SW 	    : IN STD_LOGIC_VECTOR(9 DOWNTO 0);	-- Switch inputs
  writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  address   : IN STD_LOGIC;
  LEDR	    : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- LED outputs
  irq       : OUT STD_LOGIC;					-- IRQ output
  outwave   : OUT STD_LOGIC
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
  LEDR     : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
  outwave  : OUT STD_LOGIC
);
END COMPONENT servo_controller;
END PACKAGE servo_controller_pkg;