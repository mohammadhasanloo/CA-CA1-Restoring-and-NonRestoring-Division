`timescale 1ns/1ns
module Testbench();
	parameter n = 10;
	reg [9:0] dividend;
	reg [4:0] divisor;

	reg rst, start,gotResult, clk;

	wire [9:0] Q;
	wire [10:0] A;
	wire [10:0] M;
	wire done;
	wire divByZero;
	wire ov;
	RestoringDivision RD(clk,rst,start,gotResult,dividend, divisor, Q, M, A, done,divByZero, ov);

	initial begin
		start = 1'b0;
		rst = 1'b0;
		clk = 1'b0;
		gotResult = 1'b0;
		#13 rst = 1'b1;
		#20 rst = 1'b0;
		#13 start = 1'b1;dividend = 10'b1001000011; divisor = 5'b01111;
		#1000 start = 1'b0; gotResult = 1'b1;
		#200 rst = 1'b1; gotResult = 1'b0;
		#20 rst = 1'b0; start = 1'b1; dividend = 10'b0001000011; divisor = 5'b00101;
		#1000 start = 1'b0; gotResult = 1'b1;
		#600
		#200 rst = 1'b1; gotResult = 1'b0;
		#20 rst = 1'b0; start = 1'b1; dividend = 10'b0001000011; divisor = 5'b00000;
		#1000 $stop;
	end

	always
	begin
	#10 clk = ~clk;
	end

endmodule
