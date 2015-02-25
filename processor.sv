module processor (input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  //output logic [6:0] HEX0,
				  //					 HEX1,
				  //					 HEX2,
				  //					 HEX3,
				  output logic [15:0] ADDR,
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
				  Bus,
				  PC_out,
				  PC_out_1, 
				  PC_in,
				  MDR_in, 
				  MDR_out,
				  MAR_out,
				  MARMUX_out;
				  
	wire[1:0] ALUK;
	
	
	//I-seh-Desu
	ISDU control(.*,.ContinueIR(Continue),.Opcode(IR_out[15:12]),.IR_5(IR_out[5]));
	
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
	wire [15:0] ZEXT;
	assign ZEXT[15:8] = 8'b0;
	assign ZEXT[7:0] = IR_out[7:0];
	mux_2x1 MARMUX_mux(.In0(ZEXT), .In1(add_adder), .select(MARMUX), .Out(MARMUX_out)); // 0 is PC, 1 is Addition Adder
	tri_buffer_16 marmux_gate(.Enable(GateMARMUX), .In(MARMUX_out), .Out(CPU_Bus));
	
	//nzp Thing
	nzp nzp_logic
	
	//REGFILE
	wire [15:0] SR1_in, SR2_out, SR1_out, DR_in;
	//need to add SR1 SR2 DR Outputs in ISDU and Inputs in processor
	regfile REGFILE(.*, .Load(LD_REG), .SR1(SR1_in), .SR2(IR_out[2:0]), .DR(DR_in), .Bus(CPU_Bus)); //SR2 is always [2:0] right??
	mux_4x1 SR1MUX_mux(.In0(IR_out[11:9]), .In1(IR_out[8:6]), .In2(3'b110), .In3(3'b0), .select(SR1MUX), .Out(SR1_in));
	mux_4x1 DRMUX_mux(.In0(IR_out[11:9]), .In1(3'b110), .In2(3'b111), .In3(3'b0), .select(DRMUX), .Out(DR_in));
	
	//ALU
	wire [15:0]SR2MUX_out, ALU_out;
	mux_2x1 SR2MUX_mux(.In0(SEXT5), .In1(SR2_out), .select(SR2MUX), .Out(SR2MUX_out));
	ALU_K ALU(.*, .A_in(SR1_out), .B_in(SR2MUX_out), .ALU_K_out(ALU_out));
	tri_buffer_16 alu_gate(.Enable(GateALU), .In(ALU_out), .Bus(CPU_Bus));
	
	//Addition Adder + ADDR1MUX/ADDR2MUX
	wire [15:0] ADD_in1, ADD_in2;
	mux_2x1 ADDR1MUX_mux(.In0(SR1_out), .In1(PC_out), .select(ADDR1MUX), .Out(ADD_in1)); // 0 is SR1, 1 is PC
	mux_4x1 ADDR2MUX_mux(.In0(SEXT11), .In1(SEXT9), .In2(SEXT6), .In3(16'b0), .select(ADDR2MUX), .Out(ADD_in2));
	wire [15:0] add_adder;
	assign add_adder = ADD_in1 + ADD_in2;
	
	//SEXTs-------------------------------
	wire [15:0] SEXT11;
	assign SEXT11[10:0] = IR_out[10:0];
   integer i;
	for (i = 11; i < 16; i = i + 1) // FOR LOOPS NOT WORKING WAT
		assign SEXT11[i] = IR_out[10];
		
	wire [15:0] SEXT9;
	assign SEXT9[8:0] = IR_out[8:0];
	integer j;
	for(j = 9; j < 16; j = j + 1)
		assign SEXT9[i] = IR_out[8];

	wire [15:0] SEXT6;
	assign SEXT6[5:0] = IR_out[5:0];
	integer k;
	for (k = 6; k < 16; k = k + 1)
		assign SEXT6[i] = IR_out[5];
		
	wire [15:0] SEXT5;
	assign SEXT5[4:0] = IR_out[4:0];
	integer l;
	for (l = 5; l < 16; l = l + 1)
		assign SEXT5[i] = IR_out[4];
	//-------------------------------------

	assign ADDR=MAR_out;
//	assign Mem_Bus=MDR_out;
	assign CE=Mem_CE;
	assign UB=Mem_UB;
	assign LB=Mem_LB;
	assign OE=Mem_OE;
	assign WE=Mem_WE;
	assign IR_val=IR_out;
	
endmodule
