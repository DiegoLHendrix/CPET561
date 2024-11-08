LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY servo_controller_tb IS
END servo_controller_tb;

ARCHITECTURE behavior OF servo_controller_tb IS

    -- Constants
    constant period : time := 20 ns;

    -- Signals
    SIGNAL CLOCK_50 : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL write : STD_LOGIC := '0';
    SIGNAL LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL writedata : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL address : STD_LOGIC := '0';
    SIGNAL irq : STD_LOGIC;
    SIGNAL outwave : STD_LOGIC;

    SIGNAL max_angle : UNSIGNED(31 DOWNTO 0) := to_unsigned(100000, 32);
    SIGNAL min_angle : UNSIGNED(31 DOWNTO 0) := to_unsigned(50000, 32);

    -- Debugging signal to observe angle_count from inside the UUT
    SIGNAL angle_count : UNSIGNED(31 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ENTITY work.top
    PORT MAP(
        CLOCK_50   => CLOCK_50,
        reset      => reset,
        write      => write,
        SW         => (OTHERS => '0'),
        writedata  => writedata,
        LEDR       => LEDR,
        address    => address,
        irq        => irq,
        outwave    => outwave
    );

    -- Clock generation process
    CLOCK_50_gen: PROCESS
    BEGIN
        CLOCK_50 <= '0';
        WAIT FOR period / 2;
        CLOCK_50 <= '1';
        WAIT FOR period / 2;
    END PROCESS;

    -- Reset process
    async_reset: PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 2 * period;
        reset <= '0';
        WAIT;
    END PROCESS;

    -- Testbench stimulus process
    stimulus: PROCESS
    BEGIN
        -- Start simulation
        REPORT "****************** TB Start ****************" SEVERITY NOTE;

        -- Test case 1: Write max_angle
        address <= '0';   -- Writing to max_angle
        writedata <= x"000186A0";  -- Set max_angle to 100000
        write <= '1';
        WAIT FOR 8 * period;  -- Ensure write is held for enough cycles

        -- Test case 2: Write min_angle
        address <= '1';   -- Writing to min_angle
        writedata <= x"0000C350";  -- Set min_angle to 50000
        WAIT FOR 8 * period;  -- Ensure write is held for enough cycles

        -- Wait and monitor the angle_count
        WAIT FOR 1000 * period;
        REPORT "****************** TB Finish ****************" SEVERITY NOTE;
        WAIT;
    END PROCESS;

END behavior;
