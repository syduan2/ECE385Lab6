module processor (input Clk, Reset, Run, Continue,
						input [15:0] S,
						output logic [15:0] ADDR,
						output logic [11:0] LED,
						inout  [15:0] CPU_Bus,
						output logic[15:0] IR_val,
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
			LD_LED,
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
			
	wire[15:0] IR_out, 
				  PC_out,
				  PC_out_1, 
				  PC_in,
				  MDR_in, 
				  MDR_out,
				  MAR_out,
				  MARMUX_out;
				  
	wire[1:0] ALUK;
	wire [15:0] add_adder;
	wire [15:0] SR1_in, SR2_Out, SR1_Out, DR_in;
	wire [2:0] NZP_in, NZP_out;
	wire BEN_out;
	wire [15:0] ZEXT;
	wire [15:0] ADD_in1, ADD_in2;
	wire [15:0]SR2MUX_out, ALU_out;
	wire [15:0] SEXT11_out, SEXT9_out, SEXT6_out, SEXT5_out;
	//I-seh-Desu
	ISDU control(.*,.Opcode(IR_out[15:12]),.IR_5(IR_out[5]), .BEN(BEN_out));
	
	//IR
	reg_16 IR(.*, .Load(LD_IR), .Reset(Reset), .D_in(CPU_Bus), .R_out(IR_out));
	
	//PC
	reg_16 PC(.*, .Load(LD_PC), .Reset(Reset), .D_in(PC_in), .R_out(PC_out));
	mux_4x1 PC_mux(.In0(PC_out_1), .In1(add_adder), .In2(CPU_Bus), .In3(16'b0), .select(PCMUX), .Out(PC_in));
	tri_buffer_16 pc_gate(.Enable(GatePC), .In(PC_out), .Out(CPU_Bus));
	carry_select_adder_16 PC_adder(.A(PC_out), .B(16'b0), .c_in(1'b1), .c_out(c_out_arb), .S(PC_out_1));
	
	
	//MDR
//	reg_16 MDR(.*, .Load(LD_MDR), .Reset(0), .D_in(MDR_in), .R(MDR_out));
//	mux_2x1 MDR_mux(.In0(Bus), .In1(SRAM_bus), .select(Mem_OE), .Out(MDR_in));
	reg_16 MDR(.*, .Load(LD_MDR), .Reset(Reset), .D_in(CPU_Bus), .R_out(MDR_out));
	tri_buffer_16 mdr_gate_PC(.Enable(GateMDR), .In(MDR_out), .Out(CPU_Bus));
//	tri_buffer_16 mdr_gate_SRAM(.Enable(GateMDR), .In(MDR_out), .Out(SRAM_bus));
	
	//MAR
	reg_16 MAR(.*, .Load(LD_MAR), .Reset(Reset), .D_in(CPU_Bus), .R_out(MAR_out));

	//MARMUX
	
	assign ZEXT[15:8] = 8'b0;
	assign ZEXT[7:0] = IR_out[7:0];
	mux_2x1 MARMUX_mux(.In0(ZEXT), .In1(add_adder), .select(MARMUX), .Out(MARMUX_out)); // 0 is PC, 1 is Addition Adder
	tri_buffer_16 marmux_gate(.Enable(GateMARMUX), .In(MARMUX_out), .Out(CPU_Bus));
	
	//nzp Thing
	
	nzp_logic NZP_logic (.D_in(CPU_Bus), .D_out(NZP_in));
	reg_3 NZP_reg (.*, .Load(LD_CC), .D_in(NZP_in), .R_out(NZP_out));
	reg_1 BEN_reg (.*, .Load(LD_BEN), .D_in1(NZP_out), .D_in2(IR_out[11:9]), .R_out(BEN_out));
	
	//REGFILE
	
	//need to add SR1 SR2 DR Outputs in ISDU and Inputs in processor
	regfile REGFILE(.*, .Load(LD_REG), .SR1(SR1_in), .SR2(IR_out[2:0]), .DR(DR_in), .Bus(CPU_Bus)); //SR2 is always [2:0] right??
	mux_4x1 SR1MUX_mux(.In0(IR_out[11:9]), .In1(IR_out[8:6]), .In2(3'b110), .In3(3'b0), .select(SR1MUX), .Out(SR1_in));
	mux_4x1 DRMUX_mux(.In0(IR_out[11:9]), .In1(3'b110), .In2(3'b111), .In3(3'b0), .select(DRMUX), .Out(DR_in));
	
	//ALU
	
	mux_2x1 SR2MUX_mux(.In0(SEXT5_out), .In1(SR2_Out), .select(SR2MUX), .Out(SR2MUX_out));
	ALU_K ALU(.*, .A_in(SR1_Out), .B_in(SR2MUX_out), .ALU_K_out(ALU_out));
	tri_buffer_16 alu_gate(.Enable(GateALU), .In(ALU_out), .Out(CPU_Bus));
	
	//Addition Adder + ADDR1MUX/ADDR2MUX
	
	mux_2x1 ADDR1MUX_mux(.In0(SR1_Out), .In1(PC_out), .select(ADDR1MUX), .Out(ADD_in1)); // 0 is SR1, 1 is PC
	mux_4x1 ADDR2MUX_mux(.In0(SEXT11_out), .In1(SEXT9_out), .In2(SEXT6_out), .In3(16'b0), .select(ADDR2MUX), .Out(ADD_in2));
	
	assign add_adder = ADD_in1 + ADD_in2;
	
	//SEXTs-------------------------------
	
	SEXT11 sext_11 (.*, .Input(IR_out[10:0]));
	SEXT9 sext_9 (.*, .Input(IR_out[8:0]));
	SEXT6 sext_6 (.*, .Input(IR_out[5:0]));
	SEXT5 sext_5 (.*, .Input(IR_out[4:0]));
	//-------------------------------------
	assign LED= LD_LED ? IR_out[11:0] : 12'b0; 
	assign ADDR=MAR_out;
//	assign Mem_Bus=MDR_out;
	assign CE=Mem_CE;
	assign UB=Mem_UB;
	assign LB=Mem_LB;
	assign OE=Mem_OE;
	assign WE=Mem_WE;
	assign IR_val=IR_out;
	
endmodule
