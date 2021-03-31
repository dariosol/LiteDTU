/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/4_LDTU_CUTMR.v                                                  *
 *                                                                                                  *
 * user    : soldi                                                                                  *
 * host    : elt159xl.to.infn.it                                                                    *
 * date    : 31/03/2021 08:54:49                                                                    *
 *                                                                                                  *
 * workdir : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/LiteDTUv2_0_NoTMR *
 * cmd     : /export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/tmrg/bin/tmrg -c     *
 *           tmr_Config/DTU_v2.cfg --tmr-dir=../LiteDTUv2_0_AUTOTMR/ -vvv                           *
 * tmrg rev: ececa199b20e3753893c07f87ef839ce926b269f                                               *
 *                                                                                                  *
 * src file: 4_LDTU_CU.v                                                                            *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-03-08 14:42:28.504065                                         *
 *           File Size         : 7590                                                               *
 *           MD5 hash          : db5474da4f469177969c7b6d2ddee872                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ps/1ps

module LDTU_CUTMR(
  CLKA,
  CLKB,
  CLKC,
  rst_bA,
  rst_bB,
  rst_bC,
  fallback,
  Load_data,
  DATA_32,
  Load_data_FB,
  DATA_32_FB,
  full,
  DATA_from_CU,
  losing_data,
  write_signal,
  read_signal,
  SeuError,
  handshake
);
parameter    Nbits_32=32;
parameter    FifoDepth_buff=64;
parameter    bits_ptr=6;
parameter    limit=6'b110001;
parameter    crcBits=12;
parameter    Initial=32'b11110000000000000000000000000000;
parameter    bits_counter=2;
wire fullC;
wire fullB;
wire fullA;
wire [Nbits_32-1:0] DATA_32_FBC;
wire [Nbits_32-1:0] DATA_32_FBB;
wire [Nbits_32-1:0] DATA_32_FBA;
wire Load_data_FBC;
wire Load_data_FBB;
wire Load_data_FBA;
wire fallbackC;
wire fallbackB;
wire fallbackA;
wire Load_dataC;
wire Load_dataB;
wire Load_dataA;
wire [Nbits_32-1:0] DATA_32C;
wire [Nbits_32-1:0] DATA_32B;
wire [Nbits_32-1:0] DATA_32A;
wire handshakeC;
wire handshakeB;
wire handshakeA;
wire tmrError;
wor write_signal_synchTmrError;
wor read_signal_synchTmrError;
wor losing_data_synchTmrError;
wor DATA_from_CU_synchTmrError;
wire [Nbits_32-1:0] DATA_from_CU_synch;
wire losing_data_synch;
wire read_signal_synch;
wire write_signal_synch;
input CLKA;
input CLKB;
input CLKC;
input rst_bA;
input rst_bB;
input rst_bC;
input fallback;
input Load_data;
input [Nbits_32-1:0] DATA_32;
input Load_data_FB;
input [Nbits_32-1:0] DATA_32_FB;
input full;
input handshake;
output losing_data;
output write_signal;
output [Nbits_32-1:0] DATA_from_CU;
output read_signal;
output SeuError;
reg  [7:0] NSampleA;
reg  [7:0] NSampleB;
reg  [7:0] NSampleC;
reg  [5:0] NlimitA;
reg  [5:0] NlimitB;
reg  [5:0] NlimitC;
reg  [7:0] NFrameA;
reg  [7:0] NFrameB;
reg  [7:0] NFrameC;
reg  [crcBits-1:0] crcA;
reg  [crcBits-1:0] crcB;
reg  [crcBits-1:0] crcC;
reg  r_read_signalA;
reg  r_read_signalB;
reg  r_read_signalC;
reg  r_losing_dataA;
reg  r_losing_dataB;
reg  r_losing_dataC;
reg  r_write_signalA;
reg  r_write_signalB;
reg  r_write_signalC;
reg  [Nbits_32-1:0] r_DATA_from_CUA;
reg  [Nbits_32-1:0] r_DATA_from_CUB;
reg  [Nbits_32-1:0] r_DATA_from_CUC;
wire read_signal_synchA;
wire read_signal_synchB;
wire read_signal_synchC;
wire losing_data_synchA;
wire losing_data_synchB;
wire losing_data_synchC;
wire write_signal_synchA;
wire write_signal_synchB;
wire write_signal_synchC;
wire [Nbits_32-1:0] DATA_from_CU_synchA;
wire [Nbits_32-1:0] DATA_from_CU_synchB;
wire [Nbits_32-1:0] DATA_from_CU_synchC;
wire [crcBits-1:0] out_crcA;
wire [crcBits-1:0] out_crcB;
wire [crcBits-1:0] out_crcC;
wire check_limitA;
wire check_limitB;
wire check_limitC;
wire [7:0] NSamplesA;
wire [7:0] NSamplesB;
wire [7:0] NSamplesC;
wire [Nbits_32-1:0] wireTrailerA;
wire [Nbits_32-1:0] wireTrailerB;
wire [Nbits_32-1:0] wireTrailerC;
assign check_limitA =  (NlimitA>limit) ? 1'b1 : 1'b0;
assign check_limitB =  (NlimitB>limit) ? 1'b1 : 1'b0;
assign check_limitC =  (NlimitC>limit) ? 1'b1 : 1'b0;
assign NSamplesA =  (NlimitA==6'b0) ? 8'b0 : NSampleA;
assign NSamplesB =  (NlimitB==6'b0) ? 8'b0 : NSampleB;
assign NSamplesC =  (NlimitC==6'b0) ? 8'b0 : NSampleC;
assign wireTrailerA =  {4'b1101,NSamplesA,crcA,NFrameA};
assign wireTrailerB =  {4'b1101,NSamplesB,crcB,NFrameB};
assign wireTrailerC =  {4'b1101,NSamplesC,crcC,NFrameC};
wire [crcBits-1:0] wcrcA;
wire [crcBits-1:0] wcrcB;
wire [crcBits-1:0] wcrcC;
assign wcrcA =  crcA;
assign wcrcB =  crcB;
assign wcrcC =  crcC;
assign SeuError =  tmrError;

CRC_calc calc_crcA (
    .reset(rst_bA),
    .data(DATA_32A),
    .crc(wcrcA),
    .newcrc(out_crcA)
    );

CRC_calc calc_crcB (
    .reset(rst_bB),
    .data(DATA_32B),
    .crc(wcrcB),
    .newcrc(out_crcB)
    );

CRC_calc calc_crcC (
    .reset(rst_bC),
    .data(DATA_32C),
    .crc(wcrcC),
    .newcrc(out_crcC)
    );
wire [7:0] sum_valA;
wire [7:0] sum_valB;
wire [7:0] sum_valC;

SumValue SumValueA (
    .data(DATA_32A[31:24] ),
    .sum_val(sum_valA)
    );

SumValue SumValueB (
    .data(DATA_32B[31:24] ),
    .sum_val(sum_valB)
    );

SumValue SumValueC (
    .data(DATA_32C[31:24] ),
    .sum_val(sum_valC)
    );

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0||fallbackA==1'b1)
      begin
        NSampleA <= 8'b0;
        NlimitA <= 6'b0;
        NFrameA <= 8'b0;
        crcA <= 12'b0;
      end
    else
      begin
        if (Load_dataA==1'b0)
          begin
            if (check_limitA==1'b1)
              begin
                if (fullA==1'b0)
                  begin
                    NSampleA <= 8'b0;
                    NlimitA <= 6'b0;
                    crcA <= 12'b0;
                    NFrameA <= NFrameA+8'b1;
                  end
              end
          end
        else
          begin
            if (fullA==1'b0)
              begin
                NlimitA <= NlimitA+6'b1;
                NSampleA <= NSampleA+sum_valA;
                crcA <= out_crcA;
              end
          end
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0||fallbackB==1'b1)
      begin
        NSampleB <= 8'b0;
        NlimitB <= 6'b0;
        NFrameB <= 8'b0;
        crcB <= 12'b0;
      end
    else
      begin
        if (Load_dataB==1'b0)
          begin
            if (check_limitB==1'b1)
              begin
                if (fullB==1'b0)
                  begin
                    NSampleB <= 8'b0;
                    NlimitB <= 6'b0;
                    crcB <= 12'b0;
                    NFrameB <= NFrameB+8'b1;
                  end
              end
          end
        else
          begin
            if (fullB==1'b0)
              begin
                NlimitB <= NlimitB+6'b1;
                NSampleB <= NSampleB+sum_valB;
                crcB <= out_crcB;
              end
          end
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0||fallbackC==1'b1)
      begin
        NSampleC <= 8'b0;
        NlimitC <= 6'b0;
        NFrameC <= 8'b0;
        crcC <= 12'b0;
      end
    else
      begin
        if (Load_dataC==1'b0)
          begin
            if (check_limitC==1'b1)
              begin
                if (fullC==1'b0)
                  begin
                    NSampleC <= 8'b0;
                    NlimitC <= 6'b0;
                    crcC <= 12'b0;
                    NFrameC <= NFrameC+8'b1;
                  end
              end
          end
        else
          begin
            if (fullC==1'b0)
              begin
                NlimitC <= NlimitC+6'b1;
                NSampleC <= NSampleC+sum_valC;
                crcC <= out_crcC;
              end
          end
      end
  end

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      begin
        r_DATA_from_CUA <= Initial;
        r_losing_dataA <= 1'b0;
        r_write_signalA <= 1'b0;
      end
    else
      begin
        if (Load_dataA==1'b0&&Load_data_FBA==1'b0)
          begin
            r_losing_dataA <= 1'b0;
            if (check_limitA==1'b1&&fallbackA==1'b0)
              begin
                if (fullA==1'b0)
                  begin
                    r_DATA_from_CUA <= wireTrailerA;
                    r_write_signalA <= 1'b1;
                  end
                else
                  begin
                    r_write_signalA <= 1'b0;
                  end
              end
            else
              begin
                r_write_signalA <= 1'b0;
              end
          end
        else
          begin
            if (fullA==1'b0&&fallbackA==1'b0)
              begin
                r_write_signalA <= 1'b1;
                r_losing_dataA <= 1'b0;
                r_DATA_from_CUA <= DATA_32A;
              end
            else
              if (fullA==1'b0&&fallbackA==1'b1)
                begin
                  r_write_signalA <= 1'b1;
                  r_losing_dataA <= 1'b0;
                  r_DATA_from_CUA <= DATA_32_FBA;
                end
              else
                begin
                  r_losing_dataA <= 1'b1;
                  r_write_signalA <= 1'b0;
                end
          end
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      begin
        r_DATA_from_CUB <= Initial;
        r_losing_dataB <= 1'b0;
        r_write_signalB <= 1'b0;
      end
    else
      begin
        if (Load_dataB==1'b0&&Load_data_FBB==1'b0)
          begin
            r_losing_dataB <= 1'b0;
            if (check_limitB==1'b1&&fallbackB==1'b0)
              begin
                if (fullB==1'b0)
                  begin
                    r_DATA_from_CUB <= wireTrailerB;
                    r_write_signalB <= 1'b1;
                  end
                else
                  begin
                    r_write_signalB <= 1'b0;
                  end
              end
            else
              begin
                r_write_signalB <= 1'b0;
              end
          end
        else
          begin
            if (fullB==1'b0&&fallbackB==1'b0)
              begin
                r_write_signalB <= 1'b1;
                r_losing_dataB <= 1'b0;
                r_DATA_from_CUB <= DATA_32B;
              end
            else
              if (fullB==1'b0&&fallbackB==1'b1)
                begin
                  r_write_signalB <= 1'b1;
                  r_losing_dataB <= 1'b0;
                  r_DATA_from_CUB <= DATA_32_FBB;
                end
              else
                begin
                  r_losing_dataB <= 1'b1;
                  r_write_signalB <= 1'b0;
                end
          end
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      begin
        r_DATA_from_CUC <= Initial;
        r_losing_dataC <= 1'b0;
        r_write_signalC <= 1'b0;
      end
    else
      begin
        if (Load_dataC==1'b0&&Load_data_FBC==1'b0)
          begin
            r_losing_dataC <= 1'b0;
            if (check_limitC==1'b1&&fallbackC==1'b0)
              begin
                if (fullC==1'b0)
                  begin
                    r_DATA_from_CUC <= wireTrailerC;
                    r_write_signalC <= 1'b1;
                  end
                else
                  begin
                    r_write_signalC <= 1'b0;
                  end
              end
            else
              begin
                r_write_signalC <= 1'b0;
              end
          end
        else
          begin
            if (fullC==1'b0&&fallbackC==1'b0)
              begin
                r_write_signalC <= 1'b1;
                r_losing_dataC <= 1'b0;
                r_DATA_from_CUC <= DATA_32C;
              end
            else
              if (fullC==1'b0&&fallbackC==1'b1)
                begin
                  r_write_signalC <= 1'b1;
                  r_losing_dataC <= 1'b0;
                  r_DATA_from_CUC <= DATA_32_FBC;
                end
              else
                begin
                  r_losing_dataC <= 1'b1;
                  r_write_signalC <= 1'b0;
                end
          end
      end
  end

always @( posedge CLKA )
  begin
    if (rst_bA==1'b0)
      r_read_signalA <= 1'b0;
    else
      begin
        if (handshakeA==1'b1)
          begin
            r_read_signalA <= 1'b1;
          end
        else
          r_read_signalA <= 1'b0;
      end
  end

always @( posedge CLKB )
  begin
    if (rst_bB==1'b0)
      r_read_signalB <= 1'b0;
    else
      begin
        if (handshakeB==1'b1)
          begin
            r_read_signalB <= 1'b1;
          end
        else
          r_read_signalB <= 1'b0;
      end
  end

always @( posedge CLKC )
  begin
    if (rst_bC==1'b0)
      r_read_signalC <= 1'b0;
    else
      begin
        if (handshakeC==1'b1)
          begin
            r_read_signalC <= 1'b1;
          end
        else
          r_read_signalC <= 1'b0;
      end
  end
assign read_signal_synchA =  r_read_signalA;
assign read_signal_synchB =  r_read_signalB;
assign read_signal_synchC =  r_read_signalC;
assign write_signal_synchA =  r_write_signalA;
assign write_signal_synchB =  r_write_signalB;
assign write_signal_synchC =  r_write_signalC;
assign losing_data_synchA =  r_losing_dataA;
assign losing_data_synchB =  r_losing_dataB;
assign losing_data_synchC =  r_losing_dataC;
assign DATA_from_CU_synchA =  r_DATA_from_CUA;
assign DATA_from_CU_synchB =  r_DATA_from_CUB;
assign DATA_from_CU_synchC =  r_DATA_from_CUC;
assign read_signal =  read_signal_synch;
assign write_signal =  write_signal_synch;
assign losing_data =  losing_data_synch;
assign DATA_from_CU =  DATA_from_CU_synch;

majorityVoter write_signal_synchVoter (
    .inA(write_signal_synchA),
    .inB(write_signal_synchB),
    .inC(write_signal_synchC),
    .out(write_signal_synch),
    .tmrErr(write_signal_synchTmrError)
    );

majorityVoter read_signal_synchVoter (
    .inA(read_signal_synchA),
    .inB(read_signal_synchB),
    .inC(read_signal_synchC),
    .out(read_signal_synch),
    .tmrErr(read_signal_synchTmrError)
    );

majorityVoter losing_data_synchVoter (
    .inA(losing_data_synchA),
    .inB(losing_data_synchB),
    .inC(losing_data_synchC),
    .out(losing_data_synch),
    .tmrErr(losing_data_synchTmrError)
    );

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_from_CU_synchVoter (
    .inA(DATA_from_CU_synchA),
    .inB(DATA_from_CU_synchB),
    .inC(DATA_from_CU_synchC),
    .out(DATA_from_CU_synch),
    .tmrErr(DATA_from_CU_synchTmrError)
    );
assign tmrError =  DATA_from_CU_synchTmrError|losing_data_synchTmrError|read_signal_synchTmrError|write_signal_synchTmrError;

fanout handshakeFanout (
    .in(handshake),
    .outA(handshakeA),
    .outB(handshakeB),
    .outC(handshakeC)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_32Fanout (
    .in(DATA_32),
    .outA(DATA_32A),
    .outB(DATA_32B),
    .outC(DATA_32C)
    );

fanout Load_dataFanout (
    .in(Load_data),
    .outA(Load_dataA),
    .outB(Load_dataB),
    .outC(Load_dataC)
    );

fanout fallbackFanout (
    .in(fallback),
    .outA(fallbackA),
    .outB(fallbackB),
    .outC(fallbackC)
    );

fanout Load_data_FBFanout (
    .in(Load_data_FB),
    .outA(Load_data_FBA),
    .outB(Load_data_FBB),
    .outC(Load_data_FBC)
    );

fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_32_FBFanout (
    .in(DATA_32_FB),
    .outA(DATA_32_FBA),
    .outB(DATA_32_FBB),
    .outC(DATA_32_FBC)
    );

fanout fullFanout (
    .in(full),
    .outA(fullA),
    .outB(fullB),
    .outC(fullC)
    );
endmodule

module CRC_calc(
  reset,
  data,
  crc,
  newcrc
);
parameter    Nbits_32=32;
parameter    crcBits=12;
input reset;
input [Nbits_32-1:0] data;
input [crcBits-1:0] crc;
output [crcBits-1:0] newcrc;
wire bit_0;
wire bit_1;
wire bit_2;
wire bit_3;
wire bit_4;
wire bit_5;
wire bit_6;
wire bit_7;
wire bit_8;
wire bit_9;
wire bit_10;
wire bit_11;
assign bit_0 =  (reset==1'b0) ? 1'b0 : data[30] ^data[29] ^data[26] ^data[25] ^data[24] ^data[23] ^data[22] ^data[17] ^data[16] ^data[15] ^data[14] ^data[13] ^data[12] ^data[11] ^data[8] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[1] ^data[0] ^crc[2] ^crc[3] ^crc[4] ^crc[5] ^crc[6] ^crc[9] ^crc[10] ;
assign bit_1 =  (reset==1'b0) ? 1'b0 : data[31] ^data[29] ^data[27] ^data[22] ^data[18] ^data[11] ^data[9] ^data[0] ^crc[2] ^crc[7] ^crc[9] ^crc[11] ;
assign bit_2 =  (reset==1'b0) ? 1'b0 : data[29] ^data[28] ^data[26] ^data[25] ^data[24] ^data[22] ^data[19] ^data[17] ^data[16] ^data[15] ^data[14] ^data[13] ^data[11] ^data[10] ^data[8] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[0] ^crc[2] ^crc[4] ^crc[5] ^crc[6] ^crc[8] ^crc[9] ;
assign bit_3 =  (reset==1'b0) ? 1'b0 : data[27] ^data[24] ^data[22] ^data[20] ^data[18] ^data[13] ^data[9] ^data[2] ^data[0] ^crc[0] ^crc[2] ^crc[4] ^crc[7] ;
assign bit_4 =  (reset==1'b0) ? 1'b0 : data[28] ^data[25] ^data[23] ^data[21] ^data[19] ^data[14] ^data[10] ^data[3] ^data[1] ^crc[1] ^crc[3] ^crc[5] ^crc[8] ;
assign bit_5 =  (reset==1'b0) ? 1'b0 : data[29] ^data[26] ^data[24] ^data[22] ^data[20] ^data[15] ^data[11] ^data[4] ^data[2] ^crc[0] ^crc[2] ^crc[4] ^crc[6] ^crc[9] ;
assign bit_6 =  (reset==1'b0) ? 1'b0 : data[30] ^data[27] ^data[25] ^data[23] ^data[21] ^data[16] ^data[12] ^data[5] ^data[3] ^crc[1] ^crc[3] ^crc[5] ^crc[7] ^crc[10] ;
assign bit_7 =  (reset==1'b0) ? 1'b0 : data[31] ^data[28] ^data[26] ^data[24] ^data[22] ^data[17] ^data[13] ^data[6] ^data[4] ^crc[2] ^crc[4] ^crc[6] ^crc[8] ^crc[11] ;
assign bit_8 =  (reset==1'b0) ? 1'b0 : data[29] ^data[27] ^data[25] ^data[23] ^data[18] ^data[14] ^data[7] ^data[5] ^crc[3] ^crc[5] ^crc[7] ^crc[9] ;
assign bit_9 =  (reset==1'b0) ? 1'b0 : data[30] ^data[28] ^data[26] ^data[24] ^data[19] ^data[15] ^data[8] ^data[6] ^crc[4] ^crc[6] ^crc[8] ^crc[10] ;
assign bit_10 =  (reset==1'b0) ? 1'b0 : data[31] ^data[29] ^data[27] ^data[25] ^data[20] ^data[16] ^data[9] ^data[7] ^crc[0] ^crc[5] ^crc[7] ^crc[9] ^crc[11] ;
assign bit_11 =  (reset==1'b0) ? 1'b0 : data[29] ^data[28] ^data[25] ^data[24] ^data[23] ^data[22] ^data[21] ^data[16] ^data[15] ^data[14] ^data[13] ^data[12] ^data[11] ^data[10] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[1] ^data[0] ^crc[1] ^crc[2] ^crc[3] ^crc[4] ^crc[5] ^crc[8] ^crc[9] ;
assign newcrc =  {bit_11,bit_10,bit_9,bit_8,bit_7,bit_6,bit_5,bit_4,bit_3,bit_2,bit_1,bit_0};
endmodule

module SumValue(
  data,
  sum_val
);
input [7:0] data;
output reg   [7:0] sum_val;

always @( data )
  begin
    case (data[7:6] )
      2'b01 : sum_val =  8'b101;
      2'b10 : sum_val =  {2'b0,data[5:0] };
      2'b00 : 
        begin
          if (data[7:2] ==6'b001010)
            sum_val =  8'b10;
          else
            sum_val =  8'b1;
        end
      default : sum_val =  8'b0;
    endcase
  end
endmodule

