// *************************************************************************************************
//                              -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Input FIFOs
//	
//	Input:	- CLK: LiTe-DTU clock
//			- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//			- GAIN_SEL_MODE:	2'b00: Gain selection ACTIVE - window width : 8 samples
//						2'b01: Gain selection ACTIVE - window width : 16 samples
//						2'b10: Gain selection INACTIVE - transmitted only gain x10 samples
//						2'b11: Gain selection INACTIVE - transmitted only gain x1 samples
//			- DATA_gain_01: 12 bit from channel_gain_1 (already beseline subtracted)
//			- DATA_gain_10: 12 bit from channel_gain_10 (already beseline subtracted)
//
//	Output:	- DATA_to_enc: 13 bit data
//			- baseline_flag: signal that define if data is baseline or signal data
//
//	15.5.2020	: FIFO inputs synchronized on DCLK. Write pointer splitted for the two FIFOs
//				  Read pointer now is an independent counter - Gianni
//
//	19.5.2020	: distance between write and read pointers increased to 2 to avoid synchronization
//				  problems. RefSample2 updated in order to avoid superposition with the write pointer
//
// *************************************************************************************************
 
`timescale   1ps/1ps

module LDTU_iFIFO(
	DCLK_1,
	DCLK_10,
	CLK_,
	reset_,
	GAIN_SEL_MODE,
	DATA_gain_01,
	DATA_gain_10,
	SATURATION_value,
	shift_gain_10,	     
	DATA_to_enc,
	baseline_flag,
	tmrError
	);

// Internal constants

	parameter    Nbits_7 = 7;
	parameter    Nbits_12 = 12;
	parameter    FifoDepth2 = 16;
	parameter    FifoDepth = 8;
	parameter    NBitsCnt = 3;
	parameter    RefSample = 3'b011;
	parameter    RefSample2 = 3'b101;


// Input ports
	input DCLK_1;
	input DCLK_10;
	input CLK_;
	input reset_;
	input [1:0] GAIN_SEL_MODE;
	input [Nbits_12-1:0] DATA_gain_01;
	input [Nbits_12-1:0] DATA_gain_10;
	input [Nbits_12-1:0] SATURATION_value;
      input [1:0] shift_gain_10;
   

// Output ports
	output [Nbits_12:0] DATA_to_enc;
	output baseline_flag;
	output tmrError;

// TMR variables
	reg [NBitsCnt-1:0] wrH_ptr_;	// Write pointer for gain 10

	reg [NBitsCnt-1:0] wrL_ptr_;	// Write pointer for gain 1

	reg [Nbits_12-1:0] SATval_;

	reg [Nbits_12-1:0] FIFO_g1_ [FifoDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_ [FifoDepth-1:0];

	reg [NBitsCnt-1:0] rd_ptr_;

	wire [NBitsCnt-1:0] ref_ptr_;
	wire [Nbits_12-1:0] FIFO_g10_ref_;
	wire ref_sat_;

	reg [FifoDepth-1:0] gain_sel_;
	reg [FifoDepth2-1:0] gain_sel2_;

	wire [Nbits_12-1:0] dout_g1_;
	wire [Nbits_12-1:0] dout_g10_;

	wire [Nbits_12:0] DATA_to_enc_;
	wire DATA_to_encTmrError;

	wire baseline_flag_;
	wire baseline_flagTmrError;

	wire [1:0] GAIN_SEL_MODE_;

	integer iH;
	integer iL;

// SATval: saturation value tunable  : @(posedge CLK)
	always @(posedge CLK_) begin
		if (reset_ == 1'b0) SATval_ <= 12'hfff;
		else SATval_ <= SATURATION_value >> shift_gain_10;
	end


// WRITE POINTERS : @(posedge DCLK)
	always @(posedge DCLK_10) begin
		if (reset_ == 1'b0) wrH_ptr_ <= 3'b000;
		else wrH_ptr_ <= wrH_ptr_+3'b001;
	end


	always @(posedge DCLK_1) begin
		if (reset_ == 1'b0) wrL_ptr_ <= 3'b000;
		else wrL_ptr_ <= wrL_ptr_+3'b001;
	end


// WRITING in FIFO GAIN 1

	always @(posedge DCLK_1) begin
		if (reset_ == 1'b0) begin
			for (iL = 0; iL < FifoDepth; iL = iL +1) begin
				FIFO_g1_[iL] <= 12'b0;
			end
		end else begin
			FIFO_g1_[wrL_ptr_] <= DATA_gain_01;
		end
	end


// WRITING in FIFO GAIN 10

	always @(posedge DCLK_10) begin
		if (reset_ == 1'b0) begin
			for (iH = 0; iH < FifoDepth; iH = iH +1) begin
				FIFO_g10_[iH] <= 12'b0;
			end
		end else begin
			FIFO_g10_[wrH_ptr_] <= DATA_gain_10 >> shift_gain_10;
		end
	end

	always @(posedge CLK_) begin
		if (reset_ == 1'b0) rd_ptr_ <= 3'b010;
			else rd_ptr_ <= rd_ptr_+3'b001;
	end

// REF POINTERS : @(posedge CLK)
	assign ref_ptr_ = (GAIN_SEL_MODE_ == 2'b01) ? (rd_ptr_ + RefSample2) : (rd_ptr_ + RefSample);

	assign FIFO_g10_ref_ = FIFO_g10_[ref_ptr_];


	assign ref_sat_ = (GAIN_SEL_MODE_ == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_ == 2'b10) ? 1'b0 : (FIFO_g10_ref_ >= SATval_) ? 1'b1 : 1'b0;

	always @(posedge CLK_) begin
		if (reset_ == 1'b0) gain_sel_ <= 8'b0;
		else begin
			if (GAIN_SEL_MODE_ == 2'b00) gain_sel_ <= {gain_sel_[FifoDepth-2:0] ,ref_sat_};
			else begin
				if (GAIN_SEL_MODE_ == 2'b11) gain_sel_ <= {gain_sel_[FifoDepth-2:0] ,ref_sat_};
				else gain_sel_ <= 8'b0;
			end
		end
	end
	
// Registri per aumentare la finestra
	always @(posedge CLK_) begin
		if (reset_ == 1'b0) gain_sel2_ <= 16'b0;
		else begin
			if (GAIN_SEL_MODE_ == 2'b01) gain_sel2_ <= {gain_sel2_[FifoDepth2-2:0] ,ref_sat_};
			else gain_sel2_ <= 16'b0;
		end
	end
	
	assign dout_g1_ = FIFO_g1_[rd_ptr_];
	assign dout_g10_ = FIFO_g10_[rd_ptr_];

	wire decision1_, decision2_;
	assign decision1_ = (gain_sel_ == 8'b0) ? 1'b1 : 1'b0;
 	assign decision2_ = (gain_sel2_ == 16'b0) ? 1'b1 : 1'b0;
	assign DATA_to_enc_ = (decision1_ && decision2_) ? {1'b0,dout_g10_} : {1'b1,dout_g1_};

	wire bas_flag_;
	wire b_flag_;


	assign bas_flag_ = (DATA_to_enc_[12:6] == 7'b0) ? 1'b1 : 1'b0;
	assign b_flag_ = (DATA_to_enc_[11:6] == 6'b0) ? 1'b1 : 1'b0;

	assign baseline_flag_ = (reset_ == 1'b0) ? 1'b1 : (GAIN_SEL_MODE_[1] == 1'b0) ? bas_flag_ : b_flag_;


assign tmrError = DATA_to_encTmrError | baseline_flagTmrError;


endmodule
