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
module fulltest;


   parameter Nbits_8 	   = 8;
   parameter Nbits_12     = 12;
   parameter FifoDepth     = 8;
   parameter NBitsCnt 	   = 3;
   parameter Nbits_32 	   = 32;
   parameter ck_period     = 6240;
   parameter crcBits       = 12;
   parameter ck_srl_period = 780;
   parameter    Nbits_5=5;
   parameter bits_ptr=4;
   ///////////NAMES ARE NOW FIX... BUT TB MUCH MORE READABLE
   parameter file_SER_name       ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_SER.dat"; 
   parameter file_sample_name    ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_sample.dat";
   parameter file_datain_10_name ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_in10.dat";
   parameter file_datain_01_name ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_in01.dat";

   ///////////NAMES ARE NOW FIX... BUT TB MUCH MORE READABLE
   parameter file_SER_name_2       ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_SER_2.dat"; 
   parameter file_sample_name_2    ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_sample_2.dat";
   parameter file_datain_10_name_2 ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_in10_2.dat";
   parameter file_datain_01_name_2 ="/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/sim_results/fulltest_in01_2.dat";

   
   
   reg DCLK_1;
   reg DCLK_10;	
   reg clk_srl;
   reg clk;
   reg RST_A;
   reg RST_B;
   reg RST_C;

   reg DCLK_1_2;
   reg DCLK_10_2;	
   reg RST_A_2;
   reg RST_B_2;
   reg RST_C_2;

   reg [1:0] GAIN_SEL_MODE;
   reg 	     CALIBRATION_BUSY_1;
   reg 	     CALIBRATION_BUSY_10;
   wire [Nbits_12-1:0] DATA12_g01;
   wire [Nbits_12-1:0] DATA12_g10;

   wire [Nbits_12-1:0] REJECTED_g01;
   wire [Nbits_12-1:0] REJECTED_g10;
   
   reg [Nbits_8-1:0]   BSL_VAL_g01 = 8'b00000000;
   reg [Nbits_8-1:0]   BSL_VAL_g10 = 8'b00000000;
   reg [Nbits_12-1:0]  SATURATION_value = 12'b111111111111;

   reg [1:0] 	       GAIN_SEL_MODE_2;
   reg 		       CALIBRATION_BUSY_1_2;
   reg 		       CALIBRATION_BUSY_10_2;
   wire [Nbits_12-1:0] DATA12_g01_2;
   wire [Nbits_12-1:0] DATA12_g10_2;

   wire [Nbits_12-1:0] REJECTED_g01_2;
   wire [Nbits_12-1:0] REJECTED_g10_2;

   reg [Nbits_8-1:0]   BSL_VAL_g01_2 = 8'b00000000;
   reg [Nbits_8-1:0]   BSL_VAL_g10_2 = 8'b00000000;
   reg [Nbits_12-1:0]  SATURATION_value_2 = 12'b111111111111;
   
   wire 	       losing_data;
   reg [Nbits_32-1:0]  word;

   wire 	       totalError;

   wire 	       losing_data_2;

   reg [Nbits_32-1:0]  word_2;

   wire 	       totalError_2;

   wire 	       CALIBRATION_BUSY;

   assign CALIBRATION_BUSY = CALIBRATION_BUSY_1 | CALIBRATION_BUSY_10;
   assign CALIBRATION_BUSY_2 = CALIBRATION_BUSY_1_2 | CALIBRATION_BUSY_10_2;

   wire 	       output_ser_0;
   wire 	       output_ser_1;
   wire 	       output_ser_2;
   wire 	       output_ser_3;
   reg 		       test_enable;

   wire 	       output_ser_0_2;
   wire 	       output_ser_1_2;
   wire 	       output_ser_2_2;
   wire 	       output_ser_3_2;
   reg 		       test_enable_2;


   //New Orbit Signal for Phase 2
   reg 		       Orbit;
   reg 		       fallback;
   reg                 flush;
   reg 		       synch;
   reg 		       synch_2;
   reg [31:0] 	       synch_pattern = 32'hcafecafe;
   
   reg [1:0] 	       shift_gain_10 = 2'b00;

   reg 		       fallback_2;
   reg [1:0] 	       shift_gain_10_2 = 2'b00;
   reg                 flush_2;

   //I2C    
   reg [1:0] 	       AdcOvf_in=2'b0;
   reg [1:0] 	       AdcSEU=2'b0;
   reg [1:0] 	       AdcOvf_in_2=2'b0;
   reg [1:0] 	       AdcSEU_2=2'b0;
   wire 	       DtuAdcSel;
   wire 	       DtuSysCal;
      wire 	       DtuAdcSel_2;
   wire 	       DtuSysCal_2;

   //SynchUnit
   wire 	       ReSync;
   reg [7:0] 	       input_sr;
   reg [3:0] 	       isr_in = 4'h0;
   wire [7:0] 	       isr_in_enc;
   reg 		       isr_load = 1'b0;


   wire 	       ReSync_2;
   reg [7:0] 	       input_sr_2;
   reg [3:0] 	       isr_in_2 = 4'h0;
   wire [7:0] 	       isr_in_enc_2;
   reg 		       isr_load_2 = 1'b0;

   
   assign DtuAdcSel = GAIN_SEL_MODE[0];
   assign DtuSysCal = GAIN_SEL_MODE[1];

   assign DtuAdcSel_2 = GAIN_SEL_MODE_2[0];
   assign DtuSysCal_2 = GAIN_SEL_MODE_2[1];
  


   
   /////////////1st module///////////////////////
   FileReader #(.infile("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g10_less.dat"),
		.ck_period(ck_period)
		) FR10  (
			 .clk(DCLK_10),
			 .rst(RST_A),
			 .CALIBRATION_BUSY({CALIBRATION_BUSY_1,CALIBRATION_BUSY_10}),
			 .DATA12(DATA12_g10),
			 .REJECTED(REJECTED_g10)
			 );

   FileReader #(.infile("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g01_less.dat"),
		.ck_period(ck_period)
		) FR01  (
			 .clk(DCLK_1),
			 .rst(RST_A),
			 .CALIBRATION_BUSY({CALIBRATION_BUSY_1,CALIBRATION_BUSY_10}),
			 .DATA12(DATA12_g01),
			 .REJECTED(REJECTED_g01)
			 );
   

   /////////////2nd module///////////////////////
   FileReader #(.infile("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g10_less.dat"),
		.ck_period(ck_period)
		) FR10_2  (
			   .clk(DCLK_10_2),
			   .rst(RST_A_2),
			   .CALIBRATION_BUSY({CALIBRATION_BUSY_1_2,CALIBRATION_BUSY_10_2}),
			   .DATA12(DATA12_g10_2),
			   .REJECTED(REJECTED_g10_2)
			   );

   FileReader #(.infile("/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/data_input/Ene2000GeV_DT_120bx_g01_less.dat"),
		.ck_period(ck_period)
		) FR01_2  (
			   .clk(DCLK_1_2),
			   .rst(RST_A_2),
			   .CALIBRATION_BUSY({CALIBRATION_BUSY_1_2,CALIBRATION_BUSY_10_2}),
			   .DATA12(DATA12_g01_2),
			   .REJECTED(REJECTED_g01_2)
			   );
   
   
   SerDecoder #(	     .outfile_SER(file_SER_name),	   
			     .outfile_sample(file_sample_name),	   
			     .outfile_datain_10(file_datain_10_name),
			     .outfile_datain_01(file_datain_01_name)
			     )  Decoder1 (
					  .clk_160(DCLK_1),
					  .clk_srl(clk_srl),
					  .rst(RST_A),
					  .CALIBRATION_BUSY(CALIBRATION_BUSY),
					  .DATA12_g10(DATA12_g10),
					  .DATA12_g01(DATA12_g01),
					  .test_enable(test_enable),
					  .output_ser_0(output_ser_0),
					  .output_ser_1(output_ser_1),
					  .output_ser_2(output_ser_2),
					  .output_ser_3(output_ser_3)
					  );


   
   SerDecoder #(	     .outfile_SER(file_SER_name_2),	   
			     .outfile_sample(file_sample_name_2),	   
			     .outfile_datain_10(file_datain_10_name_2),
			     .outfile_datain_01(file_datain_01_name_2)
			     )  Decoder2 (
					  .clk_160(DCLK_10_2),
					  .clk_srl(clk_srl),
					  .rst(RST_A_2),
					  .CALIBRATION_BUSY(CALIBRATION_BUSY_2),
					  .DATA12_g10(DATA12_g10_2),
					  .DATA12_g01(DATA12_g01_2),
					  .test_enable(test_enable_2),
					  .output_ser_0(output_ser_0_2),
					  .output_ser_1(output_ser_1_2),
					  .output_ser_2(output_ser_2_2),
					  .output_ser_3(output_ser_3_2)
					  );
   
   
   /////////////FIRST DTU////////////////////////////////////////////////////////////////
   top_ofthetop toptoplevel(
			    //input
			    .rstA_b(RST_A),.rstB_b(RST_B),.rstC_b(RST_C),
			    .AdcClkOut({DCLK_1,DCLK_10}),
			    .ClkInA(clk),.ClkInB(clk),.ClkInC(clk),
			    .CLK_SRL(clk_srl),
			    .AdcTestMode(test_enable),
			    .AdcDoutH(DATA12_g10),.AdcDoutL(DATA12_g01),
			    .AdcCalBusy_in({CALIBRATION_BUSY_1,CALIBRATION_BUSY_10}),
			    .AdcOvf_in(AdcOvf_in),
			    .AdcSEU(AdcSEU),
			    .fallback(fallback),
			    .flush(flush),
			    .synch(synch),
			    .synch_pattern(synch_pattern),
			    .shift_gain_10(shift_gain_10),
			    //I2C
			    .DtuAdcSel(DtuAdcSel),
			    .DtuSysCal(DtuSysCal),
			    .DtuBslineH(BSL_VAL_g10),.DtuBslineL(BSL_VAL_g01),
			    .DtuDivby2(shift_gain_10[0]),.DtuDivby4(shift_gain_10[1]),
			    .DtuSatValue(SATURATION_value),
			    .DtuSMPattern(),
			    .DtuTPLength(),
      
			    //output
			    .AdcRstA_b(),.AdcRstB_b(),.AdcRstC_b(),
			    .AdcCalInA(),.AdcCalInB(),.AdcCalInC(),
			    .AdcCalBusy(),
			    .AdcOverflow(),
			    .PllLockStartA(),.PllLockStartB(),.PllLockStartC(),
			    .CatiaTPA(),.CatiaTPB(),.CatiaTPC(),
			    .SerRstA_b(),.SerRstB_b(),.SerRstC_b(),
			    .TUdoutHo(),.TUdoutHe(),.TUdoutLo(),.TUdoutLe(),
			    .DtuHshake(),
      
			    //I2C
			    .DtuLoss(losing_data),
			    .I2cRstA_b(), .I2cRstB_b(), .I2cRstC_b(),

			    // SEU detection signals

			    .SEUA(),      // SEU on the ADC logic
			    .SEUD(),      // SEU on the digital logic
			    //Serializers
			    .output_ser_0(output_ser_0), .output_ser_1(output_ser_1),
			    .output_ser_2(output_ser_2), .output_ser_3(output_ser_3),
                            .ReSync(ReSync));




   /////////////SECOND DTU////////////////////////////////////////////////////////////////
     top_ofthetop toptoplevel_2(
				//input
				.rstA_b(RST_A_2),.rstB_b(RST_B_2),.rstC_b(RST_C_2),
				.AdcClkOut({DCLK_1_2,DCLK_10_2}),
				.ClkInA(clk),.ClkInB(clk),.ClkInC(clk),
				.CLK_SRL(clk_srl),
				.AdcTestMode(test_enable_2),
				.AdcDoutH(DATA12_g10_2),.AdcDoutL(DATA12_g01_2),
				.AdcCalBusy_in({CALIBRATION_BUSY_1_2,CALIBRATION_BUSY_10_2}),
				.AdcOvf_in(AdcOvf_in_2),
				.AdcSEU(AdcSEU_2),
				.fallback(fallback_2),
				.flush(flush_2),
				.synch(synch_2),
				.synch_pattern(synch_pattern),
				.shift_gain_10(shift_gain_10_2),
				//I2C
				.DtuAdcSel(DtuAdcSel_2),
				.DtuSysCal(DtuSysCal_2),
				.DtuBslineH(BSL_VAL_g10_2),.DtuBslineL(BSL_VAL_g01_2),
				.DtuDivby2(shift_gain_10_2[0]),.DtuDivby4(shift_gain_10_2[1]),
				.DtuSatValue(SATURATION_value_2),
				.DtuSMPattern(),
				.DtuTPLength(),
     
				//output
				.AdcRstA_b(),.AdcRstB_b(),.AdcRstC_b(),
				.AdcCalInA(),.AdcCalInB(),.AdcCalInC(),
				.AdcCalBusy(),
				.AdcOverflow(),
				.PllLockStartA(),.PllLockStartB(),.PllLockStartC(),
				.CatiaTPA(),.CatiaTPB(),.CatiaTPC(),
				.SerRstA_b(),.SerRstB_b(),.SerRstC_b(),
				.TUdoutHo(),.TUdoutHe(),.TUdoutLo(),.TUdoutLe(),
				.DtuHshake(),
     
				//I2C
				.DtuLoss(losing_data_2),
				.I2cRstA_b(), .I2cRstB_b(), .I2cRstC_b(),

				// SEU detection signals

				.SEUA(),      // SEU on the ADC logic
				.SEUD(),      // SEU on the digital logic
				//Serializers
				.output_ser_0(output_ser_0_2), .output_ser_1(output_ser_1_2),
				.output_ser_2(output_ser_2_2), .output_ser_3(output_ser_3_2),
				.ReSync(ReSync_2));


//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
   // clk generation for ADCs
   initial begin
      DCLK_1 = 1'b1;
//      #(0.00155*ck_period)
      forever begin
	 #(ck_period/2);
	 DCLK_1 = ~DCLK_1;
      end
   end

   // clk generation
   initial begin
      DCLK_10 = 1'b1;
  //    #(0.00155*ck_period)
      forever begin
	 #(ck_period/2);
	 DCLK_10 = ~DCLK_10;
      end
   end

   
   // clk generation for ADC 2
   initial begin
      DCLK_1_2 = 1'b1;
     // #(0.00155*ck_period)
      forever begin
	 #(ck_period/2);
	 DCLK_1_2 = ~DCLK_1_2;
      end
   end

   // clk generation
   initial begin
      DCLK_10_2 = 1'b1;
      //#(0.00155*ck_period)
      forever begin
	 #(ck_period/2);
	 DCLK_10_2 = ~DCLK_10_2;
      end
   end

   // clk generation
   initial begin
      clk = 1'b1;
      forever begin
	 #(ck_period/2);
	 clk = ~clk;
      end
   end

   // clk_srl generation
   initial begin
      clk_srl = 1'b1;
      forever begin
	 #(ck_srl_period/2);
	 clk_srl = ~clk_srl;
      end
   end

   /////////////////////////////////////////////////////
   /////////////////////////////////////////////////////
   //Orbit signal generation
   initial begin
      Orbit = 1'b0;
      #(196*ck_period); 
      Orbit = 1'b1;
      #(4*ck_period); 
      Orbit = 1'b0;
      
      forever begin
	 #(14240*ck_period); //89us
	 Orbit = 1'b1;
	 #(4*ck_period);
	 Orbit = 1'b0;
      end
   end // initial begin
   
   ////ORBIT FROM SYNCH UNIT
   always @(posedge clk) begin
      if(Orbit==1'b1) begin
	 $display("Orbit seen");
	 isr_in = 1;
	 isr_in_2 = 1;
	 // Start
	 isr_load = 1'b1;
	 isr_load_2 = 1'b1;
	 #ck_period;
	 isr_load = 1'b0;
	 isr_load_2 = 1'b0;
	 #(7*ck_period);
	 isr_in = 1;
	 isr_in_2 = 1;
	 // Start
	 isr_load = 1'b1;
	 isr_load_2 = 1'b1;
	 #ck_period;
	 isr_load = 1'b0;
	 isr_load_2 = 1'b0;
	 #(7*ck_period)
	 isr_in = 14;
	 isr_in_2 = 14;
	 // BC0 marker
	 isr_load = 1'b1;
	 isr_load_2 = 1'b1;
	 #ck_period;
	 isr_load = 1'b0;
	 isr_load_2 = 1'b0;
	 #(7*ck_period);
	 isr_in = 0;
	 isr_in_2 = 0;
	 // Stop
	 isr_load = 1'b1;
	 isr_load_2 = 1'b1;
	 #ck_period;
	 isr_load = 1'b0;
	 isr_load_2 = 1'b0;
	 	 
      end // if (Orbit==1'b1)
   end // always @ posedge(clk)

   // Hamming encoding

   assign isr_in_enc[0] = isr_in[0] ^ isr_in[1] ^ isr_in[3];
   assign isr_in_enc[1] = isr_in[0] ^ isr_in[2] ^ isr_in[3];
   assign isr_in_enc[2] = isr_in[0];
   assign isr_in_enc[3] = isr_in[1] ^ isr_in[2] ^ isr_in[3] ;
   assign isr_in_enc[6:4] = isr_in[3:1];
   assign isr_in_enc[7] = 1'b0;

   assign isr_in_enc_2[0] = isr_in_2[0] ^ isr_in_2[1] ^ isr_in_2[3];
   assign isr_in_enc_2[1] = isr_in_2[0] ^ isr_in_2[2] ^ isr_in_2[3];
   assign isr_in_enc_2[2] = isr_in_2[0];
   assign isr_in_enc_2[3] = isr_in_2[1] ^ isr_in_2[2] ^ isr_in_2[3] ;
   assign isr_in_enc_2[6:4] = isr_in_2[3:1];
   assign isr_in_enc_2[7] = 1'b0;

   // Input shift register for Synch Unit

   always @(posedge clk) begin
      if (RST_A == 0)
	input_sr = 1'b0;

      else if (isr_load == 1)
	input_sr = isr_in_enc;

      else
	input_sr = {input_sr[6:0],1'b0};

   end // always @ (posedge clock)

   assign ReSync = input_sr[7];

   always @(posedge clk) begin
      if (RST_A_2 == 0)
	input_sr_2 = 1'b0;

      else if (isr_load_2 == 1)
	input_sr_2 = isr_in_enc_2;

      else
	input_sr_2 = {input_sr_2[6:0],1'b0};

   end // always @ (posedge clock)

   assign ReSync_2 = input_sr_2[7];
   


   // Main testbench
   initial begin

      $display("***********************STARTING SIMULATION -%g",$time);
      
      RST_A   = 1'b1;
      RST_B   = 1'b1;
      RST_C   = 1'b1;
      flush =1'b1;
      synch =1'b0;
      fallback=1'b0;
      
      CALIBRATION_BUSY_1 = 1'b0;
      CALIBRATION_BUSY_10 = 1'b0;

      test_enable   = 1'b0;    	// DTU_test_mode
      GAIN_SEL_MODE = 2'b00;		// Auto-gain selection

      RST_A_2   = 1'b1;
      RST_B_2   = 1'b1;
      RST_C_2   = 1'b1;
      flush_2 =1'b1;
      synch_2 =1'b0;
      fallback_2=1'b0;
      
      CALIBRATION_BUSY_1_2 = 1'b0;
      CALIBRATION_BUSY_10_2= 1'b0;
      test_enable_2   = 1'b0;    	// DTU_test_mode
      GAIN_SEL_MODE_2 = 2'b01;		// Auto-gain selection


      //  isr_in = 4'h0;
      //  isr_load = 1'b0;
      
      #(1*ck_period);	// --------------- system reset
      $display("***********************POWER ON RESET - %g",$time);
      RST_A = 1'b0;
      RST_B = 1'b0;
      RST_C = 1'b0;
      
      RST_A_2 = 1'b0;
      RST_B_2 = 1'b0;
      RST_C_2 = 1'b0;

      #(2*ck_period);
      $display("***********************POWER OFF RESET - %g",$time);
      RST_A   = 1'b1;		// --------------- system active
      RST_B   = 1'b1;
      RST_C   = 1'b1;
      RST_A_2   = 1'b1;		
      RST_B_2   = 1'b1;
      RST_C_2   = 1'b1;

      // DTU reset
      #(2*ck_period);
      $display("***********************DTU RESET FROM SynchU - %g",$time);
      isr_in = 1;
      isr_in_2 = 1;
      // Start
      isr_load = 1'b1;
      isr_load_2 = 1'b1;

      #ck_period;

      isr_load = 1'b0;
      isr_load_2 = 1'b0;

      #(7*ck_period);

      isr_in = 2;
      isr_in_2 = 2;
      // DTU reset
      isr_load = 1'b1;
      isr_load_2 = 1'b1;

      #ck_period;

      isr_load = 1'b0;
      isr_load_2 = 1'b0;

      #(7*ck_period);

      isr_in = 6;
      isr_in_2 = 6;
      // Normal mode
      isr_load = 1'b1;
      isr_load_2 = 1'b1;

      #ck_period;

      isr_load = 1'b0;
      isr_load_2 = 1'b0;
      #(7*ck_period);

      isr_in = 0;
      isr_in_2 = 0;
      // Stop
      isr_load = 1'b1;
      isr_load_2 = 1'b1;

      #ck_period;

      isr_load = 1'b0;
      isr_load_2 = 1'b0;

      
      $display("***********************CALIBRATION ON - %g",$time);      
      #(5*ck_period);			
      CALIBRATION_BUSY_1 <= 1'b1;	// --------------- calibration starts here ADC_L
      CALIBRATION_BUSY_1_2 = 1'b1;
      #(1*ck_period);	
      CALIBRATION_BUSY_10 <= 1'b1;	// --------------- calibration starts here ADC_H
      CALIBRATION_BUSY_10_2= 1'b1; 
      #(26*ck_period);
      $display("***********************CALIBRATION OFF - %g",$time);      
      CALIBRATION_BUSY_1 <= 1'b0;	// --------------- end of calibration ADC_L
      CALIBRATION_BUSY_10 <= 1'b0;	// --------------- end of calibration ADC_H     
      #(0.014*ck_period);
      CALIBRATION_BUSY_1_2 <= 1'b0;	// --------------- end of calibration ADC_L
      CALIBRATION_BUSY_10_2 <= 1'b0;	// --------------- end of calibration ADC_H

      $display("***********************TEST MODE ON- %g",$time);      
      test_enable = 1'b1;
      test_enable_2 = 1'b1;

      #(3000*ck_period);
      $display("***********************TEST MODE OFF (DTU MODE ON) - %g",$time); 
      test_enable = 1'b0;
      test_enable_2 = 1'b0;
      #(10000*ck_period);
      $display("***********************FLUSH DTU0 - %g",$time); 
      flush = 1'b1;
      #(24*ck_period);
      flush = 1'b0;

      #(10000*ck_period);
      $display("***********************SYNCH - %g",$time); 
      synch=1'b1;
      
      //////////////////////////////////////////
      /////////////////////////////////////////
      //#(2.4*ck_period);
      #(2000*ck_period);
      RST_A_2   = 1'b1;		// --------------- system active
      RST_B_2   = 1'b1;
      RST_C_2   = 1'b1;
      
      #(100*ck_period);
      
      RST_A_2   = 1'b1;
      RST_B_2   = 1'b1;
      RST_C_2   = 1'b1;
      
      // DTU reset
      
      isr_in_2 = 1;
      // Start
      isr_load_2 = 1'b1;
      
      #ck_period;
      
      isr_load_2 = 1'b0;
      
      #(7*ck_period);
      
      isr_in_2 = 2;
      // DTU reset
      isr_load_2= 1'b1;
      
      #ck_period;
      
      isr_load_2 = 1'b0;
      
      #(7*ck_period);
      
      isr_in_2 = 6;
      // Normal mode
      isr_load_2 = 1'b1;
      
      #ck_period;
      
      isr_load_2 = 1'b0;
      
      #(7*ck_period);
      
      isr_in_2 = 0;
      // Stop
      isr_load_2 = 1'b1;
      
      #ck_period;
      
      isr_load_2 = 1'b0;


      
   end // initial begin
   


endmodule
