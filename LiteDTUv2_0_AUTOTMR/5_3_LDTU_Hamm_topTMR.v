/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/5_3_LDTU_Hamm_topTMR.v                                          *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 22/04/2021 11:25:43                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 5_3_LDTU_Hamm_top.v                                                                    *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-04-19 14:24:33.450544                                         *
 *           File Size         : 3828                                                               *
 *           MD5 hash          : 43d25e1437d8979b44a3b12ca6e4246e                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale   1ps/1ps

module LDTU_oFIFO_topTMR(
  CLKA,
  CLKB,
  CLKC,
  rst_bA,
  rst_bB,
  rst_bC,
  write_signal,
  read_signal,
  data_in_32,
  flush_bA,
  flush_bB,
  flush_bC,
  synchA,
  synchB,
  synchC,
  synch_pattern,
  DATA32_DTU,
  full_signal,
  SeuError
);
parameter    Nbits_32=32;
parameter    Nbits_ham=38;
parameter    FifoDepth_buff=16;
parameter    bits_ptr=4;
parameter    idle_patternEA=32'b11101010101010101010101010101010;
parameter    idle_pattern5A=32'b01011010010110100101101001011010;
wire [Nbits_32-1:0] data_out_32C;
wire [Nbits_32-1:0] data_out_32B;
wire [Nbits_32-1:0] data_out_32A;
wire [Nbits_32-1:0] synch_patternC;
wire [Nbits_32-1:0] synch_patternB;
wire [Nbits_32-1:0] synch_patternA;
wire read_signalC;
wire read_signalB;
wire read_signalA;
wire start_writeC;
wire start_writeB;
wire start_writeA;
wire [Nbits_ham-1:0] data_in_38C;
wire [Nbits_ham-1:0] data_in_38B;
wire [Nbits_ham-1:0] data_in_38A;
wire empty_signalC;
wire empty_signalB;
wire empty_signalA;
wire fiforesetC;
wire fiforesetB;
wire fiforesetA;
wire tmrError;
wor synchTmrError;
wor rst_bTmrError;
wor flush_bTmrError;
wor DATA32_DTU_synchTmrError;
wor CLKTmrError;
wire flush_b;
wire rst_b;
wire CLK;
wire synch;
wire [Nbits_32-1:0] DATA32_DTU_synch;
input CLKA;
input CLKB;
input CLKC;
input rst_bA;
input rst_bB;
input rst_bC;
input write_signal;
input read_signal;
input [Nbits_32-1:0] data_in_32;
input flush_bA;
input flush_bB;
input flush_bC;
input synchA;
input synchB;
input synchC;
input [Nbits_32-1:0] synch_pattern;
output [Nbits_32-1:0] DATA32_DTU;
output full_signal;
output SeuError;
reg  [Nbits_32-1:0] DATA32_DTU_synchA;
reg  [Nbits_32-1:0] DATA32_DTU_synchB;
reg  [Nbits_32-1:0] DATA32_DTU_synchC;
wire CLKA;
wire CLKB;
wire CLKC;
wire reset;
wire [Nbits_ham-1:0] data_in_38;
wire [Nbits_ham-1:0] data_out_38;
wire [Nbits_32-1:0] data_out_32;
wire start_write;
wire HammError;
wire tmrError_oFIFO;
wire read_signal;
wire empty_signal;
wire full_signal_synch;
wire decode_signal;
assign SeuError =  tmrError|tmrError_oFIFO;
wire fiforeset;
assign fiforeset =  (rst_b&flush_b&~synch);

Hamm_TRX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham)) Hamming_32_38 (
    .CLK(CLK),
    .reset(fiforeset),
    .data_input(data_in_32),
    .data_ham_in(data_in_38),
    .write_signal(write_signal),
    .start_write(start_write)
    );

LDTU_oFIFOTMR #(.Nbits_ham(Nbits_ham)) FIFO (
    .CLKA(CLKA),
    .CLKB(CLKB),
    .CLKC(CLKC),
    .rst_bA(fiforesetA),
    .rst_bB(fiforesetB),
    .rst_bC(fiforesetC),
    .start_writeA(start_writeA),
    .start_writeB(start_writeB),
    .start_writeC(start_writeC),
    .read_signalA(read_signalA),
    .read_signalB(read_signalB),
    .read_signalC(read_signalC),
    .data_inputA(data_in_38A),
    .data_inputB(data_in_38B),
    .data_inputC(data_in_38C),
    .data_output(data_out_38),
    .full_signal(full_signal_synch),
    .decode_signal(decode_signal),
    .SeuError(tmrError_oFIFO),
    .empty_signal(empty_signal)
    );

Hamm_RX #(.Nbits_32(Nbits_32), .Nbits_ham(Nbits_ham)) Hamming_38_32 (
    .CLK(CLK),
    .reset(fiforeset),
    .decode_signal(decode_signal),
    .data_ham_out(data_out_38),
    .data_output(data_out_32),
    .HammError(HammError)
    );

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      begin
        DATA32_DTU_synchA =  idle_patternEA;
      end
    else
      begin
        if (flush_bA==1'b0)
          begin
            DATA32_DTU_synchA =  32'hFEEDC0DE;
          end
        else
          begin
            if (synchA==1'b1)
              begin
                DATA32_DTU_synchA =  synch_patternA;
              end
            else
              begin
                if (read_signalA==1'b1)
                  begin
                    if (empty_signalA==1'b1)
                      begin
                        DATA32_DTU_synchA =  idle_patternEA;
                      end
                    else
                      begin
                        DATA32_DTU_synchA =  data_out_32A;
                      end
                  end
              end
          end
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      begin
        DATA32_DTU_synchB =  idle_patternEA;
      end
    else
      begin
        if (flush_bB==1'b0)
          begin
            DATA32_DTU_synchB =  32'hFEEDC0DE;
          end
        else
          begin
            if (synchB==1'b1)
              begin
                DATA32_DTU_synchB =  synch_patternB;
              end
            else
              begin
                if (read_signalB==1'b1)
                  begin
                    if (empty_signalB==1'b1)
                      begin
                        DATA32_DTU_synchB =  idle_patternEA;
                      end
                    else
                      begin
                        DATA32_DTU_synchB =  data_out_32B;
                      end
                  end
              end
          end
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      begin
        DATA32_DTU_synchC =  idle_patternEA;
      end
    else
      begin
        if (flush_bC==1'b0)
          begin
            DATA32_DTU_synchC =  32'hFEEDC0DE;
          end
        else
          begin
            if (synchC==1'b1)
              begin
                DATA32_DTU_synchC =  synch_patternC;
              end
            else
              begin
                if (read_signalC==1'b1)
                  begin
                    if (empty_signalC==1'b1)
                      begin
                        DATA32_DTU_synchC =  idle_patternEA;
                      end
                    else
                      begin
                        DATA32_DTU_synchC =  data_out_32C;
                      end
                  end
              end
          end
      end
  end
assign DATA32_DTU =  DATA32_DTU_synch;
assign full_signal =  full_signal_synch;

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_DTU_synchVoter (
    .inA(DATA32_DTU_synchA),
    .inB(DATA32_DTU_synchB),
    .inC(DATA32_DTU_synchC),
    .out(DATA32_DTU_synch),
    .tmrErr(DATA32_DTU_synchTmrError)
    );

majorityVoter synchVoter (
    .inA(synchA),
    .inB(synchB),
    .inC(synchC),
    .out(synch),
    .tmrErr(synchTmrError)
    );

majorityVoter CLKVoter (
    .inA(CLKA),
    .inB(CLKB),
    .inC(CLKC),
    .out(CLK),
    .tmrErr(CLKTmrError)
    );

majorityVoter rst_bVoter (
    .inA(rst_bA),
    .inB(rst_bB),
    .inC(rst_bC),
    .out(rst_b),
    .tmrErr(rst_bTmrError)
    );

majorityVoter flush_bVoter (
    .inA(flush_bA),
    .inB(flush_bB),
    .inC(flush_bC),
    .out(flush_b),
    .tmrErr(flush_bTmrError)
    );
assign tmrError =  CLKTmrError|DATA32_DTU_synchTmrError|flush_bTmrError|rst_bTmrError|synchTmrError;

fanout fiforesetFanout (
    .in(fiforeset),
    .outA(fiforesetA),
    .outB(fiforesetB),
    .outC(fiforesetC)
    );

fanout empty_signalFanout (
    .in(empty_signal),
    .outA(empty_signalA),
    .outB(empty_signalB),
    .outC(empty_signalC)
    );

fanout #(.WIDTH(((Nbits_ham-1)>(0)) ? ((Nbits_ham-1)-(0)+1) : ((0)-(Nbits_ham-1)+1))) data_in_38Fanout (
    .in(data_in_38),
    .outA(data_in_38A),
    .outB(data_in_38B),
    .outC(data_in_38C)
    );

fanout start_writeFanout (
    .in(start_write),
    .outA(start_writeA),
    .outB(start_writeB),
    .outC(start_writeC)
    );

fanout read_signalFanout (
    .in(read_signal),
    .outA(read_signalA),
    .outB(read_signalB),
    .outC(read_signalC)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) synch_patternFanout (
    .in(synch_pattern),
    .outA(synch_patternA),
    .outB(synch_patternB),
    .outC(synch_patternC)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) data_out_32Fanout (
    .in(data_out_32),
    .outA(data_out_32A),
    .outB(data_out_32B),
    .outC(data_out_32C)
    );
endmodule

