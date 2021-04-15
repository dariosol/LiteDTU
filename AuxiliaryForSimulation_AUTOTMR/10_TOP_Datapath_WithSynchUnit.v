
`timescale  1ps/1ps

module top_ofthetop (
		     rstA_b, 
		     rstB_b, 
		     rstC_b, 
		     AdcClkOut, 
		     ClkInA,
		     ClkInB,
		     ClkInC,
                     AdcTestMode,
		     AdcDoutH,
		     AdcDoutL,
		     AdcCalBusy_in,
		     AdcOvf_in,
		     AdcSEU,

		     AdcRstA_b,
		     AdcRstB_b,
		     AdcRstC_b,
		     AdcCalInA,       // ADC calibration mode input
		     AdcCalInB,
		     AdcCalInC,
		     AdcCalBusy,         // ADC calibration busy output
		     AdcOverflow,           // ADC overflow


		     // PLL interface

		     PllLockStartA,
		     PllLockStartB,
		     PllLockStartC,

		     // CATIA interface

		     CatiaTPA,          // Test pulse
		     CatiaTPB,
		     CatiaTPC,

		     // Serializers interface

		     SerRstA_b,
		     SerRstB_b,
		     SerRstC_b,
		     //            DtuDataOut,
		     TUdoutHo,
		     TUdoutHe,
		     TUdoutLo,
		     TUdoutLe,
		     //            DtuDecode, 
		     DtuHshake,
		     //            SerTmrErr,

		     // I2C interface

		     //                AdcExtCalEn,
		     DtuAdcSel,
		     DtuSysCal,
		     DtuBslineH,
		     DtuBslineL,
		     DtuDivby2,
		     DtuDivby4,
		     DtuSatValue,
		     DtuSMPattern,
		     DtuTPLength,
		     DtuLoss,
		     I2cRstA_b,
		     I2cRstB_b,
		     I2cRstC_b,

		     // SEU detection signals

		     SEUA,      // SEU on the ADC logic
		     SEUD,      // SEU on the digital logic


		     fallback,
		     flush,
		     synch,
		     synch_pattern,
		     shift_gain_10,          
		     CLK_SRL,
		     output_ser_0,
		     output_ser_1,
		     output_ser_2,
		     output_ser_3,
		     //SynchUnit
		     ReSync
		     );

   // Internal constants
   parameter Nbits_8    = 8;
   parameter Nbits_12    = 12;
   parameter Nbits_32    = 32;
   parameter FifoDepth = 8;
   parameter NBitsCnt    = 4;
   parameter crcBits = 12;
   parameter FifoDepth_buff = 16;
   parameter bits_ptr = 4;
   parameter Nbits_5=5;

   // Input ports
   input rstA_b;
   input rstB_b;
   input rstC_b;   
   input [1:0] AdcClkOut;
   
   input       ClkInA;                
   input       ClkInB;              
   input       ClkInC;
   
   input       CLK_SRL;
   input       AdcTestMode;

   input [11:0] AdcDoutH;   
   input [11:0] AdcDoutL;
   input [1:0] 	AdcCalBusy_in;
   input [1:0] 	AdcOvf_in;
   
   input [1:0] 	AdcSEU;
   
   output [1:0] AdcRstA_b;
   output [1:0] AdcRstB_b;
   output [1:0] AdcRstC_b;
   output [1:0] AdcCalInA;       // ADC calibration mode input
   output [1:0] AdcCalInB;
   output [1:0] AdcCalInC;
   output 	AdcCalBusy;         // ADC calibration busy output
   output 	AdcOverflow;         // ADC overflow

   
   input 	fallback;
   input        flush;
   input 	synch;
   input [31:0]	synch_pattern;
   input [1:0] 	shift_gain_10;
   // PLL interface

   output 	PllLockStartA;
   output 	PllLockStartB;
   output 	PllLockStartC;

   // CATIA interface

   output 	CatiaTPA;          // Test pulse
   output 	CatiaTPB;
   output 	CatiaTPC;

   // Serializers interface

   output 	SerRstA_b;
   output 	SerRstB_b;
   output 	SerRstC_b;
   output [31:0] TUdoutHo;
   output [31:0] TUdoutHe;
   output [31:0] TUdoutLo;
   output [31:0] TUdoutLe;
   output 	 DtuHshake; //mod

   // I2C interface

   input 	 DtuAdcSel;
   input 	 DtuSysCal;
   input [7:0] 	 DtuBslineH;
   input [7:0] 	 DtuBslineL;
   input 	 DtuDivby2;
   input 	 DtuDivby4;
   input [11:0]  DtuSatValue;
   input [31:0]  DtuSMPattern;
   input [7:0] 	 DtuTPLength;
   output 	 DtuLoss;
   output 	 I2cRstA_b;
   output 	 I2cRstB_b;
   output 	 I2cRstC_b;

   // SEU detection signals

   output 	 SEUA;      // SEU on the ADC logic
   output 	 SEUD;      // SEU on the digital logic
   output 	 output_ser_0;
   output 	 output_ser_1;
   output 	 output_ser_2;
   output 	 output_ser_3;
   // DTU internal signals

   wire 	 DtuRstA_b, DtuRstB_b, DtuRstC_b;

   // SyncUnit signals
   input 	 ReSync;

   
   wire 	 DtuSyncModeA;
   wire 	 DtuSyncModeB;
   wire 	 DtuSyncModeC;

   wire 	 DtuFlushA;
   wire 	 DtuFlushB;
   wire 	 DtuFlushC;

   wire 	 BC0markA;          // BC0 marker
   wire 	 BC0markB;
   wire 	 BC0markC;

   wire 	 ExtCalEn;
   wire [1:0] 	 TmrErr;

   // AdcTestUnit internal signals

   wire 	 TUrstA_b;
   wire 	 TUrstB_b;
   wire 	 TUrstC_b;

   wire [31:0] 	 int_TUdoutHe;
   wire [31:0] 	 int_TUdoutHo;
   wire [31:0] 	 int_TUdoutLe;
   wire [31:0] 	 int_TUdoutLo;


   wire [31 : 0] DTU_TUdoutHo;
   wire [31 : 0] DTU_TUdoutHe;
   wire [31 : 0] DTU_TUdoutLo;
   wire [31 : 0] DTU_TUdoutLe;

   
   assign SerRstA_b = DtuRstA_b;
   assign SerRstB_b = DtuRstB_b;
   assign SerRstC_b = DtuRstC_b;

   assign TUdoutHo = DTU_TUdoutHo;
   assign TUdoutHe = DTU_TUdoutHe;
   assign TUdoutLo = DTU_TUdoutLo;
   assign TUdoutLe = DTU_TUdoutLe;
   
   wire 	 Orbit=1'b0;
   
   LiTE_DTU_160MHz_v2_0TMR top_level_LiTE_DTU (.DCLK_1(AdcClkOut[0]), .DCLK_10(AdcClkOut[1]), 
					       .CLKA(ClkInA), .CLKB(ClkInB), .CLKC(ClkInC), 
					       .RSTA(DtuRstA_b),  .RSTB(DtuRstB_b), .RSTC(DtuRstC_b), 
					       .CALIBRATION_BUSY_1(AdcCalBusy_in[0]), .CALIBRATION_BUSY_10(AdcCalBusy_in[1]), 
					       .TEST_ENABLE(AdcTestMode), .GAIN_SEL_MODE({DtuSysCal,DtuAdcSel}), .fallback(fallback), 
					       .flushA(flush), .flushB(flush), .flushC(flush), 
					       .synchA(synch), .synchB(synch),.synchC(synch), .synch_pattern(synch_pattern),
					       .DATA12_g01(AdcDoutL), 
					       .DATA12_g10(AdcDoutH), .SATURATION_value(DtuSatValue), .BSL_VAL_g01(DtuBslineL), 
					       .BSL_VAL_g10(DtuBslineH), .OrbitA(BC0markA), .OrbitB(BC0markB), .OrbitC(BC0markC), .shift_gain_10(shift_gain_10), .losing_data(DtuLoss), .totalError(TmrErr[0]), 
					       .DATA32_ATU_0(int_TUdoutHo), .DATA32_ATU_1(int_TUdoutHe), 
					       .DATA32_ATU_2(int_TUdoutLo), .DATA32_ATU_3(int_TUdoutLe), 
					       .DATA32_0(DTU_TUdoutHo), .DATA32_1(DTU_TUdoutHe), 
					       .DATA32_2(DTU_TUdoutLo), .DATA32_3(DTU_TUdoutLe), .handshake(DtuHshake));



   LDTUv1b_serTMR Serializers( .rst_bA(SerRstA_b), .rst_bB(SerRstB_b), .rst_bC(SerRstC_b), .clock(CLK_SRL),
			       .DataIn0(DTU_TUdoutHo),.DataIn1(DTU_TUdoutHe),.DataIn2(DTU_TUdoutLo),.DataIn3(DTU_TUdoutLe),
			       .handshake(DtuHshake), .DataOut0(output_ser_0), .DataOut1(output_ser_1), 
			       .DataOut2(output_ser_2), .DataOut3(output_ser_3));




   AdcTestUnitTMR TestUnit (//WARNING: reset should be TUrstA_b
			    .rst_bA(rstA_b), .rst_bB(rstB_b), .rst_bC(rstC_b),
			    .clockA(ClkInA),.clockB(ClkInB),.clockC(ClkInC),
			    .test_enable(AdcTestMode),
			    .DataInH(AdcDoutH),    .DataInL(AdcDoutL),
			    .DataOutHo(int_TUdoutHo),    .DataOutHe(int_TUdoutHe),
			    .DataOutLo(int_TUdoutLo),    .DataOutLe(int_TUdoutLe),
			    .tmrError(TmrErr[1]),    .tmrErrorA(),
			    .tmrErrorB(),    .tmrErrorC());
   


   SyncUnit_v2TMR SyncUnit (
			    .rst_bA(rstA_b),                  .rst_bB(rstB_b),               .rst_bC(rstC_b),
			    .clockA(ClkInA),                  .clockB(ClkInB),               .clockC(ClkInC),
			    .serial_inA(ReSync),              .serial_inB(ReSync),           .serial_inC(ReSync),
			    .AdcRst_bA(AdcRstA_b),            .AdcRst_bB(AdcRstB_b),         .AdcRst_bC(AdcRstC_b),
			    .AdcCalA(AdcCalInA),              .AdcCalB(AdcCalInB),           .AdcCalC(AdcCalInC),
			    .DtuRst_bA(DtuRstA_b),            .DtuRst_bB(DtuRstB_b),         .DtuRst_bC(DtuRstC_b),
			    .i2cRst_bA(I2cRstA_b),            .i2cRst_bB(I2cRstB_b),         .i2cRst_bC(I2cRstC_b),
			    .atuRst_bA(TUrstA_b),             .atuRst_bB(TUrstB_b),          .atuRst_bC(TUrstC_b),
			    .DtuSyncModeA(DtuSyncModeA),      .DtuSyncModeB(DtuSyncModeB),   .DtuSyncModeC(DtuSyncModeC),
			    .DtuFlushA(DtuFlushA),            .DtuFlushB(DtuFlushB),         .DtuFlushC(DtuFlushC),
			    .PllLockStartA(PllLockStartA),    .PllLockStartB(PllLockStartB), .PllLockStartC(PllLockStartC),
			    .CatiaTPA(CatiaTPA),              .CatiaTPB(CatiaTPB),           .CatiaTPC(CatiaTPC),
			    .BC0markA(BC0markA),              .BC0markB(BC0markB),           .BC0markC(BC0markC),
			    .TP_len(DtuTPLength),
			    .AdcCalBusyIn(AdcCalBusy_in),      .AdcOvfIn(AdcOvf_in),          .AdcSeuIn(AdcSEU),
			    .AdcCalBusyOut(AdcCalBusy),        .AdcOvfOut(AdcOverflow),       .AdcSeuOut(SEUA),
			    .TmrErrIn(TmrErr),                 .TmrErrOut(SEUD));

endmodule
