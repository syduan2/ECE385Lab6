module reg_16 (input Clk, Load, Reset,
					input [15:0] D_in, 
					output [15:0] R);

	integer i;
	
	always_ff @ (posedge Clk)
	begin
	 
	if (Reset) 
		R <= 16'h0;
	else if (Load)
		for (i = 0; i < 16; i = i + 1)
		begin
			R[i] <= D_in[i];
		end
	end

endmodule