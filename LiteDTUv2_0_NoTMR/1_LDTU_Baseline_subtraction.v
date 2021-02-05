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
//	15.05.2020	Block synchronized on DCLK only - Gianni
//
// *************************************************************************************************

`timescale   1ps/1ps

module LDTU_BS(
	DCLK_1,
	DCLK_10,
	reset_,
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
	input reset_;
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

	reg	[Nbits_12-1:0] d_g01_;
	reg	[Nbits_12-1:0] d_g10_;

	wire [Nbits_12-1:0] DATA_g_01_;
	wire [Nbits_12-1:0] DATA_g_10_;

	reg [Nbits_12-1:0] dg01_;
	reg [Nbits_12-1:0] dg10_;

	assign b_val_g01 =  {4'b0,BSL_VAL_g01};
	assign b_val_g10 =  {4'b0,BSL_VAL_g10};


		// Input synchronization

	always @ (posedge DCLK_1) begin
		if (reset_ == 1'b0) d_g01_ <= 12'b0;
		else d_g01_ <= DATA12_g01;
	end

	always @ (posedge DCLK_10) begin
		if (reset_ == 1'b0) d_g10_ <= 12'b0;
		else d_g10_ <= DATA12_g10;
	end

		// Baseline subtraction

	assign DATA_g_01_ = d_g01_-b_val_g01;

	assign DATA_g_10_ = d_g10_-b_val_g10;

		// Output synchronization

	always @ (posedge DCLK_1) begin
		dg01_ <= DATA_g_01_;
	end

	always @ (posedge DCLK_10) begin
		dg10_ <= DATA_g_10_;
	end

	assign tmrError = dg01_TmrError | dg10_TmrError;

endmodule
