	component nios_system is
		port (
			clk_clk          : in  std_logic                    := 'X';             -- clk
			hex0_export      : out std_logic_vector(6 downto 0);                    -- export
			hex1_export      : out std_logic_vector(6 downto 0);                    -- export
			hex2_export      : out std_logic_vector(6 downto 0);                    -- export
			hex4_export      : out std_logic_vector(6 downto 0);                    -- export
			hex5_export      : out std_logic_vector(6 downto 0);                    -- export
			keys_export      : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n    : in  std_logic                    := 'X';             -- reset_n
			switches_export  : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			servo_ip_outwave : out std_logic                                        -- outwave
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --      clk.clk
			hex0_export      => CONNECTED_TO_hex0_export,      --     hex0.export
			hex1_export      => CONNECTED_TO_hex1_export,      --     hex1.export
			hex2_export      => CONNECTED_TO_hex2_export,      --     hex2.export
			hex4_export      => CONNECTED_TO_hex4_export,      --     hex4.export
			hex5_export      => CONNECTED_TO_hex5_export,      --     hex5.export
			keys_export      => CONNECTED_TO_keys_export,      --     keys.export
			reset_reset_n    => CONNECTED_TO_reset_reset_n,    --    reset.reset_n
			switches_export  => CONNECTED_TO_switches_export,  -- switches.export
			servo_ip_outwave => CONNECTED_TO_servo_ip_outwave  -- servo_ip.outwave
		);

