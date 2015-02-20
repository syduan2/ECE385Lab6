module IR (input Clk, Reset,
				  LD_IR,
			input [15:0] D_in,
			output [15:0] D_out);

reg_16 MAR_reg (.Clk, .Load(LD_IR), .Reset, .D_In, .R(D_Out));

endmodule