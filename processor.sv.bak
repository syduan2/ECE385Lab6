module processor (input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [11:0] LED,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3,
				  output logic [19:0] ADDR,
				  inout logic [15:0] Data)

	logic 	LD_MAR,
			LD_MDR,
			LD_IR,
			LD_BEN,
			LD_CC,
			LD_REG,
			LD_PC,

	logic GatePC,
		  GateMDR,
		  GateALU,
		  GateMARMUX,

	logic [1:0] PCMUX,
                DRMUX,
				SR1MUX,
	logic SR2MUX,
		  ADDR1MUX,
	
	logic [1:0] ADDR2MUX,

	logic MARMUX,

	logic Mem_CE,
		  Mem_UB,
	   	  Mem_LB,
		  Mem_OE,
	   	  Mem_WE,

	ISDU control
	IR instruct_reg
	MAR address_reg
	MDR data_reg
	PC prog_counter
	HexDriver hex_disp