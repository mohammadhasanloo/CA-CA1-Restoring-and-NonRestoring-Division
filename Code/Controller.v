`timescale 1ns/1ns
module Controller(clk,rst,start,gotResult,Co,SignSum, SiR_Q, QCommand, ACommand, MCommand,subtractFlag,cntEn,ldCnt,Ci, done);
	input clk,rst,start,gotResult,Co,SignSum;

	output reg [1:0] QCommand,ACommand, MCommand;
	output reg subtractFlag;
	output reg cntEn,ldCnt,Ci, SiR_Q, done;

	reg [2:0] ps;
	reg [2:0] ns;
	parameter [2:0] Idle = 3'b000;
	parameter [2:0] Init = 3'b001;
	parameter [2:0] ShifLeft_AQ = 3'b010;
	parameter [2:0] CalculateA_M = 3'b011;
	parameter [2:0] PositiveA_M = 3'b100;
	parameter [2:0] NegativeA_M = 3'b101;
	parameter [2:0] Counter = 3'b110;
	parameter [2:0] Done = 3'b111;

	always @(posedge clk, posedge rst) begin
		if (rst)
			ps <= Idle;
		else
			ps <= ns;
	end

	always @(ps or start or Co or SignSum)
	begin
		case(ps)
			Idle: ns = start ? Init: Idle;
			Init: ns = ShifLeft_AQ;
			ShifLeft_AQ: ns = CalculateA_M;
			CalculateA_M: ns = SignSum ? NegativeA_M: PositiveA_M;
			NegativeA_M: ns = Counter;
			PositiveA_M: ns = Counter;
			Counter: ns = Co ? Done: ShifLeft_AQ;
			Done: ns = gotResult ? Idle : Done;
		endcase
	end

	always @(ps)
	begin
		QCommand = 2'b00;
		ACommand = 2'b00;
		MCommand = 2'b00;
		{subtractFlag,cntEn,ldCnt,Ci,SiR_Q,done} = 6'b000000;
		case (ps)
			Idle: done = 1'b1;
			Init: begin
				MCommand = 2'b11;
				QCommand = 2'b11;
				ldCnt = 1'b1;
			end
			ShifLeft_AQ: begin
				QCommand = 2'b10;
				ACommand = 2'b10;
			end
			CalculateA_M: subtractFlag = 1'b1;
			NegativeA_M: begin
				SiR_Q = 0;
				QCommand = 2'b01;
				subtractFlag = 1'b1;
			end
			PositiveA_M: begin
				SiR_Q = 1;
				QCommand = 2'b01;
				ACommand = 2'b11;
				subtractFlag = 1'b1;
			end
			Counter: begin
				{cntEn, Ci} = 2'b11;
				subtractFlag = 1'b1;
			end
			Done: begin
				{cntEn, Ci} = 2'b11;
				subtractFlag = 1'b1;
				done = 1'b1;
			end
		endcase
	end
endmodule