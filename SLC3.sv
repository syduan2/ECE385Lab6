module SLC3(input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3);
	wire CE, UB, LB, OE, WE;
	wire[15:0] Data_CPU, Data_Mem;
	wire[19:0] WTF_IS_A; //is it address?
	initial begin
		WTF_IS_A[19:16]=4'b0;
	end
	processor CPU(.*, .ADDR(WTF_IS_A[15:0]), .CPU_Bus(Data_CPU), .Mem_Bus(Data_Mem));
	//Mem2IO  MEMIO(.*, .A(WTF_IS_A), .Switches(S), .HEX0(6'bZZZZZZ), .HEX1(6'bZZZZZZ), .HEX2(6'bZZZZZZ), .HEX3(6'bZZZZZZ) );
	test_memory MEMTEST(.*, .I_O(Data_Mem), .A(WTF_IS_A));

	
endmodule
