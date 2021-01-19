// *************************************************************************************************
//                              -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	Encoder
//	
//	Input:	- CLK: LiTe-DTU clock
//		- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//		- baseline_flag: 6/13 bits
//		- DATA_to_enc: data from the input FIFO
//
//	Output:	- DATA_32: 32-bit encoded word
//		- Load: DATA_32 complete
//		- tmrError
//
// *************************************************************************************************

`timescale	 1ns/1ps
module LDTU_EncoderTMR(
	CLK_A,
	CLK_B,
	CLK_C,
	reset_A,
	reset_B,
	reset_C,
	baseline_flag,
	DATA_to_enc,
	DATA_32,
	Load,
	tmrError
	);

	parameter SIZE=3;
	parameter Nbits_6=6;
	parameter Nbits_12=12;
	parameter Nbits_32=32;
	parameter code_sel_sign1=6'b001010;
	parameter code_sel_sign2=6'b001011;
	parameter code_sel_bas1=2'b01;
	parameter code_sel_bas2=2'b10;
	parameter sync=13'b0101010101010;
	parameter one=24'b000001000000000000000000;
	parameter two=18'b000010000000000000;
	parameter three=12'b000011000000;
	parameter four=6'b000100;
	parameter Initial=32'b11110000000000000000000000000000;


	parameter IDLE=4'b0000;
	parameter bas_0=4'b0001;
	parameter bas_1=4'b0010;
	parameter bas_2=4'b0011;
	parameter bas_3=4'b0100;
	parameter bas_4=4'b0101;
	parameter sign_0=4'b0110;
	parameter sign_1=4'b0111;
	parameter bas_0_bis=4'b1000;
	parameter bas_1_bis=4'b1001;
	parameter bas_2_bis=4'b1010;
	parameter bas_3_bis=4'b1011;
	parameter bas_4_bis=4'b1100;
	parameter sign_0_bis=4'b1101;
	parameter sign_1_bis=4'b1110;


	
	input CLK_A;
	input CLK_B;
	input CLK_C;
	input reset_A;
	input reset_B;
	input reset_C;
	input baseline_flag;
	input [Nbits_12:0] DATA_to_enc;
	output [Nbits_32-1:0] DATA_32;
	output Load;
	output tmrError;

	wire [1:0] code_sel_bas;
	wire [5:0] code_sel_sign;
	wire [Nbits_12:0] dDATA_to_enc;


	reg	[Nbits_6-1:0] Ld_bas_1_A;
	reg	[Nbits_6-1:0] Ld_bas_1_B;
	reg	[Nbits_6-1:0] Ld_bas_1_C;
	reg	[Nbits_6-1:0] Ld_bas_2_A;
	reg	[Nbits_6-1:0] Ld_bas_2_B;
	reg	[Nbits_6-1:0] Ld_bas_2_C;
	reg	[Nbits_6-1:0] Ld_bas_3_A;
	reg	[Nbits_6-1:0] Ld_bas_3_B;
	reg	[Nbits_6-1:0] Ld_bas_3_C;
	reg	[Nbits_6-1:0] Ld_bas_4_A;
	reg	[Nbits_6-1:0] Ld_bas_4_B;
	reg	[Nbits_6-1:0] Ld_bas_4_C;
	reg	[Nbits_6-1:0] Ld_bas_5_A;
	reg	[Nbits_6-1:0] Ld_bas_5_B;
	reg	[Nbits_6-1:0] Ld_bas_5_C;
	reg	[Nbits_12:0] Ld_sign_1_A;
	reg	[Nbits_12:0] Ld_sign_1_B;
	reg	[Nbits_12:0] Ld_sign_1_C;
	reg	[Nbits_12:0] Ld_sign_2_A;
	reg	[Nbits_12:0] Ld_sign_2_B;
	reg	[Nbits_12:0] Ld_sign_2_C;
	reg	[Nbits_32-1:0] DATA_32_A;
	reg	[Nbits_32-1:0] DATA_32_B;
	reg	[Nbits_32-1:0] DATA_32_C;
	reg	Load_A;
	reg	Load_B;
	reg	Load_C;
	wire [SIZE:0] Current_state_C;
	wire [SIZE:0] Current_state_B;
	wire [SIZE:0] Current_state_A;
	wire [Nbits_12:0] dDATA_to_enc_C;
	wire [Nbits_12:0] dDATA_to_enc_B;
	wire [Nbits_12:0] dDATA_to_enc_A;
	wor LoadTmrError;
	wor DATA_32TmrError;
	wire fsm_TmrError;

	Delay_enc delay_A (CLK_A, reset_A, DATA_to_enc, dDATA_to_enc_A);
	Delay_enc delay_B (CLK_B, reset_B, DATA_to_enc, dDATA_to_enc_B);
	Delay_enc delay_C (CLK_C, reset_C, DATA_to_enc, dDATA_to_enc_C);

	LDTU_FSMTMR fsm(.CLK_A(CLK_A), .CLK_B(CLK_B), .CLK_C(CLK_C), .reset_A(reset_A), .reset_B(reset_B), .reset_C(reset_C), .baseline_flag(baseline_flag),
	.Current_state_A(Current_state_A), .Current_state_B(Current_state_B), .Current_state_C(Current_state_C), .tmrError(fsm_TmrError));

	assign code_sel_bas = (baseline_flag==1'b1) ? code_sel_bas1 : code_sel_bas2;
	assign code_sel_sign = (baseline_flag==1'b0) ? code_sel_sign1 : code_sel_sign2;



always @( posedge CLK_A )
	begin : FSM_seq_outputA
	if (reset_A==1'b0)
		begin
		Ld_bas_1_A <= 6'b0;
		Ld_bas_2_A <= 6'b0;
		Ld_bas_3_A <= 6'b0;
		Ld_bas_4_A <= 6'b0;
		Ld_bas_5_A <= 6'b0;
		Ld_sign_1_A <= 13'b0;
		Ld_sign_2_A <= 13'b0;
		Load_A <= 1'b0;
		DATA_32_A <= Initial;
		end
	else
		begin
		case (Current_state_A)
			IDLE : 
			begin
				Load_A <= 1'b0;
				DATA_32_A <= Initial;
			end
			bas_0 : 
			begin
				Load_A <= 1'b0;
				Ld_bas_2_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			bas_0_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_bas2,one,Ld_bas_1_A};
				Ld_sign_1_A <= dDATA_to_enc_A;
			end
			bas_1 : 
			begin
				Load_A <= 1'b0;
				Ld_bas_3_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			bas_1_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_bas2,two,Ld_bas_2_A,Ld_bas_1_A};
				Ld_sign_1_A <= dDATA_to_enc_A;
			end
			bas_2 : 
			begin
				Load_A <= 1'b0;
				Ld_bas_4_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			bas_2_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_bas2,three,Ld_bas_3_A,Ld_bas_2_A,Ld_bas_1_A};
				Ld_sign_1_A <= dDATA_to_enc_A;
			end
			bas_3 : 
			begin
				Load_A <= 1'b0;
				Ld_bas_5_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			bas_3_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_bas2,four,Ld_bas_4_A,Ld_bas_3_A,Ld_bas_2_A,Ld_bas_1_A};
				Ld_sign_1_A <= dDATA_to_enc_A;
			end
			bas_4 : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_bas1,Ld_bas_5_A,Ld_bas_4_A,Ld_bas_3_A,Ld_bas_2_A,Ld_bas_1_A};
				Ld_bas_1_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			bas_4_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_bas1,Ld_bas_5_A,Ld_bas_4_A,Ld_bas_3_A,Ld_bas_2_A,Ld_bas_1_A};
				Ld_sign_1_A <= dDATA_to_enc_A;
			end
			sign_0 : 
			begin
				Load_A <= 1'b0;
				Ld_sign_2_A <= dDATA_to_enc_A;
			end
			sign_0_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_sign2,sync,Ld_sign_1_A};
				Ld_bas_1_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			sign_1 : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_sign1,Ld_sign_2_A,Ld_sign_1_A};
				Ld_sign_1_A <= dDATA_to_enc_A;
			end
			sign_1_bis : 
			begin
				Load_A <= 1'b1;
				DATA_32_A <= {code_sel_sign1,Ld_sign_2_A,Ld_sign_1_A};
				Ld_bas_1_A <= dDATA_to_enc_A[Nbits_6-1:0] ;
			end
			default : 
			begin
				Load_A <= 1'b0;
				DATA_32_A <= Initial;
			end
		endcase
		end
	end


always @( posedge CLK_B )
	begin : FSM_seq_outputB
	if (reset_B==1'b0)
		begin
		Ld_bas_1_B <= 6'b0;
		Ld_bas_2_B <= 6'b0;
		Ld_bas_3_B <= 6'b0;
		Ld_bas_4_B <= 6'b0;
		Ld_bas_5_B <= 6'b0;
		Ld_sign_1_B <= 13'b0;
		Ld_sign_2_B <= 13'b0;
		Load_B <= 1'b0;
		DATA_32_B <= Initial;
		end
	else
		begin
		case (Current_state_B)
			IDLE : 
			begin
				Load_B <= 1'b0;
				DATA_32_B <= Initial;
			end
			bas_0 : 
			begin
				Load_B <= 1'b0;
				Ld_bas_2_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			bas_0_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_bas2,one,Ld_bas_1_B};
				Ld_sign_1_B <= dDATA_to_enc_B;
			end
			bas_1 : 
			begin
				Load_B <= 1'b0;
				Ld_bas_3_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			bas_1_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_bas2,two,Ld_bas_2_B,Ld_bas_1_B};
				Ld_sign_1_B <= dDATA_to_enc_B;
			end
			bas_2 : 
			begin
				Load_B <= 1'b0;
				Ld_bas_4_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			bas_2_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_bas2,three,Ld_bas_3_B,Ld_bas_2_B,Ld_bas_1_B};
				Ld_sign_1_B <= dDATA_to_enc_B;
			end
			bas_3 : 
			begin
				Load_B <= 1'b0;
				Ld_bas_5_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			bas_3_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_bas2,four,Ld_bas_4_B,Ld_bas_3_B,Ld_bas_2_B,Ld_bas_1_B};
				Ld_sign_1_B <= dDATA_to_enc_B;
			end
			bas_4 : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_bas1,Ld_bas_5_B,Ld_bas_4_B,Ld_bas_3_B,Ld_bas_2_B,Ld_bas_1_B};
				Ld_bas_1_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			bas_4_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_bas1,Ld_bas_5_B,Ld_bas_4_B,Ld_bas_3_B,Ld_bas_2_B,Ld_bas_1_B};
				Ld_sign_1_B <= dDATA_to_enc_B;
			end
			sign_0 : 
			begin
				Load_B <= 1'b0;
				Ld_sign_2_B <= dDATA_to_enc_B;
			end
			sign_0_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_sign2,sync,Ld_sign_1_B};
				Ld_bas_1_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			sign_1 : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_sign1,Ld_sign_2_B,Ld_sign_1_B};
				Ld_sign_1_B <= dDATA_to_enc_B;
			end
			sign_1_bis : 
			begin
				Load_B <= 1'b1;
				DATA_32_B <= {code_sel_sign1,Ld_sign_2_B,Ld_sign_1_B};
				Ld_bas_1_B <= dDATA_to_enc_B[Nbits_6-1:0] ;
			end
			default : 
			begin
				Load_B <= 1'b0;
				DATA_32_B <= Initial;
			end
		endcase
		end
	end


always @( posedge CLK_C )
	begin : FSM_seq_outputC
	if (reset_C==1'b0)
		begin
		Ld_bas_1_C <= 6'b0;
		Ld_bas_2_C <= 6'b0;
		Ld_bas_3_C <= 6'b0;
		Ld_bas_4_C <= 6'b0;
		Ld_bas_5_C <= 6'b0;
		Ld_sign_1_C <= 13'b0;
		Ld_sign_2_C <= 13'b0;
		Load_C <= 1'b0;
		DATA_32_C <= Initial;
		end
	else
		begin
		case (Current_state_C)
			IDLE : 
			begin
				Load_C <= 1'b0;
				DATA_32_C <= Initial;
			end
			bas_0 : 
			begin
				Load_C <= 1'b0;
				Ld_bas_2_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			bas_0_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_bas2,one,Ld_bas_1_C};
				Ld_sign_1_C <= dDATA_to_enc_C;
			end
			bas_1 : 
			begin
				Load_C <= 1'b0;
				Ld_bas_3_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			bas_1_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_bas2,two,Ld_bas_2_C,Ld_bas_1_C};
				Ld_sign_1_C <= dDATA_to_enc_C;
			end
			bas_2 : 
			begin
				Load_C <= 1'b0;
				Ld_bas_4_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			bas_2_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_bas2,three,Ld_bas_3_C,Ld_bas_2_C,Ld_bas_1_C};
				Ld_sign_1_C <= dDATA_to_enc_C;
			end
			bas_3 : 
			begin
				Load_C <= 1'b0;
				Ld_bas_5_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			bas_3_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_bas2,four,Ld_bas_4_C,Ld_bas_3_C,Ld_bas_2_C,Ld_bas_1_C};
				Ld_sign_1_C <= dDATA_to_enc_C;
			end
			bas_4 : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_bas1,Ld_bas_5_C,Ld_bas_4_C,Ld_bas_3_C,Ld_bas_2_C,Ld_bas_1_C};
				Ld_bas_1_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			bas_4_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_bas1,Ld_bas_5_C,Ld_bas_4_C,Ld_bas_3_C,Ld_bas_2_C,Ld_bas_1_C};
				Ld_sign_1_C <= dDATA_to_enc_C;
			end
			sign_0 : 
			begin
				Load_C <= 1'b0;
				Ld_sign_2_C <= dDATA_to_enc_C;
			end
			sign_0_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_sign2,sync,Ld_sign_1_C};
				Ld_bas_1_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			sign_1 : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_sign1,Ld_sign_2_C,Ld_sign_1_C};
				Ld_sign_1_C <= dDATA_to_enc_C;
			end
			sign_1_bis : 
			begin
				Load_C <= 1'b1;
				DATA_32_C <= {code_sel_sign1,Ld_sign_2_C,Ld_sign_1_C};
				Ld_bas_1_C <= dDATA_to_enc_C[Nbits_6-1:0] ;
			end
			default : 
			begin
				Load_C <= 1'b0;
				DATA_32_C <= Initial;
			end
		endcase
		end
	end


majorityVoter LoadVoter (
	.inA(Load_A),
	.inB(Load_B),
	.inC(Load_C),
	.out(Load),
	.tmrErr(LoadTmrError)
	);

majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_32Voter (
	.inA(DATA_32_A),
	.inB(DATA_32_B),
	.inC(DATA_32_C),
	.out(DATA_32),
	.tmrErr(DATA_32TmrError)
	);


assign tmrError = LoadTmrError | DATA_32TmrError | fsm_TmrError;



endmodule

module Delay_enc (clk, reset, D, Dd);
	// input
	input clk, reset;
	input [12:0] D;
	// output
	output reg [12:0] Dd;

	always @ (posedge clk) begin
		if (reset == 1'b0)
			Dd <= 13'b0;
		else
			Dd <= D;
		end	
endmodule // Delay_enc
