module MDR (input Clk, Reset,
				  LD_MDR,
			input [15:0] D_in,
			output [15:0] D_out);

reg_16 MDR_reg (.Clk, .Load(LD_MDR), .Reset, .D_In, .R(D_Out));

endmodule