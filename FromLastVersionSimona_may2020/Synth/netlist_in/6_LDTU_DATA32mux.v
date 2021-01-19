
`timescale    1ns/1ps
module LDTU_DATA32_ATU_DTUTMR(
	CLK_A,
	CLK_B,
	CLK_C,
	RST_A,
	RST_B,
	RST_C,
	CALIBRATION_BUSY_A,
	CALIBRATION_BUSY_B,
	CALIBRATION_BUSY_C,
	TEST_ENABLE_A,
	TEST_ENABLE_B,
	TEST_ENABLE_C,
	DATA32_ATU_0,
	DATA32_ATU_1,
	DATA32_ATU_2,
	DATA32_ATU_3,
	DATA32_DTU,
	decode_signal,
	DATA32_0,
	DATA32_1,
	DATA32_2,
	DATA32_3,
	tmrError
  	);

	parameter Nbits_32=32;
	parameter idle_patternEA = 32'b11101010101010101010101010101010;   
	parameter idle_pattern5A = 32'b01011010010110100101101001011010;


	input CLK_A;
	input CLK_B;
	input CLK_C;
	input RST_A;
	input RST_B;
	input RST_C;
	input CALIBRATION_BUSY_A;
	input CALIBRATION_BUSY_B;
	input CALIBRATION_BUSY_C;
	input TEST_ENABLE_A;
	input TEST_ENABLE_B;
	input TEST_ENABLE_C;
	input [Nbits_32-1:0] DATA32_ATU_0;
	input [Nbits_32-1:0] DATA32_ATU_1;
	input [Nbits_32-1:0] DATA32_ATU_2;
	input [Nbits_32-1:0] DATA32_ATU_3;
	input [Nbits_32-1:0] DATA32_DTU;
	input decode_signal;
	output [Nbits_32-1:0] DATA32_0;
	output [Nbits_32-1:0] DATA32_1;
	output [Nbits_32-1:0] DATA32_2;
	output [Nbits_32-1:0] DATA32_3;
	output tmrError;


	wire [Nbits_32-1:0] DATA32_DTU_C;
	wire [Nbits_32-1:0] DATA32_DTU_B;
	wire [Nbits_32-1:0] DATA32_DTU_A;
	wire [Nbits_32-1:0] DATA32_ATU_0_C;
	wire [Nbits_32-1:0] DATA32_ATU_0_B;
	wire [Nbits_32-1:0] DATA32_ATU_0_A;
	wire [Nbits_32-1:0] DATA32_ATU_1_C;
	wire [Nbits_32-1:0] DATA32_ATU_1_B;
	wire [Nbits_32-1:0] DATA32_ATU_1_A;
	wire [Nbits_32-1:0] DATA32_ATU_2_C;
	wire [Nbits_32-1:0] DATA32_ATU_2_B;
	wire [Nbits_32-1:0] DATA32_ATU_2_A;
	wire [Nbits_32-1:0] DATA32_ATU_3_C;
	wire [Nbits_32-1:0] DATA32_ATU_3_B;
	wire [Nbits_32-1:0] DATA32_ATU_3_A;

	reg [Nbits_32-1:0] DATA32_0_A;
	reg [Nbits_32-1:0] DATA32_0_B;
	reg [Nbits_32-1:0] DATA32_0_C;
	reg [Nbits_32-1:0] DATA32_1_A;
	reg [Nbits_32-1:0] DATA32_1_B;
	reg [Nbits_32-1:0] DATA32_1_C;
	reg [Nbits_32-1:0] DATA32_2_A;
	reg [Nbits_32-1:0] DATA32_2_B;
	reg [Nbits_32-1:0] DATA32_2_C;
	reg [Nbits_32-1:0] DATA32_3_A;
	reg [Nbits_32-1:0] DATA32_3_B;
	reg [Nbits_32-1:0] DATA32_3_C;


always @(posedge CLK_A) begin
	if (RST_A == 1'b0) begin
		DATA32_0_A = idle_patternEA;
		DATA32_1_A = idle_pattern5A;
		DATA32_2_A = idle_pattern5A;
		DATA32_3_A = idle_pattern5A;
	end else begin
		if (TEST_ENABLE_A == 1'b0) begin
			if (CALIBRATION_BUSY_A == 1'b0) DATA32_0_A = DATA32_DTU_A;
			else DATA32_0_A = idle_patternEA;
			DATA32_1_A = idle_pattern5A;
			DATA32_2_A = idle_pattern5A;
			DATA32_3_A = idle_pattern5A;
		end else begin
			DATA32_0_A = DATA32_ATU_0_A;
			DATA32_1_A = DATA32_ATU_1_A;
			DATA32_2_A = DATA32_ATU_2_A;
			DATA32_3_A = DATA32_ATU_3_A;
		end //TEST_ENABLE
	end //RST
end //always

always @(posedge CLK_B) begin
	if (RST_B == 1'b0) begin
		DATA32_0_B = idle_patternEA;
		DATA32_1_B = idle_pattern5A;
		DATA32_2_B = idle_pattern5A;
		DATA32_3_B = idle_pattern5A;
	end else begin
		if (TEST_ENABLE_B == 1'b0) begin
			if (CALIBRATION_BUSY_B == 1'b0) DATA32_0_B = DATA32_DTU_B;
			else DATA32_0_B = idle_patternEA;
			DATA32_1_B = idle_pattern5A;
			DATA32_2_B = idle_pattern5A;
			DATA32_3_B = idle_pattern5A;
		end else begin
			DATA32_0_B = DATA32_ATU_0_B;
			DATA32_1_B = DATA32_ATU_1_B;
			DATA32_2_B = DATA32_ATU_2_B;
			DATA32_3_B = DATA32_ATU_3_B;
		end //TEST_ENABLE
	end //RST
end //always

always @(posedge CLK_C) begin
	if (RST_C == 1'b0) begin
		DATA32_0_C = idle_patternEA;
		DATA32_1_C = idle_pattern5A;
		DATA32_2_C = idle_pattern5A;
		DATA32_3_C = idle_pattern5A;
	end else begin
		if (TEST_ENABLE_C == 1'b0) begin
			if (CALIBRATION_BUSY_C == 1'b0) DATA32_0_C = DATA32_DTU_C;
			else DATA32_0_C = idle_patternEA;
			DATA32_1_C = idle_pattern5A;
			DATA32_2_C = idle_pattern5A;
			DATA32_3_C = idle_pattern5A;
		end else begin
			DATA32_0_C = DATA32_ATU_0_C;
			DATA32_1_C = DATA32_ATU_1_C;
			DATA32_2_C = DATA32_ATU_2_C;
			DATA32_3_C = DATA32_ATU_3_C;
		end //TEST_ENABLE
	end //RST
end //always


fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_0Fanout (
    .in(DATA32_ATU_0),
    .outA(DATA32_ATU_0_A),
    .outB(DATA32_ATU_0_B),
    .outC(DATA32_ATU_0_C)
    );
fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_1Fanout (
    .in(DATA32_ATU_1),
    .outA(DATA32_ATU_1_A),
    .outB(DATA32_ATU_1_B),
    .outC(DATA32_ATU_1_C)
    );
fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_2Fanout (
    .in(DATA32_ATU_2),
    .outA(DATA32_ATU_2_A),
    .outB(DATA32_ATU_2_B),
    .outC(DATA32_ATU_2_C)
    );
fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_ATU_3Fanout (
    .in(DATA32_ATU_3),
    .outA(DATA32_ATU_3_A),
    .outB(DATA32_ATU_3_B),
    .outC(DATA32_ATU_3_C)
    );
fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_DTUFanout (
    .in(DATA32_DTU),
    .outA(DATA32_DTU_A),
    .outB(DATA32_DTU_B),
    .outC(DATA32_DTU_C)
    );

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_0Voter (
    .inA(DATA32_0_A),
    .inB(DATA32_0_B),
    .inC(DATA32_0_C),
    .out(DATA32_0),
    .tmrErr(DATA32_0TmrError)
    );
majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_1Voter (
    .inA(DATA32_1_A),
    .inB(DATA32_1_B),
    .inC(DATA32_1_C),
    .out(DATA32_1),
    .tmrErr(DATA32_1TmrError)
    );
majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_2Voter (
    .inA(DATA32_2_A),
    .inB(DATA32_2_B),
    .inC(DATA32_2_C),
    .out(DATA32_2),
    .tmrErr(DATA32_2TmrError)
    );
majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA32_3Voter (
    .inA(DATA32_3_A),
    .inB(DATA32_3_B),
    .inC(DATA32_3_C),
    .out(DATA32_3),
    .tmrErr(DATA32_3TmrError)
    );

assign tmrError =  DATA32_0TmrError|DATA32_1TmrError|DATA32_2TmrError|DATA32_3TmrError;

endmodule
