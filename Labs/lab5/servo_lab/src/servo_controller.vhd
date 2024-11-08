-- This is the servo_controller_level VHDL file for the timer interrupt demo
-- that is being done as a hands-on demo.  The NIOS System
-- generated from the SOPC builder contains a NIOS II/s processor,
-- a 32k on-chip memory, a JTAG UART, an 8-bit output PIO that will
-- connect to the LEDs and a simple periodic interrupt 
-- generator with a 1 sec. time-out period. 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY servo_controller IS
  GENERIC (
    max_angle : IN UNSIGNED(31 DOWNTO 0) := to_unsigned(100000, 32);
    min_angle : IN UNSIGNED(31 DOWNTO 0) := to_unsigned(50000, 32)
  );
  PORT (
    CLOCK_50  : IN STD_LOGIC;
    reset     : IN STD_LOGIC;
    write     : IN STD_LOGIC;
    writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    address   : IN STD_LOGIC;
    irq       : OUT STD_LOGIC; --signal to interrupt the processor
    outwave   : OUT STD_LOGIC
  );
END servo_controller;
ARCHITECTURE Structure OF servo_controller IS

  TYPE State IS (SWEEP_RIGHT, INT_RIGHT, SWEEP_LEFT, INT_LEFT);

  SIGNAL CurrentState, NextState : State;

  SIGNAL angle_count   : UNSIGNED(31 DOWNTO 0);
  SIGNAL period_count  : UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pulse_count   : UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');
  CONSTANT max_period  : UNSIGNED(31 DOWNTO 0) := to_unsigned(1000000, 32); -- 20ms in 50MHz clock cycles
  SIGNAL max_angle_reg : UNSIGNED(31 DOWNTO 0) := to_unsigned(100000, 32);
  SIGNAL min_angle_reg : UNSIGNED(31 DOWNTO 0) := to_unsigned(50000, 32);

BEGIN

  -- Clock process
  clk_state : PROCESS (CLOCK_50, reset)
  BEGIN
    IF (reset = '0') THEN
      CurrentState <= INT_RIGHT;
    ELSIF RISING_EDGE(CLOCK_50) THEN
      CurrentState <= NextState;
    END IF;
  END PROCESS clk_state;

  PROCESS (CLOCK_50, reset)
  BEGIN
    IF (RISING_EDGE(CLOCK_50)) THEN
      IF (reset = '0') THEN
        max_angle_reg <= to_unsigned(100000, 32);
        min_angle_reg <= to_unsigned(50000, 32);
      ELSIF write = '1' THEN
        IF address = '0' THEN
          max_angle_reg <= UNSIGNED(writedata);
        ELSE
          min_angle_reg <= UNSIGNED(writedata);
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -- State transitions
  update_state : PROCESS (CurrentState, write, angle_count, max_angle_reg, min_angle_reg)
  BEGIN
    CASE CurrentState IS
      WHEN SWEEP_RIGHT =>
        IF (angle_count >= max_angle_reg) THEN
          NextState <= INT_RIGHT;
        ELSE
          NextState <= SWEEP_RIGHT;
        END IF;

      WHEN INT_RIGHT =>
        IF (write = '1') THEN
          NextState <= SWEEP_LEFT;
        ELSE
          NextState <= INT_RIGHT;
        END IF;

      WHEN SWEEP_LEFT =>
        IF (angle_count <= min_angle_reg) THEN
          NextState       <= INT_LEFT;
        ELSE
          NextState <= SWEEP_LEFT;
        END IF;

      WHEN INT_LEFT =>
        IF (write = '1') THEN
          NextState <= SWEEP_RIGHT;
        ELSE
          NextState <= INT_LEFT;
        END IF;

      WHEN OTHERS =>
        NextState <= SWEEP_RIGHT; -- Default state assignment

    END CASE;
  END PROCESS update_state;

  -- Handle outputs
  NS_decode : PROCESS (CurrentState)
  BEGIN
    CASE CurrentState IS
      WHEN SWEEP_RIGHT =>
        irq <= '0';
      WHEN INT_RIGHT =>
        irq <= '1';
      WHEN SWEEP_LEFT =>
        irq <= '0';
      WHEN INT_LEFT =>
        irq                <= '1';
      WHEN OTHERS => irq <= '0';
    END CASE;
  END PROCESS NS_decode;

  -- Increment angle process
  angle_proc : PROCESS (CLOCK_50, reset, angle_count)
  BEGIN
    IF (reset = '0') THEN
      angle_count <= (OTHERS => '0');
    ELSIF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
      IF ((CurrentState = SWEEP_RIGHT) AND (period_count = max_period)) THEN
        angle_count <= angle_count + 500;
      ELSIF ((CurrentState = SWEEP_LEFT) AND (period_count = max_period)) THEN
        angle_count <= angle_count - 500;
      ELSE
        angle_count <= angle_count;
      END IF;
    END IF;
  END PROCESS angle_proc;

  -- Period Counter Process
  period_proc : PROCESS (CLOCK_50, reset)
  BEGIN
    IF (reset = '0') THEN
      period_count <= (OTHERS => '0');
    ELSIF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
      IF (period_count < max_period) THEN
        period_count <= period_count + 1;
      ELSE
        period_count <= (OTHERS => '0');

      END IF;
    END IF;
  END PROCESS period_proc;

  -- Pulse width process
  pulse_proc : PROCESS (CLOCK_50, reset, pulse_count, period_count)
  BEGIN
    IF (reset = '0') THEN
      pulse_count <= (OTHERS => '0');
    ELSIF RISING_EDGE(CLOCK_50) THEN
      IF (period_count < max_period) THEN
        pulse_count <= pulse_count + 1;
      ELSE
        pulse_count <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS pulse_proc;

  out_proc : PROCESS (CLOCK_50, reset, pulse_count, angle_count)
  BEGIN
    IF (reset = '0') THEN
      outwave <= '0';
    ELSIF RISING_EDGE(CLOCK_50) THEN
      IF (pulse_count < angle_count) THEN
        outwave <= '1';
      ELSE
        outwave <= '0';
      END IF;
    END IF;
  END PROCESS out_proc;

END Structure;