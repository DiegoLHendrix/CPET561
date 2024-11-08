LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY WORK;
USE WORK.components.ALL;

ENTITY filter_tb IS
END filter_tb;

ARCHITECTURE behavior OF filter_tb IS

  -- Constants
  CONSTANT period : TIME := 20 ns;

  -- Signals
  SIGNAL CLOCK_50  : STD_LOGIC                     := '0';
  SIGNAL reset     : STD_LOGIC                     := '0';
  SIGNAL filter_en : STD_LOGIC                     := '0';
  SIGNAL data_in   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_out  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

  TYPE audioSampleArrayType IS ARRAY (0 TO 39) OF signed(15 DOWNTO 0);
  SIGNAL audioSampleArray : audioSampleArrayType;

  SIGNAL sim_done : BOOLEAN := false;

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut : ENTITY work.high_pass_filter
    PORT MAP
    (
      CLOCK_50  => CLOCK_50,
      reset_n   => reset,
      filter_en => filter_en,
      data_in   => data_in,
      data_out  => data_out
    );

  -- Clock generation process
  CLOCK_50_gen : PROCESS
  BEGIN
    CLOCK_50 <= '0';
    WAIT FOR period / 2;
    CLOCK_50 <= '1';
    WAIT FOR period / 2;
  END PROCESS;

  -- Reset process
  async_reset : PROCESS
  BEGIN
    reset <= '0';
    WAIT FOR 100 ns;
    reset <= '1';
    WAIT;
  END PROCESS;

  -- Testbench stimulus process
  stimulus : PROCESS IS
    FILE read_file      : text OPEN read_mode IS "../src/verification_src/one_cycle_200_8k.csv";
    FILE results_file   : text OPEN write_mode IS "../src/verification_src/output_waveform.csv";
    VARIABLE lineIn     : line;
    VARIABLE lineOut    : line;
    VARIABLE readValue  : INTEGER;
    VARIABLE writeValue : INTEGER;
  BEGIN
    WAIT FOR 100 ns;
    -- reset <= '1';
    -- Read data from file into an array
    FOR i IN 0 TO 39 LOOP
      readline(read_file, lineIn);
      read(lineIn, readValue);
      audioSampleArray(i) <= to_signed(readValue, 16);
      WAIT FOR 50 ns;
    END LOOP;
    file_close(read_file);

    -- Apply the test data and put the result into an output file
    FOR i IN 1 TO 10 LOOP
      FOR j IN 0 TO 39 LOOP

        -- Your code here...
        -- Read the data from the array and apply it to Data_In
        -- Remember to provide an enable pulse with each new sample

        -- Set data_in to the next sample and toggle filter_en
        data_in   <= STD_LOGIC_VECTOR(audioSampleArray(j));
        filter_en <= '1';
        WAIT FOR period;
        filter_en <= '0';

        -- Wait for the filter to process the data
        WAIT FOR period * 2;

        -- Write filter output to file
        writeValue := to_integer(signed(data_out));
        write(lineOut, writeValue);
        writeline(results_file, lineOut);

        -- Your code here...

      END LOOP;
    END LOOP;
    file_close(results_file);
    -- end simulation
    sim_done <= true;
    WAIT FOR 100 ns;
    -- last wait statement needs to be here to prevent the process
    -- sequence from restarting at the beginning
    WAIT;
  END PROCESS stimulus;
END behavior;