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

`timescale  1ns/1ps
module tb_LDTU_presynth;


   parameter Nbits_8 	= 8;
   parameter Nbits_12	= 12;
   parameter FifoDepth = 8;
   parameter NBitsCnt 	= 3;
   parameter Nbits_32 	= 32;
   parameter ck_period = 6240;
   parameter crcBits = 12;
   parameter ck_srl_period = 780;
   parameter    Nbits_5=5;
   parameter bits_ptr=4;
   reg DCLK_1;
   reg DCLK_10;	
   reg clk_srl;
   reg clk;
   reg RST_A;
   reg RST_B;
   reg RST_C;
   //	reg GAIN_SEL_MODE;
   reg [1:0] GAIN_SEL_MODE;
   reg 	     fallback;
   
   reg 	     CALIBRATION_BUSY_1;
   reg 	     CALIBRATION_BUSY_10;
   reg [Nbits_12-1:0] DATA12_g01;
   reg [Nbits_12-1:0] DATA12_g10;
   reg [Nbits_8-1:0]  BSL_VAL_g01 = 8'b00000000;
   reg [Nbits_8-1:0]  BSL_VAL_g10 = 8'b00000000;
   reg [Nbits_12-1:0] SATURATION_value = 12'b111111111111;
   reg [1:0] shift_gain_10 = 2'b00;
   //reg [Nbits_8-1:0] BSL_VAL_g01 = 8'b1000;
   //reg [Nbits_8-1:0] BSL_VAL_g10 = 8'b1000;
   wire 	      losing_data;
   //wire tmr_Error_LiTe_DTU;
   //wire read_signal;
   //wire [Nbits_32-1:0] data_to_ser;
   wire [Nbits_32-1:0] DATA32_to_SER_0; 
   wire [Nbits_32-1:0] DATA32_to_SER_1; 
   wire [Nbits_32-1:0] DATA32_to_SER_2; 
   wire [Nbits_32-1:0] DATA32_to_SER_3;
   reg [Nbits_32-1:0]  word;
   //wire write_signal;
   //wire [Nbits_32-1:0] DATA_from_CU;
   wire 	       totalError;
   wire 	       empty;	//***
   wire 	       full;	//***
   wire 	       baseline_flag;		//***
   wire [Nbits_12:0]   DATA_to_enc;	//***
   wire [Nbits_32-1:0] DATA_32;	//***
   wire 	       Load;			//***
   wire [bits_ptr:0]   distance;//***

   integer 	       data_file_read01, data_file_read10;
   integer 	       write_file_g01, write_file_g10, write_file_SER, write_file_output;
   integer 	       data_file_read1, data_file_read2, scan_file1, scan_file2, index, index_2;
   integer 	       conta_CLK;
   reg 		       eof1, eof2, close0, close1, close2, close3, close4, close5;

   wire 	       CALIBRATION_BUSY;
   assign CALIBRATION_BUSY = CALIBRATION_BUSY_1 | CALIBRATION_BUSY_10;

   wire 	       output_ser_0;
   wire 	       output_ser_1;
   wire 	       output_ser_2;
   wire 	       output_ser_3;
   reg 		       test_enable;

   wire 	       handshake;


   //New Orbit Signal for Phase 2
   reg 		       Orbit;
   

   top_ofthetop toptoplevel(.DCLK_1(DCLK_1), .DCLK_10(DCLK_10), .CLK(clk), .CLK_SRL(clk_srl),
			    .RST_A(RST_A),  .RST_B(RST_B), .RST_C(RST_C), 
			    .CALIBRATION_BUSY_1(CALIBRATION_BUSY_1), .CALIBRATION_BUSY_10(CALIBRATION_BUSY_10), 
			    .TEST_ENABLE(test_enable), .GAIN_SEL_MODE(GAIN_SEL_MODE),.fallback(fallback), 
			    .DATA12_g01(DATA12_g01), .DATA12_g10(DATA12_g10), 
			    .SATURATION_value(SATURATION_value), .BSL_VAL_g01(BSL_VAL_g01), .BSL_VAL_g10(BSL_VAL_g10),
			    .Orbit(Orbit),
			    .shift_gain_10(shift_gain_10),
			    .losing_data(losing_data), 
			    .totalError(totalError), .handshake(handshake), 
			    .output_ser_0(output_ser_0), .output_ser_1(output_ser_1), 
			    .output_ser_2(output_ser_2), .output_ser_3(output_ser_3));



   // clk generation
   initial begin
      DCLK_1 = 1'b1;
      #(ck_period/2);
      //#(0.3*ck_period);
      DCLK_1 = 1'b0;
      forever begin
	 #(ck_period/2);
	 DCLK_1 = ~DCLK_1;
      end
   end

   // clk generation
   initial begin
      DCLK_10 = 1'b1;
      #(ck_period/2);
      //#(0.35*ck_period);
      DCLK_10 = 1'b0;
      forever begin
	 #(ck_period/2);
	 DCLK_10 = ~DCLK_10;
      end
   end

   // clk generation
   initial begin
      clk = 1'b1;
      //clk = 1'b0;
      forever begin
	 #(ck_period/2);
	 clk = ~clk;
      end
   end

   // clk_srl generation
   initial begin
      clk_srl = 1'b1;
      //clk = 1'b0;
      forever begin
	 #(ck_srl_period/2);
	 clk_srl = ~clk_srl;
      end
   end

   
   //Orbit signal generation
   initial begin
      Orbit = 1'b0;
      #((34+54)*ck_period); //212 ns
      Orbit = 1'b1;
      #(1*ck_period); 
      Orbit = 1'b0;
      
      forever begin
	 #(14240*ck_period); //89us
	 Orbit = 1'b1;
	 #(1*ck_period);
	 Orbit = 1'b0;
      end
   end



   
   // Main testbench
   initial begin

      // ---- Initial situation ----
      /*RST_A = 1'b0;
       RST_B = 1'b0;
       RST_C = 1'b0;
       CALIBRATION_BUSY_1 <= 1'b0;
       CALIBRATION_BUSY_10 <= 1'b0;
       test_enable <= 1'b0;
       #(0.7*ck_period);		// {0,0,0}
       CALIBRATION_BUSY_1 <= 1'b1;
       CALIBRATION_BUSY_10 <= 1'b1;
       #(0.7*ck_period);		// {0,1,0}
       test_enable <= 1'b1;
       #(0.7*ck_period);		// {0,1,1}
       CALIBRATION_BUSY_1 <= 1'b0;
       CALIBRATION_BUSY_10 <= 1'b0;
       #(0.7*ck_period);		// {0,0,1}
       test_enable <= 1'b0;
       #(0.7*ck_period);		// {0,0,0}
       RST_A   = 1'b1;
       RST_B   = 1'b1;
       RST_C   = 1'b1;
       #(0.7*ck_period);		// {1,0,0}
       CALIBRATION_BUSY_1 <= 1'b1;
       CALIBRATION_BUSY_10 <= 1'b1;
       #(0.7*ck_period);		// {1,1,0}
       test_enable <= 1'b1;
       #(0.7*ck_period);		// {1,1,1}
       CALIBRATION_BUSY_1 <= 1'b0;
       CALIBRATION_BUSY_10 <= 1'b0;
       #(0.7*ck_period);		// {1,0,1}
       test_enable <= 1'b0;
       #(0.7*ck_period);		// {1,0,0}
       RST_A   = 1'b0;
       RST_B   = 1'b0;
       RST_C   = 1'b0;
       #(3.7*ck_period);		// {0,0,0}
       */




      RST_A   = 1'b1;
      RST_B   = 1'b1;
      RST_C   = 1'b1;
      CALIBRATION_BUSY_1 <= 1'b0;
      CALIBRATION_BUSY_10 <= 1'b0;
      //      test_enable <= 1'b1;			// ADC_test_mode
      test_enable <= 1'b0;			// DTU_test_mode
      GAIN_SEL_MODE <= 2'b00;		// Auto-gain selection
      fallback=1'b0;
      
      #(0.7*ck_period);	// --------------- system reset
      RST_A = 1'b0;
      RST_B = 1'b0;
      RST_C = 1'b0;
      // If both following assignation are commented: SATURATION_value = 12'hfff
      //SATURATION_value = 12'b111011011000; //3800 ADC count sat value
      //SATURATION_value = 12'b011111010000;//2000 ADC count sat value
      if (test_enable == 1'b1) begin
	 write_file_SER = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_ATM.dat","w");
	 write_file_g01= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_ATU_ing01.dat","w");
	 write_file_g10= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_ATU_ing10.dat","w");
      end else begin
	 if (GAIN_SEL_MODE == 2'b00) begin
	    write_file_SER = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTUoutputSIMONA_GSM00.dat","w");
	    write_file_output= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_00_outputSIMONA.dat","w");
	    write_file_g01= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_00_ing01.dat","w");
	    write_file_g10= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_00_ing10.dat","w");
	 end
	 if (GAIN_SEL_MODE == 2'b01) begin
	    write_file_SER = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTUoutputSIMONA_GSM01.dat","w");
	    write_file_output= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_01_outputSIMONA.dat","w");
	    write_file_g01= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_01_ing01.dat","w");
	    write_file_g10= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_01_ing10.dat","w");
	 end
	 if (GAIN_SEL_MODE == 2'b10) begin
	    write_file_SER = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTUoutputSIMONA_GSM10.dat","w");
	    write_file_output= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_10_outputSIMONA.dat","w");
	    write_file_g01= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_10_ing01.dat","w");
	    write_file_g10= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_10_ing10.dat","w");
	 end
	 if (GAIN_SEL_MODE == 2'b11) begin
	    write_file_SER = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTUoutputSIMONA_GSM11.dat","w");
	    write_file_output= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_11_outputSIMONA.dat","w");
	    write_file_g01= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_11_ing01.dat","w");
	    write_file_g10= $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/presynth_DTU_GSM_11_ing10.dat","w");
	 end
      end 
      #(2.4*ck_period);
      RST_A   = 1'b1;		// --------------- system active
      RST_B   = 1'b1;
      RST_C   = 1'b1;

      #(5.3*ck_period);			
      CALIBRATION_BUSY_1 <= 1'b1;	// --------------- calibration starts here ADC_L
      #(1.3*ck_period);	
      CALIBRATION_BUSY_10 <= 1'b1;	// --------------- calibration starts here ADC_H
      #(26*ck_period);
      CALIBRATION_BUSY_1 <= 1'b0;	// --------------- end of calibration ADC_L
      #(0.3*ck_period);
      CALIBRATION_BUSY_10 <= 1'b0;	// --------------- end of calibration ADC_H

      #(500*ck_period);	// --------------- system reset
      RST_A = 1'b0;
      RST_B = 1'b0;
      RST_C = 1'b0;
      #(10*ck_period);	// --------------- system reset
      RST_A = 1'b1;
      RST_B = 1'b1;
      RST_C = 1'b1;
     

   end



   initial begin

      //$timeformat(-9, 2, " ns", 10); 
      /* ------------------------------------------------------------------------------------------------------------------------- */

      data_file_read01 = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g01.dat","r");	// Data reading - GAIN = 1
      data_file_read10 = $fopen("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g10.dat","r");	// Data reading - GAIN = 10


      if (data_file_read01 == 0) begin
	 $display("data_file_read1 handle was NULL");
	 $finish;
      end else begin
	 $display("File 1 aperto!");
      end
      if (data_file_read10 == 0) begin
	 $display("data_file_read2 handle was NULL");
	 $finish;
      end else begin
	 $display("File 2 aperto!");
      end
   end




   always @(negedge DCLK_1) begin
      eof1= $feof(data_file_read01);
      if (RST_A == 1'b0) DATA12_g01 = 12'bx;
      else begin
	 if (CALIBRATION_BUSY != 2'b00) DATA12_g01 = 12'bx;
	 else begin			
	    if (!eof1) begin
	       scan_file1 = $fscanf(data_file_read01, "%b\n", DATA12_g01);
	    end else begin // End of the input file
	       $display("End of reading process");
	       #(ck_period)
	       close0 = 1'b1;
	       #(ck_period*(FifoDepth-1))
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
	    end
	 end // end CAL_busy == 2'b00
      end // end RST == 1'b1
   end


   always @(negedge DCLK_10) begin
      eof2= $feof(data_file_read10);
      if (RST_A == 1'b0) DATA12_g10 = 12'bx;
      else begin
	 if (CALIBRATION_BUSY != 2'b00) DATA12_g10 = 12'bx;
	 else begin
	    if (!eof2) begin
	       scan_file2 = $fscanf(data_file_read10, "%b\n", DATA12_g10);
	    end else begin // End of the input file
	       $display("End of reading process");
	       #(ck_period)
	       close0 = 1'b1;
	       #(ck_period*(FifoDepth-1))
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
	    end
	 end // end CAL_busy == 2'b00
      end // end RST == 1'b1
   end


   // For the output serializers debug

   parameter pattern_idleDTU_0 = 8'b11101010;
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


   // For the output serializers debug

   always @(posedge DCLK_1) begin
      if (CALIBRATION_BUSY == 2'b00) begin
	 $fwrite(write_file_g01,"%g %h\n", $time, DATA12_g01);
	 $fwrite(write_file_g10,"%g %h\n", $time, DATA12_g10); 
      end
   end

   always @ (posedge clk_srl) begin
      if (RST_A == 1'b0) begin					// IF reset
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
		     $fwrite(write_file_SER,"%g %h %h %h %h - BASELINE 5\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[5:0]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[11:6]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[17:12]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[23:18]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time, word_ser_0[29:24]);
		  end else begin  
		     if (word_ser_0[31:30]== 2'b10) begin			//BASELINE
			word_0_state=3'b010;
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
			   $fwrite(write_file_SER,"%g %h %h %h %h - SIGNAL 2\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
			   $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[12], word_ser_0[11:0]);
			   $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[25], word_ser_0[24:13]);
			end 
			else begin
		    	   if (word_ser_0[31:25]== 7'b0010110) begin	//SIGNAL
			      word_0_state=3'b100;
			      $fwrite(write_file_SER,"%g %h %h %h %h - SIGNAL 1\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
			      $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[12], word_ser_0[11:0]);
			   end 
			   else begin
		    	      if (word_ser_0[31:25]== 7'b0010111) begin	//HEADER
				 word_0_state=3'b101;
				 $fwrite(write_file_SER,"%g %h %h %h %h - HEADER\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
				 $fwrite(write_file_output,"%g %h %h\n", $time, word_ser_0[12], word_ser_0[11:0]);
		    	      end 
			      else begin
				 if (word_ser_0[31:28]== 4'b1110) begin	//IDLE
				    word_0_state=3'b110;
				    $fwrite(write_file_SER,"%g %h %h %h %h - IDLE\n", $time, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
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
