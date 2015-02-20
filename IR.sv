module IR (input Clk, Reset,
				  LD_IR,
			input [15:0] D_in,
			output [15:0] D_out,
			output logic ContinueIR);

reg_16 IR_reg (.Clk, .Load(LD_IR), .Reset, .D_In, .R(D_Out));

	always_comb
	begin


endmodule