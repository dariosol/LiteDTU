// *************************************************************************************************
//                              -*- Mode: Verilog -*-
//	Author:	Simona Cometti
//	Module:	FSM_encoder
//	
//	Input:	- CLK: LiTe-DTU clock
//		- reset: 1'b0 LiTe-DTU INACTIVE- 1'b1: LiTe-DTU ACTIVE
//		- baseline_flag: 6/13 bits
//
//	Output:	- Current_state
//		- tmrError
//
// *************************************************************************************************

`timescale	 1ns/1ps
module LDTU_FSMTMR(
	CLK_A,
	CLK_B,
	CLK_C,
	reset_A,
	reset_B,
	reset_C,
	baseline_flag,
	Current_state_A,
	Current_state_B,
	Current_state_C,
	tmrError
);

	parameter SIZE=3;
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
	output reg	 [SIZE:0] Current_state_A;
	output reg	 [SIZE:0] Current_state_B;
	output reg	 [SIZE:0] Current_state_C;
	output tmrError;

	wor Current_stateTmrError;
	wire [SIZE:0] Current_state;
	reg	[SIZE:0] Next_state;


	always @( posedge CLK_A ) begin : FSM_SEQA
		if (reset_A==1'b0) begin
			Current_state_A <= IDLE;
		end else begin
			Current_state_A <= Next_state;
		end
	end

	always @( posedge CLK_B ) begin : FSM_SEQB
		if (reset_B==1'b0) begin
			Current_state_B <= IDLE;
		end else begin
			Current_state_B <= Next_state;
		end

	end
	always @( posedge CLK_C ) begin : FSM_SEQC
		if (reset_C==1'b0) begin
			Current_state_C <= IDLE;
		end else begin
			Current_state_C <= Next_state;
		end
	end

	always @( Current_state or baseline_flag ) begin : FSM_COMB
		Next_state = IDLE;
		case (Current_state)
			IDLE : 
			begin
				if (baseline_flag==1'b1)
					Next_state = bas_0;
				else
					Next_state = sign_0;
			end
			bas_0_bis : 
			begin
				if (baseline_flag==1'b1)
					Next_state = sign_0_bis;
				else
					Next_state = sign_0;
			end
			bas_0 : 
			begin
				if (baseline_flag==1'b1)
					Next_state = bas_1;
				else
					Next_state = bas_1_bis;
			end
			bas_1_bis : 
			begin
				if (baseline_flag==1'b1)
					Next_state = sign_0_bis;
				else
					Next_state = sign_0;
			end
			bas_1 : 
			begin
				if (baseline_flag==1'b1)
					Next_state = bas_2;
				else
					Next_state = bas_2_bis;
			end
			bas_2_bis : 
			begin
				if (baseline_flag==1'b1)
					Next_state = sign_0_bis;
				else
					Next_state = sign_0;
			end
			bas_2 : 
			begin
				if (baseline_flag==1'b1)
					Next_state = bas_3;
				else
					Next_state = bas_3_bis;
			end
			bas_3_bis : 
			begin
				if (baseline_flag==1'b1)
					Next_state = sign_0_bis;
				else
					Next_state = sign_0;
			end
			bas_3 : 
			begin
				if (baseline_flag==1'b1)
					Next_state = bas_4;
				else
					Next_state = bas_4_bis;
			end
			bas_4_bis : 
			begin
				if (baseline_flag==1'b1)
					Next_state = sign_0_bis;
				else
					Next_state = sign_0;
			end
			bas_4 : 
			begin
				if (baseline_flag==1'b1)
					Next_state = bas_0;
				else
					Next_state = bas_0_bis;
			end
			sign_0_bis : 
			begin
				if (baseline_flag==1'b0)
					Next_state = bas_0_bis;
				else
					Next_state = bas_0;
			end
			sign_0 : 
			begin
				if (baseline_flag==1'b0)
					Next_state = sign_1;
				else
					Next_state = sign_1_bis;
			end
			sign_1_bis : 
			begin
				if (baseline_flag==1'b0)
					Next_state = bas_0_bis;
				else
					Next_state = bas_0;
			end
			sign_1 : 
			begin
				if (baseline_flag==1'b0)
					Next_state = sign_0;
				else
					Next_state = sign_0_bis;
			end
			default : Next_state = IDLE;
		endcase
	end

majorityVoter #(.WIDTH(((SIZE)>(0)) ? ((SIZE)-(0)+1) : ((0)-(SIZE)+1))) Current_stateVoter (
		.inA(Current_state_A),
		.inB(Current_state_B),
		.inC(Current_state_C),
		.out(Current_state),
		.tmrErr(Current_stateTmrError)
		);

assign tmrError = Current_stateTmrError;


endmodule
