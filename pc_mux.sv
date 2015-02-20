module pc_mux (input [15:0] D_in0,
				input [15:0] D_in1,
				input [15:0] D_in2,
				input [1:0] sel,
				output logic [15:0] D_out);

	always @ (D_in0 or D_in1 or D_in2 or sel)
	begin
		case (sel)
			2'b00:
				D_out = D_in0 + 1; // Increment PC
			2'b01:
				D_out = D_in1;
			default:
				D_out = D_in2;
		endcase
	end

endmodule
