
module nios_system (
	clk_clk,
	key_export,
	ledr_export,
	reset_reset_n);	

	input		clk_clk;
	input	[3:0]	key_export;
	output	[7:0]	ledr_export;
	input		reset_reset_n;
endmodule
