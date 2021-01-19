// ********************************************************************************************************
//					-*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Storage FIFO
//	
//	Input:	- CLK: LiTe-DTU clock
//		- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//		- start_write: hamming encoding finished
//		- read_signal: read data in the FIFO
//		- data_input: 38-bit data (containing parity bits)
//
//	Output:	- data_output: 38-bit data (containing parity bits)
//		- empty signal: No data stored
//		- full_signal: FIFO is full
//		- decode_signal: to the decoder
//		- tmrError
//
// ********************************************************************************************************

`timescale	 1ns/1ps
module LDTU_oFIFOTMR(
	CLK,
	reset_A,
	reset_B,
	reset_C,
	start_write,
	read_signal,
	data_input,
	data_output,
	empty_signal,
	full_signal,
	decode_signal,
	tmrError
);

	parameter	Nbits_ham=38;
	parameter	FifoDepth_buff=16;
	parameter	bits_ptr=4;

	output tmrError;
	output empty_signal;
	output full_signal;
	output reg [Nbits_ham-1:0] data_output;
	output	decode_signal;

	input CLK;
	input reset_A;
	input reset_B;
	input reset_C;
	input start_write;
	input read_signal;
	input [Nbits_ham-1:0] data_input;

	wire reset;
	wire [bits_ptr-1:0] ptr_read;
	wire [bits_ptr-1:0] ptr_write;
	wire resetTmrError;
	wire ptr_readTmrError;
	wire ptr_writeTmrError;
	wire decode_signalTmrError;
	reg	decode_signal_A;
	reg	decode_signal_B;
	reg	decode_signal_C;
	reg	[bits_ptr-1:0] ptr_write_A;
	reg	[bits_ptr-1:0] ptr_write_B;
	reg	[bits_ptr-1:0] ptr_write_C;
	reg	[bits_ptr-1:0] ptr_read_A;
	reg	[bits_ptr-1:0] ptr_read_B;
	reg	[bits_ptr-1:0] ptr_read_C;
	reg	[Nbits_ham-1:0] memory [ FifoDepth_buff-1 : 0 ] ;
	wire read_signal_A;
	wire read_signal_B;
 	wire read_signal_C;
 	wire start_write_A;
 	wire start_write_B;
 	wire start_write_C;
	wire empty_signal_A;
	wire empty_signal_B;
	wire empty_signal_C;
	wire emptyTmrError;
	wire full_signal_A;
	wire full_signal_B;
	wire full_signal_C;
	wire fullTmrError;


	assign empty_signal_A = (ptr_read_A == ptr_write_A);
	assign full_signal_A = ((ptr_read_A == ptr_write_A + 4'b1)||((ptr_read_A == 4'b0)&&(ptr_write_A == (4'b1111))));
	assign empty_signal_B = (ptr_read_B == ptr_write_B);
	assign full_signal_B = ((ptr_read_B == ptr_write_B + 4'b1)||((ptr_read_B == 4'b0)&&(ptr_write_B == (4'b1111))));
	assign empty_signal_C = (ptr_read_C == ptr_write_C);
	assign full_signal_C = ((ptr_read_C == ptr_write_C + 4'b1)||((ptr_read_C == 4'b0)&&(ptr_write_C == (4'b1111))));

	always @( posedge CLK ) begin
		if (reset_A==1'b0) ptr_write_A <= 4'b0;
		else begin
			if (start_write_A==1'b1) begin
				if (full_signal_A==1'b0) ptr_write_A <= ptr_write_A+4'b1;
				else ptr_write_A <= ptr_write_A;
			end else ptr_write_A <= ptr_write_A;
		end
	end

	always @( posedge CLK ) begin
		if (reset_B==1'b0) ptr_write_B <= 4'b0;
		else begin
			if (start_write_B==1'b1) begin
				if (full_signal_B==1'b0) ptr_write_B <= ptr_write_B+4'b1;
				else ptr_write_B <= ptr_write_B;
			end else ptr_write_B <= ptr_write_B;
		end
	end

	always @( posedge CLK ) begin
		if (reset_C==1'b0) ptr_write_C <= 4'b0;
		else begin
			if (start_write_C==1'b1) begin
				if (full_signal_C==1'b0) ptr_write_C <= ptr_write_C+4'b1;
				else ptr_write_C <= ptr_write_C;
			end else ptr_write_C <= ptr_write_C;
		end
	end

	always @( posedge CLK ) begin
		if (reset_A==1'b0) begin
			ptr_read_A <= 4'b0;
			decode_signal_A <= 1'b0;
		end else begin
			if (read_signal_A==1'b1) begin
				if (empty_signal_A==1'b0) begin
					ptr_read_A <= ptr_read_A+4'b1;
					decode_signal_A <= 1'b1;
				end else begin
					ptr_read_A <= ptr_read_A;
					decode_signal_A <= 1'b0;
				end
			end else begin
				ptr_read_A <= ptr_read_A;
				decode_signal_A <= 1'b0;
			end
		end
	end

	always @( posedge CLK ) begin
		if (reset_B==1'b0) begin
			ptr_read_B <= 4'b0;
			decode_signal_B <= 1'b0;
		end else begin
			if (read_signal_B==1'b1) begin
				if (empty_signal_B==1'b0) begin
					ptr_read_B <= ptr_read_B+4'b1;
					decode_signal_B <= 1'b1;
				end else begin
					ptr_read_B <= ptr_read_B;
					decode_signal_B <= 1'b0;
				end
			end else begin
				ptr_read_B <= ptr_read_B;
				decode_signal_B <= 1'b0;
			end
		end
	end

	always @( posedge CLK ) begin
		if (reset_C==1'b0) begin
			ptr_read_C <= 4'b0;
			decode_signal_C <= 1'b0;
		end else begin
			if (read_signal_C==1'b1) begin
				if (empty_signal_C==1'b0) begin
					ptr_read_C <= ptr_read_C+4'b1;
					decode_signal_C <= 1'b1;
				end else begin
					ptr_read_C <= ptr_read_C;
					decode_signal_C <= 1'b0;
				end
			end else begin
				ptr_read_C <= ptr_read_C;
				decode_signal_C <= 1'b0;
			end
		end
	end

	always @( posedge CLK ) begin
		if (reset==1'b0)
			memory[ptr_write]	<= 38'b0;
		else begin
			if (start_write==1'b1) begin
				if (full_signal==1'b0) memory[ptr_write] <= data_input;
			end
		end
	end
	always @( posedge CLK ) begin
		if (reset==1'b0) data_output = 38'b01000000000000000000000000000000;
		else data_output = memory[ptr_read] ;
	end


	majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_writeVoter (
		.inA(ptr_write_A),
		.inB(ptr_write_B),
		.inC(ptr_write_C),
		.out(ptr_write),
		.tmrErr(ptr_writeTmrError)
		);

	majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_readVoter (
		.inA(ptr_read_A),
		.inB(ptr_read_B),
		.inC(ptr_read_C),
		.out(ptr_read),
		.tmrErr(ptr_readTmrError)
		);

	majorityVoter decode_signalVoter (
		.inA(decode_signal_A),
		.inB(decode_signal_B),
		.inC(decode_signal_C),
		.out(decode_signal),
		.tmrErr(decode_signalTmrError)
		);

	majorityVoter resetVoter (
		.inA(reset_A),
		.inB(reset_B),
		.inC(reset_C),
		.out(reset),
		.tmrErr(resetTmrError)
		);

	majorityVoter emptyVoter (
		.inA(empty_signal_A),
		.inB(empty_signal_B),
		.inC(empty_signal_C),
		.out(empty_signal), 
		.tmrErr(emptyTmrError)
		); 

	majorityVoter fullVoter (
		.inA(full_signal_A),
		.inB(full_signal_B),
		.inC(full_signal_C),
		.out(full_signal),
		.tmrErr(fullTmrError)
		);


	assign tmrError =	ptr_readTmrError | ptr_writeTmrError | resetTmrError | decode_signalTmrError | emptyTmrError | fullTmrError;


	fanout read_signalFanout (
		.in(read_signal),
		.outA(read_signal_A),
		.outB(read_signal_B),
		.outC(read_signal_C)
		);

	fanout start_writeFanout (
		.in(start_write),
		.outA(start_write_A),
		.outB(start_write_B),
		.outC(start_write_C)
		);
endmodule
