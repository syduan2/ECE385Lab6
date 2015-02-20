module PC (input [15:0] Data_Path,
						ALU,
		   input LD_PC, Clk, Reset,
		   input [1:0] PCMUX,
		   output [15:0] PC_out);

	logic [15:0] mux_out;

	pc_mux MUX_PC(.D_in0(PC_out), .D_in1(ALU), .D_in2(Data_Path), .sel(PCMUX), .D_out(mux_out));
	reg_16 pc_reg(.*, .Load(LD_PC), .Reset, .D_in(mux_out), .D_out(PC_out));

endmodule
