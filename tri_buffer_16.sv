module tri_buffer_16 (input Enable, input[15:0] In, output[15:0] Out);
	always_comb
	begin
		if(Enable)
			Out=In;
		else
			Out=16'bZZZZZZZZZZZZZZZZ;
	end

endmodule
