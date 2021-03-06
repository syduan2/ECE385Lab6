module regfile (input Clk, Load, Reset, 
					 input [2:0] SR1, SR2, DR,
					 inout [15:0] Bus,
					 output logic [15:0] SR2_Out, SR1_Out);
					 
	wire [15:0] R0_Out,
					R1_Out,
					R2_Out,
					R3_Out,
					R4_Out,
					R5_Out,
					R6_Out,
					R7_Out;
	
	logic LoadR0,
		  LoadR1,
		  LoadR2,
		  LoadR3,
		  LoadR4,
		  LoadR5,
		  LoadR6,
		  LoadR7;
					 
	reg_16 R0 (.*, .Load(LoadR0), .D_in(Bus), .R_out(R0_Out));
	reg_16 R1 (.*, .Load(LoadR1), .D_in(Bus), .R_out(R1_Out));
	reg_16 R2 (.*, .Load(LoadR2), .D_in(Bus), .R_out(R2_Out));
	reg_16 R3 (.*, .Load(LoadR3), .D_in(Bus), .R_out(R3_Out));
	reg_16 R4 (.*, .Load(LoadR4), .D_in(Bus), .R_out(R4_Out));
	reg_16 R5 (.*, .Load(LoadR5), .D_in(Bus), .R_out(R5_Out));
	reg_16 R6 (.*, .Load(LoadR6), .D_in(Bus), .R_out(R6_Out));
	reg_16 R7 (.*, .Load(LoadR7), .D_in(Bus), .R_out(R7_Out));
	
	always_comb
	begin
	
		LoadR0 = 1'b0;
		LoadR1 = 1'b0;
		LoadR2 = 1'b0;
		LoadR3 = 1'b0;
		LoadR4 = 1'b0;
		LoadR5 = 1'b0;
		LoadR6 = 1'b0;
		LoadR7 = 1'b0;
		
		SR1_Out = 16'b0000000000000000;
		SR2_Out = 16'b0000000000000000;
	
		case (DR)
			3'b000: LoadR0 = Load;
			3'b001: LoadR1 = Load;
			3'b010: LoadR2 = Load;
			3'b011: LoadR3 = Load;
			3'b100: LoadR4 = Load;
			3'b101: LoadR5 = Load;
			3'b110: LoadR6 = Load;
			3'b111: LoadR7 = Load;
			default: ;
		endcase
		
		case (SR1)
			3'b000: SR1_Out = R0_Out;
			3'b001: SR1_Out = R1_Out;
			3'b010: SR1_Out = R2_Out;
			3'b011: SR1_Out = R3_Out;
			3'b100: SR1_Out = R4_Out;
			3'b101: SR1_Out = R5_Out;
			3'b110: SR1_Out = R6_Out;
			3'b111: SR1_Out = R7_Out;
			default: ;
		endcase
			
		case (SR2)
			3'b000: SR2_Out = R0_Out;
			3'b001: SR2_Out = R1_Out;
			3'b010: SR2_Out = R2_Out;
			3'b011: SR2_Out = R3_Out;
			3'b100: SR2_Out = R4_Out;
			3'b101: SR2_Out = R5_Out;
			3'b110: SR2_Out = R6_Out;
			3'b111: SR2_Out = R7_Out;
			default: ;
		endcase
		
	end

endmodule
