// File>>> ADC_HL_v2.v
//
// Date: Thu Jan  7 16:35:00 CET 2021
// Author: gianni
//
// Revision history:
//
// LiTE_DTU_v2 two ADCs block 
//

module ADC_HL_v2 (

		// Supply and ground voltages
			
	inout VDDA, 			// Analogue VDD

	inout VDDref1H, 		// high gain ADC reference 1 VDD
	inout VDDref2H, 		// high gain ADC reference 2 VDD

	inout VDDref1L, 		// low gain ADC reference 1 VDD
	inout VDDref2L, 		// low gain ADC reference 2 VDD

	inout VSSA, 			// Analogue VSS

	inout VDDD, 			// Digital VDD
	inout VSSD, 			// Digital VSS

		// Note : VDDD/VSSD and VDDD2/VSSD2 are shorted togheter at the pad level

	inout VDDD2, 			// Digital VDD, DTU side
	inout VSSD2, 			// Digital VSS, DTU side

	inout VDD_PLL, 			// PLL VDD
	inout VSS_PLL, 			// PLL VSS

		// Input voltages

	input VinHp, 			// high gain ADC inputs
	input VinHm,
	input VinLp, 			// low gain ADC inputs
	input VinLm,

		// Input reset and clocks

	input[1:0] rstA_b,
	input[1:0] rstB_b,
	input[1:0] rstC_b,
	input ClkIn,			// Master clock (1.28 GHz)
	input SClkIn,			// Sampling clock (160 MHz)

		// Output buses

	output[11:0] DoutH,
	output[11:0] DoutL,

		// Control signals

	input 	TestClkIn,			// Test clock input
	input 	TestClkSel, 		// Test Mode select
	input 	ClkInv,
	input[1:0]  CalInA,			// Calibration mode input
	input[1:0]  CalInB,
	input[1:0]  CalInC,
	output[1:0] CalBusy,		// Calibration busy output
	output[1:0] Overflow,		// Overflow
	output[1:0] ClkOut_b,		// Clock output (inverted, sampling on falling edge)
	output[1:0] SEU,			// SEU output

	input[1:0] DataFormatA,		// 0 -> binary, 1 -> 2's complement
	input[1:0] DataFormatB,
	input[1:0] DataFormatC,
	input[1:0] OpModeA, 		// 0 -> power down, 1 -> normal
	input[1:0] OpModeB,
	input[1:0] OpModeC,


		// I2C interface signals

	input 			sclA,
	input 			sclB,
	input 			sclC,
	input 			sda_in,
	output[1:0] 	sda_out_b,

	input[6:2] 		i2c_addr);

	wire[6:0] 	i2c_addrH;
	wire[6:0] 	i2c_addrL;

	assign i2c_addrH = {i2c_addr, 2'b01};
	assign i2c_addrL = {i2c_addr, 2'b00};

	S3ADS160M12BT65LP ADC_H (
			.VINP(VinHp), 				.VINN(VinHm),
			.AVDDREF_STG1(VDDref1H), 	.AVDDREF_STG2(VDDref2H),
			.AVDD(VDDA),				.AVSS(VSSA),			.VSS_SUB(VSSA),
			.DVDD(VDDD), 				.DVSS(VSSD),
			.CLK(ClkIn), 				.CLK_ST(SClkIn),
			.OM_A(OpModeA[1]), 			.OM_B(OpModeB[1]), 		.OM_C(OpModeC[1]),
			.DF_A(DataFormatA[1]), 		.DF_B(DataFormatB[1]), 	.DF_C(DataFormatC[1]),
			.CAL_A(CalInA[1]), 			.CAL_B(CalInB[1]), 		.CAL_C(CalInC[1]),
			.DCLK(ClkOut_b[1]), 		.D(DoutH), 				.OVF(Overflow[1]),
			.CAL_BUSY(CalBusy[1]), 		.SEU(SEU[1]),
			.RSTA_N(rstA_b[1]), 		.RSTB_N(rstB_b[1]), 	.RSTC_N(rstC_b[1]),
			.SCLA(sclA), 				.SCLB(sclB), 			.SCLC(sclC),
			.I2C_ADDR(i2c_addrH), 		.SDA_I(sda_in), 		.SDA_O_N(sda_out_b[1]));

	S3ADS160M12BT65LP ADC_L (
			.VINP(VinLp), 				.VINN(VinLm),
			.AVDDREF_STG1(VDDref1L), 	.AVDDREF_STG2(VDDref2L),
			.AVDD(VDDA),				.AVSS(VSSA),			.VSS_SUB(VSSA),
			.DVDD(VDDD), 				.DVSS(VSSD),
			.CLK(ClkIn), 				.CLK_ST(SClkIn),
			.OM_A(OpModeA[0]), 			.OM_B(OpModeB[0]), 		.OM_C(OpModeC[0]),
			.DF_A(DataFormatA[0]), 		.DF_B(DataFormatB[0]), 	.DF_C(DataFormatC[0]),
			.CAL_A(CalInA[0]), 			.CAL_B(CalInB[0]), 		.CAL_C(CalInC[0]),
			.DCLK(ClkOut_b[0]), 		.D(DoutL), 				.OVF(Overflow[0]),
			.CAL_BUSY(CalBusy[0]), 		.SEU(SEU[0]),
			.RSTA_N(rstA_b[0]), 		.RSTB_N(rstB_b[0]), 	.RSTC_N(rstC_b[0]),
			.SCLA(sclA), 				.SCLB(sclB), 			.SCLC(sclC),
			.I2C_ADDR(i2c_addrL), 		.SDA_I(sda_in), 		.SDA_O_N(sda_out_b[0]));

endmodule

