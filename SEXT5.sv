module SEXT5 (input [4:0] Input,
					output logic [15:0] SEXT5_out);
					
	integer i;
			
	always_comb
	begin
		SEXT5_out[4:0] = Input[4:0];
		for (i = 5; i < 16; i = i + 1) // FOR LOOPS NOT WORKING WAT
		SEXT5_out[i] = Input[4];
	end
	
endmodule
