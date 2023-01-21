`timescale 1ns/1ns
module AdderSubtractor #(parameter n = 11) (A,B,SubtractFlag,Co,Sum);
	input [n-1:0] A,B;
	input SubtractFlag;

	output reg Co;
	output reg [n-1:0] Sum;

	always @(A or B or SubtractFlag) begin
		if (SubtractFlag == 1)
			//Two's Complement
			{Co,Sum} = A+(~B)+1;
		else
			{Co,Sum} = A+B;
	end
	
endmodule