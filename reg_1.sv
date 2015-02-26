module reg_1 (input Clk, Load, Reset,
					input [2:0] D_in1,
					input [2:0] D_in2,
					output logic R_out);

	reg R;
	always_ff @ (posedge Clk)
	
	begin
		if (Reset) 
			R <= 1'b0;
		else if (Load)
			R <= (D_in1[2] & D_in2[2]) & (D_in1[1] & D_in2[1]) & (D_in1[0] & D_in2[0]); 
	end
	
	assign R_out=R;
	
endmodule
