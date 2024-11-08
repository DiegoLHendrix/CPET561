LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY raminfr_be_tb IS
END raminfr_be_tb;

ARCHITECTURE behavior OF raminfr_be_tb IS

  -- Constants
  CONSTANT period : TIME := 20 ns;

  -- Signals
  SIGNAL CLOCK_50        : STD_LOGIC                     := '0';
  SIGNAL reset           : STD_LOGIC                     := '0';
  SIGNAL writebyteenable : STD_LOGIC_VECTOR(3 DOWNTO 0)  := (OTHERS => '0');
  SIGNAL address         : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
  SIGNAL writedata       : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL readdata        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

  FUNCTION to_hstring(slv : STD_LOGIC_VECTOR) RETURN STRING IS
    CONSTANT hexlen         : INTEGER                                   := (slv'length + 3)/4;
    VARIABLE longslv        : STD_LOGIC_VECTOR(slv'length + 3 DOWNTO 0) := (OTHERS => '0');
    VARIABLE hex            : STRING(1 TO hexlen);
    VARIABLE fourbit        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  BEGIN
    longslv(slv'length - 1 DOWNTO 0) := slv;
    FOR i IN hexlen - 1 DOWNTO 0 LOOP
      fourbit := longslv(i * 4 + 3 DOWNTO i * 4);
      CASE fourbit IS
        WHEN "0000" => hex(hexlen - i) := '0';
        WHEN "0001" => hex(hexlen - i) := '1';
        WHEN "0010" => hex(hexlen - i) := '2';
        WHEN "0011" => hex(hexlen - i) := '3';
        WHEN "0100" => hex(hexlen - i) := '4';
        WHEN "0101" => hex(hexlen - i) := '5';
        WHEN "0110" => hex(hexlen - i) := '6';
        WHEN "0111" => hex(hexlen - i) := '7';
        WHEN "1000" => hex(hexlen - i) := '8';
        WHEN "1001" => hex(hexlen - i) := '9';
        WHEN "1010" => hex(hexlen - i) := 'A';
        WHEN "1011" => hex(hexlen - i) := 'B';
        WHEN "1100" => hex(hexlen - i) := 'C';
        WHEN "1101" => hex(hexlen - i) := 'D';
        WHEN "1110" => hex(hexlen - i) := 'E';
        WHEN "1111" => hex(hexlen - i) := 'F';
        WHEN "ZZZZ" => hex(hexlen - i) := 'Z';
        WHEN "UUUU" => hex(hexlen - i) := 'U';
        WHEN "XXXX" => hex(hexlen - i) := 'X';
        WHEN OTHERS => hex(hexlen - i) := '?';
      END CASE;
    END LOOP;
    RETURN hex;
  END FUNCTION to_hstring;

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  -- uut: ENTITY work.top
  -- PORT MAP(
  --     CLOCK_50 => CLOCK_50,
  --     KEY      => KEY,
  --     LEDR     => LEDR
  -- );

  uut : ENTITY work.raminfr_be
    PORT MAP
    (
      CLOCK_50          => CLOCK_50,
      reset_n           => reset,
      writebyteenable_n => writebyteenable,
      address           => address,
      writedata         => writedata,
      readdata          => readdata
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
    WAIT FOR period;
    reset <= '1';
    WAIT;
  END PROCESS;

  -- Testbench stimulus process
  stimulus : PROCESS
  BEGIN
    -- Start simulation
    REPORT "****************** TB Start ****************" SEVERITY NOTE;

    WAIT FOR period;

    -- Test 1
    writebyteenable <= "1110";
    address         <= (OTHERS => '0');
    writedata       <= x"ABCDEF98";

    WAIT FOR period;
    ASSERT readdata(7 DOWNTO 0) = x"98"
    REPORT "Test 1 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    -- Test 2
    writebyteenable <= "1101";
    address         <= (OTHERS => '0');
    writedata       <= x"ABCDEF98";

    WAIT FOR period;
    ASSERT readdata(15 DOWNTO 8) = x"EF"
    REPORT "Test 2 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    -- Test 3
    writebyteenable <= "1011";
    address         <= (OTHERS => '0');
    writedata       <= x"ABCDEF98";

    WAIT FOR period;
    ASSERT readdata(23 DOWNTO 16) = x"CD"
    REPORT "Test 3 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    -- Test 4
    writebyteenable <= "0111";
    address         <= (OTHERS => '0');
    writedata       <= x"ABCDEF98";

    WAIT FOR period;
    ASSERT readdata(31 DOWNTO 24) = x"AB"
    REPORT "Test 4 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    -- Test 5
    writebyteenable <= "0000";
    address         <= (OTHERS => '0');
    writedata       <= (OTHERS => '0');

    WAIT FOR period;
    ASSERT readdata = x"00000000"
    REPORT "Test 5 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    -- Test 6
    writebyteenable <= "1100";
    address         <= (OTHERS => '0');
    writedata       <= x"ABCDEF98";

    WAIT FOR period;
    ASSERT readdata = x"0000EF98"
    REPORT "Test 6 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    -- Test 7
    writebyteenable <= "0011";
    address         <= (OTHERS => '0');
    writedata       <= x"ABCDEF98";

    WAIT FOR period;
    ASSERT readdata = x"ABCDEF98"
    REPORT "Test 7 failed: Expected x""ABCDEF98"", got " & to_hstring(readdata)
      SEVERITY ERROR;

    REPORT "****************** TB Finish ****************" SEVERITY NOTE;
    WAIT;
  END PROCESS;

END behavior;
