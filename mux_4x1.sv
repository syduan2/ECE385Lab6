module mux_4x1(input[15:0] In0, In1, In2, In3, input[1:0] select, output[15:0] Out);

	always_comb
	begin
		unique case(select)
		2'b00:
			Out=In0;
		2'b01:
			Out=In1;
		2'b10:
			Out=In2;
		2'b11:
			Out=In3;
		endcase
	end
endmodule