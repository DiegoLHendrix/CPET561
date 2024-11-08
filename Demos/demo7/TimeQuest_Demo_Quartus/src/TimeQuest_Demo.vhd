LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TimeQuest_Demo IS
  PORT (
    -- General input signals
    CLOCK_50 : IN STD_LOGIC;
    reset_n  : IN STD_LOGIC;
    A        : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    B        : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    result   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END TimeQuest_Demo;

ARCHITECTURE rtl OF TimeQuest_Demo IS
  SIGNAL a_sync_1      : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL a_sync_2      : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL b_sync_1      : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL b_sync_2      : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL result_async  : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL result_sync_1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
  --   Nios II system component

BEGIN

  double_flop : PROCESS (CLOCK_50, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      a_sync_1 <= (OTHERS => '0');
      a_sync_2 <= (OTHERS => '0');

      b_sync_1 <= (OTHERS => '0');
      b_sync_2 <= (OTHERS => '0');
    ELSIF RISING_EDGE(CLOCK_50) THEN
      a_sync_1 <= A;
      a_sync_2 <= a_sync_1;

      b_sync_1 <= B;
      b_sync_2 <= b_sync_1;
    END IF;
  END PROCESS;

  adder_proc : PROCESS (a_sync_2, b_sync_2)
  BEGIN
    result_async <= STD_LOGIC_VECTOR(UNSIGNED(a_sync_2) + UNSIGNED(b_sync_2));
  END PROCESS adder_proc;

  result_sync : PROCESS (CLOCK_50, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      result <= (OTHERS => '0');
    ELSIF RISING_EDGE(CLOCK_50) THEN
      result_sync_1 <= result_async;
      result        <= result_sync_1;
    END IF;
  END PROCESS result_sync;
END rtl;