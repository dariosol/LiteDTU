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
//   4.02.2021	: Manual triplication removed - Gianni
//
// *************************************************************************************************
 
`timescale   1ps/1ps

module LDTU_iFIFO(
	DCLK_1,
	DCLK_10,
	CLK,
	rst_b,
	GAIN_SEL_MODE,
	DATA_gain_01,
	DATA_gain_10,
	SATURATION_value,
	shift_gain_10,	     
	DATA_to_enc,
	baseline_flag,
	SeuError
	);

// Internal constants

	parameter    Nbits_7 = 7;
	parameter    Nbits_12 = 12;
	parameter    FifoDepth2 = 16;
	parameter    FifoDepth = 8;
	parameter    NBitsCnt = 3;
	parameter    RefSample = 3'b011;
	//parameter    RefSample2 = 3'b110;
	parameter    RefSample2 = 3'b101;


// Input ports
	input DCLK_1;
	input DCLK_10;
	input CLK;
	input rst_b;
	input [1:0] GAIN_SEL_MODE;
	input [Nbits_12-1:0] DATA_gain_01;
	input [Nbits_12-1:0] DATA_gain_10;
	input [Nbits_12-1:0] SATURATION_value;

   

// Output ports
	output reg[Nbits_12:0] DATA_to_enc;
	output reg baseline_flag;
	output SeuError;

	wire tmrError = 1'b0;
	wire errorVoted = tmrError;
	assign SeuError = errorVoted;

	reg[NBitsCnt-1:0] 	wrH_ptr;	// Write pointer for gain 10
	reg[NBitsCnt-1:0] 	wrL_ptr;	// Write pointer for gain 1

	wire[NBitsCnt-1:0] wrH_ptrVoted = wrH_ptr;
	wire[NBitsCnt-1:0] wrL_ptrVoted = wrL_ptr;

	reg [Nbits_12-1:0] 	SATval;

	reg [Nbits_12-1:0] 	FIFO_g1 [FifoDepth-1:0];
	reg [Nbits_12-1:0] 	FIFO_g10 [FifoDepth-1:0];

	reg[NBitsCnt-1:0]  rd_ptr;
	wire[NBitsCnt-1:0] rd_ptrVoted 	= rd_ptr;

	wire [NBitsCnt-1:0] ref_ptr;
	wire [NBitsCnt-1:0] ref_ptrVoted = ref_ptr;
	wire [Nbits_12-1:0] FIFO_g10_ref;
	wire ref_sat;

	reg [FifoDepth-1:0] 	gain_sel;
	reg [FifoDepth2-1:0] 	gain_sel2;

	wire [Nbits_12-1:0] 	dout_g1;
	wire [Nbits_12-1:0] 	dout_g10;

	wire [Nbits_12:0] 		d2enc;
	wire [Nbits_12:0] 		d2encVoted = d2enc;

	wire bsflag;
	wire bsflagVoted;

	wire [1:0] GAIN_SEL_MODE;

	integer iH;
	integer iL;

// SATval: saturation value tunable  : @(posedge CLK)
	always @(posedge CLK) begin
		if (rst_b == 1'b0) SATval <= 12'hfff;
		else SATval <= SATURATION_value >> shift_gain_10;
	end

// WRITE POINTERS : @(posedge DCLK)
	always @(posedge DCLK_10) begin
		if (rst_b == 1'b0) wrH_ptr <= 3'b000;
		else wrH_ptr <= wrH_ptrVoted+3'b001;
	end

	always @(posedge DCLK_1) begin
		if (rst_b == 1'b0) wrL_ptr <= 3'b000;
		else wrL_ptr <= wrL_ptrVoted+3'b001;
	end

// WRITING in FIFO GAIN 1

	always @(posedge DCLK_1) begin
		if (rst_b == 1'b0) begin
			for (iL = 0; iL < FifoDepth; iL = iL +1) begin
				FIFO_g1[iL] <= 12'b0;
			end
		end else begin
			FIFO_g1[wrL_ptrVoted] <= DATA_gain_01;
		end
	end


// WRITING in FIFO GAIN 10

	always @(posedge DCLK_10) begin
		if (rst_b == 1'b0) begin
			for (iH = 0; iH < FifoDepth; iH = iH +1) begin
				FIFO_g10[iH] <= 12'b0;
			end
		end else begin
			FIFO_g10[wrH_ptrVoted] <= DATA_gain_10 >> shift_gain_10;
		end
	end


// READ POINTERS : @(posedge CLK)

	always @(posedge CLK) begin
		if (rst_b == 1'b0) rd_ptr <= 3'b010;
			else rd_ptr <= rd_ptr+3'b001;
	end


// REF POINTERS : @(posedge CLK)
	assign ref_ptr = (GAIN_SEL_MODE == 2'b01) ? (rd_ptr + RefSample2) : (rd_ptr + RefSample);
	assign FIFO_g10_ref = FIFO_g10[ref_ptrVoted];
	assign ref_sat = (GAIN_SEL_MODE == 2'b11) ? 1'b1 : (GAIN_SEL_MODE == 2'b10) ? 1'b0 : (FIFO_g10_ref >= SATval) ? 1'b1 : 1'b0;


	always @(posedge CLK) begin
		if (rst_b == 1'b0) gain_sel <= 8'b0;
		else begin
			if (GAIN_SEL_MODE == 2'b00) gain_sel <= {gain_sel[FifoDepth-2:0] ,ref_sat};
			else begin
				if (GAIN_SEL_MODE == 2'b11) gain_sel <= {gain_sel[FifoDepth-2:0] ,ref_sat};
				else gain_sel <= 8'b0;
			end
		end
	end
	
// Registri per aumentare la finestra
	always @(posedge CLK) begin
		if (rst_b == 1'b0) gain_sel2 <= 16'b0;
		else begin
			if (GAIN_SEL_MODE == 2'b01) gain_sel2 <= {gain_sel2[FifoDepth2-2:0] ,ref_sat};
			else gain_sel2 <= 16'b0;
		end
	end
	
	assign dout_g1 = FIFO_g1[rd_ptrVoted];
	assign dout_g10 = FIFO_g10[rd_ptrVoted];

	wire decision1, decision2;
	assign decision1 = (gain_sel == 8'b0) ? 1'b1 : 1'b0;
 	assign decision2 = (gain_sel2 == 16'b0) ? 1'b1 : 1'b0;

	assign d2enc = (decision1 && decision2) ? {1'b0,dout_g10} : {1'b1,dout_g1};

	always @(posedge CLK) begin
		if (rst_b == 1'b0) begin
			DATA_to_enc = 12'h000;
			baseline_flag = 1'b1;
		end else begin
			DATA_to_enc = d2encVoted;
			//baseline_flag = bsflagVoted;
		        baseline_flag = bsflag; //MOD: Per simularlo senza triplicazione, devo togliere il voted, se no non e' pilotato
		end
	end

	wire bas_flag;
	wire b_flag;

	assign bas_flag = (d2encVoted[12:6] == 7'b0) ? 1'b1 : 1'b0;
	assign b_flag 	= (d2encVoted[11:6] == 6'b0) ? 1'b1 : 1'b0;
	assign bsflag 	= (GAIN_SEL_MODE[1] == 1'b0) ? bas_flag : b_flag;

endmodule
