module carry_select_adder_16(input[15:0] A,B, input c_in, output[15:0] S, output c_out);

wire c;
carry_select_adder_8(.*,.c_in(c),.A(A[15:8]),.B(B[15:8]));
carry_select_adder_8(.*,.c_out(c),.A(A[7:0]),.B(B[7:0]));
endmodule
