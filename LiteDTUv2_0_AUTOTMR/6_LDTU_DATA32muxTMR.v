/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/6_LDTU_DATA32muxTMR.v                                           *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 19/04/2021 14:40:33                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 6_LDTU_DATA32mux.v                                                                     *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-04-06 14:05:37.038385                                         *
 *           File Size         : 2590                                                               *
 *           MD5 hash          : b3266c92078524c1ab2a8f2f33ea5ac8                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale     1ps/1ps

module LDTU_DATA32_ATU_DTUTMR(
  CLKA,
  CLKB,
  CLKC,
  RSTA,
  RSTB,
  RSTC,
  CALIBRATION_BUSYA,
  CALIBRATION_BUSYB,
  CALIBRATION_BUSYC,
  TEST_ENABLEA,
  TEST_ENABLEB,
  TEST_ENABLEC,
  DATA32_ATU_0,
  DATA32_ATU_1,
  DATA32_ATU_2,
  DATA32_ATU_3,
  DATA32_DTU,
  DATA32_0,
  DATA32_1,
  DATA32_2,
  DATA32_3,
  SeuError
);
parameter    Nbits_32=32;
parameter    idle_patternEA=32'b11101010101010101010101010101010;
parameter    idle_pattern5A=32'b01011010010110100101101001011010;
parameter    idle_patternRST=32'b00110101010101010101010101010101;
wire [Nbits_32-1:0] DATA32_ATU_3C;
wire [Nbits_32-1:0] DATA32_ATU_3B;
wire [Nbits_32-1:0] DATA32_ATU_3A;
wire [Nbits_32-1:0] DATA32_ATU_2C;
wire [Nbits_32-1:0] DATA32_ATU_2B;
wire [Nbits_32-1:0] DATA32_ATU_2A;
wire [Nbits_32-1:0] DATA32_ATU_0C;
wire [Nbits_32-1:0] DATA32_ATU_0B;
wire [Nbits_32-1:0] DATA32_ATU_0A;
wire [Nbits_32-1:0] DATA32_DTUC;
wire [Nbits_32-1:0] DATA32_DTUB;
wire [Nbits_32-1:0] DATA32_DTUA;
wire [Nbits_32-1:0] DATA32_ATU_1C;
wire [Nbits_32-1:0] DATA32_ATU_1B;
wire [Nbits_32-1:0] DATA32_ATU_1A;
wire tmrError;
wor DATA32_3_synchTmrError;
wor DATA32_2_synchTmrError;
wor DATA32_1_synchTmrError;
wor DATA32_0_synchTmrError;
wire [Nbits_32-1:0] DATA32_3_synch;
wire [Nbits_32-1:0] DATA32_2_synch;
wire [Nbits_32-1:0] DATA32_1_synch;
wire [Nbits_32-1:0] DATA32_0_synch;
input CLKA;
input CLKB;
input CLKC;
input RSTA;
input RSTB;
input RSTC;
input CALIBRATION_BUSYA;
input CALIBRATION_BUSYB;
input CALIBRATION_BUSYC;
input TEST_ENABLEA;
input TEST_ENABLEB;
input TEST_ENABLEC;
input [Nbits_32-1:0] DATA32_ATU_0;
input [Nbits_32-1:0] DATA32_ATU_1;
input [Nbits_32-1:0] DATA32_ATU_2;
input [Nbits_32-1:0] DATA32_ATU_3;
input [Nbits_32-1:0] DATA32_DTU;
output [Nbits_32-1:0] DATA32_0;
output [Nbits_32-1:0] DATA32_1;
output [Nbits_32-1:0] DATA32_2;
output [Nbits_32-1:0] DATA32_3;
output SeuError;
reg  [Nbits_32-1:0] r_DATA32_0A;
reg  [Nbits_32-1:0] r_DATA32_0B;
reg  [Nbits_32-1:0] r_DATA32_0C;
reg  [Nbits_32-1:0] r_DATA32_1A;
reg  [Nbits_32-1:0] r_DATA32_1B;
reg  [Nbits_32-1:0] r_DATA32_1C;
reg  [Nbits_32-1:0] r_DATA32_2A;
reg  [Nbits_32-1:0] r_DATA32_2B;
reg  [Nbits_32-1:0] r_DATA32_2C;
reg  [Nbits_32-1:0] r_DATA32_3A;
reg  [Nbits_32-1:0] r_DATA32_3B;
reg  [Nbits_32-1:0] r_DATA32_3C;
assign SeuError =  tmrError;

always @( posedge CLKA )
  begin
    if (RSTA==1'b0)
      begin
        if (TEST_ENABLEA==1'b0)
          r_DATA32_0A =  idle_patternRST;
        else
          r_DATA32_0A =  idle_pattern5A;
        r_DATA32_1A =  idle_pattern5A;
        r_DATA32_2A =  idle_pattern5A;
        r_DATA32_3A =  idle_pattern5A;
      end
    else
      begin
        if (TEST_ENABLEA==1'b0)
          begin
            if (CALIBRATION_BUSYA==1'b0)
              r_DATA32_0A =  DATA32_DTUA;
            else
              r_DATA32_0A =  idle_patternRST;
            r_DATA32_1A =  idle_pattern5A;
            r_DATA32_2A =  idle_pattern5A;
            r_DATA32_3A =  idle_pattern5A;
          end
        else
          begin
            r_DATA32_0A =  DATA32_ATU_0A;
            r_DATA32_1A =  DATA32_ATU_1A;
            r_DATA32_2A =  DATA32_ATU_2A;
            r_DATA32_3A =  DATA32_ATU_3A;
          end
      end
  end

always @( posedge CLKB )
  begin
    if (RSTB==1'b0)
      begin
        if (TEST_ENABLEB==1'b0)
          r_DATA32_0B =  idle_patternRST;
        else
          r_DATA32_0B =  idle_pattern5A;
        r_DATA32_1B =  idle_pattern5A;
        r_DATA32_2B =  idle_pattern5A;
        r_DATA32_3B =  idle_pattern5A;
      end
    else
      begin
        if (TEST_ENABLEB==1'b0)
          begin
            if (CALIBRATION_BUSYB==1'b0)
              r_DATA32_0B =  DATA32_DTUB;
            else
              r_DATA32_0B =  idle_patternRST;
            r_DATA32_1B =  idle_pattern5A;
            r_DATA32_2B =  idle_pattern5A;
            r_DATA32_3B =  idle_pattern5A;
          end
        else
          begin
            r_DATA32_0B =  DATA32_ATU_0B;
            r_DATA32_1B =  DATA32_ATU_1B;
            r_DATA32_2B =  DATA32_ATU_2B;
            r_DATA32_3B =  DATA32_ATU_3B;
          end
      end
  end

always @( posedge CLKC )
  begin
    if (RSTC==1'b0)
      begin
        if (TEST_ENABLEC==1'b0)
          r_DATA32_0C =  idle_patternRST;
        else
          r_DATA32_0C =  idle_pattern5A;
        r_DATA32_1C =  idle_pattern5A;
        r_DATA32_2C =  idle_pattern5A;
        r_DATA32_3C =  idle_pattern5A;
      end
    else
      begin
        if (TEST_ENABLEC==1'b0)
          begin
            if (CALIBRATION_BUSYC==1'b0)
              r_DATA32_0C =  DATA32_DTUC;
            else
              r_DATA32_0C =  idle_patternRST;
            r_DATA32_1C =  idle_pattern5A;
            r_DATA32_2C =  idle_pattern5A;
            r_DATA32_3C =  idle_pattern5A;
          end
        else
          begin
            r_DATA32_0C =  DATA32_ATU_0C;
            r_DATA32_1C =  DATA32_ATU_1C;
            r_DATA32_2C =  DATA32_ATU_2C;
            r_DATA32_3C =  DATA32_ATU_3C;
          end
      end
  end
wire [Nbits_32-1:0] DATA32_0_synchA;
wire [Nbits_32-1:0] DATA32_0_synchB;
wire [Nbits_32-1:0] DATA32_0_synchC;
wire [Nbits_32-1:0] DATA32_1_synchA;
wire [Nbits_32-1:0] DATA32_1_synchB;
wire [Nbits_32-1:0] DATA32_1_synchC;
wire [Nbits_32-1:0] DATA32_2_synchA;
wire [Nbits_32-1:0] DATA32_2_synchB;
wire [Nbits_32-1:0] DATA32_2_synchC;
wire [Nbits_32-1:0] DATA32_3_synchA;
wire [Nbits_32-1:0] DATA32_3_synchB;
wire [Nbits_32-1:0] DATA32_3_synchC;
assign DATA32_0_synchA =  r_DATA32_0A;
assign DATA32_0_synchB =  r_DATA32_0B;
assign DATA32_0_synchC =  r_DATA32_0C;
assign DATA32_1_synchA =  r_DATA32_1A;
assign DATA32_1_synchB =  r_DATA32_1B;
assign DATA32_1_synchC =  r_DATA32_1C;
assign DATA32_2_synchA =  r_DATA32_2A;
assign DATA32_2_synchB =  r_DATA32_2B;
assign DATA32_2_synchC =  r_DATA32_2C;
assign DATA32_3_synchA =  r_DATA32_3A;
assign DATA32_3_synchB =  r_DATA32_3B;
assign DATA32_3_synchC =  r_DATA32_3C;
assign DATA32_0 =  DATA32_0_synch;
assign DATA32_1 =  DATA32_1_synch;
assign DATA32_2 =  DATA32_2_synch;
assign DATA32_3 =  DATA32_3_synch;

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_0_synchVoter (
    .inA(DATA32_0_synchA),
    .inB(DATA32_0_synchB),
    .inC(DATA32_0_synchC),
    .out(DATA32_0_synch),
    .tmrErr(DATA32_0_synchTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_1_synchVoter (
    .inA(DATA32_1_synchA),
    .inB(DATA32_1_synchB),
    .inC(DATA32_1_synchC),
    .out(DATA32_1_synch),
    .tmrErr(DATA32_1_synchTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_2_synchVoter (
    .inA(DATA32_2_synchA),
    .inB(DATA32_2_synchB),
    .inC(DATA32_2_synchC),
    .out(DATA32_2_synch),
    .tmrErr(DATA32_2_synchTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_3_synchVoter (
    .inA(DATA32_3_synchA),
    .inB(DATA32_3_synchB),
    .inC(DATA32_3_synchC),
    .out(DATA32_3_synch),
    .tmrErr(DATA32_3_synchTmrError)
    );
assign tmrError =  DATA32_0_synchTmrError|DATA32_1_synchTmrError|DATA32_2_synchTmrError|DATA32_3_synchTmrError;

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_1Fanout (
    .in(DATA32_ATU_1),
    .outA(DATA32_ATU_1A),
    .outB(DATA32_ATU_1B),
    .outC(DATA32_ATU_1C)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_DTUFanout (
    .in(DATA32_DTU),
    .outA(DATA32_DTUA),
    .outB(DATA32_DTUB),
    .outC(DATA32_DTUC)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_0Fanout (
    .in(DATA32_ATU_0),
    .outA(DATA32_ATU_0A),
    .outB(DATA32_ATU_0B),
    .outC(DATA32_ATU_0C)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_2Fanout (
    .in(DATA32_ATU_2),
    .outA(DATA32_ATU_2A),
    .outB(DATA32_ATU_2B),
    .outC(DATA32_ATU_2C)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_3Fanout (
    .in(DATA32_ATU_3),
    .outA(DATA32_ATU_3A),
    .outB(DATA32_ATU_3B),
    .outC(DATA32_ATU_3C)
    );
endmodule

