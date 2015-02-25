module ALU_K (input [15:0] A_in, B_in,
				  input [1:0] ALUK,
				  output [15:0] ALU_K_out);
				  
	always_comb
	begin
		unique case (ALUK)
			2'b00: ALU_K_out = A_in + B_in;
			2'b01: ALU_K_out = A_in & B_in;
			2'b10: ALU_K_out~A_in;
			default: ALU_K_out = A_in;
		endcase
	end

endmodule
