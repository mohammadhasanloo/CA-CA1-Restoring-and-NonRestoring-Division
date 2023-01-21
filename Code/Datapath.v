`timescale 1ns/1ns
module DataPath(clk,rst, QCommand, ACommand, MCommand,subtractFlag,cntEn,ldCnt,Ci,SiR_Q, dividend, divisor, out_Q, out_A, out_M,Co,SignSum);
	parameter n = 10;
	input clk,rst;
	input [1:0] QCommand,ACommand, MCommand;
	input subtractFlag;
	input cntEn,ldCnt,Ci,SiR_Q;
	input [n-1:0] dividend;
	input [4:0] divisor;

	output [9:0] out_Q;
	output [10:0] out_A;
	output [10:0] out_M;
	output Co;
	output SignSum;

	wire SoL_Q;
	wire SoL_A;
	wire [10:0] sum;

	assign SignSum = sum[10];
	
	// Register Q
	ShiftReg #(.n(10)) sregQ (.clk(clk), .rst(rst),.PI(dividend),.SiR(SiR_Q),.m(QCommand),.SoL(SoL_Q), .PO(out_Q));

	// Register A
	ShiftReg #(.n(11)) sregA (.clk(clk), .rst(rst),.PI(sum),.SiR(SoL_Q),.m(ACommand),.SoL(SoL_A), .PO(out_A));

	// Register M
	wire SoL_M;
	ShiftReg #(.n(11)) sregM (.clk(clk), .rst(rst),.PI({6'b0,divisor}),.SiR(0),.m(MCommand),.SoL(SoL_M), .PO(out_M));

	// Adder/Subtractor
	wire Co2;
	AdderSubtractor #(.n(11)) adder_subtractor (.A(out_A),.B(out_M),.SubtractFlag(subtractFlag), 
					.Co(Co2), .Sum(sum));

	// Counter
	wire [3:0] count;
	upcnt4 M10C (.PI(4'b0110), .clk(clk), .rst(rst), .cntEn(cntEn), .ld(ldCnt), .Ci(Ci),.PO(count), .Co(Co));

endmodule
