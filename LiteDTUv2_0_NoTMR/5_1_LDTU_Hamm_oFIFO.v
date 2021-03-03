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

`timescale	 1ps/1ps

module LDTU_oFIFO(
		  CLK,
		  rst_b,
		  start_write,
		  read_signal,
		  data_input,
		  data_output,
		  empty_signal,
		  full_signal,
		  decode_signal,
		  SeuError
		  );
   parameter	Nbits_ham=38;
   parameter	FifoDepth_buff=16;
   parameter	bits_ptr=4;

   output SeuError;
   output empty_signal;
   output full_signal;
   output reg [Nbits_ham-1:0] data_output;
   output reg		      decode_signal;

   input 		      CLK;
   input 		      rst_b;
   input 		      start_write;
   input 		      read_signal;
   input [Nbits_ham-1:0]      data_input;


   reg [bits_ptr-1:0] 	      ptr_write;
   reg [bits_ptr-1:0] 	      ptr_read;
   reg [Nbits_ham-1:0] 	      memory [ FifoDepth_buff-1 : 0 ] ;
/*
   reg 			      r_decode_signal;
   reg[Nbits_ham-1:0]         r_data_output;
   
   wire 		      r_empty_signal;
   wire 		      r_full_signal;
  */ 
   wire 		      tmrError = 1'b0;
   assign SeuError = tmrError;
   
//   wire 		      data_inputVoted = data_input;
   

   assign empty_signal = (ptr_read == ptr_write);
   assign full_signal = ((ptr_read == ptr_write + 4'b1)||((ptr_read == 4'b0)&&(ptr_write == (4'b1111))));
   //assign empty_signal = r_empty_signal;
   //assign full_signal = r_full_signal;
   
   
   always @( posedge CLK ) begin
      if (rst_b==1'b0) ptr_write <= 4'b0;
      else begin
	 if (start_write ==1'b1) begin
	    if (full_signal ==1'b0) ptr_write <= ptr_write +4'b1;
	    else ptr_write <= ptr_write;
	 end else ptr_write <= ptr_write;
      end
   end

   always @( posedge CLK ) begin
      if (rst_b==1'b0) begin
	 ptr_read <= 4'b0;
	 decode_signal <= 1'b0;
      end else begin
	 if (read_signal ==1'b1) begin
	    if (empty_signal ==1'b0) begin
	       ptr_read <= ptr_read + 4'b1;
	       decode_signal <= 1'b1;
	    end else begin
	       ptr_read <= ptr_read;
	       decode_signal <= 1'b0;
	    end
	 end else begin
	    ptr_read <= ptr_read;
	    decode_signal <= 1'b0;
	 end
      end
   end

   always @( posedge CLK ) begin
      if (rst_b==1'b0)
	memory[ptr_write]	<= 38'b0;
      else begin
	 if (start_write==1'b1) begin
	    if (full_signal==1'b0) memory[ptr_write] <= data_input;
	 end
      end
   end
   always @( posedge CLK ) begin
      if (rst_b==1'b0) data_output = 38'b01000000000000000000000000000000;
      else data_output = memory[ptr_read] ;
   end

   /*
   always @(posedge CLK) begin
      if (rst_b == 1'b0) begin
	 data_output = 38'b01000000000000000000000000000000;
	 decode_signal <= 1'b0;
      end 
      else begin
	 data_output = r_data_output;
	 decode_signal <= r_decode_signal;
	 
      end
   end
*/

endmodule
