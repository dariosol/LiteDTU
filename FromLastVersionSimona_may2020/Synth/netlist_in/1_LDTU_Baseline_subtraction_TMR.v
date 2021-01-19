// *************************************************************************************************
//                              -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Baseline subtraction
//	
//	Input:	- DCLK_1: ADC gain_1 clock
//			- DCLK_10: ADC gain_10 clock
//			- CLK: LiTe-DTU clock
//			- reset_A,reset_B, reset_C : 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//			- DATA12_g01: 12 bit from channel_gain_1
//			- DATA12_g10: 12 bit from channel_gain_10
//			- BSL_VAL_g01: baseline value channel_gain_1
//			- BSL_VAL_g10: baseline value channel_gain_10
//
//	Output:	- DATA_gain_01: 12 bit from channel_gain_1 (beseline subtracted)
//			- DATA_gain_10: 12 bit from channel_gain_10 (beseline subtracted)
//
// *************************************************************************************************

`timescale   1ns/1ps

module LDTU_BSTMR(
	DCLK_1,
	DCLK_10,
	CLK_A, CLK_B, CLK_C,
	reset_A,
	reset_B,
	reset_C,
	DATA12_g01,
	DATA12_g10,
	BSL_VAL_g01,
	BSL_VAL_g10,
	DATA_gain_01,
	DATA_gain_10,
	tmrError
	);



	parameter    Nbits_12 = 12;
	parameter    Nbits_8 = 8;

	input DCLK_1;
	input DCLK_10;
	input CLK_A;
	input CLK_B;
	input CLK_C;
	input reset_A;
	input reset_B;
	input reset_C;
	input [Nbits_12-1:0] DATA12_g01;
	input [Nbits_12-1:0] DATA12_g10;
	input [Nbits_8-1:0] BSL_VAL_g01;
	input [Nbits_8-1:0] BSL_VAL_g10;
	output [Nbits_12-1:0] DATA_gain_01;
	output [Nbits_12-1:0] DATA_gain_10;
	output tmrError;

	wire [Nbits_12-1:0] b_val_g01;
	wire [Nbits_12-1:0] b_val_g10;
	wire dg01_TmrError;
	wire dg10_TmrError;

	reg	[Nbits_12-1:0] d_g01_A;
	reg	[Nbits_12-1:0] d_g01_B;
	reg	[Nbits_12-1:0] d_g01_C;
	reg	[Nbits_12-1:0] d_g10_A;
	reg	[Nbits_12-1:0] d_g10_B;
	reg	[Nbits_12-1:0] d_g10_C;

	wire [Nbits_12-1:0] DATA_g_01_A;
	wire [Nbits_12-1:0] DATA_g_10_A;
	wire [Nbits_12-1:0] DATA_g_01_B;
	wire [Nbits_12-1:0] DATA_g_10_B;
	wire [Nbits_12-1:0] DATA_g_01_C;
	wire [Nbits_12-1:0] DATA_g_10_C;

	reg [Nbits_12-1:0] dg01_A;
	reg [Nbits_12-1:0] dg10_A;
	reg [Nbits_12-1:0] dg01_B;
	reg [Nbits_12-1:0] dg10_B;
	reg [Nbits_12-1:0] dg01_C;
	reg [Nbits_12-1:0] dg10_C;


	assign b_val_g01 =  {4'b0,BSL_VAL_g01};
	assign b_val_g10 =  {4'b0,BSL_VAL_g10};

	assign DATA_g_01_A = d_g01_A-b_val_g01;
	assign DATA_g_10_A = d_g10_A-b_val_g10;
	assign DATA_g_01_B = d_g01_B-b_val_g01;
	assign DATA_g_10_B = d_g10_B-b_val_g10;
	assign DATA_g_01_C = d_g01_C-b_val_g01;
	assign DATA_g_10_C = d_g10_C-b_val_g10;


	always @ (posedge DCLK_1) begin
		if (reset_A == 1'b0) d_g01_A <= 12'b0;
		else d_g01_A <= DATA12_g01;
	end
	always @ (posedge DCLK_1) begin
		if (reset_B == 1'b0) d_g01_B <= 12'b0;
		else d_g01_B <= DATA12_g01;
	end
	always @ (posedge DCLK_1) begin
		if (reset_C == 1'b0) d_g01_C <= 12'b0;
		else d_g01_C <= DATA12_g01;
	end



	always @ (posedge DCLK_10) begin
		if (reset_A == 1'b0) d_g10_A <= 12'b0;
		else d_g10_A <= DATA12_g10;
	end
	always @ (posedge DCLK_10) begin
		if (reset_B == 1'b0) d_g10_B <= 12'b0;
		else d_g10_B <= DATA12_g10;
	end
	always @ (posedge DCLK_10) begin
		if (reset_C == 1'b0) d_g10_C <= 12'b0;
		else d_g10_C <= DATA12_g10;
	end



	always @ (posedge CLK_A) begin
		dg01_A <= DATA_g_01_A;
		dg10_A <= DATA_g_10_A;
	end
	always @ (posedge CLK_B) begin
		dg01_B <= DATA_g_01_B;
		dg10_B <= DATA_g_10_B;
	end
	always @ (posedge CLK_C) begin
		dg01_C <= DATA_g_01_C;
		dg10_C <= DATA_g_10_C;
	end


	majorityVoter #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) d_g01_Voter (
		.inA(dg01_A),
		.inB(dg01_B),
		.inC(dg01_C),
		.out(DATA_gain_01),
		.tmrErr(dg01_TmrError)
		);

	majorityVoter #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) d_g10_Voter (
		.inA(dg10_A),
		.inB(dg10_B),
		.inC(dg10_C),
		.out(DATA_gain_10),
		.tmrErr(dg10_TmrError)
		);

	assign tmrError = dg01_TmrError | dg10_TmrError;

endmodule

	module majorityVoter (inA, inB, inC, out, tmrErr);
		parameter WIDTH = 1;
		input	 [(WIDTH-1):0]	 inA, inB, inC;
		output	[(WIDTH-1):0]	 out;
		output	tmrErr;
		reg	tmrErr;
		assign out = (inA&inB) | (inA&inC) | (inB&inC);
		always @(inA or inB or inC) begin
			if (inA!=inB || inA!=inC || inB!=inC)
				tmrErr = 1'b1;
			else
				tmrErr = 1'b0;
		end
	endmodule

	module fanout (in, outA, outB, outC);
		parameter WIDTH = 1;
		input	 [(WIDTH-1):0]	 in;
		output	[(WIDTH-1):0]	 outA,outB,outC;
		assign outA=in;
		assign outB=in;
		assign outC=in;
	endmodule
