// ********************************************************************************************************
//				 -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	FIFO - Hamming Decoding
//	
//	Input:	- CLK: LiTe-DTU clock
//		- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//		- decode_signal: start decoding data: 38bit -> 32 bit
//		- data_ham_out: 38 bit data
//
//	Output:	- data_output: 32 bit data - corrected
//		- HammError: 
//
// ********************************************************************************************************

`timescale  1ps/1ps

module Hamm_RX (
	CLK,
	reset,
	decode_signal,
	data_ham_out,
	data_output,
	HammError
	);
// tmrg do_not_touch

// Internal constants
	parameter Nbits_32 = 32;
	parameter Nbits_ham = 38;

// Input ports
	input CLK;
	input reset;
	input [Nbits_ham-1:0] data_ham_out;
	input decode_signal;

// Output ports
	output reg [Nbits_32-1:0] data_output;
	output reg HammError;

// Internal variables
	//reg [5:0] error_position; // parity bit collected here
	reg [Nbits_ham-1:0] data_ham_corrected;

	wire [5:0] error_position; // parity bit collected here
	wire e0, e1, e2, e3, e4, e5;



assign e0 = (reset == 1'b0) ? 1'b0 : data_ham_out[0] ^ data_ham_out[2] ^ data_ham_out[4] ^ data_ham_out[6] ^ data_ham_out[8] ^ data_ham_out[10] ^ data_ham_out[12] ^ data_ham_out[14] ^ data_ham_out[16] ^ data_ham_out[18] ^ data_ham_out[20] ^ data_ham_out[22] ^ data_ham_out[24] ^ data_ham_out[26] ^ data_ham_out[28] ^ data_ham_out[30] ^ data_ham_out[32] ^ data_ham_out[34] ^ data_ham_out[36];
assign e1 = (reset == 1'b0) ? 1'b0 : data_ham_out[1] ^ data_ham_out[2] ^ data_ham_out[5] ^ data_ham_out[6] ^ data_ham_out[9] ^ data_ham_out[10] ^ data_ham_out[13] ^ data_ham_out[14] ^ data_ham_out[17] ^ data_ham_out[18] ^ data_ham_out[21] ^ data_ham_out[22] ^ data_ham_out[25] ^ data_ham_out[26] ^ data_ham_out[29] ^ data_ham_out[30] ^ data_ham_out[33] ^ data_ham_out[34] ^ data_ham_out[37];
assign e2 = (reset == 1'b0) ? 1'b0 : data_ham_out[3] ^ data_ham_out[4] ^ data_ham_out[5] ^ data_ham_out[6] ^ data_ham_out[11] ^ data_ham_out[12] ^ data_ham_out[13] ^ data_ham_out[14] ^ data_ham_out[19] ^ data_ham_out[20] ^ data_ham_out[21] ^ data_ham_out[22] ^ data_ham_out[27] ^ data_ham_out[28] ^ data_ham_out[29] ^ data_ham_out[30] ^ data_ham_out[35] ^ data_ham_out[36] ^ data_ham_out[37];
assign e3 = (reset == 1'b0) ? 1'b0 : data_ham_out[7] ^ data_ham_out[8] ^ data_ham_out[9] ^ data_ham_out[10] ^ data_ham_out[11] ^ data_ham_out[12] ^ data_ham_out[13] ^ data_ham_out[14] ^ data_ham_out[23] ^ data_ham_out[24] ^ data_ham_out[25] ^ data_ham_out[26] ^ data_ham_out[27] ^ data_ham_out[28] ^ data_ham_out[29] ^ data_ham_out[30];
assign e4 = (reset == 1'b0) ? 1'b0 : data_ham_out[15] ^ data_ham_out[16] ^ data_ham_out[17] ^ data_ham_out[18] ^ data_ham_out[19] ^ data_ham_out[20] ^ data_ham_out[21] ^ data_ham_out[22] ^ data_ham_out[23]^ data_ham_out[24] ^ data_ham_out[25] ^ data_ham_out[26] ^ data_ham_out[27] ^ data_ham_out[28] ^ data_ham_out[29] ^ data_ham_out[30];
assign e5 = (reset == 1'b0) ? 1'b0 : data_ham_out[31] ^ data_ham_out[32] ^ data_ham_out[33] ^ data_ham_out[34] ^ data_ham_out[35] ^ data_ham_out[36] ^ data_ham_out[37];

assign error_position = {e5, e4, e3, e2, e1, e0};


	always @(posedge CLK) begin
		if (reset == 1'b0) begin
			HammError = 1'b0;
			data_output = 32'b11101010101010101010101010101010;
		end else begin
			if (decode_signal == 1'b1) begin
				data_ham_corrected = data_ham_out;
				if (error_position == 6'b0) begin
					HammError = 1'b0;
				end else begin
					HammError = 1'b1;
					data_ham_corrected[error_position-6'b1] = ~ data_ham_out[error_position-6'b1];
				end
				data_output = {data_ham_corrected[37], data_ham_corrected[36], data_ham_corrected[35], data_ham_corrected[34], data_ham_corrected[33], data_ham_corrected[32], data_ham_corrected[30], data_ham_corrected[29], data_ham_corrected[28], data_ham_corrected[27], data_ham_corrected[26], data_ham_corrected[25], data_ham_corrected[24], data_ham_corrected[23], data_ham_corrected[22], data_ham_corrected[21], data_ham_corrected[20], data_ham_corrected[19], data_ham_corrected[18], data_ham_corrected[17], data_ham_corrected[16], data_ham_corrected[14], data_ham_corrected[13], data_ham_corrected[12], data_ham_corrected[11], data_ham_corrected[10], data_ham_corrected[9], data_ham_corrected[8], data_ham_corrected[6], data_ham_corrected[5], data_ham_corrected[4], data_ham_corrected[2]};
			end
		end
	end

endmodule
