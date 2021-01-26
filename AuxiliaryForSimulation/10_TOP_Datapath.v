
`timescale  1ns/1ps

module top_ofthetop (
		     DCLK_1, 
		     DCLK_10,
		     CLK,
		     RST_A, 
		     RST_B, 
		     RST_C, 
		     CALIBRATION_BUSY_1, 
		     CALIBRATION_BUSY_10, 
		     TEST_ENABLE, 
		     GAIN_SEL_MODE, 
		     DATA12_g01, 
		     DATA12_g10, 
		     SATURATION_value,
		     BSL_VAL_g01, 
		     BSL_VAL_g10,
		     Orbit,//for v2.0	     
		     losing_data, 
		     totalError, 
		     handshake,
		     CLK_SRL,
		     output_ser_0,
		     output_ser_1,
		     output_ser_2,
		     output_ser_3,
		     Resynch);

   // Internal constants
   parameter Nbits_8 	= 8;
   parameter Nbits_12 	= 12;
   parameter Nbits_32 	= 32;
   parameter FifoDepth = 8;
   parameter NBitsCnt 	= 3;
   parameter crcBits = 12;
   parameter FifoDepth_buff = 16;
   parameter bits_ptr = 4;
   parameter    Nbits_5=5;

   // Input ports
   input DCLK_1;
   input DCLK_10;
   input CLK;
   input CLK_SRL;
   input RST_A;
   input RST_B;
   input RST_C;
   input CALIBRATION_BUSY_1;
   input CALIBRATION_BUSY_10;
   input TEST_ENABLE;
   input [1:0] GAIN_SEL_MODE;
   input [Nbits_12-1:0] DATA12_g01;
   input [Nbits_12-1:0] DATA12_g10;
   input [Nbits_12-1:0] SATURATION_value;
   input [Nbits_8-1:0] 	BSL_VAL_g01;
   input [Nbits_8-1:0] 	BSL_VAL_g10;
   input 		Orbit;
   
   // Output ports
   output 		losing_data;
   output 		handshake;
   output 		totalError;
   output 		output_ser_0;
   output 		output_ser_1;
   output 		output_ser_2;
   output 		output_ser_3;
   wire [Nbits_32-1:0] 	DATA32_ATU_0;
   wire [Nbits_32-1:0] 	DATA32_ATU_1;
   wire [Nbits_32-1:0] 	DATA32_ATU_2;
   wire [Nbits_32-1:0] 	DATA32_ATU_3;
   wire [Nbits_32-1:0] 	DATA32_0;
   wire [Nbits_32-1:0] 	DATA32_1;
   wire [Nbits_32-1:0] 	DATA32_2;
   wire [Nbits_32-1:0] 	DATA32_3;


   //SynchUnit signals:
   input 		ReSync;
   input [7:0] 		TP_len;
   
   input [1:0] 		AdcOvfIn;
   input [1:0] 		AdcSeuIn; 
   input [4:0] 		TmrErrIn;
  
   wire [1:0] 		AdcCalBusyIn;

   assign AdcCAlBusyIn = CALIBRATION_BUSY_10&CALIBRATION_BUSY_1;
   
   
   SyncUnit_v2TMR SyncUnit (
			    .rst_bA(RST_A), 			.rst_bB(RST_B), 		.rst_bC(RST_C),
			    .clockA(CLK), 			.clockB(CLK), 		        .clockC(CLK),
			    .serial_inA(ReSync), 		.serial_inB(ReSync), 		.serial_inC(),
			    .AdcRst_bA(), 			.AdcRst_bB(), 			.AdcRst_bC(),
			    .AdcCalA(), 			.AdcCalB(), 			.AdcCalC(),
			    .DtuRst_bA(), 			.DtuRst_bB(), 			.DtuRst_bC(),
			    .i2cRst_bA(), 			.i2cRst_bB(), 			.i2cRst_bC(),
			    .atuRst_bA(), 			.atuRst_bB(), 			.atuRst_bC(),
			    .DtuSyncModeA(),    	        .DtuSyncModeB(),        	.DtuSyncModeC(),
			    .DtuFlushA(), 			.DtuFlushB(), 			.DtuFlushC(),
			    .PllLockStartA(),      	        .PllLockStartB(),             	.PllLockStartC(),
			    .CatiaTPA(), 			.CatiaTPB(), 			.CatiaTPC(),
			    .BC0markA(), 			.BC0markB(), 			.BC0markC(),
			    .TP_len(),
			    .AdcCalBusyIn(AdcCalBusyIn),        .AdcOvfIn(AdcOvfIn), 		        .AdcSeuIn(AdcSeuIn),
			    .AdcCalBusyOut(), 	        .AdcOvfOut(), 	        .AdcSeuOut(),
			    .TmrErrIn(TmrErrIn), 				.TmrErrOut());

   
   LiTE_DTU_160MHz_v1_2 top_level_LiTE_DTU (.DCLK_1(DCLK_1), .DCLK_10(DCLK_10), 
					    .CLK_A(CLK), .CLK_B(CLK), .CLK_C(CLK), .RST_A(RST_A),  .RST_B(RST_B), .RST_C(RST_C), 
					    .CALIBRATION_BUSY_1(CALIBRATION_BUSY_1), .CALIBRATION_BUSY_10(CALIBRATION_BUSY_10), 
					    .TEST_ENABLE(TEST_ENABLE), .GAIN_SEL_MODE(GAIN_SEL_MODE), .DATA12_g01(DATA12_g01), 
					    .DATA12_g10(DATA12_g10), .SATURATION_value(SATURATION_value), .BSL_VAL_g01(BSL_VAL_g01), 
					    .BSL_VAL_g10(BSL_VAL_g10), .Orbit(Orbit), .losing_data(losing_data), .totalError(totalError), 
					    .DATA32_ATU_0(DATA32_ATU_0), .DATA32_ATU_1(DATA32_ATU_1), 
					    .DATA32_ATU_2(DATA32_ATU_2), .DATA32_ATU_3(DATA32_ATU_3), 
					    .DATA32_0(DATA32_0), .DATA32_1(DATA32_1), 
					    .DATA32_2(DATA32_2), .DATA32_3(DATA32_3), .handshake(handshake));
   //.decode_signal(decode_signal), 


   /*Serializers_LiTE_DTU_v1_2_TMR top_level_SER_TMRG (.CLK_SRL(CLK_SRL), 
    .RST_A(RST_A),  .RST_B(RST_B), .RST_C(RST_C), 
    .CALIBRATION_BUSY_1(CALIBRATION_BUSY_1), .CALIBRATION_BUSY_10(CALIBRATION_BUSY_10), 
    .TEST_ENABLE(TEST_ENABLE),
    .DATA32_0(DATA32_0), .DATA32_1(DATA32_1), 
    .DATA32_2(DATA32_2), .DATA32_3(DATA32_3), 
    .decode_signal(decode_signal), .output_ser_0(output_ser_0), 
    .output_ser_1(output_ser_1), .output_ser_2(output_ser_2), .output_ser_3(output_ser_3), 
    .handshake(handshake));*/
   LDTUv1b_serTMR Serializers( .rst_bA(RST_A), .rst_bB(RST_B), .rst_bC(RST_C), .clock(CLK_SRL),
			       .DataIn0(DATA32_0),.DataIn1(DATA32_1),.DataIn2(DATA32_2),.DataIn3(DATA32_3),
			       .handshake(handshake), .DataOut0(output_ser_0), .DataOut1(output_ser_1), 
			       .DataOut2(output_ser_2), .DataOut3(output_ser_3));

   AdcTestUnitTMR tadc_test_unit (.rst_bA(RST_A), .rst_bB(RST_B), .rst_bC(RST_C), 
				  .clockA(CLK), .clockB(CLK), .clockC(CLK), 
				  .test_enable(TEST_ENABLE), .DataInL(DATA12_g01), .DataInH(DATA12_g10), 
				  .DataOutHo(DATA32_ATU_0), .DataOutHe(DATA32_ATU_1), 
				  .DataOutLo(DATA32_ATU_2), .DataOutLe(DATA32_ATU_3),
				  .tmrError(TmrError_ADC), .tmrErrorA(ADC_AtmrError), .tmrErrorB(ADC_BtmrError), .tmrErrorC(ADC_CtmrError));

endmodule
