module nzp_logic (input [15:0] D_in,
						output logic [2:0] D_out);
					
	always_comb
	begin
		if (D_in[15] == 1'b1)
		begin
				D_out[2] = 1'b1;
				D_out[1] = 1'b0;
				D_out[0] = 1'b0;
		end
		
		else if (D_in[14:0] == 15'b0)
		begin
				D_out[2] = 1'b0;
				D_out[1] = 1'b1;
				D_out[0] = 1'b0;
		end
		
		else
		begin
				D_out[2] = 1'b0;
				D_out[1] = 1'b0;
				D_out[0] = 1'b1;
		end
	end
	
endmodule
