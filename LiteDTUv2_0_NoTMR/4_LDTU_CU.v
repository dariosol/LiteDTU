
`timescale 1ns/1ps
module LDTU_CU(
	       CLK,
	       rst_b,
	       fallback,
	       Load_data,
	       DATA_32,
	       Load_data_FB,
	       DATA_32_FB,
	       full,
	       DATA_from_CU,
	       losing_data,
	       write_signal,
	       read_signal,
	       SeuError,
	       handshake
	       );


   parameter Nbits_32=32;
   parameter FifoDepth_buff=64;
   parameter bits_ptr=6;
   parameter limit=6'b110001;
   parameter crcBits=12;
   parameter Initial=32'b11110000000000000000000000000000;
   parameter bits_counter=2;



   input CLK;
   input rst_b;
   input fallback;
   
   input Load_data;
   input [Nbits_32-1:0] DATA_32;
   input 		Load_data_FB;
   input [Nbits_32-1:0] DATA_32_FB;
   input 		full;
   input 		handshake;

   output  		losing_data;
   output 		write_signal;
   output  [Nbits_32-1:0] DATA_from_CU;
   output 		     read_signal;
   output 		     SeuError;

   reg [7:0] 		     NSample;
   reg [5:0] 		     Nlimit;
   reg [7:0] 		     NFrame;
   reg [crcBits-1:0] 	     crc;
   
   
   reg 			     r_read_signal;
   reg 			     r_losing_data;
   reg 			     r_write_signal;
   reg [Nbits_32-1:0] 	     r_DATA_from_CU;

   wire 		     read_signal_synch;
   wire 		     losing_data_synch;
   wire 		     write_signal_synch;
   wire [Nbits_32-1:0] 	     DATA_from_CU_synch;
   
   wire [crcBits-1:0] 	     out_crc;

   wire 		     check_limit;

   wire [7:0] 		     NSamples;

   wire [Nbits_32-1:0] 	     wireTrailer;


   assign check_limit = (Nlimit>limit) ? 1'b1 : 1'b0;
   assign NSamples = (Nlimit==6'b0) ? 8'b0 : NSample;
   assign wireTrailer = {4'b1101,NSamples,crc,NFrame};



   wire [crcBits-1:0] 	     wcrc;

   assign wcrc = crc;
   wire 		     tmrError = 1'b0;   
   assign SeuError = tmrError;
   
   CRC_calc calc_crc (.reset(rst_b), .data(DATA_32), .crc(wcrc), .newcrc(out_crc));
   


   wire [7:0] 		     sum_val;


   SumValue SumValue ( .data(DATA_32[31:24]), .sum_val(sum_val));

   //////CRC calculation, not done if FALLBACK
   always @( posedge CLK ) begin
      if (rst_b==1'b0 || fallback==1'b1) begin
	 NSample <= 8'b0;
	 Nlimit <= 6'b0;
	 NFrame <= 8'b0;
	 crc <= 12'b0;
      end 
      else begin
	 if (Load_data == 1'b0) begin
	    if (check_limit==1'b1) begin
	       if (full==1'b0) begin
		  NSample <= 8'b0;
		  Nlimit <= 6'b0;
		  crc <= 12'b0;
		  NFrame <= NFrame+8'b1;
	       end
	    end
	 end 
	 else begin
	    if (full==1'b0) begin
	       Nlimit <= Nlimit+6'b1;
	       NSample <= NSample + sum_val;
	       crc <= out_crc;
	    end
	 end
      end
   end

   //Writing Process
   always @( posedge CLK ) begin
      if (rst_b==1'b0) begin
	 r_DATA_from_CU <= Initial;
   r_losing_data <= 1'b0;
   r_write_signal <= 1'b0;
end 
      else begin
	 if (Load_data == 1'b0 && Load_data_FB == 1'b0) begin
	    r_losing_data <= 1'b0;
	    if (check_limit==1'b1 && fallback==1'b0) begin
	       if (full==1'b0) begin
		  r_DATA_from_CU <= wireTrailer;
		  r_write_signal <= 1'b1;
	       end 
	       else begin
		  r_write_signal <= 1'b0;
	       end
	    end 
	    else begin
	       r_write_signal <= 1'b0;
	    end
	 end 
	 else begin
	    if (full==1'b0 && fallback==1'b0) begin
	       r_write_signal <= 1'b1;
	       r_losing_data <= 1'b0;
	       r_DATA_from_CU <= DATA_32;
	    end else if (full==1'b0 && fallback==1'b1) begin
	       r_write_signal <= 1'b1;
	       r_losing_data <= 1'b0;
	       r_DATA_from_CU <= DATA_32_FB;
	    end else begin
	       r_losing_data <= 1'b1;
	       r_write_signal <= 1'b0;
	    end
	 end
      end
   end

   always @( posedge CLK ) begin
      if (rst_b == 1'b0) r_read_signal <= 1'b0;
      else begin
	 if (handshake == 1'b1) begin
	    r_read_signal <= 1'b1;
	 end 
	 else r_read_signal <= 1'b0;
      end
   end

   assign	   read_signal_synch  = r_read_signal;
   assign	   write_signal_synch = r_write_signal;
   assign	   losing_data_synch  = r_losing_data;
   assign	   DATA_from_CU_synch = r_DATA_from_CU;	 

   
   assign read_signal  = read_signal_synch;
   assign write_signal = write_signal_synch;
   assign losing_data  = losing_data_synch;
   assign DATA_from_CU = DATA_from_CU_synch;
   

endmodule



module CRC_calc (reset,data,crc,newcrc);
   // tmrg do_not_touch
   parameter Nbits_32=32;
   parameter crcBits=12;
   input reset;
   input [Nbits_32-1:0] data;
   input [crcBits-1:0] 	crc;
   output [crcBits-1:0] newcrc;

   wire 		bit_0, bit_1, bit_2, bit_3, bit_4, bit_5, bit_6, bit_7, bit_8, bit_9, bit_10, bit_11;

   assign bit_0 = (reset == 1'b0) ? 1'b0 : data[30] ^data[29] ^data[26] ^data[25] ^data[24] ^data[23] ^data[22] ^data[17] ^data[16] ^data[15] ^data[14] ^data[13] ^data[12] ^data[11] ^data[8] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[1] ^data[0] ^crc[2] ^crc[3] ^crc[4] ^crc[5] ^crc[6] ^crc[9] ^crc[10] ;
   assign bit_1 = (reset == 1'b0) ? 1'b0 : data[31] ^data[29] ^data[27] ^data[22] ^data[18] ^data[11] ^data[9] ^data[0] ^crc[2] ^crc[7] ^crc[9] ^crc[11] ;
   assign bit_2 = (reset == 1'b0) ? 1'b0 : data[29] ^data[28] ^data[26] ^data[25] ^data[24] ^data[22] ^data[19] ^data[17] ^data[16] ^data[15] ^data[14] ^data[13] ^data[11] ^data[10] ^data[8] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[0] ^crc[2] ^crc[4] ^crc[5] ^crc[6] ^crc[8] ^crc[9] ;
   assign bit_3 = (reset == 1'b0) ? 1'b0 : data[27] ^data[24] ^data[22] ^data[20] ^data[18] ^data[13] ^data[9] ^data[2] ^data[0] ^crc[0] ^crc[2] ^crc[4] ^crc[7] ;
   assign bit_4 = (reset == 1'b0) ? 1'b0 : data[28] ^data[25] ^data[23] ^data[21] ^data[19] ^data[14] ^data[10] ^data[3] ^data[1] ^crc[1] ^crc[3] ^crc[5] ^crc[8] ;
   assign bit_5 = (reset == 1'b0) ? 1'b0 : data[29] ^data[26] ^data[24] ^data[22] ^data[20] ^data[15] ^data[11] ^data[4] ^data[2] ^crc[0] ^crc[2] ^crc[4] ^crc[6] ^crc[9] ;
   assign bit_6 = (reset == 1'b0) ? 1'b0 : data[30] ^data[27] ^data[25] ^data[23] ^data[21] ^data[16] ^data[12] ^data[5] ^data[3] ^crc[1] ^crc[3] ^crc[5] ^crc[7] ^crc[10] ;
   assign bit_7 = (reset == 1'b0) ? 1'b0 : data[31] ^data[28] ^data[26] ^data[24] ^data[22] ^data[17] ^data[13] ^data[6] ^data[4] ^crc[2] ^crc[4] ^crc[6] ^crc[8] ^crc[11] ;
   assign bit_8 = (reset == 1'b0) ? 1'b0 : data[29] ^data[27] ^data[25] ^data[23] ^data[18] ^data[14] ^data[7] ^data[5] ^crc[3] ^crc[5] ^crc[7] ^crc[9] ;
   assign bit_9 = (reset == 1'b0) ? 1'b0 : data[30] ^data[28] ^data[26] ^data[24] ^data[19] ^data[15] ^data[8] ^data[6] ^crc[4] ^crc[6] ^crc[8] ^crc[10] ;
   assign bit_10 = (reset == 1'b0) ? 1'b0 : data[31] ^data[29] ^data[27] ^data[25] ^data[20] ^data[16] ^data[9] ^data[7] ^crc[0] ^crc[5] ^crc[7] ^crc[9] ^crc[11] ;
   assign bit_11 = (reset == 1'b0) ? 1'b0 : data[29] ^data[28] ^data[25] ^data[24] ^data[23] ^data[22] ^data[21] ^data[16] ^data[15] ^data[14] ^data[13] ^data[12] ^data[11] ^data[10] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[1] ^data[0] ^crc[1] ^crc[2] ^crc[3] ^crc[4] ^crc[5] ^crc[8] ^crc[9] ;

   assign newcrc = {bit_11,bit_10,bit_9,bit_8,bit_7,bit_6,bit_5,bit_4,bit_3,bit_2,bit_1,bit_0};

endmodule



module SumValue (data, sum_val);
   // tmrg do_not_touch
   input [7:0] data;
   output reg [7:0] sum_val;

   always @(data) begin
      case (data[7:6])
	2'b01 : sum_val = 8'b101;
	2'b10 : sum_val = {2'b0,data[5:0]};
	2'b00 : begin
	   if (data[7:2] ==6'b001010) sum_val = 8'b10;
	   else sum_val = 8'b1;
	end
	default : sum_val = 8'b0;
      endcase
   end

endmodule
