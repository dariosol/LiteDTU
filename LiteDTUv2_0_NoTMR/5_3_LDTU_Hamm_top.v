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
		       CLK,
		       rst_b,
		       write_signal,
		       read_signal,
		       data_in_32,
		       DATA32_DTU,
		       full_signal,
		       SeuError
		       );

   // Internal constants
   parameter Nbits_32 = 32;
   parameter Nbits_ham = 38;
   parameter FifoDepth_buff = 16;
   parameter bits_ptr = 4; 
   parameter idle_patternEA = 32'b11101010101010101010101010101010;   
   parameter idle_pattern5A = 32'b01011010010110100101101001011010;

   // Input ports
   input CLK;
   input rst_b;
   input write_signal;
   input read_signal;
   input [Nbits_32-1:0] data_in_32;

   // Output ports
   output [Nbits_32-1:0] DATA32_DTU;
   output 		 full_signal;
   output 		 SeuError;

   // Internal variables
   wire 		 CLK;
   wire 		 reset;
   wire [Nbits_ham-1:0]  data_in_38;
   wire [Nbits_ham-1:0]  data_out_38;  
   wire [Nbits_32-1:0] 	 data_out_32;
   wire 		 start_write;
   wire 		 HammError;
   wire 		 tmrError_oFIFO;
   wire 		 read_signal;
   wire 		 empty_signal; 

   
   reg [Nbits_32-1:0] 	 DATA32_DTU;
   wire 		 DATA32_DTUTmrError;
   wire 		 decode_signal;
   
   wire 		 tmrError = 1'b0;
   wire 		 tmrErrorVoted = tmrError;
   assign SeuError = tmrErrorVoted;
   

   Hamm_TRX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham))
   Hamming_32_38 (.CLK(CLK), .reset(rst_b), .data_input(data_in_32), .data_ham_in(data_in_38), 
		  .write_signal(write_signal), .start_write(start_write));


   LDTU_oFIFO #(.Nbits_ham(Nbits_ham))		FIFO (.CLK(CLK), .rst_b(rst_b), 
						      .start_write(start_write), .read_signal(read_signal),
						      .data_input(data_in_38), .data_output(data_out_38), .full_signal(full_signal), 
						      .decode_signal(decode_signal), .SeuError(tmrError_oFIFO), .empty_signal(empty_signal)); 


   Hamm_RX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham))
   Hamming_38_32 (.CLK(CLK), .reset(rst_b), .decode_signal(decode_signal), .data_ham_out(data_out_38), 
		  .data_output(data_out_32), .HammError(HammError));


   always @( posedge CLK ) begin
      if ( rst_b == 1'b0) begin 
	 DATA32_DTU = idle_patternEA;
      end else begin
	 if (read_signal == 1'b1) begin
	    if (empty_signal == 1'b1) begin
	       DATA32_DTU = idle_patternEA;
	    end else begin
	       DATA32_DTU = data_out_32;
	    end
	 end
      end
   end

   
endmodule
