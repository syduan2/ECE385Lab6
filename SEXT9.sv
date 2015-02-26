module SEXT9 (input [8:0] Input,
					output [15:0] SEXT9_out);
					
	integer i;
			
	always_comb
	begin
		SEXT9_out[8:0] = Input[8:0];
		for (i = 9; i < 16; i = i + 1) // FOR LOOPS NOT WORKING WAT
		SEXT9_out[i] = Input[8];
	end
	
endmodule
