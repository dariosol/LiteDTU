
`timescale  1ps/1ps

module LiTE_DTU_160MHz_v2_0 (
			     DCLK_1, 
			     DCLK_10, 
			     CLK, 
			     RST, 
			     CALIBRATION_BUSY_1, 
			     CALIBRATION_BUSY_10, 
			     TEST_ENABLE, 
			     GAIN_SEL_MODE, 
			     fallback, 
			     DATA12_g01, 
			     DATA12_g10, 
			     SATURATION_value, 
			     BSL_VAL_g01, 
			     BSL_VAL_g10, 
			     losing_data, 
			     totalError, 
			     DATA32_ATU_0, 
			     DATA32_ATU_1, 
			     DATA32_ATU_2, 
			     DATA32_ATU_3, 
			     Orbit, 
			     shift_gain_10, 
			     DATA32_0, 
			     DATA32_1, 
			     DATA32_2, 
			     DATA32_3, 
			     handshake);
   
   
   // Internal constants
   parameter Nbits_8 	= 8;
   parameter Nbits_12 	= 12;
   parameter Nbits_32 	= 32;
   parameter FifoDepth = 8;
   parameter NBitsCnt 	= 3;
   parameter crcBits = 12;
   parameter FifoDepth_buff = 16;
   parameter bits_ptr = 4;


   // Input ports
   input DCLK_1;
   input DCLK_10;
   input CLK;
   input RST;
   input fallback;
   input CALIBRATION_BUSY_1;
   input CALIBRATION_BUSY_10;
   input TEST_ENABLE;
   input [1:0] GAIN_SEL_MODE;
   input [Nbits_12-1:0] DATA12_g01;
   input [Nbits_12-1:0] DATA12_g10;
   input [Nbits_12-1:0] SATURATION_value;
   input [Nbits_8-1:0] 	BSL_VAL_g01;
   input [Nbits_8-1:0] 	BSL_VAL_g10;
   input 		handshake;
   input [Nbits_32-1:0] DATA32_ATU_0;
   input [Nbits_32-1:0] DATA32_ATU_1;
   input [Nbits_32-1:0] DATA32_ATU_2;
   input [Nbits_32-1:0] DATA32_ATU_3;
   input 		Orbit;
   input [1:0] 		shift_gain_10;
   
   // Output ports
   output 		losing_data;
   output [Nbits_32-1:0] DATA32_0;
   output [Nbits_32-1:0] DATA32_1;
   output [Nbits_32-1:0] DATA32_2;
   output [Nbits_32-1:0] DATA32_3;
   output 		 totalError;
   
   // Internal variables	
   wire [Nbits_32-1:0] 	 DATA32_DTU;
   wire [Nbits_12-1:0] 	 DATA_gain_01;			// Baseline Subtraction Module
   wire [Nbits_12-1:0] 	 DATA_gain_10;			// Baseline Subtraction Module
   wire [Nbits_12:0] 	 DATA_to_enc;				// Input FIFOs Module
   wire 		 baseline_flag;					// Input FIFOs Module //***
   wire [Nbits_32-1:0] 	 DATA_32;				// Encoder Module //***
   wire [Nbits_32-1:0] 	 DATA_32_FB;				// Encoder Module //***
   wire 		 Load;						// Encoder Module //***
   wire 		 Load_FB;						// Encoder Module //***
   wire 		 write_signal;					// Control Unit Module
   wire [Nbits_32-1:0] 	 DATA_from_CU;			// Control Unit Module
   wire 		 full;						// Output FIFO Module
   wire 		 reset;
   wire 		 CALIBRATION_BUSY;
   wire 		 RD_to_SERIALIZER;						// Control Unit Module

   

   assign CALIBRATION_BUSY = CALIBRATION_BUSY_1 | CALIBRATION_BUSY_10;
   
   // LiTe-DTU resets
   wire [2:0] 		 AA;
   assign AA = {RST, CALIBRATION_BUSY, TEST_ENABLE};

   assign reset = (AA == 3'b100) ? 1'b1 : 1'b0;

   wire 		 tmrError_BS;
   wire 		 tmrError_iFIFO;
   wire 		 tmrError_enc;
   wire 		 tmrError_oFIFO;
   wire 		 tmrError_CU;
   wire 		 tmrError_mux;

   assign totalError = tmrError_BS | tmrError_iFIFO | tmrError_enc | tmrError_CU | tmrError_oFIFO | tmrError_mux;

   // ****  Baseline Subtraction Module **** //
   LDTU_BS #(.Nbits_12(Nbits_12), .Nbits_8(Nbits_8))
   B_subtraction (.DCLK_1(DCLK_1), .DCLK_10(DCLK_10), .rst_b(reset), .DATA12_g01(DATA12_g01), .DATA12_g10(DATA12_g10), .BSL_VAL_g01(BSL_VAL_g01), .BSL_VAL_g10(BSL_VAL_g10), .DATA_gain_01(DATA_gain_01), .DATA_gain_10(DATA_gain_10), .SeuError(tmrError_BS));


   // **** Input FIFOs Module **** //
   LDTU_iFIFO #(.Nbits_12(Nbits_12), .FifoDepth(FifoDepth), .NBitsCnt(NBitsCnt))
   Selection (.DCLK_1(DCLK_1), .DCLK_10(DCLK_10), .CLK(CLK), .rst_b(reset), .GAIN_SEL_MODE(GAIN_SEL_MODE), .DATA_gain_01(DATA_gain_01), .DATA_gain_10(DATA_gain_10), .SATURATION_value(SATURATION_value), .shift_gain_10(shift_gain_10), .DATA_to_enc(DATA_to_enc), .baseline_flag(baseline_flag), .SeuError(tmrError_iFIFO));


   //  **** Encoder Module ****  //
   LDTU_Encoder #(.Nbits_12(Nbits_12), .Nbits_32(Nbits_32))
   Encoder (.CLK(CLK), .rst_b(reset), .baseline_flag(baseline_flag), .Orbit(Orbit), .fallback(fallback),.DATA_to_enc(DATA_to_enc), .DATA_32(DATA_32), .DATA_32_FB(DATA_32_FB), .Load(Load),.Load_FB(Load_FB), .SeuError(tmrError_enc));


   //  **** Control Unit ****  //
   LDTU_CU #(.Nbits_32(Nbits_32))
   Control_Unit (.CLK(CLK), 
		 .rst_b(reset), 
		 .fallback(fallback),
		 .Load_data(Load), .DATA_32(DATA_32), 
		 .Load_data_FB(Load_FB), .DATA_32_FB(DATA_32_FB), 
		 .full(full), .DATA_from_CU(DATA_from_CU), .losing_data(losing_data), .write_signal(write_signal), .read_signal(RD_to_SERIALIZER), .SeuError(tmrError_CU), .handshake(handshake));// , .empty_signal(empty));
   

   //  **** outputFIFO ****  //
   LDTU_oFIFO_top  #(.Nbits_32(Nbits_32), .FifoDepth_buff(FifoDepth_buff), .bits_ptr(bits_ptr))
   StorageFIFO (.CLK(CLK),
		.rst_b(reset), 
		.write_signal(write_signal), .read_signal(RD_to_SERIALIZER), 
		.data_in_32(DATA_from_CU), .full_signal(full), .DATA32_DTU(DATA32_DTU), 
		.SeuError(tmrError_oFIFO)); //.decode_signal(decode_signal));


   LDTU_DATA32_ATU_DTU #(.Nbits_32(Nbits_32))
   DATA32_mux ( .CLK(CLK),
		.RST(reset),
		.CALIBRATION_BUSY(CALIBRATION_BUSY),
		.TEST_ENABLE(TEST_ENABLE),		
		.DATA32_ATU_0(DATA32_ATU_0), .DATA32_ATU_1(DATA32_ATU_1),
		.DATA32_ATU_2(DATA32_ATU_2), .DATA32_ATU_3(DATA32_ATU_3),
		.DATA32_DTU(DATA32_DTU), //.decode_signal(decode_signal),
		.DATA32_0(DATA32_0), .DATA32_1(DATA32_1),
		.DATA32_2(DATA32_2), .DATA32_3(DATA32_3), .SeuError(tmrError_mux));
   

endmodule
