module SLC3(input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3);
	wire CE, UB, LB, OE, WE;
	wire[15:0] Bus,IR_val;
	logic[19:0] WTF_IS_A; //is it address?
	initial begin
		WTF_IS_A=20'b0;
	end
	processor CPU(.*, .Reset(~Reset), .Run(~Run), .ADDR(WTF_IS_A[15:0]), .CPU_Bus(Bus));
	//Mem2IO  MEMIO(.*, .A(WTF_IS_A), .Switches(S), .HEX0(6'bZZZZZZ), .HEX1(6'bZZZZZZ), .HEX2(6'bZZZZZZ), .HEX3(6'bZZZZZZ) );
	test_memory MEMTEST(.*, .Reset(~Reset), .I_O(Bus), .A(WTF_IS_A));
	HexDriver out0(.In0(IR_val[3:0]), .Out0(HEX0));
	HexDriver out1(.In0(IR_val[7:4]), .Out0(HEX1));
	HexDriver out2(.In0(IR_val[11:8]), .Out0(HEX2));
	HexDriver out3(.In0(IR_val[15:12]), .Out0(HEX3));
endmodule
