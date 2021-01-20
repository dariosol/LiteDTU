
`timescale  1ps/1ps

module LiTE_DTU_160MHz_v1_2 (DCLK_1, DCLK_10, CLK_A, CLK_B, CLK_C, RST_A, RST_B, RST_C, CALIBRATION_BUSY_1, CALIBRATION_BUSY_10, TEST_ENABLE, GAIN_SEL_MODE, DATA12_g01, DATA12_g10, SATURATION_value, BSL_VAL_g01, BSL_VAL_g10, losing_data, totalError, DATA32_ATU_0, DATA32_ATU_1, DATA32_ATU_2, DATA32_ATU_3, Orbit, DATA32_0, DATA32_1, DATA32_2, DATA32_3, handshake);
	
		
// Internal constants
	parameter Nbits_8 	= 8;
	parameter Nbits_12 	= 12;
	parameter Nbits_32 	= 32;
	parameter FifoDepth = 8;
	parameter NBitsCnt 	= 4;
	parameter crcBits = 12;
	parameter FifoDepth_buff = 16;
	parameter bits_ptr = 4;


// Input ports
	input DCLK_1;
	input DCLK_10;
	input CLK_A;
	input CLK_B;
	input CLK_C;
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
	input [Nbits_8-1:0] BSL_VAL_g01;
	input [Nbits_8-1:0] BSL_VAL_g10;
	input  handshake;
	input [Nbits_32-1:0] DATA32_ATU_0;
	input [Nbits_32-1:0] DATA32_ATU_1;
	input [Nbits_32-1:0] DATA32_ATU_2;
	input [Nbits_32-1:0] DATA32_ATU_3;
        input Orbit;
   
 // Output ports
	output losing_data;
	output [Nbits_32-1:0] DATA32_0;
	output [Nbits_32-1:0] DATA32_1;
	output [Nbits_32-1:0] DATA32_2;
	output [Nbits_32-1:0] DATA32_3;
	output totalError;
	
// Internal variables	
	wire [Nbits_32-1:0] DATA32_DTU;					
	wire [Nbits_12-1:0] DATA_gain_01;			// Baseline Subtraction Module
	wire [Nbits_12-1:0] DATA_gain_10;			// Baseline Subtraction Module
	wire [Nbits_12:0]  DATA_to_enc;				// Input FIFOs Module
	wire baseline_flag;					// Input FIFOs Module //***
	wire [Nbits_32-1:0] DATA_32;				// Encoder Module //***
	wire Load;						// Encoder Module //***
	wire write_signal;					// Control Unit Module
	wire [Nbits_32-1:0] DATA_from_CU;			// Control Unit Module
	wire full;						// Output FIFO Module
	wire reset_A;
	wire reset_B;
	wire reset_C;
	wire CALIBRATION_BUSY;
	wire CALIBRATION_BUSY_A;
	wire TEST_ENABLE_A;
	wire CALIBRATION_BUSY_B;
	wire TEST_ENABLE_B;
	wire CALIBRATION_BUSY_C;
	wire TEST_ENABLE_C;
	wire RD_to_SERIALIZER;						// Control Unit Module


	assign CALIBRATION_BUSY = CALIBRATION_BUSY_1 | CALIBRATION_BUSY_10;

	// LiTe-DTU resets
	wire [2:0] AAA;
	wire [2:0] BBB;
	wire [2:0] CCC;

	assign AAA = {RST_A, CALIBRATION_BUSY_A, TEST_ENABLE_A};
	assign BBB = {RST_B, CALIBRATION_BUSY_B, TEST_ENABLE_B};
	assign CCC = {RST_C, CALIBRATION_BUSY_C, TEST_ENABLE_C};

	assign reset_A = (AAA == 3'b100) ? 1'b1 : 1'b0;
	assign reset_B = (BBB == 3'b100) ? 1'b1 : 1'b0;
	assign reset_C = (CCC == 3'b100) ? 1'b1 : 1'b0;

	wire tmrError_BS;
	wire tmrError_iFIFO;
	wire tmrError_enc;
	wire tmrError_oFIFO;
	wire tmrError_CU;
	wire tmrError_mux;

assign totalError = tmrError_BS | tmrError_iFIFO | tmrError_enc | tmrError_CU | tmrError_oFIFO | tmrError_mux;

// ****  Baseline Subtraction Module **** //
LDTU_BSTMR #(.Nbits_12(Nbits_12), .Nbits_8(Nbits_8))
	B_subtraction (.DCLK_1(DCLK_1), .DCLK_10(DCLK_10), .reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), .DATA12_g01(DATA12_g01), .DATA12_g10(DATA12_g10), .BSL_VAL_g01(BSL_VAL_g01), .BSL_VAL_g10(BSL_VAL_g10), .DATA_gain_01(DATA_gain_01), .DATA_gain_10(DATA_gain_10), .tmrError(tmrError_BS));


// **** Input FIFOs Module **** //
LDTU_iFIFOTMR #(.Nbits_12(Nbits_12), .FifoDepth(FifoDepth), .NBitsCnt(NBitsCnt))
	Selection_TMR (.DCLK_1(DCLK_1), .DCLK_10(DCLK_10), .CLK_A(CLK_A), .CLK_B(CLK_B), .CLK_C(CLK_C), .reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), .GAIN_SEL_MODE(GAIN_SEL_MODE), .DATA_gain_01(DATA_gain_01), .DATA_gain_10(DATA_gain_10), .SATURATION_value(SATURATION_value), .DATA_to_enc(DATA_to_enc), .baseline_flag(baseline_flag), .tmrError(tmrError_iFIFO));


//  **** Encoder Module ****  //
LDTU_EncoderTMR #(.Nbits_12(Nbits_12), .Nbits_32(Nbits_32))
	Encoder (.CLK_A(CLK_A), .CLK_B(CLK_B), .CLK_C(CLK_C), .reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), .baseline_flag(baseline_flag), .Orbit(Orbit), .DATA_to_enc(DATA_to_enc), .DATA_32(DATA_32), .Load(Load), .tmrError(tmrError_enc));


//  **** Control Unit ****  //
	LDTU_CUTMR #(.Nbits_32(Nbits_32))
	Control_Unit (.CLK_A(CLK_A), .CLK_B(CLK_B), .CLK_C(CLK_C), .reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), .Load_data(Load), .DATA_32(DATA_32), .full(full), .DATA_from_CU(DATA_from_CU), .losing_data(losing_data), .write_signal(write_signal), .read_signal(RD_to_SERIALIZER), .tmrError(tmrError_CU), .handshake(handshake));// , .empty_signal(empty));
	 

//  **** outputFIFO ****  //
	LDTU_oFIFO_top  #(.Nbits_32(Nbits_32), .FifoDepth_buff(FifoDepth_buff), .bits_ptr(bits_ptr))
	StorageFIFO (.CLK_A(CLK_A), .CLK_B(CLK_B), .CLK_C(CLK_C), 
			.reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), 
			.write_signal(write_signal), .read_signal(RD_to_SERIALIZER), 
			.data_in_32(DATA_from_CU), .full_signal(full), .DATA32_DTU(DATA32_DTU), 
			.tmrError(tmrError_oFIFO)); //.decode_signal(decode_signal));

 
		
	LDTU_DATA32_ATU_DTUTMR #(.Nbits_32(Nbits_32))
	DATA32_mux ( .CLK_A(CLK_A), .CLK_B(CLK_B), .CLK_C(CLK_C), 
		     .RST_A(RST_A), .RST_B(RST_B), .RST_C(RST_C),
		     .CALIBRATION_BUSY_A(CALIBRATION_BUSY_A), .CALIBRATION_BUSY_B(CALIBRATION_BUSY_B), 
		     .CALIBRATION_BUSY_C(CALIBRATION_BUSY_C), .TEST_ENABLE_A(TEST_ENABLE_A), 
		     .TEST_ENABLE_B(TEST_ENABLE_B), .TEST_ENABLE_C(TEST_ENABLE_C),
		     .DATA32_ATU_0(DATA32_ATU_0), .DATA32_ATU_1(DATA32_ATU_1), 
		     .DATA32_ATU_2(DATA32_ATU_2), .DATA32_ATU_3(DATA32_ATU_3),
		     .DATA32_DTU(DATA32_DTU), //.decode_signal(decode_signal),
		     .DATA32_0(DATA32_0), .DATA32_1(DATA32_1), 
		     .DATA32_2(DATA32_2), .DATA32_3(DATA32_3), .tmrError(tmrError_mux));

fanout CALIBRATION_BUSYFanout (
		.in(CALIBRATION_BUSY),
		.outA(CALIBRATION_BUSY_A),
		.outB(CALIBRATION_BUSY_B),
		.outC(CALIBRATION_BUSY_C)
		);

fanout TEST_ENABLEFanout (
		.in(TEST_ENABLE),
		.outA(TEST_ENABLE_A),
		.outB(TEST_ENABLE_B),
		.outC(TEST_ENABLE_C)
		);

endmodule
