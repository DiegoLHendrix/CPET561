LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- USE ieee.std_logic_signed.ALL;

ENTITY audio_filter IS
  PORT (
    CLOCK_50, reset_n : IN STD_LOGIC;
    write             : IN STD_LOGIC;
    address           : IN STD_LOGIC;
    writedata         : IN STD_LOGIC_VECTOR(15 DOWNTO 0)  := (OTHERS => '0');
    readdata          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
  );
END audio_filter;

ARCHITECTURE Structure OF audio_filter IS
  CONSTANT max_index : INTEGER := 15; -- Max number for the generate statements

  TYPE fixed_point_coeffs IS ARRAY (0 TO 16) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL high_coeffs     : fixed_point_coeffs; -- Coeffecient constants for high pass
  SIGNAL low_coeffs      : fixed_point_coeffs; -- Coeffecient constants for low pass
  SIGNAL constant_coeffs : fixed_point_coeffs; -- Holds the coeffecient constants for the chosen filter.

  -- Arrays to hold several versions of the input and output signals.
  TYPE t_array_in IS ARRAY (0 TO 16) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  TYPE t_array_out IS ARRAY (0 TO 16) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dataa_signals  : t_array_in;  -- Signal at the triangle’s input
  SIGNAL result_signals : t_array_out; -- Holds the output of the individual multiplier
  SIGNAL result         : t_array_in;  -- Holds the final value of the filter to be output

  SIGNAL delay_reg     : t_array_in;
  SIGNAL data_in       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL filter_en     : STD_LOGIC;
  SIGNAL filter_select : STD_LOGIC_VECTOR (15 DOWNTO 0);

  COMPONENT multiplier IS
    PORT (
      dataa  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      datab  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT multiplier;

BEGIN
  high_coeffs <= (
    X"003E", X"FF9A", X"FE9F", X"0000",
    X"0535", X"05B2", X"F5AC", X"DAB7",
    X"4C91", X"DAB7", X"F5AC", X"05B2",
    X"0525", X"0000", X"FE9F", X"FF9B",
    X"003E"
    );

  low_coeffs <= (
    X"0052", X"00BB", X"01E2", X"0408",
    X"071B", X"0AAD", X"0E11", X"1080",
    X"1162", X"1080", X"0E11", X"0AAD",
    X"071B", X"0408", X"01E2", X"00BB",
    X"0052"
    );

  delay_reg(0) <= data_in;

  filter_en_proc : PROCESS (write, address)
  BEGIN
    IF (write = '1') THEN
      IF (address = '0') THEN
        filter_en <= '1';
      ELSE
        filter_en <= '0';
      END IF;
    END IF;
  END PROCESS;

  data_in_proc : PROCESS (CLOCK_50, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      data_in <= (OTHERS => '0');
    ELSIF (RISING_EDGE(CLOCK_50)) THEN
      IF (write = '1') THEN
        IF (address = '0') THEN
          data_in <= writedata;
        ELSE
          -- Sets filtere select on address 1
          filter_select <= writedata;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  constant_coeffs_proc : PROCESS (CLOCK_50, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      constant_coeffs <= (
        X"0000", X"0000", X"0000", X"0000",
        X"0000", X"0000", X"0000", X"0000",
        X"0000", X"0000", X"0000", X"0000",
        X"0000", X"0000", X"0000", X"0000",
        X"0000"
        );
    ELSIF (RISING_EDGE(CLOCK_50)) THEN
      IF (filter_select = X"0000") THEN
        constant_coeffs <= low_coeffs;
      ELSE
        constant_coeffs <= high_coeffs;
      END IF;
    END IF;
  END PROCESS;

  generate_shift : FOR i IN 1 TO max_index GENERATE
    -- Enable process with data increment
    shift_reg : PROCESS (CLOCK_50, reset_n)
    BEGIN
      IF (reset_n = '0') THEN
        delay_reg(i) <= (OTHERS => '0'); -- Reset output
      ELSIF RISING_EDGE(CLOCK_50) THEN
        IF (filter_en = '1') THEN
          delay_reg(i) <= delay_reg(i - 1);
        END IF;
      END IF;
    END PROCESS;
  END GENERATE generate_shift;

  -- Instantiate 16 multipliers using a generate statement.
  generate_multi : FOR i IN 0 TO max_index GENERATE
  BEGIN
    dataa_signals(i) <= delay_reg(i); -- Set data_in as input for each multiplier

    MULTX : multiplier
    PORT MAP
    (
      dataa  => dataa_signals(i),
      datab  => constant_coeffs(i),
      result => result_signals(i)
    );
  END GENERATE generate_multi;

  result(0) <= STD_LOGIC_VECTOR(SIGNED(result_signals(0)(30 DOWNTO 15)));
  generate_adder : FOR i IN 1 TO max_index GENERATE
  BEGIN
    result(i) <= STD_LOGIC_VECTOR(SIGNED(result(i - 1)) + SIGNED(result_signals(i)(30 DOWNTO 15)));
  END GENERATE generate_adder;

  readdata <= result(max_index);

END Structure;
