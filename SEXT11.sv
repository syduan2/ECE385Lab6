module SEXT11 (input [10:0] Input,
					output logic [15:0] SEXT11_out);
					
	integer i;
			
	always_comb
	begin
		SEXT11_out[10:0] = Input[10:0];
		for (i = 11; i < 16; i = i + 1) // FOR LOOPS NOT WORKING WAT
		SEXT11_out[i] = Input[10];
	end
	
endmodule