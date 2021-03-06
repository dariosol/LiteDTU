// File>>> LDTUv2_dp.v
//
// Date: Thu Nov 14 17:00:11 CET 2019
// Author: gianni
//
// LiTE_DTU_v2 data path - 160 MHz logic
//
// Revision history:
//
// 16.09.2020 : DtuDecode signal removed
//				SerTmrErr signals removed, TmrErr becomes [4:0]
//				DtuDataOut bus removed
//  1.12.2020 : CATIA test pulse added
//				sync mode input registers added
//				CATIA test pulse length register added
//				PLL autolock command added
//				ADC_H divider inputs added
//	3.12.2020 : BC0 marker command added

module LDTUv2_dp (

		// External signals

	input rstA_b, 			// Reset for Sync Unit
	input rstB_b,
	input rstC_b,

	input  ReSync, 			// Resync input
	input  ClkInA, 			// Clock input
	input  ClkInB, 			// Clock input
	input  ClkInC, 			// Clock input

	input  AdcTestMode, 		// ADC Test Mode
	//input  AdcCalIn,        	// ADC Calibration Input

		// ADC interface

	input[11:0] AdcDoutH,
	input[11:0] AdcDoutL,
	input[1:0]  AdcClkOut,
	input[1:0]  AdcCalBusy_in,
	input[1:0]  AdcOvf_in,
	input[1:0]  AdcSEU,

	output[1:0] AdcRstA_b,
	output[1:0] AdcRstB_b,
	output[1:0] AdcRstC_b,
	output[1:0] AdcCalInA, 		// ADC calibration mode input
	output[1:0] AdcCalInB,
	output[1:0] AdcCalInC,
	output AdcCalBusy,			// ADC calibration busy output
	output AdcOverflow,			// ADC overflow

		// PLL interface

	output 	 PllLockStartA,
	output 	 PllLockStartB,
	output 	 PllLockStartC,

		// CATIA interface

	output CatiaTPA, 			// Test pulse
	output CatiaTPB,
	output CatiaTPC,

		// Serializers interface

	output 		SerRstA_b,
	output 		SerRstB_b,
	output 		SerRstC_b,
	// output[31:0] 	DtuDataOut,
	output[31:0] 	TUdoutHo,
	output[31:0] 	TUdoutHe,
	output[31:0] 	TUdoutLo,
	output[31:0] 	TUdoutLe,
	//output 		DtuDecode, 
	input 		DtuHshake,
	//input[4:0] 	SerTmrErr,

		// I2C interface

	//input           AdcExtCalEn,
	input 		DtuAdcSel,
	input 		DtuSysCal,
	input[7:0] 	DtuBslineH,
	input[7:0] 	DtuBslineL,
	input 		DtuDivby2,
	input 		DtuDivby4,
	input[11:0] DtuSatValue,
	input[31:0] DtuSMPattern,
	input[7:0] 	DtuTPLength,
	output 		DtuLoss,
	output 		I2cRstA_b,
	output 		I2cRstB_b,
	output 		I2cRstC_b,

		// SEU detection signals

	output 		SEUA,		// SEU on the ADC logic
	output 		SEUD);		// SEU on the digital logic

		// DTU internal signals

	wire 		DtuRstA_b, DtuRstB_b, DtuRstC_b;

		// SyncUnit signals

	wire 	DtuSyncModeA;
	wire 	DtuSyncModeB;
	wire 	DtuSyncModeC;

	wire 	DtuFlushA;
	wire 	DtuFlushB;
	wire 	DtuFlushC;

	wire 	BC0markA; 			// BC0 marker
	wire 	BC0markB;
	wire 	BC0markC;

	wire 	ExtCalEn;
	wire[4:0] TmrErr;

		// AdcTestUnit internal signals

	wire 		TUrstA_b;
	wire 		TUrstB_b;
	wire 		TUrstC_b;

	wire[31:0] 	int_TUdoutHe;
	wire[31:0] 	int_TUdoutHo;
	wire[31:0] 	int_TUdoutLe;
	wire[31:0] 	int_TUdoutLo;

		// Signals to be added to the DTU module
		//		Gianni 21.12.2020
		//
		// DtuSyncMode[A|B|C]   : DTU synchronization mode
		// DtuSMPattern 		: DTU pattern to be trasmitted in synch mode
		// BC0mark[A|B|C]		: BC0 marker
		// DtuDivby2			: divides by 2 the ADC_H output
		// DtuDivby4			: divides by 4 the ADC_H output
		// DtuFlush[A|B|C]		: flushes the output buffer


	LiTE_DTU_160MHz_v1_2 DTU (
			.DCLK_1(AdcClkOut[0]), 		.DCLK_10(AdcClkOut[1]),
			.CLK_A(ClkInA), 		.CLK_B(ClkInB), 			.CLK_C(ClkInC),
			.RST_A(DtuRstA_b), 		.RST_B(DtuRstB_b), 			.RST_C(DtuRstC_b), 
			.CALIBRATION_BUSY_1(AdcCalBusy_in[0]), 					
			.CALIBRATION_BUSY_10(AdcCalBusy_in[1]), 
			.TEST_ENABLE(AdcTestMode), 	.GAIN_SEL_MODE({DtuSysCal,DtuAdcSel}), 
			.DATA12_g01(AdcDoutL), 		.DATA12_g10(AdcDoutH), 			
			.SATURATION_value(DtuSatValue),
			.BSL_VAL_g01(DtuBslineL), 	.BSL_VAL_g10(DtuBslineH), 
			.losing_data(DtuLoss), 		.totalError(TmrErr[0]),
			.DATA32_ATU_0(int_TUdoutHo), 	.DATA32_ATU_1(int_TUdoutHe),
			.DATA32_ATU_2(int_TUdoutLo), 	.DATA32_ATU_3(int_TUdoutLe),
			.DATA32_0(TUdoutHo), 		.DATA32_1(TUdoutHe),
			.DATA32_2(TUdoutLo), 		.DATA32_3(TUdoutLe),
			.handshake(DtuHshake));


	assign SerRstA_b = DtuRstA_b;
	assign SerRstB_b = DtuRstB_b;
	assign SerRstC_b = DtuRstC_b;

	SyncUnit_v2TMR SyncUnit (
			.rst_bA(rstA_b), 				.rst_bB(rstB_b), 				.rst_bC(rstC_b),
			.clockA(ClkInA), 				.clockB(ClkInB), 				.clockC(ClkInC),
			.serial_inA(ReSync), 			.serial_inB(ReSync), 			.serial_inC(ReSync),
			.AdcRst_bA(AdcRstA_b), 			.AdcRst_bB(AdcRstB_b), 			.AdcRst_bC(AdcRstC_b),
			.AdcCalA(AdcCalInA), 			.AdcCalB(AdcCalInB), 			.AdcCalC(AdcCalInC),
			.DtuRst_bA(DtuRstA_b), 			.DtuRst_bB(DtuRstB_b), 			.DtuRst_bC(DtuRstC_b),
			.i2cRst_bA(I2cRstA_b), 			.i2cRst_bB(I2cRstB_b), 			.i2cRst_bC(I2cRstC_b),
			.atuRst_bA(TUrstA_b), 			.atuRst_bB(TUrstB_b), 			.atuRst_bC(TUrstC_b),
			.DtuSyncModeA(DtuSyncModeA), 	.DtuSyncModeB(DtuSyncModeB), 	.DtuSyncModeC(DtuSyncModeC),
			.DtuFlushA(DtuFlushA), 			.DtuFlushB(DtuFlushB), 			.DtuFlushC(DtuFlushC),
			.PllLockStartA(PllLockStartA), 	.PllLockStartB(PllLockStartB), 	.PllLockStartC(PllLockStartC),
			.CatiaTPA(CatiaTPA), 			.CatiaTPB(CatiaTPB), 			.CatiaTPC(CatiaTPC),
			.BC0markA(BC0markA), 			.BC0markB(BC0markB), 			.BC0markC(BC0markC),
			.TP_len(DtuTPLength),
			.AdcCalBusyIn(AdcCalBusy_in), 	.AdcOvfIn(AdcOvf_in), 		.AdcSeuIn(AdcSEU),
			.AdcCalBusyOut(AdcCalBusy), 	.AdcOvfOut(AdcOverflow), 	.AdcSeuOut(SEUA),
			.TmrErrIn(TmrErr), 				.TmrErrOut(SEUD));

	AdcTestUnitTMR TestUnit (
			.rst_bA(TUrstA_b), 	.rst_bB(TUrstB_b), 	.rst_bC(TUrstC_b),
			//.clockA(ClkInA), 		.clockB(ClkInB), 		.clockC(ClkInC),
			.AdcClk(AdcClkOut),
			.test_enable(AdcTestMode), 	.handshake(DtuHshake),
			.DataInH(AdcDoutH), 	.DataInL(AdcDoutL),
			.DataOutHo(int_TUdoutHo), 	.DataOutHe(int_TUdoutHe),
			.DataOutLo(int_TUdoutLo), 	.DataOutLe(int_TUdoutLe),
			.tmrError(TmrErr[1]), 	.tmrErrorA(TmrErr[2]),
			.tmrErrorB(TmrErr[3]), 	.tmrErrorC(TmrErr[4]));

endmodule

