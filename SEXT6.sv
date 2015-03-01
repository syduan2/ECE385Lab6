module SEXT6 (input [5:0] Input,
					output logic [15:0] SEXT6_out);
					
	integer i;
			
	always_comb
	begin
		SEXT6_out[5:0] = Input[5:0];
		for (i = 6; i < 16; i = i + 1) // FOR LOOPS NOT WORKING WAT
		SEXT6_out[i] = Input[5];
	end
	
endmodule
