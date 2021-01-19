// *************************************************************************************************
//                              -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Input FIFOs
//	
//	Input:	- CLK: LiTe-DTU clock
//			- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//			- GAIN_SEL_MODE: 1'b0: Gain selection ACTIVE - 1'b1: Gain selection: INACTIVE
//			- DATA_gain_01: 12 bit from channel_gain_1 (already beseline subtracted)
//			- DATA_gain_10: 12 bit from channel_gain_10 (already beseline subtracted)
//
//	Output:	- DATA_to_enc: 13 bit data
//			- baseline_flag: signal that define if data is baseline or signal data
//
// *************************************************************************************************
 
`timescale   1ns/1ps

module LDTU_iFIFOTMR(
	CLK_A,
	CLK_B,
	CLK_C,
	reset_A,
	reset_B,
	reset_C,
	GAIN_SEL_MODE,
	DATA_gain_01,
	DATA_gain_10,
	SATURATION_value,
	DATA_to_enc,
	baseline_flag,
	tmrError
	);

// Internal constants

	parameter    Nbits_7 = 7;
	parameter    Nbits_12 = 12;
	parameter    FifoDepth = 8;
	parameter    NBitsCnt = 3;
	parameter    RefSample = 3'b011;

// Input ports
	input CLK_A;
	input CLK_B;
	input CLK_C;
	input reset_A;
	input reset_B;
	input reset_C;
	input [1:0] GAIN_SEL_MODE;
	input [Nbits_12-1:0] DATA_gain_01;
	input [Nbits_12-1:0] DATA_gain_10;
	input [Nbits_12-1:0] SATURATION_value;

// Output ports
	output [Nbits_12:0] DATA_to_enc;
	output baseline_flag;
	output tmrError;

// TMR variables
	reg [NBitsCnt-1:0] wr_ptr_A;
	reg [NBitsCnt-1:0] wr_ptr_B;
	reg [NBitsCnt-1:0] wr_ptr_C;

	reg [Nbits_12-1:0] SATval_A;
	reg [Nbits_12-1:0] SATval_B;
	reg [Nbits_12-1:0] SATval_C;

	reg [Nbits_12-1:0] FIFO_g1_A [FifoDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_A [FifoDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g1_B [FifoDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_B [FifoDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g1_C [FifoDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_C [FifoDepth-1:0];

	wire [NBitsCnt-1:0] rd_ptr_A;
	wire [NBitsCnt-1:0] rd_ptr_B;
	wire [NBitsCnt-1:0] rd_ptr_C;

	wire [NBitsCnt-1:0] ref_ptr_A;
	wire [NBitsCnt-1:0] ref_ptr_B;
	wire [NBitsCnt-1:0] ref_ptr_C;
	wire [Nbits_12-1:0] FIFO_g10_ref_A;
	wire [Nbits_12-1:0] FIFO_g10_ref_B;
	wire [Nbits_12-1:0] FIFO_g10_ref_C;
	wire ref_sat_A;
	wire ref_sat_B;
	wire ref_sat_C;

	reg [FifoDepth-1:0] gain_sel_A;
	reg [FifoDepth-1:0] gain_sel_B;
	reg [FifoDepth-1:0] gain_sel_C;
	//wire [FifoDepth-1:0] gain_sel;

	wire [Nbits_12-1:0] dout_g1_A;
	wire [Nbits_12-1:0] dout_g10_A;
	wire [Nbits_12-1:0] dout_g1_B;
	wire [Nbits_12-1:0] dout_g10_B;
	wire [Nbits_12-1:0] dout_g1_C;
	wire [Nbits_12-1:0] dout_g10_C;

	wire [Nbits_12:0] DATA_to_enc_A;
	wire [Nbits_12:0] DATA_to_enc_B;
	wire [Nbits_12:0] DATA_to_enc_C;
	wire DATA_to_encTmrError;

	wire baseline_flag_A;
	wire baseline_flag_B;
	wire baseline_flag_C;
	wire baseline_flagTmrError;

	integer iA, iB, iC;

// SATval: saturation value tunable  : @(posedge CLK)
	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) SATval_A <= 12'hfff;
		else SATval_A <= SATURATION_value;
	end
	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) SATval_B <= 12'hfff;
		else SATval_B <= SATURATION_value;
	end
	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) SATval_C <= 12'hfff;
		else SATval_C <= SATURATION_value;
	end


// WRITE POINTER : @(posedge CLK)
	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) wr_ptr_A <= 3'b000;
		else wr_ptr_A <= wr_ptr_A+3'b001;
	end

	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) wr_ptr_B <= 3'b000;
		else wr_ptr_B <= wr_ptr_B+3'b001;
	end

	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) wr_ptr_C <= 3'b000;
		else wr_ptr_C <= wr_ptr_C+3'b001;
	end

// WRITING in FIFO GAIN 1
// WRITING in FIFO GAIN 10
	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) begin
			for (iA = 0; iA < FifoDepth; iA = iA +1) begin
				FIFO_g1_A[iA] <= 12'b0;
				FIFO_g10_A[iA] <= 12'b0;
			end
		end else begin
			FIFO_g1_A[wr_ptr_A] <= DATA_gain_01;
			FIFO_g10_A[wr_ptr_A] <= DATA_gain_10;
		end
	end

	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) begin
			for (iB = 0; iB < FifoDepth; iB = iB +1) begin
				FIFO_g1_B[iB] <= 12'b0;
				FIFO_g10_B[iB] <= 12'b0;
			end
		end else begin
			FIFO_g1_B[wr_ptr_B] <= DATA_gain_01;
			FIFO_g10_B[wr_ptr_B] <= DATA_gain_10;
		end
	end

	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) begin
			for (iC = 0; iC < FifoDepth; iC = iC +1) begin
				FIFO_g1_C[iC] <= 12'b0;
				FIFO_g10_C[iC] <= 12'b0;
			end
		end else begin
			FIFO_g1_C[wr_ptr_C] <= DATA_gain_01;
			FIFO_g10_C[wr_ptr_C] <= DATA_gain_10;
		end
	end



// READ POINTERS : @(posedge CLK)
	assign rd_ptr_A = wr_ptr_A + 3'b001;
	assign rd_ptr_B = wr_ptr_B + 3'b001;
	assign rd_ptr_C = wr_ptr_C + 3'b001;

// REF POINTERS : @(posedge CLK)
	assign ref_ptr_A = rd_ptr_A + RefSample;
	assign ref_ptr_B = rd_ptr_B + RefSample;
	assign ref_ptr_C = rd_ptr_C + RefSample;


	assign FIFO_g10_ref_A = FIFO_g10_A[ref_ptr_A];
	assign FIFO_g10_ref_B = FIFO_g10_B[ref_ptr_B];
	assign FIFO_g10_ref_C = FIFO_g10_C[ref_ptr_C];


	wire [1:0] GAIN_SEL_MODE_A;
	wire [1:0] GAIN_SEL_MODE_B;
	wire [1:0] GAIN_SEL_MODE_C;


	assign ref_sat_A = (GAIN_SEL_MODE_A == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_A == 2'b10) ? 1'b0 : (FIFO_g10_ref_A >= SATval_A) ? 1'b1 : 1'b0;
	assign ref_sat_B = (GAIN_SEL_MODE_B == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_B == 2'b10) ? 1'b0 : (FIFO_g10_ref_B >= SATval_B) ? 1'b1 : 1'b0;
	assign ref_sat_C = (GAIN_SEL_MODE_C == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_C == 2'b10) ? 1'b0 : (FIFO_g10_ref_C >= SATval_C) ? 1'b1 : 1'b0;

	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) gain_sel_A <= 8'b0;
		else gain_sel_A <= {gain_sel_A[FifoDepth-2:0] ,ref_sat_A};
	end

	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) gain_sel_B <= 8'b0;
		else gain_sel_B <= {gain_sel_B[FifoDepth-2:0] ,ref_sat_B};
	end

	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) gain_sel_C <= 8'b0;
		else gain_sel_C <= {gain_sel_C[FifoDepth-2:0] ,ref_sat_C};
	end


assign dout_g1_A = FIFO_g1_A[rd_ptr_A];
assign dout_g10_A = FIFO_g10_A[rd_ptr_A];
assign dout_g1_B = FIFO_g1_B[rd_ptr_B];
assign dout_g10_B = FIFO_g10_B[rd_ptr_B];
assign dout_g1_C = FIFO_g1_C[rd_ptr_C];
assign dout_g10_C = FIFO_g10_C[rd_ptr_C];


assign DATA_to_enc_A = (gain_sel_A == 8'b0) ? {1'b0,dout_g10_A} : {1'b1,dout_g1_A};
assign DATA_to_enc_B = (gain_sel_B == 8'b0) ? {1'b0,dout_g10_B} : {1'b1,dout_g1_B};
assign DATA_to_enc_C = (gain_sel_C == 8'b0) ? {1'b0,dout_g10_C} : {1'b1,dout_g1_C};


wire bas_flag_A, bas_flag_B, bas_flag_C;
wire b_flag_A, b_flag_B, b_flag_C;


assign bas_flag_A = (DATA_to_enc_A[12:6] == 7'b0) ? 1'b1 : 1'b0;
assign bas_flag_B = (DATA_to_enc_B[12:6] == 7'b0) ? 1'b1 : 1'b0;
assign bas_flag_C = (DATA_to_enc_C[12:6] == 7'b0) ? 1'b1 : 1'b0;
assign b_flag_A = (DATA_to_enc_A[11:6] == 6'b0) ? 1'b1 : 1'b0;
assign b_flag_B = (DATA_to_enc_B[11:6] == 6'b0) ? 1'b1 : 1'b0;
assign b_flag_C = (DATA_to_enc_C[11:6] == 6'b0) ? 1'b1 : 1'b0;

assign baseline_flag_A = (reset_A == 1'b0) ? 1'b1 : (GAIN_SEL_MODE_A[1] == 1'b0) ? bas_flag_A : b_flag_A;
assign baseline_flag_B = (reset_B == 1'b0) ? 1'b1 : (GAIN_SEL_MODE_B[1] == 1'b0) ? bas_flag_B : b_flag_B;
assign baseline_flag_C = (reset_C == 1'b0) ? 1'b1 : (GAIN_SEL_MODE_C[1] == 1'b0) ? bas_flag_C : b_flag_C;


	majorityVoter #(.WIDTH(((Nbits_12)>(0)) ? ((Nbits_12)-(0)+1) : ((0)-(Nbits_12)+1))) DATA_to_encVoter (
		.inA(DATA_to_enc_A),
		.inB(DATA_to_enc_B),
		.inC(DATA_to_enc_C),
		.out(DATA_to_enc),
		.tmrErr(DATA_to_encTmrError)
		);

	majorityVoter baseline_flagVoter (
		.inA(baseline_flag_A),
		.inB(baseline_flag_B),
		.inC(baseline_flag_C),
		.out(baseline_flag),
		.tmrErr(baseline_flagTmrError)
		);

	fanout #(.WIDTH(((1)>(0)) ? ((1)-(0)+1) : ((0)-(1)+1))) GAIN_SEL_MODEFanout (
		.in(GAIN_SEL_MODE),
		.outA(GAIN_SEL_MODE_A),
		.outB(GAIN_SEL_MODE_B),
		.outC(GAIN_SEL_MODE_C)
		);

assign tmrError = DATA_to_encTmrError | baseline_flagTmrError;


endmodule
