/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/5_1_LDTU_Hamm_oFIFOTMR.v                                        *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 12/07/2021 12:08:10                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 5_1_LDTU_Hamm_oFIFO.v                                                                  *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-07-12 12:03:31.503268                                         *
 *           File Size         : 3323                                                               *
 *           MD5 hash          : 45275c33c6641fd23e3103796e074604                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale       1ns/1ps

module LDTU_oFIFOTMR(
  CLKA,
  CLKB,
  CLKC,
  rst_bA,
  rst_bB,
  rst_bC,
  start_writeA,
  start_writeB,
  start_writeC,
  read_signalA,
  read_signalB,
  read_signalC,
  data_inputA,
  data_inputB,
  data_inputC,
  data_output,
  empty_signal,
  full_signal,
  decode_signal,
  SeuError
);
parameter    Nbits_ham=38;
parameter    FifoDepth_buff=16;
parameter    bits_ptr=4;
wire tmrErrorC;
wor ptr_writeTmrErrorC;
wor ptr_readTmrErrorC;
wire [bits_ptr-1:0] ptr_readVotedC;
wire [bits_ptr-1:0] ptr_writeVotedC;
wire tmrErrorB;
wor ptr_writeTmrErrorB;
wor ptr_readTmrErrorB;
wire [bits_ptr-1:0] ptr_readVotedB;
wire [bits_ptr-1:0] ptr_writeVotedB;
wire tmrErrorA;
wor ptr_writeTmrErrorA;
wor ptr_readTmrErrorA;
wire [bits_ptr-1:0] ptr_readVotedA;
wire [bits_ptr-1:0] ptr_writeVotedA;
wire tmrError;
wor start_writeTmrError;
wor rst_bTmrError;
wor r_full_signalTmrError;
wor r_empty_signalTmrError;
wor r_decode_signalTmrError;
wor ptr_writeVotedTmrError;
wor ptr_readVotedTmrError;
wor data_inputTmrError;
wor CLKTmrError;
wire [Nbits_ham-1:0] data_input;
wire [bits_ptr-1:0] ptr_readVoted;
wire CLK;
wire r_empty_signal;
wire r_decode_signal;
wire [bits_ptr-1:0] ptr_writeVoted;
wire start_write;
wire rst_b;
wire r_full_signal;
output SeuError;
output empty_signal;
output full_signal;
output reg   [Nbits_ham-1:0] data_output;
output decode_signal;
wire r_empty_signalA;
wire r_empty_signalB;
wire r_empty_signalC;
wire r_full_signalA;
wire r_full_signalB;
wire r_full_signalC;
reg  r_decode_signalA;
reg  r_decode_signalB;
reg  r_decode_signalC;
input CLKA;
input CLKB;
input CLKC;
input rst_bA;
input rst_bB;
input rst_bC;
input start_writeA;
input start_writeB;
input start_writeC;
input read_signalA;
input read_signalB;
input read_signalC;
input [Nbits_ham-1:0] data_inputA;
input [Nbits_ham-1:0] data_inputB;
input [Nbits_ham-1:0] data_inputC;
reg  [bits_ptr-1:0] ptr_writeA;
reg  [bits_ptr-1:0] ptr_writeB;
reg  [bits_ptr-1:0] ptr_writeC;
reg  [bits_ptr-1:0] ptr_readA;
reg  [bits_ptr-1:0] ptr_readB;
reg  [bits_ptr-1:0] ptr_readC;
reg  [Nbits_ham-1:0] memory [ FifoDepth_buff-1 : 0 ] ;
assign SeuError =  tmrError;
assign r_empty_signalA =  (ptr_readVotedA==ptr_writeVotedA);
assign r_empty_signalB =  (ptr_readVotedB==ptr_writeVotedB);
assign r_empty_signalC =  (ptr_readVotedC==ptr_writeVotedC);
assign r_full_signalA =  ((ptr_readVotedA==ptr_writeVotedA+4'b1)||((ptr_readVotedA==4'b0)&&(ptr_writeVotedA==(4'b1111))));
assign r_full_signalB =  ((ptr_readVotedB==ptr_writeVotedB+4'b1)||((ptr_readVotedB==4'b0)&&(ptr_writeVotedB==(4'b1111))));
assign r_full_signalC =  ((ptr_readVotedC==ptr_writeVotedC+4'b1)||((ptr_readVotedC==4'b0)&&(ptr_writeVotedC==(4'b1111))));

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      ptr_writeA <= 4'b0;
    else
      begin
        if (start_writeA==1'b1)
          begin
            if (r_full_signalA==1'b0)
              ptr_writeA <= ptr_writeVotedA+4'b1;
            else
              ptr_writeA <= ptr_writeVotedA;
          end
        else
          ptr_writeA <= ptr_writeVotedA;
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      ptr_writeB <= 4'b0;
    else
      begin
        if (start_writeB==1'b1)
          begin
            if (r_full_signalB==1'b0)
              ptr_writeB <= ptr_writeVotedB+4'b1;
            else
              ptr_writeB <= ptr_writeVotedB;
          end
        else
          ptr_writeB <= ptr_writeVotedB;
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      ptr_writeC <= 4'b0;
    else
      begin
        if (start_writeC==1'b1)
          begin
            if (r_full_signalC==1'b0)
              ptr_writeC <= ptr_writeVotedC+4'b1;
            else
              ptr_writeC <= ptr_writeVotedC;
          end
        else
          ptr_writeC <= ptr_writeVotedC;
      end
  end

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      begin
        ptr_readA <= 4'b0;
        r_decode_signalA <= 1'b0;
      end
    else
      begin
        if (read_signalA==1'b1)
          begin
            if (r_empty_signalA==1'b0)
              begin
                ptr_readA <= ptr_readVotedA+4'b1;
                r_decode_signalA <= 1'b1;
              end
            else
              begin
                ptr_readA <= ptr_readVotedA;
                r_decode_signalA <= 1'b0;
              end
          end
        else
          begin
            ptr_readA <= ptr_readVotedA;
            r_decode_signalA <= 1'b0;
          end
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      begin
        ptr_readB <= 4'b0;
        r_decode_signalB <= 1'b0;
      end
    else
      begin
        if (read_signalB==1'b1)
          begin
            if (r_empty_signalB==1'b0)
              begin
                ptr_readB <= ptr_readVotedB+4'b1;
                r_decode_signalB <= 1'b1;
              end
            else
              begin
                ptr_readB <= ptr_readVotedB;
                r_decode_signalB <= 1'b0;
              end
          end
        else
          begin
            ptr_readB <= ptr_readVotedB;
            r_decode_signalB <= 1'b0;
          end
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      begin
        ptr_readC <= 4'b0;
        r_decode_signalC <= 1'b0;
      end
    else
      begin
        if (read_signalC==1'b1)
          begin
            if (r_empty_signalC==1'b0)
              begin
                ptr_readC <= ptr_readVotedC+4'b1;
                r_decode_signalC <= 1'b1;
              end
            else
              begin
                ptr_readC <= ptr_readVotedC;
                r_decode_signalC <= 1'b0;
              end
          end
        else
          begin
            ptr_readC <= ptr_readVotedC;
            r_decode_signalC <= 1'b0;
          end
      end
  end

always @( posedge CLK )
  begin
    if (rst_b==1'b0)
      memory[ptr_writeVoted]  <= 38'b0;
    else
      begin
        if (start_write==1'b1)
          begin
            if (r_full_signal==1'b0)
              memory[ptr_writeVoted]  <= data_input;
          end
      end
  end

always @( posedge CLK )
  begin
    if (rst_b==1'b0)
      data_output =  38'b01000000000000000000000000000000;
    else
      data_output =  memory[ptr_readVoted] ;
  end
assign empty_signal =  r_empty_signal;
assign full_signal =  r_full_signal;
assign decode_signal =  r_decode_signal;

majorityVoter r_full_signalVoter (
    .inA(r_full_signalA),
    .inB(r_full_signalB),
    .inC(r_full_signalC),
    .out(r_full_signal),
    .tmrErr(r_full_signalTmrError)
    );

majorityVoter rst_bVoter (
    .inA(rst_bA),
    .inB(rst_bB),
    .inC(rst_bC),
    .out(rst_b),
    .tmrErr(rst_bTmrError)
    );

majorityVoter start_writeVoter (
    .inA(start_writeA),
    .inB(start_writeB),
    .inC(start_writeC),
    .out(start_write),
    .tmrErr(start_writeTmrError)
    );

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_writeVotedVoter (
    .inA(ptr_writeVotedA),
    .inB(ptr_writeVotedB),
    .inC(ptr_writeVotedC),
    .out(ptr_writeVoted),
    .tmrErr(ptr_writeVotedTmrError)
    );

majorityVoter r_decode_signalVoter (
    .inA(r_decode_signalA),
    .inB(r_decode_signalB),
    .inC(r_decode_signalC),
    .out(r_decode_signal),
    .tmrErr(r_decode_signalTmrError)
    );

majorityVoter r_empty_signalVoter (
    .inA(r_empty_signalA),
    .inB(r_empty_signalB),
    .inC(r_empty_signalC),
    .out(r_empty_signal),
    .tmrErr(r_empty_signalTmrError)
    );

majorityVoter CLKVoter (
    .inA(CLKA),
    .inB(CLKB),
    .inC(CLKC),
    .out(CLK),
    .tmrErr(CLKTmrError)
    );

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_readVotedVoter (
    .inA(ptr_readVotedA),
    .inB(ptr_readVotedB),
    .inC(ptr_readVotedC),
    .out(ptr_readVoted),
    .tmrErr(ptr_readVotedTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_ham-1)>(0)) ? ((Nbits_ham-1)-(0)+1) : ((0)-(Nbits_ham-1)+1))) data_inputVoter (
    .inA(data_inputA),
    .inB(data_inputB),
    .inC(data_inputC),
    .out(data_input),
    .tmrErr(data_inputTmrError)
    );
assign tmrError =  CLKTmrError|data_inputTmrError|ptr_readVotedTmrError|ptr_writeVotedTmrError|r_decode_signalTmrError|r_empty_signalTmrError|r_full_signalTmrError|rst_bTmrError|start_writeTmrError;

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_writeVoterA (
    .inA(ptr_writeA),
    .inB(ptr_writeB),
    .inC(ptr_writeC),
    .out(ptr_writeVotedA),
    .tmrErr(ptr_writeTmrErrorA)
    );

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_readVoterA (
    .inA(ptr_readA),
    .inB(ptr_readB),
    .inC(ptr_readC),
    .out(ptr_readVotedA),
    .tmrErr(ptr_readTmrErrorA)
    );
assign tmrErrorA =  ptr_readTmrErrorA|ptr_writeTmrErrorA;

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_writeVoterB (
    .inA(ptr_writeA),
    .inB(ptr_writeB),
    .inC(ptr_writeC),
    .out(ptr_writeVotedB),
    .tmrErr(ptr_writeTmrErrorB)
    );

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_readVoterB (
    .inA(ptr_readA),
    .inB(ptr_readB),
    .inC(ptr_readC),
    .out(ptr_readVotedB),
    .tmrErr(ptr_readTmrErrorB)
    );
assign tmrErrorB =  ptr_readTmrErrorB|ptr_writeTmrErrorB;

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_writeVoterC (
    .inA(ptr_writeA),
    .inB(ptr_writeB),
    .inC(ptr_writeC),
    .out(ptr_writeVotedC),
    .tmrErr(ptr_writeTmrErrorC)
    );

majorityVoter #(.WIDTH(((bits_ptr-1)>(0)) ? ((bits_ptr-1)-(0)+1) : ((0)-(bits_ptr-1)+1))) ptr_readVoterC (
    .inA(ptr_readA),
    .inB(ptr_readB),
    .inC(ptr_readC),
    .out(ptr_readVotedC),
    .tmrErr(ptr_readTmrErrorC)
    );
assign tmrErrorC =  ptr_readTmrErrorC|ptr_writeTmrErrorC;
endmodule

