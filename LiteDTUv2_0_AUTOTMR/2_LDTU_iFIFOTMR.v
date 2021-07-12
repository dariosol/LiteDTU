/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/2_LDTU_iFIFOTMR.v                                               *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 12/07/2021 12:08:09                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 2_LDTU_iFIFO.v                                                                         *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-07-12 12:03:31.503268                                         *
 *           File Size         : 6238                                                               *
 *           MD5 hash          : 110e06ddc98982288932a9a8bc8e9406                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale    1ns/1ps

module LDTU_iFIFOTMR(
  DCLK_1,
  DCLK_10,
  CLKA,
  CLKB,
  CLKC,
  rst_bA,
  rst_bB,
  rst_bC,
  GAIN_SEL_MODE,
  DATA_gain_01,
  DATA_gain_10,
  SATURATION_value,
  shift_gain_10,
  DATA_to_enc,
  baseline_flag,
  SeuError
);
parameter    Nbits_7=7;
parameter    Nbits_12=12;
parameter    FifoDepth2=16;
parameter    FifoDepth=8;
parameter    NBitsCnt=4;
parameter    RefSample=4'b0011;
parameter    RefSample2=4'b1001;
parameter    LookAheadDepth=16;
wire [Nbits_12-1:0] DATA_gain_01C;
wire [Nbits_12-1:0] DATA_gain_01B;
wire [Nbits_12-1:0] DATA_gain_01A;
wire DCLK_1C;
wire DCLK_1B;
wire DCLK_1A;
wire [1:0] shift_gain_10C;
wire [1:0] shift_gain_10B;
wire [1:0] shift_gain_10A;
wire [1:0] GAIN_SEL_MODEC;
wire [1:0] GAIN_SEL_MODEB;
wire [1:0] GAIN_SEL_MODEA;
wire [Nbits_12-1:0] DATA_gain_10C;
wire [Nbits_12-1:0] DATA_gain_10B;
wire [Nbits_12-1:0] DATA_gain_10A;
wire DCLK_10C;
wire DCLK_10B;
wire DCLK_10A;
wire [Nbits_12-1:0] SATURATION_valueC;
wire [Nbits_12-1:0] SATURATION_valueB;
wire [Nbits_12-1:0] SATURATION_valueA;
wire tmrErrorC;
wor wrL_ptrTmrErrorC;
wor wrH_ptrTmrErrorC;
wor rd_ptrTmrErrorC;
wire [NBitsCnt-1:0] wrL_ptrVotedC;
wire [NBitsCnt-1:0] wrH_ptrVotedC;
wire [NBitsCnt-1:0] rd_ptrVotedC;
wire tmrErrorB;
wor wrL_ptrTmrErrorB;
wor wrH_ptrTmrErrorB;
wor rd_ptrTmrErrorB;
wire [NBitsCnt-1:0] wrL_ptrVotedB;
wire [NBitsCnt-1:0] wrH_ptrVotedB;
wire [NBitsCnt-1:0] rd_ptrVotedB;
wire tmrErrorA;
wor wrL_ptrTmrErrorA;
wor wrH_ptrTmrErrorA;
wor rd_ptrTmrErrorA;
wire [NBitsCnt-1:0] wrL_ptrVotedA;
wire [NBitsCnt-1:0] rd_ptrVotedA;
wire [NBitsCnt-1:0] wrH_ptrVotedA;
wire tmrError;
wor d2encTmrError;
wor bsflagTmrError;
wire [Nbits_12:0] d2enc;
wire bsflag;
input DCLK_1;
input DCLK_10;
input CLKA;
input CLKB;
input CLKC;
input rst_bA;
input rst_bB;
input rst_bC;
input [1:0] GAIN_SEL_MODE;
input [Nbits_12-1:0] DATA_gain_01;
input [Nbits_12-1:0] DATA_gain_10;
input [Nbits_12-1:0] SATURATION_value;
input [1:0] shift_gain_10;
output [Nbits_12:0] DATA_to_enc;
output baseline_flag;
output SeuError;
assign SeuError =  tmrError;
reg  [NBitsCnt-1:0] wrH_ptrA;
reg  [NBitsCnt-1:0] wrH_ptrB;
reg  [NBitsCnt-1:0] wrH_ptrC;
reg  [NBitsCnt-1:0] wrL_ptrA;
reg  [NBitsCnt-1:0] wrL_ptrB;
reg  [NBitsCnt-1:0] wrL_ptrC;
reg  [Nbits_12-1:0] SATvalA;
reg  [Nbits_12-1:0] SATvalB;
reg  [Nbits_12-1:0] SATvalC;
reg  [Nbits_12-1:0] FIFO_g1A [ LookAheadDepth-1 : 0 ] ;
reg  [Nbits_12-1:0] FIFO_g1B [ LookAheadDepth-1 : 0 ] ;
reg  [Nbits_12-1:0] FIFO_g1C [ LookAheadDepth-1 : 0 ] ;
reg  [Nbits_12-1:0] FIFO_g10A [ LookAheadDepth-1 : 0 ] ;
reg  [Nbits_12-1:0] FIFO_g10B [ LookAheadDepth-1 : 0 ] ;
reg  [Nbits_12-1:0] FIFO_g10C [ LookAheadDepth-1 : 0 ] ;
reg  [NBitsCnt-1:0] rd_ptrA;
reg  [NBitsCnt-1:0] rd_ptrB;
reg  [NBitsCnt-1:0] rd_ptrC;
wire [NBitsCnt-1:0] ref_ptrA;
wire [NBitsCnt-1:0] ref_ptrB;
wire [NBitsCnt-1:0] ref_ptrC;
wire [Nbits_12-1:0] FIFO_g10_refA;
wire [Nbits_12-1:0] FIFO_g10_refB;
wire [Nbits_12-1:0] FIFO_g10_refC;
wire ref_satA;
wire ref_satB;
wire ref_satC;
reg  [FifoDepth-1:0] gain_selA;
reg  [FifoDepth-1:0] gain_selB;
reg  [FifoDepth-1:0] gain_selC;
reg  [FifoDepth2-1:0] gain_sel2A;
reg  [FifoDepth2-1:0] gain_sel2B;
reg  [FifoDepth2-1:0] gain_sel2C;
wire [Nbits_12-1:0] dout_g1A;
wire [Nbits_12-1:0] dout_g1B;
wire [Nbits_12-1:0] dout_g1C;
wire [Nbits_12-1:0] dout_g10A;
wire [Nbits_12-1:0] dout_g10B;
wire [Nbits_12-1:0] dout_g10C;
wire [Nbits_12:0] d2encA;
wire [Nbits_12:0] d2encB;
wire [Nbits_12:0] d2encC;
wire bsflagA;
wire bsflagB;
wire bsflagC;
wire [1:0] GAIN_SEL_MODE;
integer iHA;
integer iHB;
integer iHC;
integer iLA;
integer iLB;
integer iLC;

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      SATvalA <= 12'hfff;
    else
      SATvalA <= SATURATION_valueA>>shift_gain_10A;
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      SATvalB <= 12'hfff;
    else
      SATvalB <= SATURATION_valueB>>shift_gain_10B;
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      SATvalC <= 12'hfff;
    else
      SATvalC <= SATURATION_valueC>>shift_gain_10C;
  end

always @( negedge DCLK_10A )
  begin
    if (rst_bA==1'b0)
      wrH_ptrA <= 4'b0000;
    else
      wrH_ptrA <= wrH_ptrVotedA+4'b0001;
  end

always @( negedge DCLK_10B )
  begin
    if (rst_bB==1'b0)
      wrH_ptrB <= 4'b0000;
    else
      wrH_ptrB <= wrH_ptrVotedB+4'b0001;
  end

always @( negedge DCLK_10C )
  begin
    if (rst_bC==1'b0)
      wrH_ptrC <= 4'b0000;
    else
      wrH_ptrC <= wrH_ptrVotedC+4'b0001;
  end

always @( negedge DCLK_1A )
  begin
    if (rst_bA==1'b0)
      wrL_ptrA <= 4'b0000;
    else
      wrL_ptrA <= wrL_ptrVotedA+4'b0001;
  end

always @( negedge DCLK_1B )
  begin
    if (rst_bB==1'b0)
      wrL_ptrB <= 4'b0000;
    else
      wrL_ptrB <= wrL_ptrVotedB+4'b0001;
  end

always @( negedge DCLK_1C )
  begin
    if (rst_bC==1'b0)
      wrL_ptrC <= 4'b0000;
    else
      wrL_ptrC <= wrL_ptrVotedC+4'b0001;
  end

always @( negedge DCLK_1A )
  begin
    if (rst_bA==1'b0)
      begin
        for(iLA =  0;iLA<LookAheadDepth;iLA =  iLA+1)
          begin
            FIFO_g1A[iLA]  <= 12'b0;
          end
      end
    else
      begin
        FIFO_g1A[wrL_ptrVotedA]  <= DATA_gain_01A;
      end
  end

always @( negedge DCLK_1B )
  begin
    if (rst_bB==1'b0)
      begin
        for(iLB =  0;iLB<LookAheadDepth;iLB =  iLB+1)
          begin
            FIFO_g1B[iLB]  <= 12'b0;
          end
      end
    else
      begin
        FIFO_g1B[wrL_ptrVotedB]  <= DATA_gain_01B;
      end
  end

always @( negedge DCLK_1C )
  begin
    if (rst_bC==1'b0)
      begin
        for(iLC =  0;iLC<LookAheadDepth;iLC =  iLC+1)
          begin
            FIFO_g1C[iLC]  <= 12'b0;
          end
      end
    else
      begin
        FIFO_g1C[wrL_ptrVotedC]  <= DATA_gain_01C;
      end
  end

always @( negedge DCLK_10A )
  begin
    if (rst_bA==1'b0)
      begin
        for(iHA =  0;iHA<LookAheadDepth;iHA =  iHA+1)
          begin
            FIFO_g10A[iHA]  <= 12'b0;
          end
      end
    else
      begin
        FIFO_g10A[wrH_ptrVotedA]  <= DATA_gain_10A;
      end
  end

always @( negedge DCLK_10B )
  begin
    if (rst_bB==1'b0)
      begin
        for(iHB =  0;iHB<LookAheadDepth;iHB =  iHB+1)
          begin
            FIFO_g10B[iHB]  <= 12'b0;
          end
      end
    else
      begin
        FIFO_g10B[wrH_ptrVotedB]  <= DATA_gain_10B;
      end
  end

always @( negedge DCLK_10C )
  begin
    if (rst_bC==1'b0)
      begin
        for(iHC =  0;iHC<LookAheadDepth;iHC =  iHC+1)
          begin
            FIFO_g10C[iHC]  <= 12'b0;
          end
      end
    else
      begin
        FIFO_g10C[wrH_ptrVotedC]  <= DATA_gain_10C;
      end
  end

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      rd_ptrA <= 4'b0110;
    else
      rd_ptrA <= rd_ptrVotedA+4'b0001;
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      rd_ptrB <= 4'b0110;
    else
      rd_ptrB <= rd_ptrVotedB+4'b0001;
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      rd_ptrC <= 4'b0110;
    else
      rd_ptrC <= rd_ptrVotedC+4'b0001;
  end
assign ref_ptrA =  (GAIN_SEL_MODEA==2'b01) ? (rd_ptrVotedA+RefSample2) : (rd_ptrVotedA+RefSample);
assign ref_ptrB =  (GAIN_SEL_MODEB==2'b01) ? (rd_ptrVotedB+RefSample2) : (rd_ptrVotedB+RefSample);
assign ref_ptrC =  (GAIN_SEL_MODEC==2'b01) ? (rd_ptrVotedC+RefSample2) : (rd_ptrVotedC+RefSample);
assign FIFO_g10_refA =  FIFO_g10A[ref_ptrA] ;
assign FIFO_g10_refB =  FIFO_g10B[ref_ptrB] ;
assign FIFO_g10_refC =  FIFO_g10C[ref_ptrC] ;
assign ref_satA =  (GAIN_SEL_MODEA==2'b11) ? 1'b1 : (GAIN_SEL_MODEA==2'b10) ? 1'b0 : (FIFO_g10_refA>=SATvalA) ? 1'b1 : 1'b0;
assign ref_satB =  (GAIN_SEL_MODEB==2'b11) ? 1'b1 : (GAIN_SEL_MODEB==2'b10) ? 1'b0 : (FIFO_g10_refB>=SATvalB) ? 1'b1 : 1'b0;
assign ref_satC =  (GAIN_SEL_MODEC==2'b11) ? 1'b1 : (GAIN_SEL_MODEC==2'b10) ? 1'b0 : (FIFO_g10_refC>=SATvalC) ? 1'b1 : 1'b0;

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      gain_selA <= 8'b0;
    else
      begin
        if (GAIN_SEL_MODEA==2'b00)
          gain_selA <= {gain_selA[FifoDepth-2:0] ,ref_satA};
        else
          begin
            if (GAIN_SEL_MODEA==2'b11)
              gain_selA <= {gain_selA[FifoDepth-2:0] ,ref_satA};
            else
              gain_selA <= 8'b0;
          end
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      gain_selB <= 8'b0;
    else
      begin
        if (GAIN_SEL_MODEB==2'b00)
          gain_selB <= {gain_selB[FifoDepth-2:0] ,ref_satB};
        else
          begin
            if (GAIN_SEL_MODEB==2'b11)
              gain_selB <= {gain_selB[FifoDepth-2:0] ,ref_satB};
            else
              gain_selB <= 8'b0;
          end
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      gain_selC <= 8'b0;
    else
      begin
        if (GAIN_SEL_MODEC==2'b00)
          gain_selC <= {gain_selC[FifoDepth-2:0] ,ref_satC};
        else
          begin
            if (GAIN_SEL_MODEC==2'b11)
              gain_selC <= {gain_selC[FifoDepth-2:0] ,ref_satC};
            else
              gain_selC <= 8'b0;
          end
      end
  end

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      gain_sel2A <= 16'b0;
    else
      begin
        if (GAIN_SEL_MODEA==2'b01)
          gain_sel2A <= {gain_sel2A[FifoDepth2-2:0] ,ref_satA};
        else
          gain_sel2A <= 16'b0;
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      gain_sel2B <= 16'b0;
    else
      begin
        if (GAIN_SEL_MODEB==2'b01)
          gain_sel2B <= {gain_sel2B[FifoDepth2-2:0] ,ref_satB};
        else
          gain_sel2B <= 16'b0;
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      gain_sel2C <= 16'b0;
    else
      begin
        if (GAIN_SEL_MODEC==2'b01)
          gain_sel2C <= {gain_sel2C[FifoDepth2-2:0] ,ref_satC};
        else
          gain_sel2C <= 16'b0;
      end
  end
assign dout_g1A =  FIFO_g1A[rd_ptrVotedA] ;
assign dout_g1B =  FIFO_g1B[rd_ptrVotedB] ;
assign dout_g1C =  FIFO_g1C[rd_ptrVotedC] ;
assign dout_g10A =  FIFO_g10A[rd_ptrVotedA] ;
assign dout_g10B =  FIFO_g10B[rd_ptrVotedB] ;
assign dout_g10C =  FIFO_g10C[rd_ptrVotedC] ;
wire decision1A;
wire decision2A;
wire decision1B;
wire decision2B;
wire decision1C;
wire decision2C;
assign decision1A =  (gain_selA==8'b0) ? 1'b1 : 1'b0;
assign decision1B =  (gain_selB==8'b0) ? 1'b1 : 1'b0;
assign decision1C =  (gain_selC==8'b0) ? 1'b1 : 1'b0;
assign decision2A =  (gain_sel2A==16'b0) ? 1'b1 : 1'b0;
assign decision2B =  (gain_sel2B==16'b0) ? 1'b1 : 1'b0;
assign decision2C =  (gain_sel2C==16'b0) ? 1'b1 : 1'b0;
assign d2encA =  (decision1A&&decision2A) ? {1'b0,dout_g10A} : {1'b1,dout_g1A};
assign d2encB =  (decision1B&&decision2B) ? {1'b0,dout_g10B} : {1'b1,dout_g1B};
assign d2encC =  (decision1C&&decision2C) ? {1'b0,dout_g10C} : {1'b1,dout_g1C};
wire bas_flagA;
wire bas_flagB;
wire bas_flagC;
wire b_flagA;
wire b_flagB;
wire b_flagC;
assign bas_flagA =  (d2encA[12:6] ==7'b0) ? 1'b1 : 1'b0;
assign bas_flagB =  (d2encB[12:6] ==7'b0) ? 1'b1 : 1'b0;
assign bas_flagC =  (d2encC[12:6] ==7'b0) ? 1'b1 : 1'b0;
assign b_flagA =  (d2encA[11:6] ==6'b0) ? 1'b1 : 1'b0;
assign b_flagB =  (d2encB[11:6] ==6'b0) ? 1'b1 : 1'b0;
assign b_flagC =  (d2encC[11:6] ==6'b0) ? 1'b1 : 1'b0;
assign bsflagA =  (GAIN_SEL_MODEA[1] ==1'b0) ? bas_flagA : b_flagA;
assign bsflagB =  (GAIN_SEL_MODEB[1] ==1'b0) ? bas_flagB : b_flagB;
assign bsflagC =  (GAIN_SEL_MODEC[1] ==1'b0) ? bas_flagC : b_flagC;
assign DATA_to_enc =  d2enc;
assign baseline_flag =  bsflag;

majorityVoter bsflagVoter (
    .inA(bsflagA),
    .inB(bsflagB),
    .inC(bsflagC),
    .out(bsflag),
    .tmrErr(bsflagTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_12)>(0)) ? ((Nbits_12)-(0)+1) : ((0)-(Nbits_12)+1))) d2encVoter (
    .inA(d2encA),
    .inB(d2encB),
    .inC(d2encC),
    .out(d2enc),
    .tmrErr(d2encTmrError)
    );
assign tmrError =  bsflagTmrError|d2encTmrError;

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) wrH_ptrVoterA (
    .inA(wrH_ptrA),
    .inB(wrH_ptrB),
    .inC(wrH_ptrC),
    .out(wrH_ptrVotedA),
    .tmrErr(wrH_ptrTmrErrorA)
    );

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) rd_ptrVoterA (
    .inA(rd_ptrA),
    .inB(rd_ptrB),
    .inC(rd_ptrC),
    .out(rd_ptrVotedA),
    .tmrErr(rd_ptrTmrErrorA)
    );

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) wrL_ptrVoterA (
    .inA(wrL_ptrA),
    .inB(wrL_ptrB),
    .inC(wrL_ptrC),
    .out(wrL_ptrVotedA),
    .tmrErr(wrL_ptrTmrErrorA)
    );
assign tmrErrorA =  rd_ptrTmrErrorA|wrH_ptrTmrErrorA|wrL_ptrTmrErrorA;

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) rd_ptrVoterB (
    .inA(rd_ptrA),
    .inB(rd_ptrB),
    .inC(rd_ptrC),
    .out(rd_ptrVotedB),
    .tmrErr(rd_ptrTmrErrorB)
    );

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) wrH_ptrVoterB (
    .inA(wrH_ptrA),
    .inB(wrH_ptrB),
    .inC(wrH_ptrC),
    .out(wrH_ptrVotedB),
    .tmrErr(wrH_ptrTmrErrorB)
    );

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) wrL_ptrVoterB (
    .inA(wrL_ptrA),
    .inB(wrL_ptrB),
    .inC(wrL_ptrC),
    .out(wrL_ptrVotedB),
    .tmrErr(wrL_ptrTmrErrorB)
    );
assign tmrErrorB =  rd_ptrTmrErrorB|wrH_ptrTmrErrorB|wrL_ptrTmrErrorB;

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) rd_ptrVoterC (
    .inA(rd_ptrA),
    .inB(rd_ptrB),
    .inC(rd_ptrC),
    .out(rd_ptrVotedC),
    .tmrErr(rd_ptrTmrErrorC)
    );

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) wrH_ptrVoterC (
    .inA(wrH_ptrA),
    .inB(wrH_ptrB),
    .inC(wrH_ptrC),
    .out(wrH_ptrVotedC),
    .tmrErr(wrH_ptrTmrErrorC)
    );

majorityVoter #(.WIDTH(((NBitsCnt-1)>(0)) ? ((NBitsCnt-1)-(0)+1) : ((0)-(NBitsCnt-1)+1))) wrL_ptrVoterC (
    .inA(wrL_ptrA),
    .inB(wrL_ptrB),
    .inC(wrL_ptrC),
    .out(wrL_ptrVotedC),
    .tmrErr(wrL_ptrTmrErrorC)
    );
assign tmrErrorC =  rd_ptrTmrErrorC|wrH_ptrTmrErrorC|wrL_ptrTmrErrorC;

fanout #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) SATURATION_valueFanout (
    .in(SATURATION_value),
    .outA(SATURATION_valueA),
    .outB(SATURATION_valueB),
    .outC(SATURATION_valueC)
    );

fanout DCLK_10Fanout (
    .in(DCLK_10),
    .outA(DCLK_10A),
    .outB(DCLK_10B),
    .outC(DCLK_10C)
    );

fanout #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) DATA_gain_10Fanout (
    .in(DATA_gain_10),
    .outA(DATA_gain_10A),
    .outB(DATA_gain_10B),
    .outC(DATA_gain_10C)
    );

fanout #(.WIDTH(2)) GAIN_SEL_MODEFanout (
    .in(GAIN_SEL_MODE),
    .outA(GAIN_SEL_MODEA),
    .outB(GAIN_SEL_MODEB),
    .outC(GAIN_SEL_MODEC)
    );

fanout #(.WIDTH(2)) shift_gain_10Fanout (
    .in(shift_gain_10),
    .outA(shift_gain_10A),
    .outB(shift_gain_10B),
    .outC(shift_gain_10C)
    );

fanout DCLK_1Fanout (
    .in(DCLK_1),
    .outA(DCLK_1A),
    .outB(DCLK_1B),
    .outC(DCLK_1C)
    );

fanout #(.WIDTH(((Nbits_12-1)>(0)) ? ((Nbits_12-1)-(0)+1) : ((0)-(Nbits_12-1)+1))) DATA_gain_01Fanout (
    .in(DATA_gain_01),
    .outA(DATA_gain_01A),
    .outB(DATA_gain_01B),
    .outC(DATA_gain_01C)
    );
endmodule

