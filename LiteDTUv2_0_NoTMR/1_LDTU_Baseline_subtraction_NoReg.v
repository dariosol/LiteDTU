// *************************************************************************************************
//                              -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Baseline subtraction
//	
//	Input:	- DCLK_1: ADC gain_1 clock
//			- DCLK_10: ADC gain_10 clock
//			- CLK: LiTe-DTU clock
//			- rst_b : 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//			- DATA12_g01: 12 bit from channel_gain_1
//			- DATA12_g10: 12 bit from channel_gain_10
//			- BSL_VAL_g01: baseline value channel_gain_1
//			- BSL_VAL_g10: baseline value channel_gain_10
//
//	Output:	- DATA_gain_01: 12 bit from channel_gain_1 (baseline subtracted)
//			- DATA_gain_10: 12 bit from channel_gain_10 (baseline subtracted)
//
//	15.05.2020	Block synchronized on DCLK only - Gianni
//   4.02.2021  manual triplication removed - Gianni
//				reset renamed rst_b since it is active low
//
// *************************************************************************************************

`timescale   1ps/1ps

module LDTU_BS(
	DCLK_1,
	DCLK_10,
	rst_b,
	DATA12_g01,
	DATA12_g10,
	BSL_VAL_g01,
	BSL_VAL_g10,
	DATA_gain_01,
	DATA_gain_10,
	SeuError
	);

	parameter    Nbits_12 = 12;
	parameter    Nbits_8 = 8;

	input DCLK_1;
	input DCLK_10;
	input rst_b;
	input [Nbits_12-1:0] DATA12_g01;
	input [Nbits_12-1:0] DATA12_g10;
	input [Nbits_8-1:0] BSL_VAL_g01;
	input [Nbits_8-1:0] BSL_VAL_g10;
	output  [Nbits_12-1:0] DATA_gain_01;
	output  [Nbits_12-1:0] DATA_gain_10;
	output SeuError;

	wire [Nbits_12-1:0] b_val_g01;
	wire [Nbits_12-1:0] b_val_g10;
	wire dg01_TmrError;
	wire dg10_TmrError;

	reg	[Nbits_12-1:0] d_g01;
	reg	[Nbits_12-1:0] d_g10;

   	wire	[Nbits_12-1:0] dg01_synch;
        wire [Nbits_12-1:0]    dg10_synch;

	wire [Nbits_12-1:0] dg01;
	wire [Nbits_12-1:0] dg10;

//	wire [Nbits_12-1:0] dg01Voted = dg01;
//	wire [Nbits_12-1:0] dg10Voted = dg10;

	wire tmrError = 1'b0;
//	wire errorVoted = tmrError;
	assign SeuError = tmrError;


	assign b_val_g01 =  {4'b0,BSL_VAL_g01};
	assign b_val_g10 =  {4'b0,BSL_VAL_g10};


		// Input synchronization

	always @ (posedge DCLK_1) begin
		if (rst_b == 1'b0) d_g01 <= 12'b0;
		else d_g01 <= DATA12_g01;
	end

	always @ (posedge DCLK_10) begin
		if (rst_b == 1'b0) d_g10 <= 12'b0;
		else d_g10 <= DATA12_g10;
	end

		// Baseline subtraction

   assign dg01_synch = d_g01-b_val_g01;
   assign dg10_synch = d_g10-b_val_g10;

   assign DATA_gain_10 = dg10_synch;
   assign DATA_gain_01 = dg01_synch;
   
endmodule

