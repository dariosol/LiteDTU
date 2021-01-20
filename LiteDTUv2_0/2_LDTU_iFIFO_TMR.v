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

module LDTU_iFIFOTMR(
	DCLK_1,
	DCLK_10,
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
	parameter    FifoDepth2 = 16;
	parameter    FifoDepth = 8;
   	parameter    LookAheadDepth = 16;
	parameter    NBitsCnt = 4;
	parameter    RefSample = 4'b0011;
	//parameter    RefSample2 = 3'b110;
	parameter    RefSample2 = 4'b0110;


// Input ports
	input DCLK_1;
	input DCLK_10;
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
	reg [NBitsCnt-1:0] wrH_ptr_A;	// Write pointer for gain 10
	reg [NBitsCnt-1:0] wrH_ptr_B;
	reg [NBitsCnt-1:0] wrH_ptr_C;

	reg [NBitsCnt-1:0] wrL_ptr_A;	// Write pointer for gain 1
	reg [NBitsCnt-1:0] wrL_ptr_B;
	reg [NBitsCnt-1:0] wrL_ptr_C;

	reg [Nbits_12-1:0] SATval_A;
	reg [Nbits_12-1:0] SATval_B;
	reg [Nbits_12-1:0] SATval_C;

	reg [Nbits_12-1:0] FIFO_g1_A [LookAheadDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_A [LookAheadDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g1_B [LookAheadDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_B [LookAheadDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g1_C [LookAheadDepth-1:0];
	reg [Nbits_12-1:0] FIFO_g10_C [LookAheadDepth-1:0];

	reg [NBitsCnt-1:0] rd_ptr_A;
	reg [NBitsCnt-1:0] rd_ptr_B;
	reg [NBitsCnt-1:0] rd_ptr_C;

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
	reg [FifoDepth2-1:0] gain_sel2_A;
	reg [FifoDepth2-1:0] gain_sel2_B;
	reg [FifoDepth2-1:0] gain_sel2_C;

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

	wire [1:0] GAIN_SEL_MODE_A;
	wire [1:0] GAIN_SEL_MODE_B;
	wire [1:0] GAIN_SEL_MODE_C;

	integer iHA, iHB, iHC;
	integer iLA, iLB, iLC;

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


// WRITE POINTERS : @(posedge DCLK)
	always @(posedge DCLK_10) begin
		if (reset_A == 1'b0) wrH_ptr_A <= 4'b0000;
		else wrH_ptr_A <= wrH_ptr_A+4'b0001;
	end

	always @(posedge DCLK_10) begin
		if (reset_B == 1'b0) wrH_ptr_B <= 4'b0000;
		else wrH_ptr_B <= wrH_ptr_B+4'b0001;
	end

	always @(posedge DCLK_10) begin
		if (reset_C == 1'b0) wrH_ptr_C <= 4'b0000;
		else wrH_ptr_C <= wrH_ptr_C+4'b0001;
	end

	always @(posedge DCLK_1) begin
		if (reset_A == 1'b0) wrL_ptr_A <= 4'b0000;
		else wrL_ptr_A <= wrL_ptr_A+4'b0001;
	end

	always @(posedge DCLK_1) begin
		if (reset_B == 1'b0) wrL_ptr_B <= 4'b0000;
		else wrL_ptr_B <= wrL_ptr_B+4'b0001;
	end

	always @(posedge DCLK_1) begin
		if (reset_C == 1'b0) wrL_ptr_C <= 4'b0000;
		else wrL_ptr_C <= wrL_ptr_C+4'b0001;
	end

// WRITING in FIFO GAIN 1

	always @(posedge DCLK_1) begin
		if (reset_A == 1'b0) begin
			for (iLA = 0; iLA < LookAheadDepth; iLA = iLA +1) begin
				FIFO_g1_A[iLA] <= 12'b0;
			end
		end else begin
			FIFO_g1_A[wrL_ptr_A] <= DATA_gain_01;
		end
	end

	always @(posedge DCLK_1) begin
		if (reset_B == 1'b0) begin
			for (iLB = 0; iLB < LookAheadDepth; iLB = iLB +1) begin
				FIFO_g1_B[iLB] <= 12'b0;
			end
		end else begin
			FIFO_g1_B[wrL_ptr_B] <= DATA_gain_01;
		end
	end

	always @(posedge DCLK_1) begin
		if (reset_C == 1'b0) begin
			for (iLC = 0; iLC < LookAheadDepth; iLC = iLC +1) begin
				FIFO_g1_C[iLC] <= 12'b0;
			end
		end else begin
			FIFO_g1_C[wrL_ptr_C] <= DATA_gain_01;
		end
	end


// WRITING in FIFO GAIN 10

	always @(posedge DCLK_10) begin
		if (reset_A == 1'b0) begin
			for (iHA = 0; iHA < LookAheadDepth; iHA = iHA +1) begin
				FIFO_g10_A[iHA] <= 12'b0;
			end
		end else begin
			FIFO_g10_A[wrH_ptr_A] <= DATA_gain_10;
		end
	end

	always @(posedge DCLK_10) begin
		if (reset_B == 1'b0) begin
			for (iHB = 0; iHB < LookAheadDepth; iHB = iHB +1) begin
				FIFO_g10_B[iHB] <= 12'b0;
			end
		end else begin
			FIFO_g10_B[wrH_ptr_B] <= DATA_gain_10;
		end
	end

	always @(posedge DCLK_10) begin
		if (reset_C == 1'b0) begin
			for (iHC = 0; iHC < LookAheadDepth; iHC = iHC +1) begin
				FIFO_g10_C[iHC] <= 12'b0;
			end
		end else begin
			FIFO_g10_C[wrH_ptr_C] <= DATA_gain_10;
		end
	end


// READ POINTERS : @(posedge CLK)
	//assign rd_ptr_A = wr_ptr_A + 3'b001;
	//assign rd_ptr_B = wr_ptr_B + 3'b001;
	//assign rd_ptr_C = wr_ptr_C + 3'b001;

	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) rd_ptr_A <= 4'b0010;
			else rd_ptr_A <= rd_ptr_A+4'b0001;
	end

	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) rd_ptr_B <= 4'b0010;
			else rd_ptr_B <= rd_ptr_B+4'b0001;
	end

	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) rd_ptr_C <= 4'b0010;
			else rd_ptr_C <= rd_ptr_C+4'b0001;
	end


// REF POINTERS : @(posedge CLK)
	assign ref_ptr_A = (GAIN_SEL_MODE_A == 2'b01) ? (rd_ptr_A + RefSample2) : (rd_ptr_A + RefSample);
	assign ref_ptr_B = (GAIN_SEL_MODE_B == 2'b01) ? (rd_ptr_B + RefSample2) : (rd_ptr_B + RefSample);
	assign ref_ptr_C = (GAIN_SEL_MODE_C == 2'b01) ? (rd_ptr_C + RefSample2) : (rd_ptr_C + RefSample);


	assign FIFO_g10_ref_A = FIFO_g10_A[ref_ptr_A];
	assign FIFO_g10_ref_B = FIFO_g10_B[ref_ptr_B];
	assign FIFO_g10_ref_C = FIFO_g10_C[ref_ptr_C];


	assign ref_sat_A = (GAIN_SEL_MODE_A == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_A == 2'b10) ? 1'b0 : (FIFO_g10_ref_A >= SATval_A) ? 1'b1 : 1'b0;
	assign ref_sat_B = (GAIN_SEL_MODE_B == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_B == 2'b10) ? 1'b0 : (FIFO_g10_ref_B >= SATval_B) ? 1'b1 : 1'b0;
	assign ref_sat_C = (GAIN_SEL_MODE_C == 2'b11) ? 1'b1 : (GAIN_SEL_MODE_C == 2'b10) ? 1'b0 : (FIFO_g10_ref_C >= SATval_C) ? 1'b1 : 1'b0;

	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) gain_sel_A <= 8'b0;
		else begin
			if (GAIN_SEL_MODE_A == 2'b00) gain_sel_A <= {gain_sel_A[FifoDepth-2:0] ,ref_sat_A};
			else begin
				if (GAIN_SEL_MODE_A == 2'b11) gain_sel_A <= {gain_sel_A[FifoDepth-2:0] ,ref_sat_A};
				else gain_sel_A <= 8'b0;
			end
		end
	end

	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) gain_sel_B <= 8'b0;
		else begin
			if (GAIN_SEL_MODE_B == 2'b00) gain_sel_B <= {gain_sel_B[FifoDepth-2:0] ,ref_sat_B};
			else begin
				if (GAIN_SEL_MODE_B == 2'b11) gain_sel_B <= {gain_sel_B[FifoDepth-2:0] ,ref_sat_B};
				else gain_sel_B <= 8'b0;
			end
		end
	end

	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) gain_sel_C <= 8'b0;
		else begin
			if (GAIN_SEL_MODE_C == 2'b00) gain_sel_C <= {gain_sel_C[FifoDepth-2:0] ,ref_sat_C};
			else begin
				if (GAIN_SEL_MODE_C == 2'b11) gain_sel_C <= {gain_sel_C[FifoDepth-2:0] ,ref_sat_C};
				else gain_sel_C <= 8'b0;
			end
		end
	end  
	
// Registri per aumentare la finestra
	always @(posedge CLK_A) begin
		if (reset_A == 1'b0) gain_sel2_A <= 16'b0;
		else begin
			if (GAIN_SEL_MODE_A == 2'b01) gain_sel2_A <= {gain_sel2_A[FifoDepth2-2:0] ,ref_sat_A};
			else gain_sel2_A <= 16'b0;
		end
	end

	always @(posedge CLK_B) begin
		if (reset_B == 1'b0) gain_sel2_B <= 16'b0;
		else begin
			if (GAIN_SEL_MODE_B == 2'b01) gain_sel2_B <= {gain_sel2_B[FifoDepth2-2:0] ,ref_sat_B};
			else gain_sel2_B <= 16'b0;
		end
	end

	always @(posedge CLK_C) begin
		if (reset_C == 1'b0) gain_sel2_C <= 16'b0;
		else begin
			if (GAIN_SEL_MODE_C == 2'b01) gain_sel2_C <= {gain_sel2_C[FifoDepth2-2:0] ,ref_sat_C};
			else gain_sel2_C <= 16'b0;
		end
	end	
	
	assign dout_g1_A = FIFO_g1_A[rd_ptr_A];
	assign dout_g10_A = FIFO_g10_A[rd_ptr_A];
	assign dout_g1_B = FIFO_g1_B[rd_ptr_B];
	assign dout_g10_B = FIFO_g10_B[rd_ptr_B];
	assign dout_g1_C = FIFO_g1_C[rd_ptr_C];
	assign dout_g10_C = FIFO_g10_C[rd_ptr_C];

	wire decision1_A, decision2_A;
	assign decision1_A = (gain_sel_A == 8'b0) ? 1'b1 : 1'b0;
 	assign decision2_A = (gain_sel2_A == 16'b0) ? 1'b1 : 1'b0;
	wire decision1_B, decision2_B;
	assign decision1_B = (gain_sel_B == 8'b0) ? 1'b1 : 1'b0;
 	assign decision2_B = (gain_sel2_B == 16'b0) ? 1'b1 : 1'b0;	
	wire decision1_C, decision2_C;
	assign decision1_C = (gain_sel_C == 8'b0) ? 1'b1 : 1'b0;
 	assign decision2_C = (gain_sel2_C == 16'b0) ? 1'b1 : 1'b0;

	assign DATA_to_enc_A = (decision1_A && decision2_A) ? {1'b0,dout_g10_A} : {1'b1,dout_g1_A};
	assign DATA_to_enc_B = (decision1_B && decision2_B) ? {1'b0,dout_g10_B} : {1'b1,dout_g1_B};
	assign DATA_to_enc_C = (decision1_C && decision2_C) ? {1'b0,dout_g10_C} : {1'b1,dout_g1_C};

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
