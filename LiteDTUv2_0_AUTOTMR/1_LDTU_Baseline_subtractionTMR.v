/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/1_LDTU_Baseline_subtractionTMR.v                                *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 19/04/2021 14:40:31                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 1_LDTU_Baseline_subtraction.v                                                          *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-04-15 14:29:02.985750                                         *
 *           File Size         : 2980                                                               *
 *           MD5 hash          : 8c78926e67b377645338b61b7893e8b8                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale    1ps/1ps
module LDTU_BSTMR(
  DCLK_1,
  DCLK_10,
  rst_bA,
  rst_bB,
  rst_bC,
  DATA12_g01,
  DATA12_g10,
  shift_gain_10A,
  shift_gain_10B,
  shift_gain_10C,
  BSL_VAL_g01,
  BSL_VAL_g10,
  DATA_gain_01,
  DATA_gain_10,
  SeuError
);
parameter    Nbits_12=12;
parameter    Nbits_8=8;
wire DCLK_1C;
wire DCLK_1B;
wire DCLK_1A;
wire [Nbits_12-1:0] DATA12_g10C;
wire [Nbits_12-1:0] DATA12_g10B;
wire [Nbits_12-1:0] DATA12_g10A;
wire [Nbits_12-1:0] DATA12_g01C;
wire [Nbits_12-1:0] DATA12_g01B;
wire [Nbits_12-1:0] DATA12_g01A;
wire DCLK_10C;
wire DCLK_10B;
wire DCLK_10A;
wire [Nbits_8-1:0] BSL_VAL_g10C;
wire [Nbits_8-1:0] BSL_VAL_g10B;
wire [Nbits_8-1:0] BSL_VAL_g10A;
wire [Nbits_8-1:0] BSL_VAL_g01C;
wire [Nbits_8-1:0] BSL_VAL_g01B;
wire [Nbits_8-1:0] BSL_VAL_g01A;
wire tmrError;
wor dg10_synchTmrError;
wor dg01_synchTmrError;
wire [Nbits_12-1:0] dg10_synch;
wire [Nbits_12-1:0] dg01_synch;
input DCLK_1;
input DCLK_10;
input rst_bA;
input rst_bB;
input rst_bC;
input [Nbits_12-1:0] DATA12_g01;
input [Nbits_12-1:0] DATA12_g10;
input [Nbits_8-1:0] BSL_VAL_g01;
input [Nbits_8-1:0] BSL_VAL_g10;
input [1:0] shift_gain_10A;
input [1:0] shift_gain_10B;
input [1:0] shift_gain_10C;
output [Nbits_12-1:0] DATA_gain_01;
output [Nbits_12-1:0] DATA_gain_10;
output SeuError;
wire [Nbits_12-1:0] b_val_g01A;
wire [Nbits_12-1:0] b_val_g01B;
wire [Nbits_12-1:0] b_val_g01C;
wire [Nbits_12-1:0] b_val_g10A;
wire [Nbits_12-1:0] b_val_g10B;
wire [Nbits_12-1:0] b_val_g10C;
wire dg01_TmrErrorA;
wire dg01_TmrErrorB;
wire dg01_TmrErrorC;
wire dg10_TmrErrorA;
wire dg10_TmrErrorB;
wire dg10_TmrErrorC;
reg  [Nbits_12-1:0] d_g01A;
reg  [Nbits_12-1:0] d_g01B;
reg  [Nbits_12-1:0] d_g01C;
reg  [Nbits_12-1:0] d_g10A;
reg  [Nbits_12-1:0] d_g10B;
reg  [Nbits_12-1:0] d_g10C;
reg  [Nbits_12-1:0] dg01_synchA;
reg  [Nbits_12-1:0] dg01_synchB;
reg  [Nbits_12-1:0] dg01_synchC;
reg  [Nbits_12-1:0] dg10_synchA;
reg  [Nbits_12-1:0] dg10_synchB;
reg  [Nbits_12-1:0] dg10_synchC;
wire [Nbits_12-1:0] dg01A;
wire [Nbits_12-1:0] dg01B;
wire [Nbits_12-1:0] dg01C;
wire [Nbits_12-1:0] dg10A;
wire [Nbits_12-1:0] dg10B;
wire [Nbits_12-1:0] dg10C;
assign SeuError =  tmrError;
assign b_val_g01A =  {4'b0,BSL_VAL_g01A};
assign b_val_g01B =  {4'b0,BSL_VAL_g01B};
assign b_val_g01C =  {4'b0,BSL_VAL_g01C};
assign b_val_g10A =  {4'b0,BSL_VAL_g10A};
assign b_val_g10B =  {4'b0,BSL_VAL_g10B};
assign b_val_g10C =  {4'b0,BSL_VAL_g10C};

always @( posedge DCLK_1A )
  begin
    if (rst_bA==1'b0)
      d_g01A <= 12'b0;
    else
      d_g01A <= DATA12_g01A;
  end

always @( posedge DCLK_1B )
  begin
    if (rst_bB==1'b0)
      d_g01B <= 12'b0;
    else
      d_g01B <= DATA12_g01B;
  end

always @( posedge DCLK_1C )
  begin
    if (rst_bC==1'b0)
      d_g01C <= 12'b0;
    else
      d_g01C <= DATA12_g01C;
  end

always @( posedge DCLK_10A )
  begin
    if (rst_bA==1'b0)
      d_g10A <= 12'b0;
    else
      d_g10A <= DATA12_g10A>>shift_gain_10A;
  end

always @( posedge DCLK_10B )
  begin
    if (rst_bB==1'b0)
      d_g10B <= 12'b0;
    else
      d_g10B <= DATA12_g10B>>shift_gain_10B;
  end

always @( posedge DCLK_10C )
  begin
    if (rst_bC==1'b0)
      d_g10C <= 12'b0;
    else
      d_g10C <= DATA12_g10C>>shift_gain_10C;
  end
assign dg01A =  d_g01A-b_val_g01A;
assign dg01B =  d_g01B-b_val_g01B;
assign dg01C =  d_g01C-b_val_g01C;
assign dg10A =  d_g10A-b_val_g10A;
assign dg10B =  d_g10B-b_val_g10B;
assign dg10C =  d_g10C-b_val_g10C;

always @( posedge DCLK_1A )
  begin
    if (dg01A>d_g01A)
      begin
        dg01_synchA <= 12'b0;
      end
    else
      begin
        dg01_synchA <= dg01A;
      end
  end

always @( posedge DCLK_1B )
  begin
    if (dg01B>d_g01B)
      begin
        dg01_synchB <= 12'b0;
      end
    else
      begin
        dg01_synchB <= dg01B;
      end
  end

always @( posedge DCLK_1C )
  begin
    if (dg01C>d_g01C)
      begin
        dg01_synchC <= 12'b0;
      end
    else
      begin
        dg01_synchC <= dg01C;
      end
  end

always @( posedge DCLK_10A )
  begin
    if (dg10A>d_g10A)
      begin
        dg10_synchA <= 12'b0;
      end
    else
      begin
        dg10_synchA <= dg10A;
      end
  end

always @( posedge DCLK_10B )
  begin
    if (dg10B>d_g10B)
      begin
        dg10_synchB <= 12'b0;
      end
    else
      begin
        dg10_synchB <= dg10B;
      end
  end

always @( posedge DCLK_10C )
  begin
    if (dg10C>d_g10C)
      begin
        dg10_synchC <= 12'b0;
      end
    else
      begin
        dg10_synchC <= dg10C;
      end
  end
assign DATA_gain_01 =  dg01_synch;
assign DATA_gain_10 =  dg10_synch;

majorityVoter #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) dg01_synchVoter (
    .inA(dg01_synchA),
    .inB(dg01_synchB),
    .inC(dg01_synchC),
    .out(dg01_synch),
    .tmrErr(dg01_synchTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) dg10_synchVoter (
    .inA(dg10_synchA),
    .inB(dg10_synchB),
    .inC(dg10_synchC),
    .out(dg10_synch),
    .tmrErr(dg10_synchTmrError)
    );
assign tmrError =  dg01_synchTmrError|dg10_synchTmrError;

fanout #(.WIDTH(((Nbits_8-1)>(0)) ? ((Nbits_8-1)-(0)+1) : ((0)-(Nbits_8-1)+1))) BSL_VAL_g01Fanout (
    .in(BSL_VAL_g01),
    .outA(BSL_VAL_g01A),
    .outB(BSL_VAL_g01B),
    .outC(BSL_VAL_g01C)
    );

fanout #(.WIDTH(((Nbits_8-1)>(0)) ? ((Nbits_8-1)-(0)+1) : ((0)-(Nbits_8-1)+1))) BSL_VAL_g10Fanout (
    .in(BSL_VAL_g10),
    .outA(BSL_VAL_g10A),
    .outB(BSL_VAL_g10B),
    .outC(BSL_VAL_g10C)
    );

fanout DCLK_10Fanout (
    .in(DCLK_10),
    .outA(DCLK_10A),
    .outB(DCLK_10B),
    .outC(DCLK_10C)
    );

fanout #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) DATA12_g01Fanout (
    .in(DATA12_g01),
    .outA(DATA12_g01A),
    .outB(DATA12_g01B),
    .outC(DATA12_g01C)
    );

fanout #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) DATA12_g10Fanout (
    .in(DATA12_g10),
    .outA(DATA12_g10A),
    .outB(DATA12_g10B),
    .outC(DATA12_g10C)
    );

fanout DCLK_1Fanout (
    .in(DCLK_1),
    .outA(DCLK_1A),
    .outB(DCLK_1B),
    .outC(DCLK_1C)
    );
endmodule

