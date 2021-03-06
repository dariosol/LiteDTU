/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./LDTUv2_serTMR.v                                                                      *
 *                                                                                                  *
 * user    : gianni                                                                                 *
 * host    : elt153xl.to.infn.it                                                                    *
 * date    : 16/09/2020 16:12:12                                                                    *
 *                                                                                                  *
 * workdir : /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/v2/netlist_in                    *
 * cmd     : /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/tmrg/bin/tmrg --sdc-generate --sdc- *
 *           headers --config LDTUv2_ser.cfg LDTUv2_ser.v                                           *
 * tmrg rev: 9a6ee4d64fce05b58c62ee9ecfc4ef5a8551d404                                               *
 *                                                                                                  *
 * src file: LDTUv2_ser.v                                                                           *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2020-09-16 16:12:09.170368                                         *
 *           File Size         : 2266                                                               *
 *           MD5 hash          : 1fc26e09f6d58155a09c9ecd3de31f17                                   *
 *                                                                                                  *
 ****************************************************************************************************/

module LDTUv2_serTMR(
  input  rst_bA,
  input  rst_bB,
  input  rst_bC,
  input  clock,
  input [31:0] DataIn0,
  input [31:0] DataIn1,
  input [31:0] DataIn2,
  input [31:0] DataIn3,
  output  handshake,
  output  DataOut0,
  output  DataOut1,
  output  DataOut2,
  output  DataOut3
);
wire [31:0] DataIn0C;
wire [31:0] DataIn0B;
wire [31:0] DataIn0A;
wire [31:0] DataIn3C;
wire [31:0] DataIn3B;
wire [31:0] DataIn3A;
wire [31:0] DataIn1C;
wire [31:0] DataIn1B;
wire [31:0] DataIn1A;
wire [31:0] DataIn2C;
wire [31:0] DataIn2B;
wire [31:0] DataIn2A;
wire clockC;
wire clockB;
wire clockA;
wor rstb_syncTmrErrorC;
wire rstb_syncVotedC;
wor rstb_syncTmrErrorB;
wire rstb_syncVotedB;
wor rstb_syncTmrErrorA;
wire rstb_syncVotedA;
wor bitShiftReg1TmrError;
wire [31:0] bitShiftReg1;
wor bitShiftReg3TmrError;
wire [31:0] bitShiftReg3;
wor bitShiftReg2TmrError;
wire [31:0] bitShiftReg2;
wor int_hshakeTmrError;
wire int_hshake;
wor bitShiftReg0TmrError;
wire [31:0] bitShiftReg0;
reg  [4:0] pointer_serA;
reg  [4:0] pointer_serB;
reg  [4:0] pointer_serC;
wire [4:0] next_ptr_serA;
wire [4:0] next_ptr_serB;
wire [4:0] next_ptr_serC;
reg  [31:0] bitShiftReg0A;
reg  [31:0] bitShiftReg0B;
reg  [31:0] bitShiftReg0C;
reg  [31:0] bitShiftReg1A;
reg  [31:0] bitShiftReg1B;
reg  [31:0] bitShiftReg1C;
reg  [31:0] bitShiftReg2A;
reg  [31:0] bitShiftReg2B;
reg  [31:0] bitShiftReg2C;
reg  [31:0] bitShiftReg3A;
reg  [31:0] bitShiftReg3B;
reg  [31:0] bitShiftReg3C;
reg  load_serA;
reg  load_serB;
reg  load_serC;
reg  int_hshakeA;
reg  int_hshakeB;
reg  int_hshakeC;
wire set_hshakeA;
wire set_hshakeB;
wire set_hshakeC;
wire rst_hshakeA;
wire rst_hshakeB;
wire rst_hshakeC;
wire next_loadA;
wire next_loadB;
wire next_loadC;
reg  rstb_syncA;
reg  rstb_syncB;
reg  rstb_syncC;
assign next_ptr_serA =  pointer_serA+5'b00001;
assign next_ptr_serB =  pointer_serB+5'b00001;
assign next_ptr_serC =  pointer_serC+5'b00001;

always @( posedge clockA )
  begin
    rstb_syncA <= rst_bA;
  end

always @( posedge clockB )
  begin
    rstb_syncB <= rst_bB;
  end

always @( posedge clockC )
  begin
    rstb_syncC <= rst_bC;
  end

always @( posedge clockA )
  begin
    if (rstb_syncVotedA==1'b0)
      begin
        pointer_serA <= 5'b0;
      end
    else
      begin
        pointer_serA <= next_ptr_serA;
      end
  end

always @( posedge clockB )
  begin
    if (rstb_syncVotedB==1'b0)
      begin
        pointer_serB <= 5'b0;
      end
    else
      begin
        pointer_serB <= next_ptr_serB;
      end
  end

always @( posedge clockC )
  begin
    if (rstb_syncVotedC==1'b0)
      begin
        pointer_serC <= 5'b0;
      end
    else
      begin
        pointer_serC <= next_ptr_serC;
      end
  end
assign set_hshakeA =  (pointer_serA==5'b00010) ? 1'b1 : 1'b0;
assign set_hshakeB =  (pointer_serB==5'b00010) ? 1'b1 : 1'b0;
assign set_hshakeC =  (pointer_serC==5'b00010) ? 1'b1 : 1'b0;
assign rst_hshakeA =  (pointer_serA==5'b01010) ? 1'b1 : 1'b0;
assign rst_hshakeB =  (pointer_serB==5'b01010) ? 1'b1 : 1'b0;
assign rst_hshakeC =  (pointer_serC==5'b01010) ? 1'b1 : 1'b0;
assign next_loadA =  (pointer_serA==5'b11111) ? 1'b1 : 1'b0;
assign next_loadB =  (pointer_serB==5'b11111) ? 1'b1 : 1'b0;
assign next_loadC =  (pointer_serC==5'b11111) ? 1'b1 : 1'b0;

always @( posedge clockA )
  begin
    if (rstb_syncVotedA==1'b0)
      int_hshakeA <= 1'b0;
    else
      begin
        if (set_hshakeA==1)
          int_hshakeA <= 1'b1;
        else
          if (rst_hshakeA==1)
            int_hshakeA <= 1'b0;
      end
  end

always @( posedge clockB )
  begin
    if (rstb_syncVotedB==1'b0)
      int_hshakeB <= 1'b0;
    else
      begin
        if (set_hshakeB==1)
          int_hshakeB <= 1'b1;
        else
          if (rst_hshakeB==1)
            int_hshakeB <= 1'b0;
      end
  end

always @( posedge clockC )
  begin
    if (rstb_syncVotedC==1'b0)
      int_hshakeC <= 1'b0;
    else
      begin
        if (set_hshakeC==1)
          int_hshakeC <= 1'b1;
        else
          if (rst_hshakeC==1)
            int_hshakeC <= 1'b0;
      end
  end
assign handshake =  int_hshake;

always @( posedge clockA )
  begin
    if (rstb_syncVotedA==1'b0)
      load_serA <= 1'b1;
    else
      load_serA <= next_loadA;
  end

always @( posedge clockB )
  begin
    if (rstb_syncVotedB==1'b0)
      load_serB <= 1'b1;
    else
      load_serB <= next_loadB;
  end

always @( posedge clockC )
  begin
    if (rstb_syncVotedC==1'b0)
      load_serC <= 1'b1;
    else
      load_serC <= next_loadC;
  end

always @( posedge clockA )
  begin
    if (rst_bA==1'b0|load_serA==1'b1)
      begin
        bitShiftReg0A <= DataIn0A;
        bitShiftReg1A <= DataIn1A;
        bitShiftReg2A <= DataIn2A;
        bitShiftReg3A <= DataIn3A;
      end
    else
      begin
        bitShiftReg0A <= {bitShiftReg0A[30:0] ,1'b0};
        bitShiftReg1A <= {bitShiftReg1A[30:0] ,1'b0};
        bitShiftReg2A <= {bitShiftReg2A[30:0] ,1'b0};
        bitShiftReg3A <= {bitShiftReg3A[30:0] ,1'b0};
      end
  end

always @( posedge clockB )
  begin
    if (rst_bB==1'b0|load_serB==1'b1)
      begin
        bitShiftReg0B <= DataIn0B;
        bitShiftReg1B <= DataIn1B;
        bitShiftReg2B <= DataIn2B;
        bitShiftReg3B <= DataIn3B;
      end
    else
      begin
        bitShiftReg0B <= {bitShiftReg0B[30:0] ,1'b0};
        bitShiftReg1B <= {bitShiftReg1B[30:0] ,1'b0};
        bitShiftReg2B <= {bitShiftReg2B[30:0] ,1'b0};
        bitShiftReg3B <= {bitShiftReg3B[30:0] ,1'b0};
      end
  end

always @( posedge clockC )
  begin
    if (rst_bC==1'b0|load_serC==1'b1)
      begin
        bitShiftReg0C <= DataIn0C;
        bitShiftReg1C <= DataIn1C;
        bitShiftReg2C <= DataIn2C;
        bitShiftReg3C <= DataIn3C;
      end
    else
      begin
        bitShiftReg0C <= {bitShiftReg0C[30:0] ,1'b0};
        bitShiftReg1C <= {bitShiftReg1C[30:0] ,1'b0};
        bitShiftReg2C <= {bitShiftReg2C[30:0] ,1'b0};
        bitShiftReg3C <= {bitShiftReg3C[30:0] ,1'b0};
      end
  end
assign DataOut0 =  bitShiftReg0[31] ;
assign DataOut1 =  bitShiftReg1[31] ;
assign DataOut2 =  bitShiftReg2[31] ;
assign DataOut3 =  bitShiftReg3[31] ;

Ser_mVoter #(.WIDTH(32)) bitShiftReg0Voter (
    .inA(bitShiftReg0A),
    .inB(bitShiftReg0B),
    .inC(bitShiftReg0C),
    .out(bitShiftReg0),
    .tmrErr(bitShiftReg0TmrError)
    );

Ser_mVoter int_hshakeVoter (
    .inA(int_hshakeA),
    .inB(int_hshakeB),
    .inC(int_hshakeC),
    .out(int_hshake),
    .tmrErr(int_hshakeTmrError)
    );

Ser_mVoter #(.WIDTH(32)) bitShiftReg2Voter (
    .inA(bitShiftReg2A),
    .inB(bitShiftReg2B),
    .inC(bitShiftReg2C),
    .out(bitShiftReg2),
    .tmrErr(bitShiftReg2TmrError)
    );

Ser_mVoter #(.WIDTH(32)) bitShiftReg3Voter (
    .inA(bitShiftReg3A),
    .inB(bitShiftReg3B),
    .inC(bitShiftReg3C),
    .out(bitShiftReg3),
    .tmrErr(bitShiftReg3TmrError)
    );

Ser_mVoter #(.WIDTH(32)) bitShiftReg1Voter (
    .inA(bitShiftReg1A),
    .inB(bitShiftReg1B),
    .inC(bitShiftReg1C),
    .out(bitShiftReg1),
    .tmrErr(bitShiftReg1TmrError)
    );

Ser_mVoter rstb_syncVoterA (
    .inA(rstb_syncA),
    .inB(rstb_syncB),
    .inC(rstb_syncC),
    .out(rstb_syncVotedA),
    .tmrErr(rstb_syncTmrErrorA)
    );

Ser_mVoter rstb_syncVoterB (
    .inA(rstb_syncA),
    .inB(rstb_syncB),
    .inC(rstb_syncC),
    .out(rstb_syncVotedB),
    .tmrErr(rstb_syncTmrErrorB)
    );

Ser_mVoter rstb_syncVoterC (
    .inA(rstb_syncA),
    .inB(rstb_syncB),
    .inC(rstb_syncC),
    .out(rstb_syncVotedC),
    .tmrErr(rstb_syncTmrErrorC)
    );

Ser_fout clockFanout (
    .in(clock),
    .outA(clockA),
    .outB(clockB),
    .outC(clockC)
    );

Ser_fout #(.WIDTH(32)) DataIn2Fanout (
    .in(DataIn2),
    .outA(DataIn2A),
    .outB(DataIn2B),
    .outC(DataIn2C)
    );

Ser_fout #(.WIDTH(32)) DataIn1Fanout (
    .in(DataIn1),
    .outA(DataIn1A),
    .outB(DataIn1B),
    .outC(DataIn1C)
    );

Ser_fout #(.WIDTH(32)) DataIn3Fanout (
    .in(DataIn3),
    .outA(DataIn3A),
    .outB(DataIn3B),
    .outC(DataIn3C)
    );

Ser_fout #(.WIDTH(32)) DataIn0Fanout (
    .in(DataIn0),
    .outA(DataIn0A),
    .outB(DataIn0B),
    .outC(DataIn0C)
    );
endmodule



// /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/tmrg/src/../common/voter.v
module Ser_mVoter (inA, inB, inC, out, tmrErr);
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


// /export/elt153xl/disk0/users/gianni/projects/LiTE-DTU/tmrg/src/../common/Ser_fout.v
module Ser_fout (in, outA, outB, outC);
  parameter WIDTH = 1;
  input   [(WIDTH-1):0]   in;
  output  [(WIDTH-1):0]   outA,outB,outC;
  assign outA=in;
  assign outB=in;
  assign outC=in;
endmodule
