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

`timescale  1ns/1ps

module LDTU_oFIFO_top (
		       CLK,
		       rst_b,
		       write_signal,
		       read_signal,
		       data_in_32,
		       flush_b,
		       synch,
		       synch_pattern,
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
   input 		flush_b;
   input 		synch;
   input [Nbits_32-1:0] synch_pattern;
   	 
   // Output ports

   output  [Nbits_32-1:0] DATA32_DTU;
   output 		 full_signal;
   output 		 SeuError;
   

   reg [Nbits_32-1:0] DATA32_DTU_synch;
   
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
   wire 		 full_signal_synch;
   
   
   wire 		 decode_signal;
   
   wire 		 tmrError = 1'b0;
  
   assign SeuError = tmrError | tmrError_oFIFO;

   wire 		 fiforeset;
   
   assign fiforeset = (rst_b & flush_b & ~synch);//WARNING: do we want synch resetting in the same way of flush?
   
   Hamm_TRX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham))
   Hamming_32_38 (.CLK(CLK), .reset(fiforeset), 
		  .data_input(data_in_32), .data_ham_in(data_in_38), 
		  .write_signal(write_signal), .start_write(start_write));


   LDTU_oFIFO #(.Nbits_ham(Nbits_ham)) 
   FIFO (.CLK(CLK), .rst_b(fiforeset), 
	 .start_write(start_write), .read_signal(read_signal),
	 .data_input(data_in_38), .data_output(data_out_38), .full_signal(full_signal_synch), 
	 .decode_signal(decode_signal), .SeuError(tmrError_oFIFO), .empty_signal(empty_signal)); 
   

   Hamm_RX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham))
   Hamming_38_32 (.CLK(CLK), .reset(fiforeset), .decode_signal(decode_signal), .data_ham_out(data_out_38), 
		  .data_output(data_out_32), .HammError(HammError));

   //Output synch
   always @( posedge CLK ) begin
      if ( rst_b == 1'b0) begin 
	 DATA32_DTU_synch = idle_patternEA;
      end else begin
	 if(flush_b==1'b0) begin
	    DATA32_DTU_synch =  32'h2CF0F0F0;
	 end
	 else begin
	    if(synch==1'b1) begin
	       DATA32_DTU_synch =  synch_pattern;
	    end
	 else begin
	   if (read_signal == 1'b1) begin
	      if (empty_signal == 1'b1) begin
		 DATA32_DTU_synch = idle_patternEA;
	      end else begin
		 DATA32_DTU_synch = data_out_32;
	      end
	   end
	 end // else: !if(synch==1'b1)
	 end // else: !if(flush==1'b0)
      end // else: !if( rst_b == 1'b0)
   end // always @ ( posedge CLK )
   
      
   assign DATA32_DTU = DATA32_DTU_synch;
   assign full_signal = full_signal_synch;
   

endmodule
