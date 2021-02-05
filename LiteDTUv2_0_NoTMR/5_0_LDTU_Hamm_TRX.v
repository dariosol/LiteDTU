// ********************************************************************************************************
//					-*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Hamming module - Encoder
//	
//	Input:	- CLK: LiTe-DTU clock
//		- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//		- data_input: 32 bit data from CU
//		- write_signal: control signal for FIFO
//
//	Output:	- data_ham_in: 38 bit data (containing parity bits)
//		- start_write: hamming encoding finished
//
// ********************************************************************************************************

`timescale  1ps/1ps

module Hamm_TRX (
	CLK,
	reset,
	data_input,
	data_ham_in,
	write_signal,
	start_write
);


// Internal constants
	parameter Nbits_32 = 32;
	parameter Nbits_ham = 38;

// Input ports
	input CLK;
	input reset;
	input [Nbits_32-1:0] data_input;
	input write_signal;

// Output ports
	output reg [Nbits_ham-1:0] data_ham_in;
	output reg start_write;

// Internal variables
	wire p1, p2, p3, p4, p5, p6; // parity bit


	assign p1 = (reset == 1'b0) ? 1'b0 : data_input[0] ^ data_input[1] ^ data_input[3] ^ data_input[4] ^ data_input[6] ^ data_input[8] ^ data_input[10] ^ data_input[11] ^ data_input[13] ^ data_input[15] ^ data_input[17] ^ data_input[19] ^ data_input[21] ^ data_input[23] ^ data_input[25] ^ data_input[26] ^ data_input[28] ^ data_input[30];
	assign p2 = (reset == 1'b0) ? 1'b0 :  data_input[0] ^ data_input[2] ^ data_input[3] ^ data_input[5] ^ data_input[6] ^ data_input[9] ^ data_input[10] ^ data_input[12] ^ data_input[13] ^ data_input[16] ^ data_input[17] ^ data_input[20] ^ data_input[21] ^ data_input[24] ^ data_input[25] ^ data_input[27] ^ data_input[28] ^ data_input[31];
	assign p3 = (reset == 1'b0) ? 1'b0 : data_input[1] ^ data_input[2] ^ data_input[3] ^ data_input[7] ^ data_input[8] ^ data_input[9] ^ data_input[10] ^ data_input[14] ^ data_input[15] ^ data_input[16] ^ data_input[17] ^ data_input[22] ^ data_input[23] ^ data_input[24] ^ data_input[25] ^ data_input[29] ^ data_input[30] ^ data_input[31];
	assign p4 = (reset == 1'b0) ? 1'b0 : data_input[4] ^ data_input[5] ^ data_input[6] ^ data_input[7] ^ data_input[8] ^ data_input[9] ^ data_input[10] ^ data_input[18] ^ data_input[19] ^ data_input[20] ^ data_input[21] ^ data_input[22] ^ data_input[23] ^ data_input[24] ^ data_input[25];
	assign p5 = (reset == 1'b0) ? 1'b0 : data_input[11] ^ data_input[12] ^ data_input[13] ^ data_input[14] ^ data_input[15] ^ data_input[16] ^ data_input[17] ^ data_input[18] ^ data_input[19] ^ data_input[20] ^ data_input[21] ^ data_input[22] ^ data_input[23]^ data_input[24] ^ data_input[25];
	assign p6 = (reset == 1'b0) ? 1'b0 : data_input[26] ^ data_input[27] ^ data_input[28] ^ data_input[29] ^ data_input[30] ^ data_input[31];

	always @(posedge CLK) begin
		if (reset == 1'b0) begin
			data_ham_in = 38'b01000000000000000000000000000000;
			start_write = 1'b0;
		end else begin
			if (write_signal == 1'b1) begin
				data_ham_in = {data_input[31], data_input[30], data_input[29], data_input[28], data_input[27], data_input[26], p6, data_input[25], data_input[24], data_input[23], data_input[22], data_input[21], data_input[20], data_input[19], data_input[18], data_input[17], data_input[16], data_input[15], data_input[14], data_input[13], data_input[12], data_input[11], p5, data_input[10], data_input[9], data_input[8], data_input[7], data_input[6], data_input[5], data_input[4], p4, data_input[3], data_input[2], data_input[1], p3, data_input[0], p2, p1};
				start_write = 1'b1;
			end else begin
				start_write = 1'b0;
			end
		end
	end


endmodule
