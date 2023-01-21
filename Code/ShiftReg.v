`timescale 1ns/1ns
module ShiftReg #(parameter n = 11) (input [n-1:0] PI, input clk, rst, SiR, input [1:0] m, output SoL, output reg [n-1:0] PO);
	assign SoL = PO[n-1];

	always @(posedge clk, posedge rst) begin
		if(rst)
			PO <= 0;
		else
			case(m)
				2'b00 : PO <= PO;
				2'b01 : PO[0] <= SiR;
				2'b10 : PO <= {PO[n-2:0],SiR};
				2'b11 : PO <= PI;
			endcase
	end
endmodule