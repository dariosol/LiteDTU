/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../LiteDTUv2_0_AUTOTMR/5_0_LDTU_Hamm_TRXTMR.v                                          *
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
 * src file: 5_0_LDTU_Hamm_TRX.v                                                                    *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2021-03-08 12:01:27.601214                                         *
 *           File Size         : 3681                                                               *
 *           MD5 hash          : 84e1765d4e695160c79152428bca864d                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale   1ps/1ps

module Hamm_TRX(
  CLK,
  reset,
  data_input,
  data_ham_in,
  write_signal,
  start_write
);
parameter    Nbits_32=32;
parameter    Nbits_ham=38;
input CLK;
input reset;
input [Nbits_32-1:0] data_input;
input write_signal;
output reg   [Nbits_ham-1:0] data_ham_in;
output reg    start_write;
wire p1;
wire p2;
wire p3;
wire p4;
wire p5;
wire p6;
assign p1 =  (reset==1'b0) ? 1'b0 : data_input[0] ^data_input[1] ^data_input[3] ^data_input[4] ^data_input[6] ^data_input[8] ^data_input[10] ^data_input[11] ^data_input[13] ^data_input[15] ^data_input[17] ^data_input[19] ^data_input[21] ^data_input[23] ^data_input[25] ^data_input[26] ^data_input[28] ^data_input[30] ;
assign p2 =  (reset==1'b0) ? 1'b0 : data_input[0] ^data_input[2] ^data_input[3] ^data_input[5] ^data_input[6] ^data_input[9] ^data_input[10] ^data_input[12] ^data_input[13] ^data_input[16] ^data_input[17] ^data_input[20] ^data_input[21] ^data_input[24] ^data_input[25] ^data_input[27] ^data_input[28] ^data_input[31] ;
assign p3 =  (reset==1'b0) ? 1'b0 : data_input[1] ^data_input[2] ^data_input[3] ^data_input[7] ^data_input[8] ^data_input[9] ^data_input[10] ^data_input[14] ^data_input[15] ^data_input[16] ^data_input[17] ^data_input[22] ^data_input[23] ^data_input[24] ^data_input[25] ^data_input[29] ^data_input[30] ^data_input[31] ;
assign p4 =  (reset==1'b0) ? 1'b0 : data_input[4] ^data_input[5] ^data_input[6] ^data_input[7] ^data_input[8] ^data_input[9] ^data_input[10] ^data_input[18] ^data_input[19] ^data_input[20] ^data_input[21] ^data_input[22] ^data_input[23] ^data_input[24] ^data_input[25] ;
assign p5 =  (reset==1'b0) ? 1'b0 : data_input[11] ^data_input[12] ^data_input[13] ^data_input[14] ^data_input[15] ^data_input[16] ^data_input[17] ^data_input[18] ^data_input[19] ^data_input[20] ^data_input[21] ^data_input[22] ^data_input[23] ^data_input[24] ^data_input[25] ;
assign p6 =  (reset==1'b0) ? 1'b0 : data_input[26] ^data_input[27] ^data_input[28] ^data_input[29] ^data_input[30] ^data_input[31] ;

always @( posedge CLK )
  begin
    if (reset==1'b0)
      begin
        data_ham_in =  38'b01000000000000000000000000000000;
        start_write =  1'b0;
      end
    else
      begin
        if (write_signal==1'b1)
          begin
            data_ham_in =  {data_input[31] ,data_input[30] ,data_input[29] ,data_input[28] ,data_input[27] ,data_input[26] ,p6,data_input[25] ,data_input[24] ,data_input[23] ,data_input[22] ,data_input[21] ,data_input[20] ,data_input[19] ,data_input[18] ,data_input[17] ,data_input[16] ,data_input[15] ,data_input[14] ,data_input[13] ,data_input[12] ,data_input[11] ,p5,data_input[10] ,data_input[9] ,data_input[8] ,data_input[7] ,data_input[6] ,data_input[5] ,data_input[4] ,p4,data_input[3] ,data_input[2] ,data_input[1] ,p3,data_input[0] ,p2,p1};
            start_write =  1'b1;
          end
        else
          begin
            start_write =  1'b0;
          end
      end
  end
endmodule

