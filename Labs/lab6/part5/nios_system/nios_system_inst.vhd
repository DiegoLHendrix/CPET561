	component nios_system is
		port (
			clk_clk       : in  std_logic                    := 'X';             -- clk
			key_export    : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			ledr_export   : out std_logic_vector(9 downto 0);                    -- export
			reset_reset_n : in  std_logic                    := 'X'              -- reset_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			key_export    => CONNECTED_TO_key_export,    --   key.export
			ledr_export   => CONNECTED_TO_ledr_export,   --  ledr.export
			reset_reset_n => CONNECTED_TO_reset_reset_n  -- reset.reset_n
		);

