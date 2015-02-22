module processor (input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3,
				  output logic [15:0] ADDR,
				  inout logic [15:0] Data,
				  output logic Mem_CE_out,
									Mem_UB_out,
									Mem_LB_out,
									Mem_OE_out,
									Mem_WE_out);

	wire 	LD_MAR,
			LD_MDR,
			LD_IR,
			LD_BEN,
			LD_CC,
			LD_REG,
			LD_PC,
			GatePC,
		  GateMDR,
		  GateALU,
		  GateMARMUX;

	wire [1:0] 	PCMUX,
					DRMUX,
					SR1MUX;
	wire 	SR2MUX,
			ADDR1MUX;
	
	wire [1:0] ADDR2MUX;

	wire MARMUX;

	wire 	Mem_CE,
			Mem_UB,
			Mem_LB,
			Mem_OE, //Output Enable
	   	Mem_WE; //Write Enable
	wire[15:0] IR_out, Bus, SRAM_bus,
			PC_out,PC_out_1, PC_in,
			MDR_in, MDR_out,
			MAR_out;
	wire[1:0] ALUK;
	
	
	//I-seh-Desu
	ISDU control(.*,.ContinueIR(Continue),.Opcode(IR_out[15:12]),.IR_5(IR_out[5]));
	
	//IR
	reg_16 IR(.*, .Load(LD_IR), .Reset(0), .D_in(Bus), .R(IR_out));
	
	//PC
	reg_16 PC(.*, .Load(LD_PC), .Reset(0), .D_in(PC_in), .R(PC_out));
	mux_4x1(.In0(PC_out_1), .In1(16'b0), .In2(Bus), .In3(16'b0), .select(PCMUX), .Out(PC_in));
	tri_buffer_16 pc_gate(.Enable(GatePC), .In(PC), .Out(Bus));
	carry_select_adder_16(.A(PC_out), .B(16'b0), .c_in(1'b1), .c_out(1'bz), .S(PC_out_1));
	
	
	//MDR
	reg_16 MDR(.*, .Load(LD_MDR), .Reset(0), .D_in(MDR_in), .R(MDR_out));
	mux_2x1(.In0(Bus), .In1(SRAM_bus), .select(Mem_OE), .Out(MDR_in));
	tri_buffer_16 mdr_gate_PC(.Enable(GateMDR), .In(MDR_out), .Out(Bus));
	tri_buffer_16 mdr_gate_SRAM(.Enable(GateMDR), .In(MDR_out), .Out(SRAM_bus));
	
	reg_16 MAR(.*, .Load(LD_MAR), .Reset(0), .D_in(Bus), .R(MAR_out));
	
	HexDriver out0(.In0(IR_out[3:0]), .Out0(HEX0));
	HexDriver out1(.In0(IR_out[7:4]), .Out0(HEX1));
	HexDriver out2(.In0(IR_out[11:8]), .Out0(HEX2));
	HexDriver out3(.In0(IR_out[15:12]), .Out0(HEX3));
	assign ADDR=MAR_out;
	assign Data=MDR_out;
	assign Mem_CE_out=Mem_CE;
	assign Mem_UB_out=Mem_UB;
	assign Mem_LB_out=Mem_LB;
	assign Mem_OE_out=Mem_OE;
	assign Mem_WE_out=Mem_WE;
	
endmodule