module carry_select_adder_16(input[15:0] A,B, input c_in, output logic[15:0] S, output logic c_out);

logic[16:0] Sum;
always_comb begin
	Sum=A+B+c_in;
end
assign S=Sum[15:0];
assign c_out=Sum[16];
endmodule
