/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/3_LDTU_FSMTMR.v                                                 *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 08/03/2021 13:29:53                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/Last_DTU_v2_NoReg.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/                     *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 3_LDTU_FSM.v                                                                           *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-03-08 12:03:07.569213                                         *
 *           File Size         : 8649                                                               *
 *           MD5 hash          : 3e2fd8e2d4112bb6e1db5d211cb12ddb                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale       1ps/1ps

module LDTU_FSMTMR(
  CLKA,
  CLKB,
  CLKC,
  rst_bA,
  rst_bB,
  rst_bC,
  fallback,
  Orbit,
  baseline_flag,
  Current_stateA,
  Current_stateB,
  Current_stateC,
  Current_state_FBA,
  Current_state_FBB,
  Current_state_FBC,
  SeuError
);
parameter    SIZE=4;
parameter    IDLE=4'b0000;
parameter    bas_0=4'b0001;
parameter    bas_1=4'b0010;
parameter    bas_2=4'b0011;
parameter    bas_3=4'b0100;
parameter    bas_4=4'b0101;
parameter    sign_0=4'b0110;
parameter    sign_1=4'b0111;
parameter    bas_0_bis=4'b1000;
parameter    bas_1_bis=4'b1001;
parameter    bas_2_bis=4'b1010;
parameter    bas_3_bis=4'b1011;
parameter    bas_4_bis=4'b1100;
parameter    sign_0_bis=4'b1101;
parameter    sign_1_bis=4'b1110;
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
wire OrbitC;
wire OrbitB;
wire OrbitA;
wire fallbackC;
wire fallbackB;
wire fallbackA;
wire baseline_flagC;
wire baseline_flagB;
wire baseline_flagA;
input CLKA;
input CLKB;
input CLKC;
input rst_bA;
input rst_bB;
input rst_bC;
input fallback;
input Orbit;
input baseline_flag;
output reg   [SIZE:0] Current_stateA;
output reg   [SIZE:0] Current_stateB;
output reg   [SIZE:0] Current_stateC;
output SeuError;
reg  [SIZE:0] nStateA;
reg  [SIZE:0] nStateB;
reg  [SIZE:0] nStateC;
output reg   [SIZE_FB:0] Current_state_FBA;
output reg   [SIZE_FB:0] Current_state_FBB;
output reg   [SIZE_FB:0] Current_state_FBC;
reg  [SIZE_FB:0] nState_FBA;
reg  [SIZE_FB:0] nState_FBB;
reg  [SIZE_FB:0] nState_FBC;

always @( posedge CLKA )
  begin : FSM_SEQA
    if (rst_bA==1'b0||fallbackA==1'b1)
      begin
        Current_stateA <= IDLE;
      end
    else
      begin
        Current_stateA <= nStateA;
      end
  end

always @( posedge CLKB )
  begin : FSM_SEQB
    if (rst_bB==1'b0||fallbackB==1'b1)
      begin
        Current_stateB <= IDLE;
      end
    else
      begin
        Current_stateB <= nStateB;
      end
  end

always @( posedge CLKC )
  begin : FSM_SEQC
    if (rst_bC==1'b0||fallbackC==1'b1)
      begin
        Current_stateC <= IDLE;
      end
    else
      begin
        Current_stateC <= nStateC;
      end
  end

always @( Current_stateA or baseline_flagA or OrbitA )
  begin : FSM_COMBA
    nStateA =  IDLE;
    case (Current_stateA)
      IDLE : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  bas_0;
          else
            if (OrbitA==1'b1)
              nStateA =  header;
            else
              nStateA =  sign_0;
        end
      bas_0_bis : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  sign_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0_bis;
            else
              nStateA =  sign_0;
        end
      bas_0 : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  bas_1;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_1;
            else
              nStateA =  bas_1_bis;
        end
      bas_1_bis : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  sign_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0_bis;
            else
              nStateA =  sign_0;
        end
      bas_1 : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  bas_2;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_2;
            else
              nStateA =  bas_2_bis;
        end
      bas_2_bis : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  sign_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0_bis;
            else
              nStateA =  sign_0;
        end
      bas_2 : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  bas_3;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_3;
            else
              nStateA =  bas_3_bis;
        end
      bas_3_bis : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  sign_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0_bis;
            else
              nStateA =  sign_0;
        end
      bas_3 : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  bas_4;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_4;
            else
              nStateA =  bas_4_bis;
        end
      bas_4_bis : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  sign_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0_bis;
            else
              nStateA =  sign_0;
        end
      bas_4 : 
        begin
          if (baseline_flagA==1'b1&&OrbitA==1'b0)
            nStateA =  bas_0;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_0;
            else
              nStateA =  bas_0_bis;
        end
      sign_0_bis : 
        begin
          if (baseline_flagA==1'b0&&OrbitA==1'b0)
            nStateA =  bas_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_0;
            else
              nStateA =  bas_0;
        end
      sign_0 : 
        begin
          if (baseline_flagA==1'b0&&OrbitA==1'b0)
            nStateA =  sign_1;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0;
            else
              nStateA =  sign_1_bis;
        end
      sign_1_bis : 
        begin
          if (baseline_flagA==1'b0&&OrbitA==1'b0)
            nStateA =  bas_0_bis;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_0;
            else
              nStateA =  bas_0;
        end
      sign_1 : 
        begin
          if (baseline_flagA==1'b0&&OrbitA==1'b0)
            nStateA =  sign_0;
          else
            if (OrbitA==1'b1)
              nStateA =  bc0_s0_bis;
            else
              nStateA =  sign_0_bis;
        end
      bc0_0 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  header_s0;
          else
            nStateA =  header_b0;
        end
      bc0_1 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  header_s0;
          else
            nStateA =  header_b0;
        end
      bc0_2 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  header_s0;
          else
            nStateA =  header_b0;
        end
      bc0_3 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  header_s0;
          else
            nStateA =  header_b0;
        end
      bc0_4 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  header_s0;
          else
            nStateA =  header_b0;
        end
      bc0_s0 : 
        begin
          nStateA =  header;
        end
      bc0_s0_bis : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  header_s0;
          else
            nStateA =  header_b0;
        end
      header : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  sign_0;
          else
            nStateA =  bas_0;
        end
      header_s0 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  sign_0;
          else
            nStateA =  sign_0_bis;
        end
      header_b0 : 
        begin
          if (baseline_flagA==1'b0)
            nStateA =  bas_0_bis;
          else
            nStateA =  bas_0;
        end
      default : nStateA =  IDLE;
    endcase
  end

always @( Current_stateB or baseline_flagB or OrbitB )
  begin : FSM_COMBB
    nStateB =  IDLE;
    case (Current_stateB)
      IDLE : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  bas_0;
          else
            if (OrbitB==1'b1)
              nStateB =  header;
            else
              nStateB =  sign_0;
        end
      bas_0_bis : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  sign_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0_bis;
            else
              nStateB =  sign_0;
        end
      bas_0 : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  bas_1;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_1;
            else
              nStateB =  bas_1_bis;
        end
      bas_1_bis : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  sign_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0_bis;
            else
              nStateB =  sign_0;
        end
      bas_1 : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  bas_2;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_2;
            else
              nStateB =  bas_2_bis;
        end
      bas_2_bis : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  sign_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0_bis;
            else
              nStateB =  sign_0;
        end
      bas_2 : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  bas_3;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_3;
            else
              nStateB =  bas_3_bis;
        end
      bas_3_bis : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  sign_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0_bis;
            else
              nStateB =  sign_0;
        end
      bas_3 : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  bas_4;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_4;
            else
              nStateB =  bas_4_bis;
        end
      bas_4_bis : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  sign_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0_bis;
            else
              nStateB =  sign_0;
        end
      bas_4 : 
        begin
          if (baseline_flagB==1'b1&&OrbitB==1'b0)
            nStateB =  bas_0;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_0;
            else
              nStateB =  bas_0_bis;
        end
      sign_0_bis : 
        begin
          if (baseline_flagB==1'b0&&OrbitB==1'b0)
            nStateB =  bas_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_0;
            else
              nStateB =  bas_0;
        end
      sign_0 : 
        begin
          if (baseline_flagB==1'b0&&OrbitB==1'b0)
            nStateB =  sign_1;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0;
            else
              nStateB =  sign_1_bis;
        end
      sign_1_bis : 
        begin
          if (baseline_flagB==1'b0&&OrbitB==1'b0)
            nStateB =  bas_0_bis;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_0;
            else
              nStateB =  bas_0;
        end
      sign_1 : 
        begin
          if (baseline_flagB==1'b0&&OrbitB==1'b0)
            nStateB =  sign_0;
          else
            if (OrbitB==1'b1)
              nStateB =  bc0_s0_bis;
            else
              nStateB =  sign_0_bis;
        end
      bc0_0 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  header_s0;
          else
            nStateB =  header_b0;
        end
      bc0_1 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  header_s0;
          else
            nStateB =  header_b0;
        end
      bc0_2 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  header_s0;
          else
            nStateB =  header_b0;
        end
      bc0_3 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  header_s0;
          else
            nStateB =  header_b0;
        end
      bc0_4 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  header_s0;
          else
            nStateB =  header_b0;
        end
      bc0_s0 : 
        begin
          nStateB =  header;
        end
      bc0_s0_bis : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  header_s0;
          else
            nStateB =  header_b0;
        end
      header : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  sign_0;
          else
            nStateB =  bas_0;
        end
      header_s0 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  sign_0;
          else
            nStateB =  sign_0_bis;
        end
      header_b0 : 
        begin
          if (baseline_flagB==1'b0)
            nStateB =  bas_0_bis;
          else
            nStateB =  bas_0;
        end
      default : nStateB =  IDLE;
    endcase
  end

always @( Current_stateC or baseline_flagC or OrbitC )
  begin : FSM_COMBC
    nStateC =  IDLE;
    case (Current_stateC)
      IDLE : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  bas_0;
          else
            if (OrbitC==1'b1)
              nStateC =  header;
            else
              nStateC =  sign_0;
        end
      bas_0_bis : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  sign_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0_bis;
            else
              nStateC =  sign_0;
        end
      bas_0 : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  bas_1;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_1;
            else
              nStateC =  bas_1_bis;
        end
      bas_1_bis : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  sign_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0_bis;
            else
              nStateC =  sign_0;
        end
      bas_1 : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  bas_2;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_2;
            else
              nStateC =  bas_2_bis;
        end
      bas_2_bis : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  sign_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0_bis;
            else
              nStateC =  sign_0;
        end
      bas_2 : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  bas_3;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_3;
            else
              nStateC =  bas_3_bis;
        end
      bas_3_bis : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  sign_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0_bis;
            else
              nStateC =  sign_0;
        end
      bas_3 : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  bas_4;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_4;
            else
              nStateC =  bas_4_bis;
        end
      bas_4_bis : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  sign_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0_bis;
            else
              nStateC =  sign_0;
        end
      bas_4 : 
        begin
          if (baseline_flagC==1'b1&&OrbitC==1'b0)
            nStateC =  bas_0;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_0;
            else
              nStateC =  bas_0_bis;
        end
      sign_0_bis : 
        begin
          if (baseline_flagC==1'b0&&OrbitC==1'b0)
            nStateC =  bas_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_0;
            else
              nStateC =  bas_0;
        end
      sign_0 : 
        begin
          if (baseline_flagC==1'b0&&OrbitC==1'b0)
            nStateC =  sign_1;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0;
            else
              nStateC =  sign_1_bis;
        end
      sign_1_bis : 
        begin
          if (baseline_flagC==1'b0&&OrbitC==1'b0)
            nStateC =  bas_0_bis;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_0;
            else
              nStateC =  bas_0;
        end
      sign_1 : 
        begin
          if (baseline_flagC==1'b0&&OrbitC==1'b0)
            nStateC =  sign_0;
          else
            if (OrbitC==1'b1)
              nStateC =  bc0_s0_bis;
            else
              nStateC =  sign_0_bis;
        end
      bc0_0 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  header_s0;
          else
            nStateC =  header_b0;
        end
      bc0_1 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  header_s0;
          else
            nStateC =  header_b0;
        end
      bc0_2 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  header_s0;
          else
            nStateC =  header_b0;
        end
      bc0_3 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  header_s0;
          else
            nStateC =  header_b0;
        end
      bc0_4 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  header_s0;
          else
            nStateC =  header_b0;
        end
      bc0_s0 : 
        begin
          nStateC =  header;
        end
      bc0_s0_bis : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  header_s0;
          else
            nStateC =  header_b0;
        end
      header : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  sign_0;
          else
            nStateC =  bas_0;
        end
      header_s0 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  sign_0;
          else
            nStateC =  sign_0_bis;
        end
      header_b0 : 
        begin
          if (baseline_flagC==1'b0)
            nStateC =  bas_0_bis;
          else
            nStateC =  bas_0;
        end
      default : nStateC =  IDLE;
    endcase
  end

always @( posedge CLKA )
  begin : FSM_SEQ_FBA
    if (rst_bA==1'b0||fallbackA==1'b0)
      begin
        Current_state_FBA <= IDLE_FB;
      end
    else
      begin
        Current_state_FBA <= nState_FBA;
      end
  end

always @( posedge CLKB )
  begin : FSM_SEQ_FBB
    if (rst_bB==1'b0||fallbackB==1'b0)
      begin
        Current_state_FBB <= IDLE_FB;
      end
    else
      begin
        Current_state_FBB <= nState_FBB;
      end
  end

always @( posedge CLKC )
  begin : FSM_SEQ_FBC
    if (rst_bC==1'b0||fallbackC==1'b0)
      begin
        Current_state_FBC <= IDLE_FB;
      end
    else
      begin
        Current_state_FBC <= nState_FBC;
      end
  end

always @( Current_state_FBA or OrbitA )
  begin : FSM_COMB_FBA
    nState_FBA =  IDLE_FB;
    case (Current_state_FBA)
      IDLE_FB : 
        begin
          nState_FBA =  data_odd;
        end
      data_odd : 
        begin
          nState_FBA =  latency1;
        end
      latency1 : 
        begin
          nState_FBA =  data_even;
        end
      data_even : 
        begin
          nState_FBA =  latency2;
        end
      latency2 : 
        begin
          nState_FBA =  data_odd;
        end
      default : nState_FBA =  IDLE_FB;
    endcase
  end

always @( Current_state_FBB or OrbitB )
  begin : FSM_COMB_FBB
    nState_FBB =  IDLE_FB;
    case (Current_state_FBB)
      IDLE_FB : 
        begin
          nState_FBB =  data_odd;
        end
      data_odd : 
        begin
          nState_FBB =  latency1;
        end
      latency1 : 
        begin
          nState_FBB =  data_even;
        end
      data_even : 
        begin
          nState_FBB =  latency2;
        end
      latency2 : 
        begin
          nState_FBB =  data_odd;
        end
      default : nState_FBB =  IDLE_FB;
    endcase
  end

always @( Current_state_FBC or OrbitC )
  begin : FSM_COMB_FBC
    nState_FBC =  IDLE_FB;
    case (Current_state_FBC)
      IDLE_FB : 
        begin
          nState_FBC =  data_odd;
        end
      data_odd : 
        begin
          nState_FBC =  latency1;
        end
      latency1 : 
        begin
          nState_FBC =  data_even;
        end
      data_even : 
        begin
          nState_FBC =  latency2;
        end
      latency2 : 
        begin
          nState_FBC =  data_odd;
        end
      default : nState_FBC =  IDLE_FB;
    endcase
  end

fanout baseline_flagFanout (
    .in(baseline_flag),
    .outA(baseline_flagA),
    .outB(baseline_flagB),
    .outC(baseline_flagC)
    );

fanout fallbackFanout (
    .in(fallback),
    .outA(fallbackA),
    .outB(fallbackB),
    .outC(fallbackC)
    );

fanout OrbitFanout (
    .in(Orbit),
    .outA(OrbitA),
    .outB(OrbitB),
    .outC(OrbitC)
    );
endmodule

