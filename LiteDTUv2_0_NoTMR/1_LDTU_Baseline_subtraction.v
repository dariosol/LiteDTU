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
//   21.06.21   ADC clock on the negative edge
// *************************************************************************************************

`timescale   1ns/1ps

module LDTU_BS(
	DCLK_1,
	DCLK_10,
	rst_b,
	DATA12_g01,
	DATA12_g10,
	shift_gain_10,
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
        input [1:0] shift_gain_10;
   
	output  [Nbits_12-1:0] DATA_gain_01;
	output  [Nbits_12-1:0] DATA_gain_10;
	output SeuError;

	wire [Nbits_12-1:0] b_val_g01;
	wire [Nbits_12-1:0] b_val_g10;

	reg	[Nbits_12-1:0] d_g01;
	reg	[Nbits_12-1:0] d_g10;

   	reg	[Nbits_12-1:0] dg01_synch;
	reg	[Nbits_12-1:0] dg10_synch;

	wire [Nbits_12-1:0] dg01;
	wire [Nbits_12-1:0] dg10;

	wire tmrError = 1'b0;
	assign SeuError = tmrError;


	assign b_val_g01 =  {4'b0,BSL_VAL_g01};
	assign b_val_g10 =  {4'b0,BSL_VAL_g10};


		// Input synchronization

	always @ (negedge DCLK_1) begin
		if (rst_b == 1'b0) d_g01 <= 12'b0;
		else d_g01 <= DATA12_g01;
	end

	always @ (negedge DCLK_10) begin
		if (rst_b == 1'b0) d_g10 <= 12'b0;
		else d_g10 <= DATA12_g10  >> shift_gain_10;
	end

		// Baseline subtraction

   assign dg01 = d_g01-b_val_g01;
   assign dg10 = d_g10-b_val_g10;

   //Check if the baseline subtraction is not too high to create data rollover.
   //if the data before subtraction was lower than after: rollover happened.
   //If rollover: set output to 0.
   
   always @ (negedge DCLK_1) begin
      if(dg01 > d_g01) begin // before subtraction < than after
	 dg01_synch <= 12'b0;
      end
      else begin
	 dg01_synch <= dg01;
      end 
   end

   always @ (negedge DCLK_10) begin
      if(dg10 > d_g10) begin // before subtraction < than after
	 dg10_synch <= 12'b0;
      end
      else begin
	 dg10_synch <= dg10;
      end
   end
   
   assign DATA_gain_01 = dg01_synch;
   assign DATA_gain_10 = dg10_synch;
   

endmodule

