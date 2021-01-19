// ********************************************************************************************************
//										 -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	top unit of FIFO with hamming code protection
//	
//	Input:	- CLK: LiTe-DTU clock
//			- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//			- data_in32: 32 bit data from CU
//			- write_signal: flag from CU
//			- read_signal: flag from CU
//
//	Output:	- data_output: 32 bit data coming from FIFO
//			- full_signal: control signal from FIFO
//			- HammError
//
// ********************************************************************************************************

`timescale  1ps/1ps

module LDTU_oFIFO_top (
	CLK_A,
	CLK_B,
	CLK_C,
	reset_A,
	reset_B,
	reset_C,
	write_signal,
	read_signal,
	data_in_32,
	DATA32_DTU,
	full_signal,
	tmrError
);


// Internal constants
	parameter Nbits_32 = 32;
	parameter Nbits_ham = 38;
	parameter FifoDepth_buff = 16;
	parameter bits_ptr = 4; 
	parameter idle_patternEA = 32'b11101010101010101010101010101010;   
	parameter idle_pattern5A = 32'b01011010010110100101101001011010;

// Input ports
	input CLK_A;
	input CLK_B;
	input CLK_C;
	input reset_A;
	input reset_B;
	input reset_C;
	input write_signal;
	input read_signal;
	input [Nbits_32-1:0] data_in_32;

// Output ports
	output [Nbits_32-1:0] DATA32_DTU;
	output full_signal;
	output tmrError;

// Internal variables
	wire CLK;
	wire reset;
	wire [Nbits_ham-1:0] 	data_in_38;
	wire [Nbits_ham-1:0] 	data_out_38;  
	wire [Nbits_32-1:0]	data_out_32;
	wire start_write;
	wire HammError;
	wire tmrError_oFIFO;
	wire read_signal_A;
	wire read_signal_B;
	wire read_signal_C;
	wire empty_signal; 
	wire empty_signal_A;
	wire empty_signal_B;
	wire empty_signal_C;
	reg [Nbits_32-1:0] DATA32_DTU_A;
	reg [Nbits_32-1:0] DATA32_DTU_B;
	reg [Nbits_32-1:0] DATA32_DTU_C;
	wire DATA32_DTUTmrError;
	wire  decode_signal;


Hamm_TRX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham))
	Hamming_32_38 (.CLK(CLK), .reset(reset), .data_input(data_in_32), .data_ham_in(data_in_38), 
	.write_signal(write_signal), .start_write(start_write));


LDTU_oFIFOTMR #(.Nbits_ham(Nbits_ham))
		FIFO (.CLK(CLK), .reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), 
		.start_write(start_write), .read_signal(read_signal),
		.data_input(data_in_38), .data_output(data_out_38), .full_signal(full_signal), 
		.decode_signal(decode_signal), .tmrError(tmrError_oFIFO), .empty_signal(empty_signal)); 


Hamm_RX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham))
	Hamming_38_32 (.CLK(CLK), .reset(reset), .decode_signal(decode_signal), .data_ham_out(data_out_38), 
	.data_output(data_out_32), .HammError(HammError));


always @( posedge CLK_A ) begin
	if ( reset_A == 1'b0) begin 
		DATA32_DTU_A = idle_patternEA;
	end else begin
		if (read_signal_A == 1'b1) begin
			if (empty_signal_A == 1'b1) begin
				DATA32_DTU_A = idle_patternEA;
			end else begin
				DATA32_DTU_A = data_out_32;
			end
		end
	end
end

always @( posedge CLK_B ) begin
	if ( reset_B == 1'b0) begin  
		DATA32_DTU_B = idle_patternEA; 
	end else begin
		if (read_signal_B == 1'b1) begin
			if (empty_signal_B == 1'b1) begin
				DATA32_DTU_B = idle_patternEA;
			end else begin
				DATA32_DTU_B = data_out_32; 
			end
		end
	end
end
	
always @( posedge CLK_C ) begin
	if ( reset_C == 1'b0) begin  
		DATA32_DTU_C = idle_patternEA; 
	end else begin
		if (read_signal_C == 1'b1) begin
			if (empty_signal_C == 1'b1) begin
				DATA32_DTU_C = idle_patternEA;
			end else begin
				DATA32_DTU_C = data_out_32; 
			end
		end
	end	
end

	majorityVoter resetVoter (
	    .inA(reset_A),
	    .inB(reset_B),
	    .inC(reset_C),
	    .out(reset),
	    .tmrErr(resetTmrError)
	    );
	majorityVoter CLK_Voter (
		.inA(CLK_A),
		.inB(CLK_B),
		.inC(CLK_C),
		.out(CLK),
		.tmrErr(CLK_TmrError)
		);
	majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_DTUVoter (
	.inA(DATA32_DTU_A),
	.inB(DATA32_DTU_B),
	.inC(DATA32_DTU_C),
	.out(DATA32_DTU),
	.tmrErr(DATA32_DTUTmrError)
	); 
    fanout read_signalFanout (
	.in(read_signal),
	.outA(read_signal_A),
	.outB(read_signal_B),
	.outC(read_signal_C)
	);
    fanout empty_signalFanout (
	.in(empty_signal),
	.outA(empty_signal_A),
	.outB(empty_signal_B),
	.outC(empty_signal_C)
	);
assign tmrError = CLK_TmrError | HammError | resetTmrError | tmrError_oFIFO | DATA32_DTUTmrError;

endmodule
