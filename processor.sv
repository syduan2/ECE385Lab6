module processor (input Clk, Reset, Run, Continue,
				  input [15:0] S,
				  output logic [11:0] LED,
				  output logic [6:0] HEX0,
				  					 HEX1,
				  					 HEX2,
				  					 HEX3,
				  output logic [19:0] ADDR,
				  inout logic [15:0] Data)

	