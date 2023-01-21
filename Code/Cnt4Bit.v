`timescale 1ns/1ns
module upcnt4(input [3:0] PI, input clk,rst,cntEn,ld,Ci,output reg[3:0] PO, output Co);
	always @(posedge clk, posedge rst) begin
		if(rst) 
			PO <= 4'b0;
		else begin
			if (ld)
				PO <= PI;
			else if(cntEn)
				PO <= Ci ? (PO + 1) : PO;
		end
	end
	assign Co = (cntEn) ? &{PO,Ci} : 1'b0;
endmodule