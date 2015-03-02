module SLC3(input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3,
					output logic[19:0] A,
					output logic[11:0] LED,
					inout [15:0] Mem_bus,
					output logic OE_out, WE_out, CE_out, UB_out, LB_out);
	wire CE, UB, LB, OE, WE;
	wire[15:0] IR_val, Bus;	
	//wire[15:0] Bus;
	wire[3:0] hex0,hex1,hex2,hex3;
	logic[19:0] WTF_IS_A; //is it address?
	initial begin
		WTF_IS_A=20'b0;
	end
	processor CPU(.*, .Reset(~Reset), .Run(~Run), .ADDR(WTF_IS_A[15:0]), .CPU_Bus(Bus));
	Mem2IO  MEMIO(.*,.Reset(~Reset),.HEX0(hex0), .HEX1(hex1), .HEX2(hex2), .HEX3(hex3), .A(WTF_IS_A), .Switches(S),.Data_CPU(Bus), .Data_Mem(Mem_bus));// .HEX0(6'bZZZZZZ), .HEX1(6'bZZZZZZ), .HEX2(6'bZZZZZZ), .HEX3(6'bZZZZZZ) );
	//test_memory MEMTEST(.*, .Reset(~Reset), .I_O(Mem_bus), .A(WTF_IS_A));
	HexDriver out0(.In0(hex0), .Out0(HEX0));
	HexDriver out1(.In0(hex1), .Out0(HEX1));
	HexDriver out2(.In0(hex2), .Out0(HEX2));
	HexDriver out3(.In0(hex3), .Out0(HEX3));
	assign A=WTF_IS_A;
	assign CE_out=CE;
	assign WE_out=WE;
	assign OE_out=OE;
	assign UB_out=UB;
	assign LB_out=LB;
endmodule
