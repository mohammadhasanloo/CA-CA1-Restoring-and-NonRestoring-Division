`timescale 1ns/1ns
module RestoringDivision(clk,rst,start,gotResult,dividend, divisor, Q, M, A, done, divByZero, ov);
	input clk,rst,start,gotResult;
	input [9:0] dividend;
	input [4:0] divisor;

	output [9:0] Q;
	output [10:0] A;
	output [10:0] M;
	output done;

	output divByZero,ov;

	assign divByZero = (divisor == 5'b0) ? 1 : 0;
	assign ov = (dividend[9:5] >= divisor) ? 1 : 0;

	// Wires
	wire [1:0] QCommand,ACommand, MCommand;
	wire subtractFlag;
	wire cntEn,ldCnt,Ci,SiR_Q,Co,SignSum;
	// Data Path
	DataPath dp(clk,rst, QCommand, ACommand, MCommand,subtractFlag,cntEn,ldCnt,Ci,SiR_Q, dividend, divisor, Q, A, M,Co,SignSum);

	// Control Unit
	Controller cu(clk,rst,start,gotResult,Co,SignSum, SiR_Q, QCommand, ACommand, MCommand,subtractFlag,cntEn,ldCnt,Ci, done);
endmodule