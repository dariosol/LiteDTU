

`timescale 1ns/1ps
module LDTU_CUTMR(
	CLK_A,
	CLK_B,
	CLK_C,
	reset_A,
	reset_B,
	reset_C,
	Load_data,
	DATA_32,
	full,
	DATA_from_CU,
	losing_data,
	write_signal,
	read_signal,
	tmrError,
	handshake
);


	parameter Nbits_32=32;
	parameter FifoDepth_buff=64;
	parameter bits_ptr=6;
	//parameter limit=6'b110010;
	parameter limit=6'b110001;
	parameter crcBits=12;
	parameter Initial=32'b11110000000000000000000000000000;
	parameter bits_counter=2;



	input CLK_A;
	input CLK_B;
	input CLK_C;
	input reset_A;
	input reset_B;
	input reset_C;
	input Load_data;
	input [Nbits_32-1:0] DATA_32;
	input full;
	input  handshake;

	output losing_data;
	output write_signal;
	output [Nbits_32-1:0] DATA_from_CU;
	output read_signal;
	output tmrError;

	wire DATA_from_CUTmrError;
	wire readTmrError;
	wire writeTmrError;
	wire losingTmrError;
	reg [7:0] NSample_A;
	reg [7:0] NSample_B;
	reg [7:0] NSample_C;
	reg [5:0] Nlimit_A;
	reg [5:0] Nlimit_B;
	reg [5:0] Nlimit_C;
	reg [7:0] NFrame_A;
	reg [7:0] NFrame_B;
	reg [7:0] NFrame_C;
	reg [crcBits-1:0] crc_A;
	reg [crcBits-1:0] crc_B;
	reg [crcBits-1:0] crc_C;

	wire [Nbits_32-1:0] DATA_32_C;
	wire [Nbits_32-1:0] DATA_32_B;
	wire [Nbits_32-1:0] DATA_32_A;
	wire Load_data_C;
	wire Load_data_B;
	wire Load_data_A;
	wire full_C;
	wire full_B;
	wire full_A;
	reg read_signal_A;
	reg read_signal_B;
	reg read_signal_C;
	reg losing_data_A;
	reg losing_data_B;
	reg losing_data_C;
	reg write_signal_A;
	reg write_signal_B;
	reg write_signal_C;

	wire [crcBits-1:0] out_crc_A;
	wire [crcBits-1:0] out_crc_C;
	wire [crcBits-1:0] out_crc_B;
	wire check_limit_A;
	wire check_limit_B;
	wire check_limit_C;
	wire [7:0] NSamples_A;
	wire [7:0] NSamples_B;
	wire [7:0] NSamples_C;
	wire [Nbits_32-1:0] wireTrailer_A;
	wire [Nbits_32-1:0] wireTrailer_B;
	wire [Nbits_32-1:0] wireTrailer_C;

	assign check_limit_A = (Nlimit_A>limit) ? 1'b1 : 1'b0;
	assign NSamples_A = (Nlimit_A==6'b0) ? 8'b0 : NSample_A;
	assign wireTrailer_A = {4'b1101,NSamples_A,crc_A,NFrame_A};

	assign check_limit_B = (Nlimit_B>limit) ? 1'b1 : 1'b0;
	assign NSamples_B = (Nlimit_B==6'b0) ? 8'b0 : NSample_B;
	assign wireTrailer_B = {4'b1101,NSamples_B,crc_B,NFrame_B};

	assign check_limit_C = (Nlimit_C>limit) ? 1'b1 : 1'b0;
	assign NSamples_C = (Nlimit_C==6'b0) ? 8'b0 : NSample_C;
	assign wireTrailer_C = {4'b1101,NSamples_C,crc_C,NFrame_C};

	reg [Nbits_32-1:0] DATA_from_CU_A;
	reg [Nbits_32-1:0] DATA_from_CU_B;
	reg [Nbits_32-1:0] DATA_from_CU_C;

	wire [crcBits-1:0] wcrc_A;
	wire [crcBits-1:0] wcrc_B;
	wire [crcBits-1:0] wcrc_C;
	assign wcrc_A = crc_A;
	assign wcrc_B = crc_B;
	assign wcrc_C = crc_C;
	CRC_calc calc_crc_A (.reset(reset_A), .data(DATA_32_A), .crc(wcrc_A), .newcrc(out_crc_A));
	CRC_calc calc_crc_B (.reset(reset_B), .data(DATA_32_B), .crc(wcrc_B), .newcrc(out_crc_B));
	CRC_calc calc_crc_C (.reset(reset_C), .data(DATA_32_C), .crc(wcrc_C), .newcrc(out_crc_C));


	wire [7:0] sum_val_A;
	wire [7:0] sum_val_B;
	wire [7:0] sum_val_C;
	wire handshake_A;
	wire handshake_B;
	wire handshake_C;

	SumValue SumValue_A ( .data(DATA_32_A[31:24]), .sum_val(sum_val_A));
	SumValue SumValue_B ( .data(DATA_32_B[31:24]), .sum_val(sum_val_B));
	SumValue SumValue_C ( .data(DATA_32_C[31:24]), .sum_val(sum_val_C));


	always @( posedge CLK_A ) begin
		if (reset_A==1'b0) begin
			NSample_A <= 8'b0;
			Nlimit_A <= 6'b0;
			NFrame_A <= 8'b0;
			crc_A <= 12'b0;
		end else begin
			if (Load_data_A == 1'b0) begin
					if (check_limit_A==1'b1) begin
						if (full_A==1'b0) begin
							NSample_A <= 8'b0;
							Nlimit_A <= 6'b0;
							crc_A <= 12'b0;
							NFrame_A <= NFrame_A+8'b1;
						end
					end
			end else begin
				if (full_A==1'b0) begin
					Nlimit_A <= Nlimit_A+6'b1;
					NSample_A <= NSample_A + sum_val_A;
					crc_A <= out_crc_A;
				end
			end
		end
	end

	always @( posedge CLK_B ) begin
		if (reset_B==1'b0) begin
			NSample_B <= 8'b0;
			Nlimit_B <= 6'b0;
			NFrame_B <= 8'b0;
			crc_B <= 12'b0;
		end else begin
			if (Load_data_B == 1'b0) begin
				if (check_limit_B==1'b1) begin
					if (full_B==1'b0) begin
						NSample_B <= 8'b0;
						Nlimit_B <= 6'b0;
						crc_B <= 12'b0;
						NFrame_B <= NFrame_B+8'b1;
					end
				end
			end else begin
				if (full_B==1'b0) begin
					Nlimit_B <= Nlimit_B+6'b1;
					NSample_B <= NSample_B + sum_val_B;
					crc_B <= out_crc_B;
				end
			end
		end
	end

	always @( posedge CLK_C ) begin
		if (reset_C==1'b0) begin
			NSample_C <= 8'b0;
			Nlimit_C <= 6'b0;
			NFrame_C <= 8'b0;
			crc_C <= 12'b0;
		end else begin
			if (Load_data_C == 1'b0) begin
				if (check_limit_C==1'b1) begin
					if (full_C==1'b0) begin
						NSample_C <= 8'b0;
						Nlimit_C <= 6'b0;
						crc_C <= 12'b0;
						NFrame_C <= NFrame_C+8'b1;
					end
				end
			end else begin
				if (full_C==1'b0) begin
					Nlimit_C <= Nlimit_C+6'b1;
					NSample_C <= NSample_C + sum_val_C;
					crc_C <= out_crc_C;
				end
			end
		end
	end

	always @( posedge CLK_A ) begin
		if (reset_A==1'b0) begin
			DATA_from_CU_A = Initial;
			losing_data_A = 1'b0;
			write_signal_A = 1'b0;
		end else begin
			if (Load_data_A == 1'b0) begin
				losing_data_A = 1'b0;
				if (check_limit_A==1'b1) begin
					if (full_A==1'b0) begin
						DATA_from_CU_A = wireTrailer_A;
						write_signal_A = 1'b1;
					end else begin
						write_signal_A = 1'b0;
					end
				end else begin
					write_signal_A = 1'b0;
				end
			end else begin
				if (full_A==1'b0) begin
					write_signal_A = 1'b1;
					losing_data_A = 1'b0;
					DATA_from_CU_A = DATA_32_A;
				end else begin
					losing_data_A = 1'b1;
					write_signal_A = 1'b0;
				end
			end
		end
	end

	always @( posedge CLK_B ) begin
		if (reset_B==1'b0) begin
			DATA_from_CU_B = Initial;
			losing_data_B = 1'b0;
			write_signal_B = 1'b0;
		end else begin
			if (Load_data_B == 1'b0) begin
				losing_data_B = 1'b0;
				if (check_limit_B==1'b1) begin
					if (full_B==1'b0) begin
						DATA_from_CU_B = wireTrailer_B;
						write_signal_B = 1'b1;
					end else begin
						write_signal_B = 1'b0;
					end
				end else begin
					write_signal_B = 1'b0;
				end
			end else begin
				if (full_B==1'b0) begin
					write_signal_B = 1'b1;
					losing_data_B = 1'b0;
					DATA_from_CU_B = DATA_32_B;
				end else begin
					losing_data_B = 1'b1;
					write_signal_B = 1'b0;
				end
			end
		end
	end

	always @( posedge CLK_C ) begin
		if (reset_C==1'b0) begin
			DATA_from_CU_C = Initial;
			losing_data_C = 1'b0;
			write_signal_C = 1'b0;
		end else begin
			if (Load_data_C == 1'b0) begin
				losing_data_C = 1'b0;
				if (check_limit_C==1'b1) begin
					if (full_C==1'b0) begin
						DATA_from_CU_C = wireTrailer_C;
						write_signal_C = 1'b1;
					end else begin
						write_signal_C = 1'b0;
					end
				end else begin
					write_signal_C = 1'b0;
				end
			end else begin
				if (full_C==1'b0) begin
					write_signal_C = 1'b1;
					losing_data_C = 1'b0;
					DATA_from_CU_C = DATA_32_C;
				end else begin
					losing_data_C = 1'b1;
					write_signal_C = 1'b0;
				end
			end
		end
	end

	always @( posedge CLK_A ) begin
		if (reset_A == 1'b0) read_signal_A = 1'b0;
		else begin
			if (handshake_A == 1'b1) begin
				read_signal_A = 1'b1;
			end else read_signal_A = 1'b0;
		end
	end

	always @( posedge CLK_B ) begin
		if (reset_B == 1'b0) read_signal_B = 1'b0;
		else begin
			if (handshake_B == 1'b1) begin
				read_signal_B = 1'b1;
			end else read_signal_B = 1'b0;
		end
	end

	always @( posedge CLK_C ) begin
		if (reset_C == 1'b0) read_signal_C = 1'b0;
		else begin
			if (handshake_C == 1'b1) begin
				read_signal_C = 1'b1;
			end else read_signal_C = 1'b0;
		end
	end


majorityVoter #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_from_CUVoter (
	.inA(DATA_from_CU_A),
	.inB(DATA_from_CU_B),
	.inC(DATA_from_CU_C),
	.out(DATA_from_CU),
	.tmrErr(DATA_from_CUTmrError)
	);


majorityVoter readVoter (
	.inA(read_signal_A),
	.inB(read_signal_B),
	.inC(read_signal_C),
	.out(read_signal),
	.tmrErr(readTmrError)
	);

majorityVoter writeVoter (
	.inA(write_signal_A),
	.inB(write_signal_B),
	.inC(write_signal_C),
	.out(write_signal),
	.tmrErr(writeTmrError)
	);

majorityVoter losingVoter (
	.inA(losing_data_A),
	.inB(losing_data_B),
	.inC(losing_data_C),
	.out(losing_data),
	.tmrErr(losingTmrError)
	);

assign tmrError = DATA_from_CUTmrError | readTmrError | writeTmrError | losingTmrError;


fanout #(.WIDTH(((Nbits_32-1)>(0)) ? ((Nbits_32-1)-(0)+1) : ((0)-(Nbits_32-1)+1))) DATA_32Fanout (
	.in(DATA_32),
	.outA(DATA_32_A),
	.outB(DATA_32_B),
	.outC(DATA_32_C)
	);

fanout Load_dataFanout (
	.in(Load_data),
	.outA(Load_data_A),
	.outB(Load_data_B),
	.outC(Load_data_C)
	);

fanout handshakeFanout (
	.in(handshake),
	.outA(handshake_A),
	.outB(handshake_B),
	.outC(handshake_C)
	);

fanout fullFanout (
	.in(full),
	.outA(full_A),
	.outB(full_B),
	.outC(full_C)
	);
endmodule



module CRC_calc (reset,data,crc,newcrc);
	parameter Nbits_32=32;
	parameter crcBits=12;
	input reset;
	input [Nbits_32-1:0] data;
	input [crcBits-1:0] crc;
	output [crcBits-1:0] newcrc;

	wire bit_0, bit_1, bit_2, bit_3, bit_4, bit_5, bit_6, bit_7, bit_8, bit_9, bit_10, bit_11;

	assign bit_0 = (reset == 1'b0) ? 1'b0 : data[30] ^data[29] ^data[26] ^data[25] ^data[24] ^data[23] ^data[22] ^data[17] ^data[16] ^data[15] ^data[14] ^data[13] ^data[12] ^data[11] ^data[8] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[1] ^data[0] ^crc[2] ^crc[3] ^crc[4] ^crc[5] ^crc[6] ^crc[9] ^crc[10] ;
	assign bit_1 = (reset == 1'b0) ? 1'b0 : data[31] ^data[29] ^data[27] ^data[22] ^data[18] ^data[11] ^data[9] ^data[0] ^crc[2] ^crc[7] ^crc[9] ^crc[11] ;
	assign bit_2 = (reset == 1'b0) ? 1'b0 : data[29] ^data[28] ^data[26] ^data[25] ^data[24] ^data[22] ^data[19] ^data[17] ^data[16] ^data[15] ^data[14] ^data[13] ^data[11] ^data[10] ^data[8] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[0] ^crc[2] ^crc[4] ^crc[5] ^crc[6] ^crc[8] ^crc[9] ;
	assign bit_3 = (reset == 1'b0) ? 1'b0 : data[27] ^data[24] ^data[22] ^data[20] ^data[18] ^data[13] ^data[9] ^data[2] ^data[0] ^crc[0] ^crc[2] ^crc[4] ^crc[7] ;
	assign bit_4 = (reset == 1'b0) ? 1'b0 : data[28] ^data[25] ^data[23] ^data[21] ^data[19] ^data[14] ^data[10] ^data[3] ^data[1] ^crc[1] ^crc[3] ^crc[5] ^crc[8] ;
	assign bit_5 = (reset == 1'b0) ? 1'b0 : data[29] ^data[26] ^data[24] ^data[22] ^data[20] ^data[15] ^data[11] ^data[4] ^data[2] ^crc[0] ^crc[2] ^crc[4] ^crc[6] ^crc[9] ;
	assign bit_6 = (reset == 1'b0) ? 1'b0 : data[30] ^data[27] ^data[25] ^data[23] ^data[21] ^data[16] ^data[12] ^data[5] ^data[3] ^crc[1] ^crc[3] ^crc[5] ^crc[7] ^crc[10] ;
	assign bit_7 = (reset == 1'b0) ? 1'b0 : data[31] ^data[28] ^data[26] ^data[24] ^data[22] ^data[17] ^data[13] ^data[6] ^data[4] ^crc[2] ^crc[4] ^crc[6] ^crc[8] ^crc[11] ;
	assign bit_8 = (reset == 1'b0) ? 1'b0 : data[29] ^data[27] ^data[25] ^data[23] ^data[18] ^data[14] ^data[7] ^data[5] ^crc[3] ^crc[5] ^crc[7] ^crc[9] ;
	assign bit_9 = (reset == 1'b0) ? 1'b0 : data[30] ^data[28] ^data[26] ^data[24] ^data[19] ^data[15] ^data[8] ^data[6] ^crc[4] ^crc[6] ^crc[8] ^crc[10] ;
	assign bit_10 = (reset == 1'b0) ? 1'b0 : data[31] ^data[29] ^data[27] ^data[25] ^data[20] ^data[16] ^data[9] ^data[7] ^crc[0] ^crc[5] ^crc[7] ^crc[9] ^crc[11] ;
	assign bit_11 = (reset == 1'b0) ? 1'b0 : data[29] ^data[28] ^data[25] ^data[24] ^data[23] ^data[22] ^data[21] ^data[16] ^data[15] ^data[14] ^data[13] ^data[12] ^data[11] ^data[10] ^data[7] ^data[6] ^data[5] ^data[4] ^data[3] ^data[2] ^data[1] ^data[0] ^crc[1] ^crc[2] ^crc[3] ^crc[4] ^crc[5] ^crc[8] ^crc[9] ;

	assign newcrc = {bit_11,bit_10,bit_9,bit_8,bit_7,bit_6,bit_5,bit_4,bit_3,bit_2,bit_1,bit_0};

endmodule



module SumValue (data, sum_val);
	input [7:0] data;
	output reg [7:0] sum_val;

	always @(data) begin
			case (data[7:6])
				2'b01 : sum_val = 8'b101;
				2'b10 : sum_val = {2'b0,data[5:0]};
				2'b00 : begin
					if (data[7:2] ==6'b001010) sum_val = 8'b10;
					else sum_val = 8'b1;
				end
				default : sum_val = 8'b0;
			endcase
	end

endmodule
