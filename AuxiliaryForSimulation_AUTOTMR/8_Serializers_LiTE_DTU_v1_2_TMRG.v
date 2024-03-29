/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./7_TOPser_sr_v1TMR.v                                                                  *
 *                                                                                                  *
 * user    : cometti                                                                                *
 * host    : elt78xl.to.infn.it                                                                     *
 * date    : 11/11/2018 12:32:41                                                                    *
 *                                                                                                  *
 * workdir : /export/elt54xl/disk0/users/cometti/project/2-Synthesis/netlist_in/Ottobre_2018/TMR_files *
 * cmd     : /export/elt54xl/disk0/users/cometti/project/2-Synthesis/netlist_in/aa_DTU_ECAL_1ch_final/t *
 *           mrg/bin/tmrg -v 7_4_ser_sr_v1.v 7_TOPser_sr_v1.v                                       *
 * tmrg rev: 9a6ee4d64fce05b58c62ee9ecfc4ef5a8551d404                                               *
 *                                                                                                  *
 * src file: 7_TOPser_sr_v1.v                                                                       *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2018-11-11 12:29:58.591096                                         *
 *           File Size         : 4474                                                               *
 *           MD5 hash          : fa5bb284408b8f899692fbd0459f9ee5                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale    1ns/1ps
module Serializers_LiTE_DTU_v1_2_TMR(
  CLK_SRL,
  RST_A,
  RST_B,
  RST_C,
  CALIBRATION_BUSY_1,
  CALIBRATION_BUSY_10,
  TEST_ENABLE,
  DATA32_0,
  DATA32_1,
  DATA32_2,
  DATA32_3,
  decode_signal,
  output_ser_0,
  output_ser_1,
  output_ser_2,
  output_ser_3,
  handshake
); 

parameter    Nbits_32=32;
parameter    IDLE_pattern=32'b11101010101010101010101010101010;
parameter    IDLE_pattern_ser=32'h5a5a5a5a;
parameter    Nbits_5=5;
wire CALIBRATION_BUSY_1_C;
wire CALIBRATION_BUSY_1_B;
wire CALIBRATION_BUSY_1_A;
wire [Nbits_32-1:0] DATA32_0_C;
wire [Nbits_32-1:0] DATA32_0_B;
wire [Nbits_32-1:0] DATA32_0_A;
wire [Nbits_32-1:0] DATA32_1_C;
wire [Nbits_32-1:0] DATA32_1_B;
wire [Nbits_32-1:0] DATA32_1_A;
wire [Nbits_32-1:0] DATA32_2_C;
wire [Nbits_32-1:0] DATA32_2_B;
wire [Nbits_32-1:0] DATA32_2_A;
wire [Nbits_32-1:0] DATA32_3_C;
wire [Nbits_32-1:0] DATA32_3_B;
wire [Nbits_32-1:0] DATA32_3_A;
wire decode_signal_C;
wire decode_signal_B;
wire decode_signal_A;
wire CALIBRATION_BUSY_10_C;
wire CALIBRATION_BUSY_10_B;
wire CALIBRATION_BUSY_10_A;
wire TEST_ENABLE_C;
wire TEST_ENABLE_B;
wire TEST_ENABLE_A;
wire tmrError;
wire pointer_serTmrError;
wire [Nbits_5-1:0] pointer_ser;
wire START_SERTmrError;
wire handshakeTmrError;
wire Serializer_0tmrError;
wire Serializer_1tmrError;
wire Serializer_2tmrError;
wire Serializer_3tmrError;
input CLK_SRL;
input RST_A;
input RST_B;
input RST_C;
input CALIBRATION_BUSY_1;
input CALIBRATION_BUSY_10;
input TEST_ENABLE;
input [Nbits_32-1:0] DATA32_0;
input [Nbits_32-1:0] DATA32_1;
input [Nbits_32-1:0] DATA32_2;
input [Nbits_32-1:0] DATA32_3;
input decode_signal;
output output_ser_0;
output output_ser_1;
output output_ser_2;
output output_ser_3;
output handshake;
wire [Nbits_32-1:0] data_to_ser_0_A;
wire [Nbits_32-1:0] data_to_ser_0_B;
wire [Nbits_32-1:0] data_to_ser_0_C;
wire [Nbits_32-1:0] data_to_ser_1_A;
wire [Nbits_32-1:0] data_to_ser_1_B;
wire [Nbits_32-1:0] data_to_ser_1_C;
wire [Nbits_32-1:0] data_to_ser_2_A;
wire [Nbits_32-1:0] data_to_ser_2_B;
wire [Nbits_32-1:0] data_to_ser_2_C;
wire [Nbits_32-1:0] data_to_ser_3_A;
wire [Nbits_32-1:0] data_to_ser_3_B;
wire [Nbits_32-1:0] data_to_ser_3_C;
reg  [Nbits_5-1:0] pointer_ser_A;
reg  [Nbits_5-1:0] pointer_ser_B;
reg  [Nbits_5-1:0] pointer_ser_C;
reg handshake_A;
reg handshake_B;
reg handshake_C;
reg  START_SER_A;
reg  START_SER_B;
reg  START_SER_C;
wire CALIBRATION_BUSY_A;
wire CALIBRATION_BUSY_B;
wire CALIBRATION_BUSY_C;
wire [2:0] AAA;
wire [2:0] BBB;
wire [2:0] CCC;


	always @( posedge CLK_SRL ) begin
		if (RST_A==1'b0) begin
			pointer_ser_A <= 5'b0;
		end else begin
			pointer_ser_A <= pointer_ser_A + 5'b00001;
		end
	end

	always @( posedge CLK_SRL ) begin
		if (RST_B==1'b0) begin
			pointer_ser_B <= 5'b0;
		end else begin
			pointer_ser_B <= pointer_ser_B + 5'b00001;
		end
	end

	always @( posedge CLK_SRL ) begin
		if (RST_C==1'b0) begin
			pointer_ser_C <= 5'b0;
		end else begin
			pointer_ser_C <= pointer_ser_C + 5'b00001;
		end
	end


	always @( posedge CLK_SRL ) begin
		if (RST_A==1'b0) begin handshake_A <= 1'b0;
		end else begin
			if (pointer_ser_A==5'b10000) handshake_A <= ~handshake_A;
			if (pointer_ser_A==5'b10111) handshake_A <= ~handshake_A;
		end
	end

	always @( posedge CLK_SRL ) begin
		if (RST_B==1'b0) begin handshake_B <= 1'b0;
		end else begin
			if (pointer_ser_B==5'b10000) handshake_B <= ~handshake_B;
			if (pointer_ser_B==5'b10111) handshake_B <= ~handshake_B;
		end
	end

	always @( posedge CLK_SRL ) begin
		if (RST_C==1'b0) begin handshake_C <= 1'b0;
		end else begin
			if (pointer_ser_C==5'b10000) handshake_C <= ~handshake_C;
			if (pointer_ser_C==5'b10111) handshake_C <= ~handshake_C;
		end
	end



	always @( posedge CLK_SRL )  begin
		if (RST_A==1'b0) START_SER_A <= 1'b1;
		else begin
			if (pointer_ser_A==5'b11111) START_SER_A <= 1'b1;
			else START_SER_A <= 1'b0;
		end
	end

	always @( posedge CLK_SRL ) begin
		if (RST_B==1'b0) START_SER_B <= 1'b1;
		else begin
			if (pointer_ser_B==5'b11111) START_SER_B <= 1'b1;
			else START_SER_B <= 1'b0;
		end
	end

	always @( posedge CLK_SRL ) begin
		if (RST_C==1'b0) START_SER_C <= 1'b1;
		else begin
			if (pointer_ser_C==5'b11111) START_SER_C <= 1'b1;
			else START_SER_C <= 1'b0;
		end
	end

Serializer_shiftTMR Serializer_1 (
    .CLK_SRL(CLK_SRL),
    .RST_A(RST_A),
    .RST_B(RST_B),
    .RST_C(RST_C),
    .DATA_IN_A(data_to_ser_0_A),
    .DATA_IN_B(data_to_ser_0_B),
    .DATA_IN_C(data_to_ser_0_C),
    .START_SER_A(START_SER),//A),
    .START_SER_B(START_SER),//B),
    .START_SER_C(START_SER),//C),
    .BIT_OUT(output_ser_0),
    .tmrError(Serializer_0tmrError)
    );

Serializer_shiftTMR Serializer_2 (
    .CLK_SRL(CLK_SRL),
    .RST_A(RST_A),
    .RST_B(RST_B),
    .RST_C(RST_C),
    .DATA_IN_A(data_to_ser_1_A),
    .DATA_IN_B(data_to_ser_1_B),
    .DATA_IN_C(data_to_ser_1_C),
    .START_SER_A(START_SER),//A),
    .START_SER_B(START_SER),//B),
    .START_SER_C(START_SER),//C),
    .BIT_OUT(output_ser_1),
    .tmrError(Serializer_1tmrError)
    );

Serializer_shiftTMR Serializer_3 (
    .CLK_SRL(CLK_SRL),
    .RST_A(RST_A),
    .RST_B(RST_B),
    .RST_C(RST_C),
    .DATA_IN_A(data_to_ser_2_A),
    .DATA_IN_B(data_to_ser_2_B),
    .DATA_IN_C(data_to_ser_2_C),
    .START_SER_A(START_SER),//A),
    .START_SER_B(START_SER),//B),
    .START_SER_C(START_SER),//C),
    .BIT_OUT(output_ser_2),
    .tmrError(Serializer_2tmrError)
    );

Serializer_shiftTMR Serializer_4 (
    .CLK_SRL(CLK_SRL),
    .RST_A(RST_A),
    .RST_B(RST_B),
    .RST_C(RST_C),
    .DATA_IN_A(data_to_ser_3_A),
    .DATA_IN_B(data_to_ser_3_B),
    .DATA_IN_C(data_to_ser_3_C),
    .START_SER_A(START_SER),//A),
    .START_SER_B(START_SER),//B),
    .START_SER_C(START_SER),//C),
    .BIT_OUT(output_ser_3),
    .tmrError(Serializer_3tmrError)
    );


majVoter START_SERVoter (
    .inA(START_SER_A),
    .inB(START_SER_B),
    .inC(START_SER_C),
    .out(START_SER),
    .tmrErr(START_SERTmrError)
    );

majVoter handshakeVoter (
    .inA(handshake_A),
    .inB(handshake_B),
    .inC(handshake_C),
    .out(handshake),
    .tmrErr(handshakeTmrError)
    );

majVoter #(.WIDTH(((Nbits_5-1)>(0)) ? ((Nbits_5-1)-(0)+1) : ((0)-(Nbits_5-1)+1))) pointer_serVoter (
    .inA(pointer_ser_A),
    .inB(pointer_ser_B),
    .inC(pointer_ser_C),
    .out(pointer_ser),
    .tmrErr(pointer_serTmrError)
    );
assign tmrError =  handshakeTmrError|pointer_serTmrError|START_SERTmrError;

fan_out #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_0Fanout (
    .in(DATA32_0),
    .outA(DATA32_0_A),
    .outB(DATA32_0_B),
    .outC(DATA32_0_C)
    );
fan_out #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_1Fanout (
    .in(DATA32_1),
    .outA(DATA32_1_A),
    .outB(DATA32_1_B),
    .outC(DATA32_1_C)
    );
fan_out #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_2Fanout (
    .in(DATA32_2),
    .outA(DATA32_2_A),
    .outB(DATA32_2_B),
    .outC(DATA32_2_C)
    );
fan_out #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_3Fanout (
    .in(DATA32_3),
    .outA(DATA32_3_A),
    .outB(DATA32_3_B),
    .outC(DATA32_3_C)
    );




fan_out decode_signalFanout (
    .in(decode_signal),
    .outA(decode_signal_A),
    .outB(decode_signal_B),
    .outC(decode_signal_C)
    );

endmodule
