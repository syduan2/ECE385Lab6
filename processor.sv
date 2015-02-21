module processor (input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [11:0] LED,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3,
				  output logic [19:0] ADDR,
				  inout logic [15:0] Data);

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
	mux_4x1(.In0(PC_1), .In1(16'b0), .In2(Bus), .In3(16'b0), .select(PCMUX), .Out(PC_in));
	tri_buffer_16 pc_gate(.Enable(GatePC), .In(PC), .Out(Bus));
	
	//MDR
	reg_16 MDR(.*, .Load(LD_MDR), .Reset(0), .D_in(MDR_in), .R(MDR_out));
	mux_2x1(.In0(Bus), .In1(SRAM_bus), .select(Mem_OE), .Out(MDR_in));
	tri_buffer_16 mdr_gate_PC(.Enable(GateMDR), .In(MDR_out), .Out(Bus));
	tri_buffer_16 mdr_gate_SRAM(.Enable(GateMDR), .In(MDR_out), .Out(SRAM_bus));
	
	reg_16 MAR(.*, .Load(LD_MAR), .Reset(0), .D_in(Bus), .R(MAR_out));

	
endmodule