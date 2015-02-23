module reg_16 (input Clk, Load, Reset,
					input [15:0] D_in, 
					output logic [15:0] R_out);

	integer i;
	reg[15:0] R;
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
	assign R_out=R;
endmodule