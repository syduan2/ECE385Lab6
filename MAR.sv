module MAR (input Clk, Reset,
				  LD_MAR,
			input [15:0] D_in,
			output [15:0] D_out);

reg_16 MAR_reg (.Clk, .Load(LD_MAR), .Reset, .D_In, .R(D_Out));

endmodule