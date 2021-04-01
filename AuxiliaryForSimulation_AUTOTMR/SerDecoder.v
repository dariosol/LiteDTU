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
module SerDecoder(
		  clk_160,
		  clk_srl,
		  rst,
		  CALIBRATION_BUSY,
		  DATA12_g10,
		  DATA12_g01,
		  test_enable,
		  output_ser_0,
		  output_ser_1,
		  output_ser_2,
		  output_ser_3
		  );
   

   parameter outfile_SER;
   parameter outfile_sample;
   parameter outfile_datain_10;
   parameter outfile_datain_01;
   
   
   parameter ck_period     = 6240;
   parameter ck_srl_period = 780;
   input 	   clk_160;
   input 	   clk_srl;
   input 	   rst;
   input [11:0]    DATA12_g10;
   input [11:0]    DATA12_g01;
   input 	   CALIBRATION_BUSY;
   input 	   test_enable;
   input 	   output_ser_0;
   input 	   output_ser_1;
   input 	   output_ser_2;
   input 	   output_ser_3;
   
   
   integer 	   data_file_read01, data_file_read10;
   integer 	   write_file_g01, write_file_g10, write_file_SER, write_file_output;
   integer 	   data_file_read1, data_file_read2, scan_file1, scan_file2;
   reg 		   eof1, eof2, close0, close1, close2, close3, close4, close5;


   // Main testbench
   initial begin
      
      $display("%s", outfile_SER);
      $display("%s", outfile_sample);
      $display("%s", outfile_datain_10);
      $display("%s", outfile_datain_01);
      
      write_file_SER = $fopen(outfile_SER,"w");
      write_file_output= $fopen(outfile_sample,"w");
      write_file_g10= $fopen(outfile_datain_10,"w");
      write_file_g10= $fopen(outfile_datain_01,"w");
      
   end
   

   ////////////////////////////////////////////////
   //////////DUMP DATA IN FILES////////////////
   // For the output serializers debug

   //parameter pattern_idleDTU_0 = 8'b11101010;
   parameter pattern_idleDTU_0 = 8'b00110101;
   parameter pattern_idleATM = 8'b01011010;
   reg data_aligned=1'b0;
   reg [7:0] pattern;
   integer   index_ser0=31;
   reg [7:0] check_pattern_0 = 8'b0;
   reg [31:0] word_ser_0 = 32'b0;
   reg [7:0]  check_pattern_1 = 8'b0;
   reg [31:0] word_ser_1 = 32'b0;
   reg [7:0]  check_pattern_2 = 8'b0;
   reg [31:0] word_ser_2 = 32'b0;
   reg [7:0]  check_pattern_3 = 8'b0;
   reg [31:0] word_ser_3 = 32'b0;
   reg [31:0] w_ser0 = 32'b0;
   reg [31:0] w_ser1 = 32'b0;
   reg [31:0] w_ser2 = 32'b0;
   reg [31:0] w_ser3 = 32'b0;
   reg 	      wreset=1'b0;

   // For the output serializers debug

   always @(posedge clk_160) begin
      $fwrite(write_file_g01,"%g %h\n", $time, DATA12_g01);
      $fwrite(write_file_g10,"%g %h\n", $time, DATA12_g10); 
   end

   always @ (posedge clk_srl) begin
      if (rst == 1'b0) begin					// IF reset
         index_ser0 = 31;
	 data_aligned = 1'b0;
	 check_pattern_0 = 8'b0;
	 check_pattern_1 = 8'b0;
	 check_pattern_2 = 8'b0;
	 check_pattern_3 = 8'b0;
      end else begin						// END IF reset -> not reset
	 if (test_enable == 1'b1) pattern = pattern_idleATM;	// IF test_enable
	 else pattern = pattern_idleDTU_0;			// END IF test_enable
	 if (data_aligned == 1'b0) begin				// IF data not aligned
	    check_pattern_0 = {check_pattern_0[6:0],output_ser_0};
	    check_pattern_1 = {check_pattern_1[6:0],output_ser_1};
	    check_pattern_2 = {check_pattern_2[6:0],output_ser_2};
	    check_pattern_3 = {check_pattern_3[6:0],output_ser_3};
	    if (check_pattern_0 == pattern) begin	// IF pattern = data
	       data_aligned = 1'b1;
	       /*
		word_ser_0[31]=check_pattern_0[7];
		word_ser_0[30]=check_pattern_0[6];
		word_ser_0[29]=check_pattern_0[5];
		word_ser_0[28]=check_pattern_0[4];
		word_ser_0[30]=check_pattern_0[3];
		word_ser_0[29]=check_pattern_0[2];
		word_ser_0[28]=check_pattern_0[1];
		word_ser_0[27]=check_pattern_0[0];
		word_ser_1[31:27]={check_pattern_1};
		word_ser_2[31:27]={check_pattern_2};
		word_ser_3[31:27]={check_pattern_3};
		*/
	       word_ser_0[31:24]=check_pattern_0;
	       word_ser_1[31:24]=check_pattern_1;
	       word_ser_2[31:24]=check_pattern_2;
	       word_ser_3[31:24]=check_pattern_3;

	       index_ser0 = index_ser0 - 8;
	    end							// END IF pattern = data
	 end else begin						// END IF data not aligned -> now aligned
	    if (index_ser0 == 0) begin				// IF index = 0
	       word_ser_0[index_ser0]=output_ser_0;
	       word_ser_1[index_ser0]=output_ser_1;
	       word_ser_2[index_ser0]=output_ser_2;
	       word_ser_3[index_ser0]=output_ser_3;
	       w_ser0 = word_ser_0;
	       w_ser1 = word_ser_1;
	       w_ser2 = word_ser_2;
	       w_ser3 = word_ser_3;
	       index_ser0 = 31;
	    end else begin					// END IF index = 0 -> index != 0
	       word_ser_0[index_ser0]=output_ser_0;
	       word_ser_1[index_ser0]=output_ser_1;
	       word_ser_2[index_ser0]=output_ser_2;
	       word_ser_3[index_ser0]=output_ser_3;
	       index_ser0 = index_ser0 - 1;
	    end							// END IF index != 0
	 end							// END IF data now aligned
      end								// END IF not reset
      //end								// END ATM
   end								// END always @ (posedge PllClkp)
   reg [2:0] word_0_state;
   integer   frame_counter = 0;
   integer   SER_error = 0;
   always @(negedge clk_srl) begin
      if (index_ser0 == 31) begin
	 if (data_aligned == 1'b1) begin
	    if (CALIBRATION_BUSY == 1'b0) begin
	       if (test_enable == 1'b0) begin
		  if (word_ser_0[31:30]== 2'b01) begin			//BASELINE
		     word_0_state=3'b001;
		     if(wreset==1'b1) begin
			wreset=1'b0;
		     end
		     $fwrite(write_file_SER,"%g %h %h %h %h - BASELINE 5\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[5:0]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[11:6]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[17:12]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[23:18]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[29:24]);
		  end else begin  
		     if (word_ser_0[31:30]== 2'b10) begin			//BASELINE
			word_0_state=3'b010;
			if(wreset==1'b1) begin
			   wreset=1'b0;   
			end
			$fwrite(write_file_SER,"%g %h %h %h %h - BASELINE %h\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3, word_ser_0[27:24]);
			case(word_ser_0[26:24])
			  3'b001: $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[5:0]);
			  3'b010: begin
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[5:0]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[11:6]);
			  end
			  3'b011:begin
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[5:0]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[11:6]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[17:12]);
			  end
			  3'b100:begin
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[5:0]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[11:6]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[17:12]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[23:18]);
			  end
			  default: $fwrite(write_file_output,"%g %h - ERROR\n", $time, word_ser_0);
			endcase		
		     end else begin
		 	if (word_ser_0[31:26]== 6'b001010) begin		//SIGNAL
			   word_0_state=3'b011;
			   if(wreset==1'b1) begin
			      wreset=1'b0;
			   end
			   $fwrite(write_file_SER,"%g %h %h %h %h - SIGNAL 2\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
			   $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[12], word_ser_0[11:0]);
			   $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[25], word_ser_0[24:13]);
			end 
			else begin
		    	   if (word_ser_0[31:25]== 7'b0010110) begin	//SIGNAL
			      word_0_state=3'b100;
			      if(wreset==1'b1) begin
				 wreset=1'b0;
			      end
			      $fwrite(write_file_SER,"%g %h %h %h %h - SIGNAL 1\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
			      $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[12], word_ser_0[11:0]);
			   end 
			   else begin
		    	      if (word_ser_0[31:25]== 7'b0010111) begin	//HEADER
				 if(wreset==1'b1) begin
				    wreset=1'b0;
				 end				  
				 word_0_state=3'b101;
				 $fwrite(write_file_SER,"%g %h %h %h %h - HEADER\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
				 $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[12], word_ser_0[11:0]);
		    	      end 
			      else begin
				 if (word_ser_0[31:28]== 4'b1110) begin	//IDLE
				    word_0_state=3'b110;
				    $fwrite(write_file_SER,"%g %h %h %h %h - IDLE\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
				    if(wreset==1'b1) begin
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				    end
		 		 end
				 else begin
				    if (word_ser_0[31:26]== 6'b001101) begin	//RESET
				       word_0_state=3'b110;
				       $fwrite(write_file_SER,"%g %h %h %h %h - RESET\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       $fwrite(write_file_output,"%g * 0%h\n", $time, 0);
				       wreset=1'b1;
		 		    end
				    
				    else begin
		    		       if (word_ser_0[31:28]== 4'b1101) begin	//TRAILER
					  word_0_state=3'b111;
					  frame_counter = frame_counter+1;
					  $fwrite(write_file_SER,"%g %h %h %h %h - TRAILER\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
		    		       end
				       else begin
					  SER_error=SER_error+1;
					  $fwrite(write_file_SER,"%g %h %h %h %h - SER_ERROR\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
				       end
				    end
				 end
			      end
			   end // else: !if(word_ser_0[31:25]== 7'b0010110)
			end
		     end	
		  end
	       end else begin
		  $fwrite(write_file_SER,"%g %h %h %h %h \n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
	       end
	    end
	 end
      end
   end //END always

endmodule
