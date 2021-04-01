//                              -*- Mode: Verilog -*-
// Author          		: Simona Cometti
// Created On      		: 08/05/2018
// Last modification	: 
// Test bench for ECAL Data Transmission Unit - 1 channel verbose version

//			- reset 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//			- GAIN_SEL_MODE:	2'b00: Gain selection ACTIVE - window width : 8 samples
//						2'b01: Gain selection ACTIVE - window width : 16 samples
//						2'b10: Gain selection INACTIVE - transmitted only gain x10 samples
//						2'b11: Gain selection INACTIVE - transmitted only gain x1 samples
//			- DATA_gain_01: 12 bit from channel_gain_1 (already beseline subtracted)
//			- DATA_gain_10: 12 bit from channel_gain_10 (already beseline subtracted)
// CTRL + F path - for change the path of input and output files

`timescale  1ps/1ps
module FileReader(
		  clk,
		  rst,
		  CALIBRATION_BUSY,
		  DATA12,
		  REJECTED

		  );
   parameter ck_period=6240;
   parameter  infile = "/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g01.dat";
   input clk;
   input rst;
   input [1:0] CALIBRATION_BUSY;
   output reg[11:0]  DATA12;
   output reg[11:0] REJECTED;
   
   
   
   integer 	     data_file_read, scan_file;
   integer 	     write_file_g01, write_file_g10, write_file_SER, write_file_output;
   reg 		     eof, close0, close1, close2, close3, close4, close5;


   initial begin

      data_file_read = $fopen(infile,"r");	

      if (data_file_read == 0) begin
	 $display("FileReader: File to read was NULL");
	 $finish;
      end else begin
	 $display("FileReader: File found: %s",infile);
      end
   end // initial begin
   
   ////////////////////////////////////////////////

   always @(negedge clk) begin
      eof= $feof(data_file_read);
      if (rst == 1'b0) begin //I write xxx but i still read the file 
	 DATA12 = 12'bx;
	 scan_file = $fscanf(data_file_read, "%b\n", REJECTED);
      end   
      else begin
	 if (CALIBRATION_BUSY != 2'b00) begin
	    DATA12 = 12'bx;
	    scan_file = $fscanf(data_file_read, "%b\n", REJECTED);
	 end      
	 else begin			
	    if (!eof) begin
	       scan_file = $fscanf(data_file_read, "%b\n", DATA12);
	       REJECTED=12'b0;	       
	    end 
	    else begin // End of the input file
	       $display("End of reading process");
	       #(ck_period)
	       close0 = 1'b1;
	       #(ck_period*(8-1))
	       close1 = 1'b1;
	       #(10*ck_period)
	       close2 = 1'b1;
	       #(10*ck_period)
	       #(200*ck_period)
	       #(ck_period)
	       close4 = 1'b1;
	       # (16*ck_period)
	       close5 = 1'b1;
	       # (ck_period) $finish;
	    end // end CAL_busy == 2'b00
	 end // end RST == 1'b1
      end // else: !if(rst == 1'b0;
   end // always @ (negedge clk)

endmodule    
