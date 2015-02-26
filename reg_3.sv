module reg_3 (input Clk, Load, Reset,
					input [2:0] D_in, 
					output logic [2:0] R_out);

	integer i;
	reg[2:0] R;
	always_ff @ (posedge Clk)
	begin
	 
	if (Reset) 
		R <= 3'h0;
	else if (Load)
		for (i = 0; i < 3; i = i + 1)
		begin
			R[i] <= D_in[i];
		end
	end
	assign R_out=R;
	
endmodule
