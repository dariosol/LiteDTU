// File>>> LDTUv1b_dp.v
//
// Date: Thu Nov 14 17:00:11 CET 2019
// Author: gianni
//
// Revision history:
//
// LiTE_DTU_v1b data path - 160 MHz logic
//

module LDTUv1b_dp (

		// External signals

	input rstA_b, 			// Reset for Sync Unit
	input rstB_b,
	input rstC_b,

	input  ReSync, 			// Resync input
	input  ClkInA, 			// Clock input
	input  ClkInB, 			// Clock input
	input  ClkInC, 			// Clock input

	input  AdcTestMode, 		// ADC Test Mode
	//input  AdcCalIn,              // ADC Calibration Input

		// ADC interface

	input[11:0] AdcDoutH,
	input[11:0] AdcDoutL,
	input[1:0] AdcClkOut,
	input[1:0] AdcCalBusy_in,
	input[1:0] AdcOvf_in,
	input[1:0] AdcSEU,

	output[1:0] AdcRstA_b,
	output[1:0] AdcRstB_b,
	output[1:0] AdcRstC_b,
	output[1:0] AdcCalInA, 		// ADC calibration mode input
	output[1:0] AdcCalInB,
	output[1:0] AdcCalInC,
	output AdcCalBusy,			// ADC calibration busy output
	output AdcOverflow,			// ADC overflow

		// Serializers interface

	output 		SerRstA_b,
	output 		SerRstB_b,
	output 		SerRstC_b,
	output[31:0] 	DtuDataOut,
	output[31:0] 	TUdoutHo,
	output[31:0] 	TUdoutHe,
	output[31:0] 	TUdoutLo,
	output[31:0] 	TUdoutLe,
	output 		DtuDecode, 
	input 		DtuHshake,
	input[4:0] 	SerTmrErr,

		// I2C interface

	//input           AdcExtCalEn,
	input 		DtuAdcSel,
	input 		DtuSysCal,
	input[7:0] 	DtuBslineH,
	input[7:0] 	DtuBslineL,
	input[11:0] 	DtuSatValue,
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

	wire 	ExtCalEn;
	wire[9:0] TmrErr;

		// AdcTestUnit internal signals

	wire 		TUrstA_b;
	wire 		TUrstB_b;
	wire 		TUrstC_b;


	LiTE_DTU_160MHz_v1_2 DTU (
			.DCLK_1(AdcClkOut[0]), 		.DCLK_10(AdcClkOut[1]),
			.CLK_A(ClkInA), 		.CLK_B(ClkInB), 			.CLK_C(ClkInC),
			.RST_A(DtuRstA_b), 		.RST_B(DtuRstB_b), 			.RST_C(DtuRstC_b), 
			.CALIBRATION_BUSY_1(AdcCalBusy_in[0]), 					.CALIBRATION_BUSY_10(AdcCalBusy_in[1]), 
			.TEST_ENABLE(AdcTestMode), 	.GAIN_SEL_MODE({DtuSysCal,DtuAdcSel}), 
			.DATA12_g01(AdcDoutL), 		.DATA12_g10(AdcDoutH), 			.SATURATION_value(DtuSatValue),
			.BSL_VAL_g01(DtuBslineL), 	.BSL_VAL_g10(DtuBslineH), 
			.losing_data(DtuLoss), 		.totalError(TmrErr[0]), 
			.DATA32_to_SERIALIZER(DtuDataOut), 
			.decode_signal(DtuDecode), 	.handshake(DtuHshake));


	assign SerRstA_b = DtuRstA_b;
	assign SerRstB_b = DtuRstB_b;
	assign SerRstC_b = DtuRstC_b;

	assign TmrErr[5:1] = SerTmrErr;

	SyncUnit_v1bTMR SyncUnit (
			.rst_bA(rstA_b), 		.rst_bB(rstB_b), 		.rst_bC(rstC_b),
			.clockA(ClkInA), 		.clockB(ClkInB), 		.clockC(ClkInC),
			.serial_inA(ReSync), 		.serial_inB(ReSync), 		.serial_inC(ReSync),
			.AdcRst_bA(AdcRstA_b), 		.AdcRst_bB(AdcRstB_b), 		.AdcRst_bC(AdcRstC_b),
			.AdcCalA(AdcCalInA), 		.AdcCalB(AdcCalInB), 		.AdcCalC(AdcCalInC),
			.DtuRst_bA(DtuRstA_b), 		.DtuRst_bB(DtuRstB_b), 		.DtuRst_bC(DtuRstC_b),
			.i2cRst_bA(I2cRstA_b), 		.i2cRst_bB(I2cRstB_b), 		.i2cRst_bC(I2cRstC_b),
			.atuRst_bA(TUrstA_b), 		.atuRst_bB(TUrstB_b), 		.atuRst_bC(TUrstC_b),
			.AdcCalBusyIn(AdcCalBusy_in), 	.AdcOvfIn(AdcOvf_in), 		.AdcSeuIn(AdcSEU),
			.AdcCalBusyOut(AdcCalBusy), 	.AdcOvfOut(AdcOverflow), 	.AdcSeuOut(SEUA),
			.TmrErrIn(TmrErr), 		.TmrErrOut(SEUD));

	AdcTestUnitTMR TestUnit (
			.rst_bA(TUrstA_b), 	.rst_bB(TUrstB_b), 	.rst_bC(TUrstC_b),
			.clockA(AdcClkOut[1]), 	.clockB(AdcClkOut[1]), 	.clockC(AdcClkOut[1]),
			.test_enable(AdcTestMode),
			.DataInH(AdcDoutH), 	.DataInL(AdcDoutL),
			.DataOutHo(TUdoutHo), 	.DataOutHe(TUdoutHe),
			.DataOutLo(TUdoutLo), 	.DataOutLe(TUdoutLe),
			.tmrError(TmrErr[6]), 	.tmrErrorA(TmrErr[7]),
			.tmrErrorB(TmrErr[8]), 	.tmrErrorC(TmrErr[9]));

endmodule

