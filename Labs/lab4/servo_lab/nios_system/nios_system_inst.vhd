	component nios_system is
		port (
			clk_clk                       : in  std_logic := 'X'; -- clk
			reset_reset_n                 : in  std_logic := 'X'; -- reset_n
			servo_controller_ext_out_wave : out std_logic         -- ext_out_wave
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                       => CONNECTED_TO_clk_clk,                       --              clk.clk
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --            reset.reset_n
			servo_controller_ext_out_wave => CONNECTED_TO_servo_controller_ext_out_wave  -- servo_controller.ext_out_wave
		);

