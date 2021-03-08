/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/3_LDTU_Encoder_NoRegTMR.v                                       *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 07/03/2021 17:29:04                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/Last_DTU_v2_NoReg.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/                     *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 3_LDTU_Encoder_NoReg.v                                                                 *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-03-07 16:25:37.014309                                         *
 *           File Size         : 10962                                                              *
 *           MD5 hash          : 329120bdd4a87c911b3e0cf3ff473ce4                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale       1ps/1ps

module Delay_enc(
  clk,
  reset,
  D,
  Dd
);
input clk;
input reset;
input [12:0] D;
output reg   [12:0] Dd;

always @( posedge clk )
  begin
    if (reset==1'b0)
      Dd <= 13'b0;
    else
      Dd <= D;
  end
endmodule

module LDTU_EncoderTMR(
  CLKA,
  CLKB,
  CLKC,
  rst_bA,
  rst_bB,
  rst_bC,
  Orbit,
  fallback,
  baseline_flag,
  DATA_to_enc,
  DATA_32,
  Load,
  DATA_32_FB,
  Load_FB,
  SeuError
);
parameter    SIZE=4;
parameter    Nbits_6=6;
parameter    Nbits_12=12;
parameter    Nbits_32=32;
parameter    code_sel_sign1=6'b001010;
parameter    code_sel_sign2=6'b001011;
parameter    code_sel_bas1=2'b01;
parameter    code_sel_bas2=2'b10;
parameter    sync=13'b0101010101010;
parameter    one=24'b000001000000000000000000;
parameter    two=18'b000010000000000000;
parameter    three=12'b000011000000;
parameter    four=6'b000100;
parameter    Initial=32'b11110000000000000000000000000000;
parameter    Initial_FB=32'b00000000000000000000000000000000;
parameter    header_synch=13'b1111000001111;
parameter    IDLE=5'b00000;
parameter    bas_0=5'b00001;
parameter    bas_1=5'b00010;
parameter    bas_2=5'b00011;
parameter    bas_3=5'b00100;
parameter    bas_4=5'b00101;
parameter    sign_0=5'b00110;
parameter    sign_1=5'b00111;
parameter    bas_0_bis=5'b01000;
parameter    bas_1_bis=5'b01001;
parameter    bas_2_bis=5'b01010;
parameter    bas_3_bis=5'b01011;
parameter    bas_4_bis=5'b01100;
parameter    sign_0_bis=5'b01101;
parameter    sign_1_bis=5'b01110;
parameter    bc0_0=5'b01111;
parameter    bc0_1=5'b10000;
parameter    bc0_2=5'b10001;
parameter    bc0_3=5'b10010;
parameter    bc0_4=5'b10011;
parameter    header=5'b10100;
parameter    header_b0=5'b10101;
parameter    bc0_s0=5'b10110;
parameter    header_s0=5'b10111;
parameter    bc0_s0_bis=5'b11000;
parameter    SIZE_FB=3;
parameter    IDLE_FB=3'b000;
parameter    data_odd=3'b001;
parameter    latency1=3'b010;
parameter    data_even=3'b011;
parameter    latency2=3'b100;
wire fallbackC;
wire fallbackB;
wire fallbackA;
wire [Nbits_12:0] DATA_to_encC;
wire [Nbits_12:0] DATA_to_encB;
wire [Nbits_12:0] DATA_to_encA;
wire baseline_flagC;
wire baseline_flagB;
wire baseline_flagA;
wire tmrError;
wor Load_synchTmrError;
wor Load_FB_synchTmrError;
wor DATA_32_synchTmrError;
wor DATA_32_FB_synchTmrError;
wire Load_FB_synch;
wire [Nbits_32-1:0] DATA_32_FB_synch;
wire Load_synch;
wire [Nbits_32-1:0] DATA_32_synch;
input CLKA;
input CLKB;
input CLKC;
input rst_bA;
input rst_bB;
input rst_bC;
input Orbit;
input fallback;
input baseline_flag;
input [Nbits_12:0] DATA_to_enc;
output [Nbits_32-1:0] DATA_32;
output Load;
output [Nbits_32-1:0] DATA_32_FB;
output Load_FB;
output SeuError;
wire [1:0] code_sel_basA;
wire [1:0] code_sel_basB;
wire [1:0] code_sel_basC;
wire [5:0] code_sel_signA;
wire [5:0] code_sel_signB;
wire [5:0] code_sel_signC;
wire Load_FB_synchA;
wire Load_FB_synchB;
wire Load_FB_synchC;
wire [Nbits_32-1:0] DATA_32_FB_synchA;
wire [Nbits_32-1:0] DATA_32_FB_synchB;
wire [Nbits_32-1:0] DATA_32_FB_synchC;
wire Load_synchA;
wire Load_synchB;
wire Load_synchC;
wire [Nbits_32-1:0] DATA_32_synchA;
wire [Nbits_32-1:0] DATA_32_synchB;
wire [Nbits_32-1:0] DATA_32_synchC;
reg  [Nbits_6-1:0] Ld_bas_1A;
reg  [Nbits_6-1:0] Ld_bas_1B;
reg  [Nbits_6-1:0] Ld_bas_1C;
reg  [Nbits_6-1:0] Ld_bas_2A;
reg  [Nbits_6-1:0] Ld_bas_2B;
reg  [Nbits_6-1:0] Ld_bas_2C;
reg  [Nbits_6-1:0] Ld_bas_3A;
reg  [Nbits_6-1:0] Ld_bas_3B;
reg  [Nbits_6-1:0] Ld_bas_3C;
reg  [Nbits_6-1:0] Ld_bas_4A;
reg  [Nbits_6-1:0] Ld_bas_4B;
reg  [Nbits_6-1:0] Ld_bas_4C;
reg  [Nbits_6-1:0] Ld_bas_5A;
reg  [Nbits_6-1:0] Ld_bas_5B;
reg  [Nbits_6-1:0] Ld_bas_5C;
reg  [Nbits_12:0] Ld_sign_1A;
reg  [Nbits_12:0] Ld_sign_1B;
reg  [Nbits_12:0] Ld_sign_1C;
reg  [Nbits_12:0] Ld_sign_2A;
reg  [Nbits_12:0] Ld_sign_2B;
reg  [Nbits_12:0] Ld_sign_2C;
reg  [Nbits_32-1:0] rDATA_32A;
reg  [Nbits_32-1:0] rDATA_32B;
reg  [Nbits_32-1:0] rDATA_32C;
reg  rLoadA;
reg  rLoadB;
reg  rLoadC;
wire [SIZE:0] Current_stateA;
wire [SIZE:0] Current_stateB;
wire [SIZE:0] Current_stateC;
wire [Nbits_12:0] dDATA_to_encA;
wire [Nbits_12:0] dDATA_to_encB;
wire [Nbits_12:0] dDATA_to_encC;
reg  [Nbits_12:0] Ld_sign_FBA;
reg  [Nbits_12:0] Ld_sign_FBB;
reg  [Nbits_12:0] Ld_sign_FBC;
reg  [Nbits_32-1:0] rDATA_32_FBA;
reg  [Nbits_32-1:0] rDATA_32_FBB;
reg  [Nbits_32-1:0] rDATA_32_FBC;
reg  rLoad_FBA;
reg  rLoad_FBB;
reg  rLoad_FBC;
wire [SIZE_FB:0] Current_state_FBA;
wire [SIZE_FB:0] Current_state_FBB;
wire [SIZE_FB:0] Current_state_FBC;
wire fsm_SeuError;
assign SeuError =  tmrError|fsm_SeuError;

Delay_enc delayA (
    .clk(CLKA),
    .reset(rst_bA),
    .D(DATA_to_encA),
    .Dd(dDATA_to_encA)
    );

Delay_enc delayB (
    .clk(CLKB),
    .reset(rst_bB),
    .D(DATA_to_encB),
    .Dd(dDATA_to_encB)
    );

Delay_enc delayC (
    .clk(CLKC),
    .reset(rst_bC),
    .D(DATA_to_encC),
    .Dd(dDATA_to_encC)
    );

LDTU_FSMTMR fsm (
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .rst_bA(rst_bA),
    .rst_bB(rst_bB),
    .rst_bC(rst_bC),
    .baseline_flag(baseline_flag),
    .Orbit(Orbit),
    .fallback(fallback),
    .Current_stateA(Current_stateA),
    .Current_stateB(Current_stateB),
    .Current_stateC(Current_stateC),
    .Current_state_FBA(Current_state_FBA),
    .Current_state_FBB(Current_state_FBB),
    .Current_state_FBC(Current_state_FBC),
    .SeuError(fsm_SeuError)
    );
assign code_sel_basA =  (baseline_flagA==1'b1) ? code_sel_bas1 : code_sel_bas2;
assign code_sel_basB =  (baseline_flagB==1'b1) ? code_sel_bas1 : code_sel_bas2;
assign code_sel_basC =  (baseline_flagC==1'b1) ? code_sel_bas1 : code_sel_bas2;
assign code_sel_signA =  (baseline_flagA==1'b0) ? code_sel_sign1 : code_sel_sign2;
assign code_sel_signB =  (baseline_flagB==1'b0) ? code_sel_sign1 : code_sel_sign2;
assign code_sel_signC =  (baseline_flagC==1'b0) ? code_sel_sign1 : code_sel_sign2;

always @( posedge CLKA )
  begin : FSM_seq_outputA
    if (rst_bA==1'b0||fallbackA==1'b1)
      begin
        Ld_bas_1A <= 6'b0;
        Ld_bas_2A <= 6'b0;
        Ld_bas_3A <= 6'b0;
        Ld_bas_4A <= 6'b0;
        Ld_bas_5A <= 6'b0;
        Ld_sign_1A <= 13'b0;
        Ld_sign_2A <= 13'b0;
        rLoadA <= 1'b0;
        rDATA_32A <= Initial;
      end
    else
      begin
        case (Current_stateA)
          bc0_0 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,one,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bc0_1 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,two,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bc0_2 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,three,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bc0_3 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,four,Ld_bas_4A,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bc0_4 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas1,Ld_bas_5A,Ld_bas_4A,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bc0_s0 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign1,Ld_sign_2A,Ld_sign_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bc0_s0_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign2,sync,Ld_sign_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          header_s0 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign2,header_synch,Ld_sign_1A};
              Ld_bas_1A <= dDATA_to_encA;
              Ld_sign_1A <= dDATA_to_encA;
            end
          header : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign2,header_synch,Ld_sign_1A};
              Ld_bas_1A <= dDATA_to_encA;
              Ld_sign_1A <= dDATA_to_encA;
            end
          header_b0 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign2,header_synch,Ld_sign_1A};
              Ld_bas_1A <= dDATA_to_encA;
              Ld_sign_1A <= dDATA_to_encA;
            end
          IDLE : 
            begin
              rLoadA <= 1'b0;
              rDATA_32A <= Initial;
            end
          bas_0 : 
            begin
              rLoadA <= 1'b0;
              Ld_bas_2A <= dDATA_to_encA;
            end
          bas_0_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,one,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bas_1 : 
            begin
              rLoadA <= 1'b0;
              Ld_bas_3A <= dDATA_to_encA;
            end
          bas_1_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,two,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bas_2 : 
            begin
              rLoadA <= 1'b0;
              Ld_bas_4A <= dDATA_to_encA;
            end
          bas_2_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,three,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bas_3 : 
            begin
              rLoadA <= 1'b0;
              Ld_bas_5A <= dDATA_to_encA;
            end
          bas_3_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas2,four,Ld_bas_4A,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          bas_4 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas1,Ld_bas_5A,Ld_bas_4A,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_bas_1A <= dDATA_to_encA;
            end
          bas_4_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_bas1,Ld_bas_5A,Ld_bas_4A,Ld_bas_3A,Ld_bas_2A,Ld_bas_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          sign_0 : 
            begin
              rLoadA <= 1'b0;
              Ld_sign_2A <= dDATA_to_encA;
            end
          sign_0_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign2,sync,Ld_sign_1A};
              Ld_bas_1A <= dDATA_to_encA;
            end
          sign_1 : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign1,Ld_sign_2A,Ld_sign_1A};
              Ld_sign_1A <= dDATA_to_encA;
            end
          sign_1_bis : 
            begin
              rLoadA <= 1'b1;
              rDATA_32A <= {code_sel_sign1,Ld_sign_2A,Ld_sign_1A};
              Ld_bas_1A <= dDATA_to_encA;
            end
          default : 
            begin
              rLoadA <= 1'b0;
              rDATA_32A <= Initial;
            end
        endcase
      end
  end

always @( posedge CLKB )
  begin : FSM_seq_outputB
    if (rst_bB==1'b0||fallbackB==1'b1)
      begin
        Ld_bas_1B <= 6'b0;
        Ld_bas_2B <= 6'b0;
        Ld_bas_3B <= 6'b0;
        Ld_bas_4B <= 6'b0;
        Ld_bas_5B <= 6'b0;
        Ld_sign_1B <= 13'b0;
        Ld_sign_2B <= 13'b0;
        rLoadB <= 1'b0;
        rDATA_32B <= Initial;
      end
    else
      begin
        case (Current_stateB)
          bc0_0 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,one,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bc0_1 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,two,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bc0_2 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,three,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bc0_3 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,four,Ld_bas_4B,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bc0_4 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas1,Ld_bas_5B,Ld_bas_4B,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bc0_s0 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign1,Ld_sign_2B,Ld_sign_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bc0_s0_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign2,sync,Ld_sign_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          header_s0 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign2,header_synch,Ld_sign_1B};
              Ld_bas_1B <= dDATA_to_encB;
              Ld_sign_1B <= dDATA_to_encB;
            end
          header : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign2,header_synch,Ld_sign_1B};
              Ld_bas_1B <= dDATA_to_encB;
              Ld_sign_1B <= dDATA_to_encB;
            end
          header_b0 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign2,header_synch,Ld_sign_1B};
              Ld_bas_1B <= dDATA_to_encB;
              Ld_sign_1B <= dDATA_to_encB;
            end
          IDLE : 
            begin
              rLoadB <= 1'b0;
              rDATA_32B <= Initial;
            end
          bas_0 : 
            begin
              rLoadB <= 1'b0;
              Ld_bas_2B <= dDATA_to_encB;
            end
          bas_0_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,one,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bas_1 : 
            begin
              rLoadB <= 1'b0;
              Ld_bas_3B <= dDATA_to_encB;
            end
          bas_1_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,two,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bas_2 : 
            begin
              rLoadB <= 1'b0;
              Ld_bas_4B <= dDATA_to_encB;
            end
          bas_2_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,three,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bas_3 : 
            begin
              rLoadB <= 1'b0;
              Ld_bas_5B <= dDATA_to_encB;
            end
          bas_3_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas2,four,Ld_bas_4B,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          bas_4 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas1,Ld_bas_5B,Ld_bas_4B,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_bas_1B <= dDATA_to_encB;
            end
          bas_4_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_bas1,Ld_bas_5B,Ld_bas_4B,Ld_bas_3B,Ld_bas_2B,Ld_bas_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          sign_0 : 
            begin
              rLoadB <= 1'b0;
              Ld_sign_2B <= dDATA_to_encB;
            end
          sign_0_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign2,sync,Ld_sign_1B};
              Ld_bas_1B <= dDATA_to_encB;
            end
          sign_1 : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign1,Ld_sign_2B,Ld_sign_1B};
              Ld_sign_1B <= dDATA_to_encB;
            end
          sign_1_bis : 
            begin
              rLoadB <= 1'b1;
              rDATA_32B <= {code_sel_sign1,Ld_sign_2B,Ld_sign_1B};
              Ld_bas_1B <= dDATA_to_encB;
            end
          default : 
            begin
              rLoadB <= 1'b0;
              rDATA_32B <= Initial;
            end
        endcase
      end
  end

always @( posedge CLKC )
  begin : FSM_seq_outputC
    if (rst_bC==1'b0||fallbackC==1'b1)
      begin
        Ld_bas_1C <= 6'b0;
        Ld_bas_2C <= 6'b0;
        Ld_bas_3C <= 6'b0;
        Ld_bas_4C <= 6'b0;
        Ld_bas_5C <= 6'b0;
        Ld_sign_1C <= 13'b0;
        Ld_sign_2C <= 13'b0;
        rLoadC <= 1'b0;
        rDATA_32C <= Initial;
      end
    else
      begin
        case (Current_stateC)
          bc0_0 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,one,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bc0_1 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,two,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bc0_2 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,three,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bc0_3 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,four,Ld_bas_4C,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bc0_4 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas1,Ld_bas_5C,Ld_bas_4C,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bc0_s0 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign1,Ld_sign_2C,Ld_sign_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bc0_s0_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign2,sync,Ld_sign_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          header_s0 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign2,header_synch,Ld_sign_1C};
              Ld_bas_1C <= dDATA_to_encC;
              Ld_sign_1C <= dDATA_to_encC;
            end
          header : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign2,header_synch,Ld_sign_1C};
              Ld_bas_1C <= dDATA_to_encC;
              Ld_sign_1C <= dDATA_to_encC;
            end
          header_b0 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign2,header_synch,Ld_sign_1C};
              Ld_bas_1C <= dDATA_to_encC;
              Ld_sign_1C <= dDATA_to_encC;
            end
          IDLE : 
            begin
              rLoadC <= 1'b0;
              rDATA_32C <= Initial;
            end
          bas_0 : 
            begin
              rLoadC <= 1'b0;
              Ld_bas_2C <= dDATA_to_encC;
            end
          bas_0_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,one,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bas_1 : 
            begin
              rLoadC <= 1'b0;
              Ld_bas_3C <= dDATA_to_encC;
            end
          bas_1_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,two,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bas_2 : 
            begin
              rLoadC <= 1'b0;
              Ld_bas_4C <= dDATA_to_encC;
            end
          bas_2_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,three,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bas_3 : 
            begin
              rLoadC <= 1'b0;
              Ld_bas_5C <= dDATA_to_encC;
            end
          bas_3_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas2,four,Ld_bas_4C,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          bas_4 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas1,Ld_bas_5C,Ld_bas_4C,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_bas_1C <= dDATA_to_encC;
            end
          bas_4_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_bas1,Ld_bas_5C,Ld_bas_4C,Ld_bas_3C,Ld_bas_2C,Ld_bas_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          sign_0 : 
            begin
              rLoadC <= 1'b0;
              Ld_sign_2C <= dDATA_to_encC;
            end
          sign_0_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign2,sync,Ld_sign_1C};
              Ld_bas_1C <= dDATA_to_encC;
            end
          sign_1 : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign1,Ld_sign_2C,Ld_sign_1C};
              Ld_sign_1C <= dDATA_to_encC;
            end
          sign_1_bis : 
            begin
              rLoadC <= 1'b1;
              rDATA_32C <= {code_sel_sign1,Ld_sign_2C,Ld_sign_1C};
              Ld_bas_1C <= dDATA_to_encC;
            end
          default : 
            begin
              rLoadC <= 1'b0;
              rDATA_32C <= Initial;
            end
        endcase
      end
  end

always @( posedge CLKA )
  begin : FSM_seq_output_FBA
    if (rst_bA==1'b0||fallbackA==1'b0)
      begin
        rLoad_FBA <= 1'b0;
        rDATA_32_FBA <= Initial_FB;
        Ld_sign_FBA <= 13'b0;
      end
    else
      begin
        case (Current_state_FBA)
          data_odd : 
            begin
              rLoad_FBA <= 1'b0;
              Ld_sign_FBA <= dDATA_to_encA;
            end
          latency1 : 
            begin
              rLoad_FBA <= 1'b0;
            end
          data_even : 
            begin
              rLoad_FBA <= 1'b1;
              rDATA_32_FBA <= {2'b11,2'b11,~^ dDATA_to_encA ,~^ Ld_sign_FBA ,dDATA_to_encA,Ld_sign_FBA};
            end
          latency2 : 
            begin
              rLoad_FBA <= 1'b0;
            end
          default : 
            begin
              rLoad_FBA <= 1'b0;
              rDATA_32_FBA <= Initial_FB;
            end
        endcase
      end
  end

always @( posedge CLKB )
  begin : FSM_seq_output_FBB
    if (rst_bB==1'b0||fallbackB==1'b0)
      begin
        rLoad_FBB <= 1'b0;
        rDATA_32_FBB <= Initial_FB;
        Ld_sign_FBB <= 13'b0;
      end
    else
      begin
        case (Current_state_FBB)
          data_odd : 
            begin
              rLoad_FBB <= 1'b0;
              Ld_sign_FBB <= dDATA_to_encB;
            end
          latency1 : 
            begin
              rLoad_FBB <= 1'b0;
            end
          data_even : 
            begin
              rLoad_FBB <= 1'b1;
              rDATA_32_FBB <= {2'b11,2'b11,~^ dDATA_to_encB ,~^ Ld_sign_FBB ,dDATA_to_encB,Ld_sign_FBB};
            end
          latency2 : 
            begin
              rLoad_FBB <= 1'b0;
            end
          default : 
            begin
              rLoad_FBB <= 1'b0;
              rDATA_32_FBB <= Initial_FB;
            end
        endcase
      end
  end

always @( posedge CLKC )
  begin : FSM_seq_output_FBC
    if (rst_bC==1'b0||fallbackC==1'b0)
      begin
        rLoad_FBC <= 1'b0;
        rDATA_32_FBC <= Initial_FB;
        Ld_sign_FBC <= 13'b0;
      end
    else
      begin
        case (Current_state_FBC)
          data_odd : 
            begin
              rLoad_FBC <= 1'b0;
              Ld_sign_FBC <= dDATA_to_encC;
            end
          latency1 : 
            begin
              rLoad_FBC <= 1'b0;
            end
          data_even : 
            begin
              rLoad_FBC <= 1'b1;
              rDATA_32_FBC <= {2'b11,2'b11,~^ dDATA_to_encC ,~^ Ld_sign_FBC ,dDATA_to_encC,Ld_sign_FBC};
            end
          latency2 : 
            begin
              rLoad_FBC <= 1'b0;
            end
          default : 
            begin
              rLoad_FBC <= 1'b0;
              rDATA_32_FBC <= Initial_FB;
            end
        endcase
      end
  end
assign Load_FB_synchA =  rLoad_FBA;
assign Load_FB_synchB =  rLoad_FBB;
assign Load_FB_synchC =  rLoad_FBC;
assign DATA_32_FB_synchA =  rDATA_32_FBA;
assign DATA_32_FB_synchB =  rDATA_32_FBB;
assign DATA_32_FB_synchC =  rDATA_32_FBC;
assign Load_synchA =  rLoadA;
assign Load_synchB =  rLoadB;
assign Load_synchC =  rLoadC;
assign DATA_32_synchA =  rDATA_32A;
assign DATA_32_synchB =  rDATA_32B;
assign DATA_32_synchC =  rDATA_32C;
assign DATA_32 =  DATA_32_synch;
assign DATA_32_FB =  DATA_32_FB_synch;
assign Load =  Load_synch;
assign Load_FB =  Load_FB_synch;

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_32_synchVoter (
    .inA(DATA_32_synchA),
    .inB(DATA_32_synchB),
    .inC(DATA_32_synchC),
    .out(DATA_32_synch),
    .tmrErr(DATA_32_synchTmrError)
    );

majorityVoter Load_synchVoter (
    .inA(Load_synchA),
    .inB(Load_synchB),
    .inC(Load_synchC),
    .out(Load_synch),
    .tmrErr(Load_synchTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_32_FB_synchVoter (
    .inA(DATA_32_FB_synchA),
    .inB(DATA_32_FB_synchB),
    .inC(DATA_32_FB_synchC),
    .out(DATA_32_FB_synch),
    .tmrErr(DATA_32_FB_synchTmrError)
    );

majorityVoter Load_FB_synchVoter (
    .inA(Load_FB_synchA),
    .inB(Load_FB_synchB),
    .inC(Load_FB_synchC),
    .out(Load_FB_synch),
    .tmrErr(Load_FB_synchTmrError)
    );
assign tmrError =  DATA_32_FB_synchTmrError|DATA_32_synchTmrError|Load_FB_synchTmrError|Load_synchTmrError;

fanout baseline_flagFanout (
    .in(baseline_flag),
    .outA(baseline_flagA),
    .outB(baseline_flagB),
    .outC(baseline_flagC)
    );

fanout #(.WIDTH(((Nbits_12)>(0)) ? ((Nbits_12)-(0)+1) : ((0)-(Nbits_12)+1))) DATA_to_encFanout (
    .in(DATA_to_enc),
    .outA(DATA_to_encA),
    .outB(DATA_to_encB),
    .outC(DATA_to_encC)
    );

fanout fallbackFanout (
    .in(fallback),
    .outA(fallbackA),
    .outB(fallbackB),
    .outC(fallbackC)
    );
endmodule

