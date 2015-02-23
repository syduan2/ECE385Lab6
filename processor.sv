module processor (input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  //output logic [6:0] HEX0,
				  //					 HEX1,
				  //					 HEX2,
				  //					 HEX3,
				  output logic [15:0] ADDR,
				  inout logic [15:0] CPU_Bus, IR_val,
				  output logic CE,
									UB,
									LB,
									OE,
									WE);

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

	wire MARMUX, c_out_arb;

	wire 	Mem_CE,
			Mem_UB,
			Mem_LB,
			Mem_OE, //Output Enable
	   	Mem_WE; //Write Enable
	wire[15:0] IR_out, Bus,
			PC_out,PC_out_1, PC_in,
			MDR_in, MDR_out,
			MAR_out;
	wire[1:0] ALUK;
	
	
	//I-seh-Desu
	ISDU control(.*,.ContinueIR(Continue),.Opcode(IR_out[15:12]),.IR_5(IR_out[5]));
	
	//IR
	reg_16 IR(.*, .Load(LD_IR), .Reset(Reset), .D_in(CPU_Bus), .R_out(IR_out));
	
	//PC
	reg_16 PC(.*, .Load(LD_PC), .Reset(Reset), .D_in(PC_in), .R_out(PC_out));
	mux_4x1 PC_mux(.In0(PC_out_1), .In1(16'b0), .In2(CPU_Bus), .In3(16'b0), .select(PCMUX), .Out(PC_in));
	tri_buffer_16 pc_gate(.Enable(GatePC), .In(PC_out), .Out(CPU_Bus));
	carry_select_adder_16 PC_adder(.A(PC_out), .B(16'b0), .c_in(1'b1), .c_out(c_out_arb), .S(PC_out_1));
	
	
	//MDR
//	reg_16 MDR(.*, .Load(LD_MDR), .Reset(0), .D_in(MDR_in), .R(MDR_out));
//	mux_2x1 MDR_mux(.In0(Bus), .In1(SRAM_bus), .select(Mem_OE), .Out(MDR_in));
	reg_16 MDR(.*, .Load(LD_MDR), .Reset(Reset), .D_in(CPU_Bus), .R_out(MDR_out));
	tri_buffer_16 mdr_gate_PC(.Enable(GateMDR), .In(MDR_out), .Out(CPU_Bus));
//	tri_buffer_16 mdr_gate_SRAM(.Enable(GateMDR), .In(MDR_out), .Out(SRAM_bus));
	
	reg_16 MAR(.*, .Load(LD_MAR), .Reset(Reset), .D_in(CPU_Bus), .R_out(MAR_out));

	

	assign ADDR=MAR_out;
//	assign Mem_Bus=MDR_out;
	assign CE=Mem_CE;
	assign UB=Mem_UB;
	assign LB=Mem_LB;
	assign OE=Mem_OE;
	assign WE=Mem_WE;
	assign IR_val=IR_out;
	
endmodule