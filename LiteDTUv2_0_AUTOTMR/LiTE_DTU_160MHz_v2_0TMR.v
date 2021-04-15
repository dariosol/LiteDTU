/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/LiTE_DTU_160MHz_v2_0TMR.v                                       *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 14/04/2021 14:52:36                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: LiTE_DTU_160MHz_v2_0.v                                                                 *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-04-14 14:49:32.442945                                         *
 *           File Size         : 5942                                                               *
 *           MD5 hash          : 7ad2399719c2aa16503d7a0649991e95                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale   1ps/1ps

module LiTE_DTU_160MHz_v2_0TMR(
  DCLK_1,
  DCLK_10,
  CLKA,
  CLKB,
  CLKC,
  RSTA,
  RSTB,
  RSTC,
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
  OrbitA,
  OrbitB,
  OrbitC,
  shift_gain_10,
  flushA,
  flushB,
  flushC,
  synchA,
  synchB,
  synchC,
  synch_pattern,
  DATA32_0,
  DATA32_1,
  DATA32_2,
  DATA32_3,
  handshake
);
parameter    Nbits_8=8;
parameter    Nbits_12=12;
parameter    Nbits_32=32;
parameter    FifoDepth=8;
parameter    NBitsCnt=4;
parameter    crcBits=12;
parameter    FifoDepth_buff=16;
parameter    bits_ptr=4;
wire CALIBRATION_BUSYC;
wire CALIBRATION_BUSYB;
wire CALIBRATION_BUSYA;
wire TEST_ENABLEC;
wire TEST_ENABLEB;
wire TEST_ENABLEA;
wire flushresetC;
wire flushresetB;
wire flushresetA;
wire [1:0] shift_gain_10C;
wire [1:0] shift_gain_10B;
wire [1:0] shift_gain_10A;
wor resetTmrError;
wire reset;
wor flushTmrError;
wire flush;
input DCLK_1;
input DCLK_10;
input CLKA;
input CLKB;
input CLKC;
input RSTA;
input RSTB;
input RSTC;
input fallback;
input CALIBRATION_BUSY_1;
input CALIBRATION_BUSY_10;
input TEST_ENABLE;
input [1:0] GAIN_SEL_MODE;
input [Nbits_12-1:0] DATA12_g01;
input [Nbits_12-1:0] DATA12_g10;
input [Nbits_12-1:0] SATURATION_value;
input [Nbits_8-1:0] BSL_VAL_g01;
input [Nbits_8-1:0] BSL_VAL_g10;
input handshake;
input [Nbits_32-1:0] DATA32_ATU_0;
input [Nbits_32-1:0] DATA32_ATU_1;
input [Nbits_32-1:0] DATA32_ATU_2;
input [Nbits_32-1:0] DATA32_ATU_3;
input OrbitA;
input OrbitB;
input OrbitC;
input [1:0] shift_gain_10;
input flushA;
input flushB;
input flushC;
input synchA;
input synchB;
input synchC;
input [Nbits_32-1:0] synch_pattern;
output losing_data;
output [Nbits_32-1:0] DATA32_0;
output [Nbits_32-1:0] DATA32_1;
output [Nbits_32-1:0] DATA32_2;
output [Nbits_32-1:0] DATA32_3;
output totalError;
wire [Nbits_32-1:0] DATA32_DTU;
wire [Nbits_12-1:0] DATA_gain_01;
wire [Nbits_12-1:0] DATA_gain_10;
wire [Nbits_12:0] DATA_to_enc;
wire baseline_flag;
wire [Nbits_32-1:0] DATA_32;
wire [Nbits_32-1:0] DATA_32_FB;
wire Load;
wire Load_FB;
wire write_signal;
wire [Nbits_32-1:0] DATA_from_CU;
wire full;
wire resetA;
wire resetB;
wire resetC;
wire CALIBRATION_BUSY;
wire RD_to_SERIALIZER;
assign CALIBRATION_BUSY =  CALIBRATION_BUSY_1|CALIBRATION_BUSY_10;
wire [2:0] AAA;
wire [2:0] AAB;
wire [2:0] AAC;
assign AAA =  {RSTA,CALIBRATION_BUSYA,TEST_ENABLEA};
assign AAB =  {RSTB,CALIBRATION_BUSYB,TEST_ENABLEB};
assign AAC =  {RSTC,CALIBRATION_BUSYC,TEST_ENABLEC};
assign resetA =  (AAA==3'b100) ? 1'b1 : 1'b0;
assign resetB =  (AAB==3'b100) ? 1'b1 : 1'b0;
assign resetC =  (AAC==3'b100) ? 1'b1 : 1'b0;
wire tmrError_BS;
wire tmrError_iFIFO;
wire tmrError_enc;
wire tmrError_oFIFO;
wire tmrError_CU;
wire tmrError_mux;
assign totalError =  tmrError_BS|tmrError_iFIFO|tmrError_enc|tmrError_CU|tmrError_oFIFO|tmrError_mux;
wire flushreset;
assign flushreset =  reset&flush;

LDTU_BSTMR #(.Nbits_12(Nbits_12), .Nbits_8(Nbits_8)) B_subtraction (
    .DCLK_1(DCLK_1),
    .DCLK_10(DCLK_10),
    .rst_bA(resetA),
    .rst_bB(resetB),
    .rst_bC(resetC),
    .DATA12_g01(DATA12_g01),
    .DATA12_g10(DATA12_g10),
    .BSL_VAL_g01(BSL_VAL_g01),
    .BSL_VAL_g10(BSL_VAL_g10),
    .DATA_gain_01(DATA_gain_01),
    .DATA_gain_10(DATA_gain_10),
    .shift_gain_10A(shift_gain_10A),
    .shift_gain_10B(shift_gain_10B),
    .shift_gain_10C(shift_gain_10C),
    .SeuError(tmrError_BS)
    );

LDTU_iFIFOTMR #(.Nbits_12(Nbits_12), .FifoDepth(FifoDepth), .NBitsCnt(NBitsCnt)) Selection (
    .DCLK_1(DCLK_1),
    .DCLK_10(DCLK_10),
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .rst_bA(resetA),
    .rst_bB(resetB),
    .rst_bC(resetC),
    .GAIN_SEL_MODE(GAIN_SEL_MODE),
    .DATA_gain_01(DATA_gain_01),
    .DATA_gain_10(DATA_gain_10),
    .SATURATION_value(SATURATION_value),
    .shift_gain_10(shift_gain_10),
    .DATA_to_enc(DATA_to_enc),
    .baseline_flag(baseline_flag),
    .SeuError(tmrError_iFIFO)
    );

LDTU_EncoderTMR #(.Nbits_12(Nbits_12), .Nbits_32(Nbits_32)) Encoder (
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .rst_bA(flushresetA),
    .rst_bB(flushresetB),
    .rst_bC(flushresetC),
    .baseline_flag(baseline_flag),
    .OrbitA(OrbitA),
    .OrbitB(OrbitB),
    .OrbitC(OrbitC),
    .fallback(fallback),
    .DATA_to_enc(DATA_to_enc),
    .DATA_32(DATA_32),
    .DATA_32_FB(DATA_32_FB),
    .Load(Load),
    .Load_FB(Load_FB),
    .SeuError(tmrError_enc)
    );

LDTU_CUTMR #(.Nbits_32(Nbits_32)) Control_Unit (
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .rst_bA(flushresetA),
    .rst_bB(flushresetB),
    .rst_bC(flushresetC),
    .fallback(fallback),
    .Load_data(Load),
    .DATA_32(DATA_32),
    .Load_data_FB(Load_FB),
    .DATA_32_FB(DATA_32_FB),
    .full(full),
    .DATA_from_CU(DATA_from_CU),
    .losing_data(losing_data),
    .write_signal(write_signal),
    .read_signal(RD_to_SERIALIZER),
    .SeuError(tmrError_CU),
    .handshake(handshake)
    );

LDTU_oFIFO_topTMR #(.Nbits_32(Nbits_32), .FifoDepth_buff(FifoDepth_buff), .bits_ptr(bits_ptr)) StorageFIFO (
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .rst_bA(resetA),
    .rst_bB(resetB),
    .rst_bC(resetC),
    .flushA(flushA),
    .flushB(flushB),
    .flushC(flushC),
    .synchA(synchA),
    .synchB(synchB),
    .synchC(synchC),
    .synch_pattern(synch_pattern),
    .write_signal(write_signal),
    .read_signal(RD_to_SERIALIZER),
    .data_in_32(DATA_from_CU),
    .full_signal(full),
    .DATA32_DTU(DATA32_DTU),
    .SeuError(tmrError_oFIFO)
    );

LDTU_DATA32_ATU_DTUTMR #(.Nbits_32(Nbits_32)) DATA32_mux (
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .RSTA(RSTA),
    .RSTB(RSTB),
    .RSTC(RSTC),
    .CALIBRATION_BUSYA(CALIBRATION_BUSYA),
    .CALIBRATION_BUSYB(CALIBRATION_BUSYB),
    .CALIBRATION_BUSYC(CALIBRATION_BUSYC),
    .TEST_ENABLEA(TEST_ENABLEA),
    .TEST_ENABLEB(TEST_ENABLEB),
    .TEST_ENABLEC(TEST_ENABLEC),
    .DATA32_ATU_0(DATA32_ATU_0),
    .DATA32_ATU_1(DATA32_ATU_1),
    .DATA32_ATU_2(DATA32_ATU_2),
    .DATA32_ATU_3(DATA32_ATU_3),
    .DATA32_DTU(DATA32_DTU),
    .DATA32_0(DATA32_0),
    .DATA32_1(DATA32_1),
    .DATA32_2(DATA32_2),
    .DATA32_3(DATA32_3),
    .SeuError(tmrError_mux)
    );

majorityVoter flushVoter (
    .inA(flushA),
    .inB(flushB),
    .inC(flushC),
    .out(flush),
    .tmrErr(flushTmrError)
    );

majorityVoter resetVoter (
    .inA(resetA),
    .inB(resetB),
    .inC(resetC),
    .out(reset),
    .tmrErr(resetTmrError)
    );

fanout #(.WIDTH(2)) shift_gain_10Fanout (
    .in(shift_gain_10),
    .outA(shift_gain_10A),
    .outB(shift_gain_10B),
    .outC(shift_gain_10C)
    );

fanout flushresetFanout (
    .in(flushreset),
    .outA(flushresetA),
    .outB(flushresetB),
    .outC(flushresetC)
    );

fanout TEST_ENABLEFanout (
    .in(TEST_ENABLE),
    .outA(TEST_ENABLEA),
    .outB(TEST_ENABLEB),
    .outC(TEST_ENABLEC)
    );

fanout CALIBRATION_BUSYFanout (
    .in(CALIBRATION_BUSY),
    .outA(CALIBRATION_BUSYA),
    .outB(CALIBRATION_BUSYB),
    .outC(CALIBRATION_BUSYC)
    );
endmodule



// /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/tmrg/../common/voter.v
module majorityVoter #(
  parameter WIDTH = 1
)( 
  input wire  [WIDTH-1:0] inA,
  input wire  [WIDTH-1:0] inB,
  input wire  [WIDTH-1:0] inC,
  output wire [WIDTH-1:0] out,
  output reg              tmrErr
);
  assign out = (inA&inB) | (inA&inC) | (inB&inC);
  always @(inA or inB or inC) begin
    if (inA!=inB || inA!=inC || inB!=inC)
      tmrErr = 1;
    else
      tmrErr = 0;
  end
endmodule


// /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/tmrg/../common/fanout.v
module fanout #(
  parameter WIDTH = 1
)(
  input wire  [WIDTH-1:0] in,
  output wire [WIDTH-1:0] outA,
  output wire [WIDTH-1:0] outB,
  output wire [WIDTH-1:0] outC
);
  assign outA = in;
  assign outB = in;
  assign outC = in;
endmodule
