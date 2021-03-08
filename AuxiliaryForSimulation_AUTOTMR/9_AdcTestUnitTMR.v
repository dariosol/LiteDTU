/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./AdcTestUnitTMR.v                                                                     *
 *                                                                                                  *
 * user    : gianni                                                                                 *
 * host    : elt153xl.to.infn.it                                                                    *
 * date    : 08/11/2018 09:19:53                                                                    *
 *                                                                                                  *
 * workdir : /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/syn/netlist_in                   *
 * cmd     : /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/tmrg/bin/tmrg --sdc-generate --sdc- *
 *           headers --config AdcTestUnit.cfg AdcTestUnit.v                                         *
 * tmrg rev: 9a6ee4d64fce05b58c62ee9ecfc4ef5a8551d404                                               *
 *                                                                                                  *
 * src file: AdcTestUnit.v                                                                          *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2018-11-08 09:18:17.519037                                         *
 *           File Size         : 3423                                                               *
 *           MD5 hash          : a1237c7b8e96ee39ed9a3e26240f4d19                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale 1ns/1ps
module AdcTestUnitTMR #(
  parameter NBitsADC=12,
  parameter NBitsOut=32
)(
  input  rst_bA,
  input  rst_bB,
  input  rst_bC,
  input  clockA,
  input  clockB,
  input  clockC,
  input  test_enable,
  input [NBitsADC-1:0] DataInL,
  input [NBitsADC-1:0] DataInH,
  output [NBitsOut-1:0] DataOutLe,
  output [NBitsOut-1:0] DataOutLo,
  output [NBitsOut-1:0] DataOutHe,
  output [NBitsOut-1:0] DataOutHo,
  output  tmrError,
  output  tmrErrorA,
  output  tmrErrorB,
  output  tmrErrorC
);

parameter    idle=3'b000;
parameter    state_0=3'b100;
parameter    state_1=3'b101;
parameter    state_2=3'b111;
parameter    state_3=3'b110;
wire [NBitsADC-1:0] DataInHC;
wire [NBitsADC-1:0] DataInHB;
wire [NBitsADC-1:0] DataInHA;
wire test_enableC;
wire test_enableB;
wire test_enableA;
wire [NBitsADC-1:0] DataInLC;
wire [NBitsADC-1:0] DataInLB;
wire [NBitsADC-1:0] DataInLA;
//wire tmrErrorC;
wor nStateTmrErrorC;
wire [2:0] nStateVotedC;
//wire tmrErrorB;
wor nStateTmrErrorB;
wire [2:0] nStateVotedB;
//wire tmrErrorA;
wor nStateTmrErrorA;
wire [2:0] nStateVotedA;
//wire tmrError;
wor DoutHeTmrError;
wire [NBitsOut-1:0] DoutHe;
wor DoutHoTmrError;
wire [NBitsOut-1:0] DoutHo;
wor DoutLeTmrError;
wire [NBitsOut-1:0] DoutLe;
wor DoutLoTmrError;
wire [NBitsOut-1:0] DoutLo;
reg  [2:0] cStateA;
reg  [2:0] cStateB;
reg  [2:0] cStateC;
reg  [2:0] nStateA;
reg  [2:0] nStateB;
reg  [2:0] nStateC;
reg  [(NBitsOut/2)-1:0] DataIntL0A;
reg  [(NBitsOut/2)-1:0] DataIntL0B;
reg  [(NBitsOut/2)-1:0] DataIntL0C;
reg  [(NBitsOut/2)-1:0] DataIntL1A;
reg  [(NBitsOut/2)-1:0] DataIntL1B;
reg  [(NBitsOut/2)-1:0] DataIntL1C;
reg  [(NBitsOut/2)-1:0] DataIntL2A;
reg  [(NBitsOut/2)-1:0] DataIntL2B;
reg  [(NBitsOut/2)-1:0] DataIntL2C;
reg  [(NBitsOut/2)-1:0] DataIntL3A;
reg  [(NBitsOut/2)-1:0] DataIntL3B;
reg  [(NBitsOut/2)-1:0] DataIntL3C;
reg  [(NBitsOut/2)-1:0] DataIntH0A;
reg  [(NBitsOut/2)-1:0] DataIntH0B;
reg  [(NBitsOut/2)-1:0] DataIntH0C;
reg  [(NBitsOut/2)-1:0] DataIntH1A;
reg  [(NBitsOut/2)-1:0] DataIntH1B;
reg  [(NBitsOut/2)-1:0] DataIntH1C;
reg  [(NBitsOut/2)-1:0] DataIntH2A;
reg  [(NBitsOut/2)-1:0] DataIntH2B;
reg  [(NBitsOut/2)-1:0] DataIntH2C;
reg  [(NBitsOut/2)-1:0] DataIntH3A;
reg  [(NBitsOut/2)-1:0] DataIntH3B;
reg  [(NBitsOut/2)-1:0] DataIntH3C;
reg  [NBitsOut-1:0] DoutLeA;
reg  [NBitsOut-1:0] DoutLeB;
reg  [NBitsOut-1:0] DoutLeC;
reg  [NBitsOut-1:0] DoutLoA;
reg  [NBitsOut-1:0] DoutLoB;
reg  [NBitsOut-1:0] DoutLoC;
reg  [NBitsOut-1:0] DoutHeA;
reg  [NBitsOut-1:0] DoutHeB;
reg  [NBitsOut-1:0] DoutHeC;
reg  [NBitsOut-1:0] DoutHoA;
reg  [NBitsOut-1:0] DoutHoB;
reg  [NBitsOut-1:0] DoutHoC;
reg  load_eA;
reg  load_eB;
reg  load_eC;
reg  load_oA;
reg  load_oB;
reg  load_oC;
reg  [3:0] ld_intA;
reg  [3:0] ld_intB;
reg  [3:0] ld_intC;
assign DataOutLe =  DoutLe;
assign DataOutLo =  DoutLo;
assign DataOutHe =  DoutHe;
assign DataOutHo =  DoutHo;

always @( cStateA or test_enableA or DataInLA or DataInHA )
  begin
    load_eA =  1'b0;
    load_oA =  1'b0;
    ld_intA =  4'b0000;
    case (cStateA)
      idle : 
        begin
          if (test_enableA==1)
            nStateA =  state_0;
          else
            nStateA =  idle;
        end
      state_0 : 
        begin
          ld_intA =  4'b0001;
          load_oA =  1'b1;
          nStateA =  state_1;
        end
      state_1 : 
        begin
          ld_intA =  4'b0010;
          nStateA =  state_2;
        end
      state_2 : 
        begin
          ld_intA =  4'b0100;
          nStateA =  state_3;
        end
      state_3 : 
        begin
          ld_intA =  4'b1000;
          load_eA =  1'b1;
          if (test_enableA==1)
            nStateA =  state_0;
          else
            nStateA =  idle;
        end
      default : nStateA =  idle;
    endcase
  end

always @( cStateB or test_enableB or DataInLB or DataInHB )
  begin
    load_eB =  1'b0;
    load_oB =  1'b0;
    ld_intB =  4'b0000;
    case (cStateB)
      idle : 
        begin
          if (test_enableB==1)
            nStateB =  state_0;
          else
            nStateB =  idle;
        end
      state_0 : 
        begin
          ld_intB =  4'b0001;
          load_oB =  1'b1;
          nStateB =  state_1;
        end
      state_1 : 
        begin
          ld_intB =  4'b0010;
          nStateB =  state_2;
        end
      state_2 : 
        begin
          ld_intB =  4'b0100;
          nStateB =  state_3;
        end
      state_3 : 
        begin
          ld_intB =  4'b1000;
          load_eB =  1'b1;
          if (test_enableB==1)
            nStateB =  state_0;
          else
            nStateB =  idle;
        end
      default : nStateB =  idle;
    endcase
  end

always @( cStateC or test_enableC or DataInLC or DataInHC )
  begin
    load_eC =  1'b0;
    load_oC =  1'b0;
    ld_intC =  4'b0000;
    case (cStateC)
      idle : 
        begin
          if (test_enableC==1)
            nStateC =  state_0;
          else
            nStateC =  idle;
        end
      state_0 : 
        begin
          ld_intC =  4'b0001;
          load_oC =  1'b1;
          nStateC =  state_1;
        end
      state_1 : 
        begin
          ld_intC =  4'b0010;
          nStateC =  state_2;
        end
      state_2 : 
        begin
          ld_intC =  4'b0100;
          nStateC =  state_3;
        end
      state_3 : 
        begin
          ld_intC =  4'b1000;
          load_eC =  1'b1;
          if (test_enableC==1)
            nStateC =  state_0;
          else
            nStateC =  idle;
        end
      default : nStateC =  idle;
    endcase
  end

always @( posedge clockA )
  begin
    if (rst_bA==0)
      begin
        cStateA =  idle;
        DataIntL0A =  16'h5a5a;
        DataIntL1A =  16'h5a5a;
        DataIntL2A =  16'h5a5a;
        DataIntL3A =  16'h5a5a;
        DataIntH0A =  16'h5a5a;
        DataIntH1A =  16'h5a5a;
        DataIntH2A =  16'h5a5a;
        DataIntH3A =  16'h5a5a;
        DoutLeA =  32'h5a5a5a5a;
        DoutLoA =  32'h5a5a5a5a;
        DoutHeA =  32'h5a5a5a5a;
        DoutHoA =  32'h5a5a5a5a;
      end
    else
      begin
        cStateA =  nStateA;
        if (ld_intA[0] ==1)
          begin
            DataIntL0A =  {4'b0011,DataInLA};
            DataIntH0A =  {4'b1100,DataInHA};
          end
        if (ld_intA[1] ==1)
          begin
            DataIntL1A =  {4'b0110,DataInLA};
            DataIntH1A =  {4'b1001,DataInHA};
          end
        if (ld_intA[2] ==1)
          begin
            DataIntL2A =  {4'b1001,DataInLA};
            DataIntH2A =  {4'b0110,DataInHA};
          end
        if (ld_intA[3] ==1)
          begin
            DataIntL3A =  {4'b1100,DataInLA};
            DataIntH3A =  {4'b0011,DataInHA};
          end
        if (load_eA==1)
          begin
            DoutLeA =  {DataIntL2A,DataIntL0A};
            DoutHeA =  {DataIntH2A,DataIntH0A};
          end
        if (load_oA==1)
          begin
            DoutLoA =  {DataIntL3A,DataIntL1A};
            DoutHoA =  {DataIntH3A,DataIntH1A};
          end
      end
  end

always @( posedge clockB )
  begin
    if (rst_bB==0)
      begin
        cStateB =  idle;
        DataIntL0B =  16'h5a5a;
        DataIntL1B =  16'h5a5a;
        DataIntL2B =  16'h5a5a;
        DataIntL3B =  16'h5a5a;
        DataIntH0B =  16'h5a5a;
        DataIntH1B =  16'h5a5a;
        DataIntH2B =  16'h5a5a;
        DataIntH3B =  16'h5a5a;
        DoutLeB =  32'h5a5a5a5a;
        DoutLoB =  32'h5a5a5a5a;
        DoutHeB =  32'h5a5a5a5a;
        DoutHoB =  32'h5a5a5a5a;
      end
    else
      begin
        cStateB =  nStateB;
        if (ld_intB[0] ==1)
          begin
            DataIntL0B =  {4'b0011,DataInLB};
            DataIntH0B =  {4'b1100,DataInHB};
          end
        if (ld_intB[1] ==1)
          begin
            DataIntL1B =  {4'b0110,DataInLB};
            DataIntH1B =  {4'b1001,DataInHB};
          end
        if (ld_intB[2] ==1)
          begin
            DataIntL2B =  {4'b1001,DataInLB};
            DataIntH2B =  {4'b0110,DataInHB};
          end
        if (ld_intB[3] ==1)
          begin
            DataIntL3B =  {4'b1100,DataInLB};
            DataIntH3B =  {4'b0011,DataInHB};
          end
        if (load_eB==1)
          begin
            DoutLeB =  {DataIntL2B,DataIntL0B};
            DoutHeB =  {DataIntH2B,DataIntH0B};
          end
        if (load_oB==1)
          begin
            DoutLoB =  {DataIntL3B,DataIntL1B};
            DoutHoB =  {DataIntH3B,DataIntH1B};
          end
      end
  end

always @( posedge clockC )
  begin
    if (rst_bC==0)
      begin
        cStateC =  idle;
        DataIntL0C =  16'h5a5a;
        DataIntL1C =  16'h5a5a;
        DataIntL2C =  16'h5a5a;
        DataIntL3C =  16'h5a5a;
        DataIntH0C =  16'h5a5a;
        DataIntH1C =  16'h5a5a;
        DataIntH2C =  16'h5a5a;
        DataIntH3C =  16'h5a5a;
        DoutLeC =  32'h5a5a5a5a;
        DoutLoC =  32'h5a5a5a5a;
        DoutHeC =  32'h5a5a5a5a;
        DoutHoC =  32'h5a5a5a5a;
      end
    else
      begin
        cStateC =  nStateC;
        if (ld_intC[0] ==1)
          begin
            DataIntL0C =  {4'b0011,DataInLC};
            DataIntH0C =  {4'b1100,DataInHC};
          end
        if (ld_intC[1] ==1)
          begin
            DataIntL1C =  {4'b0110,DataInLC};
            DataIntH1C =  {4'b1001,DataInHC};
          end
        if (ld_intC[2] ==1)
          begin
            DataIntL2C =  {4'b1001,DataInLC};
            DataIntH2C =  {4'b0110,DataInHC};
          end
        if (ld_intC[3] ==1)
          begin
            DataIntL3C =  {4'b1100,DataInLC};
            DataIntH3C =  {4'b0011,DataInHC};
          end
        if (load_eC==1)
          begin
            DoutLeC =  {DataIntL2C,DataIntL0C};
            DoutHeC =  {DataIntH2C,DataIntH0C};
          end
        if (load_oC==1)
          begin
            DoutLoC =  {DataIntL3C,DataIntL1C};
            DoutHoC =  {DataIntH3C,DataIntH1C};
          end
      end
  end

majorityVoter #(.WIDTH(((NBitsOut-1)>(0)) ? ((NBitsOut-1)-(0)+1) : ((0)-(NBitsOut-1)+1))) DoutLoVoter (
    .inA(DoutLoA),
    .inB(DoutLoB),
    .inC(DoutLoC),
    .out(DoutLo),
    .tmrErr(DoutLoTmrError)
    );

majorityVoter #(.WIDTH(((NBitsOut-1)>(0)) ? ((NBitsOut-1)-(0)+1) : ((0)-(NBitsOut-1)+1))) DoutLeVoter (
    .inA(DoutLeA),
    .inB(DoutLeB),
    .inC(DoutLeC),
    .out(DoutLe),
    .tmrErr(DoutLeTmrError)
    );

majorityVoter #(.WIDTH(((NBitsOut-1)>(0)) ? ((NBitsOut-1)-(0)+1) : ((0)-(NBitsOut-1)+1))) DoutHoVoter (
    .inA(DoutHoA),
    .inB(DoutHoB),
    .inC(DoutHoC),
    .out(DoutHo),
    .tmrErr(DoutHoTmrError)
    );

majorityVoter #(.WIDTH(((NBitsOut-1)>(0)) ? ((NBitsOut-1)-(0)+1) : ((0)-(NBitsOut-1)+1))) DoutHeVoter (
    .inA(DoutHeA),
    .inB(DoutHeB),
    .inC(DoutHeC),
    .out(DoutHe),
    .tmrErr(DoutHeTmrError)
    );
assign tmrError =  DoutHeTmrError|DoutHoTmrError|DoutLeTmrError|DoutLoTmrError;

majorityVoter #(.WIDTH(3)) nStateVoterA (
    .inA(nStateA),
    .inB(nStateB),
    .inC(nStateC),
    .out(nStateVotedA),
    .tmrErr(nStateTmrErrorA)
    );
assign tmrErrorA =  nStateTmrErrorA;

majorityVoter #(.WIDTH(3)) nStateVoterB (
    .inA(nStateA),
    .inB(nStateB),
    .inC(nStateC),
    .out(nStateVotedB),
    .tmrErr(nStateTmrErrorB)
    );
assign tmrErrorB =  nStateTmrErrorB;

majorityVoter #(.WIDTH(3)) nStateVoterC (
    .inA(nStateA),
    .inB(nStateB),
    .inC(nStateC),
    .out(nStateVotedC),
    .tmrErr(nStateTmrErrorC)
    );
assign tmrErrorC =  nStateTmrErrorC;

fanout #(.WIDTH(((NBitsADC-1)>(0)) ? ((NBitsADC-1)-(0)+1) : ((0)-(NBitsADC-1)+1))) DataInLFanout (
    .in(DataInL),
    .outA(DataInLA),
    .outB(DataInLB),
    .outC(DataInLC)
    );

fanout test_enableFanout (
    .in(test_enable),
    .outA(test_enableA),
    .outB(test_enableB),
    .outC(test_enableC)
    );

fanout #(.WIDTH(((NBitsADC-1)>(0)) ? ((NBitsADC-1)-(0)+1) : ((0)-(NBitsADC-1)+1))) DataInHFanout (
    .in(DataInH),
    .outA(DataInHA),
    .outB(DataInHB),
    .outC(DataInHC)
    );
endmodule


/*
// /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/tmrg/src/../common/voter.v
module majorityVoter (inA, inB, inC, out, tmrErr);
  parameter WIDTH = 1;
  input   [(WIDTH-1):0]   inA, inB, inC;
  output  [(WIDTH-1):0]   out;
  output                  tmrErr;
  reg                     tmrErr;
  assign out = (inA&inB) | (inA&inC) | (inB&inC);
  always @(inA or inB or inC)
  begin
    if (inA!=inB || inA!=inC || inB!=inC)
      tmrErr = 1;
    else
      tmrErr = 0;
  end
endmodule


// /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/tmrg/src/../common/fanout.v
module fanout (in, outA, outB, outC);
  parameter WIDTH = 1;
  input   [(WIDTH-1):0]   in;
  output  [(WIDTH-1):0]   outA,outB,outC;
  assign outA=in;
  assign outB=in;
  assign outC=in;
endmodule*/