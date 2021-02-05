

`timescale 1ps/1ps
module LDTU_CU(
	CLK_,
	reset_,
	fallback_,
	Load_data,
	DATA_32,
	Load_data_FB,
	DATA_32_FB,
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



	input CLK_;
	input reset_;
        input fallback_;
   
	input Load_data;
	input [Nbits_32-1:0] DATA_32;
   	input Load_data_FB;
	input [Nbits_32-1:0] DATA_32_FB;
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
	reg [7:0] NSample_;
	reg [5:0] Nlimit_;
	reg [7:0] NFrame_;
	reg [crcBits-1:0] crc_;

	wire [Nbits_32-1:0] DATA_32_;
	wire Load_data_;
	wire [Nbits_32-1:0] DATA_32_FB_;
	wire Load_data_FB_;
	wire full_;
	reg read_signal_;
	reg losing_data_;
	reg write_signal_;

	wire [crcBits-1:0] out_crc_;
	wire check_limit_;
	wire [7:0] NSamples_;
	wire [Nbits_32-1:0] wireTrailer_;

	assign check_limit_ = (Nlimit_>limit) ? 1'b1 : 1'b0;
	assign NSamples_ = (Nlimit_==6'b0) ? 8'b0 : NSample_;
	assign wireTrailer_ = {4'b1101,NSamples_,crc_,NFrame_};


	reg [Nbits_32-1:0] DATA_from_CU_;

	wire [crcBits-1:0] wcrc_;
	assign wcrc_ = crc_;
	CRC_calc calc_crc_ (.reset(reset_), .data(DATA_32_), .crc(wcrc_), .newcrc(out_crc_));


	wire [7:0] sum_val_;
	wire handshake_;

	SumValue SumValue_ ( .data(DATA_32_[31:24]), .sum_val(sum_val_));

//////CRC calculation, not done if FALLBACK
	always @( posedge CLK_ ) begin
		if (reset_==1'b0 || fallback_==1'b1) begin
			NSample_ <= 8'b0;
			Nlimit_ <= 6'b0;
			NFrame_ <= 8'b0;
			crc_ <= 12'b0;
		end else begin
			if (Load_data_ == 1'b0) begin
					if (check_limit_==1'b1) begin
						if (full_==1'b0) begin
							NSample_ <= 8'b0;
							Nlimit_ <= 6'b0;
							crc_ <= 12'b0;
							NFrame_ <= NFrame_+8'b1;
						end
					end
			end else begin
				if (full_==1'b0) begin
					Nlimit_ <= Nlimit_+6'b1;
					NSample_ <= NSample_ + sum_val_;
					crc_ <= out_crc_;
				end
			end
		end
	end

   //Writing Process
	always @( posedge CLK_ ) begin
		if (reset_==1'b0) begin
			DATA_from_CU_ = Initial;
			losing_data_ = 1'b0;
			write_signal_ = 1'b0;
		end else begin
			if (Load_data_ == 1'b0 && Load_data_FB_ == 1'b0) begin
				losing_data_ = 1'b0;
				if (check_limit_==1'b1 && fallback_==1'b0) begin
					if (full_==1'b0) begin
						DATA_from_CU_ = wireTrailer_;
						write_signal_ = 1'b1;
					end else begin
						write_signal_ = 1'b0;
					end
				end else begin
					write_signal_ = 1'b0;
				end
			end 
			else begin
				if (full_==1'b0 && fallback_==1'b0) begin
					write_signal_ = 1'b1;
					losing_data_ = 1'b0;
					DATA_from_CU_ = DATA_32_;
				end else if (full_==1'b0 && fallback_==1'b1) begin
				   write_signal_ = 1'b1;
				   losing_data_ = 1'b0;
				   DATA_from_CU_ = DATA_32_FB_;
				end else begin
					losing_data_ = 1'b1;
					write_signal_ = 1'b0;
				end
			end
		end
	end

	always @( posedge CLK_ ) begin
		if (reset_ == 1'b0) read_signal_ = 1'b0;
		else begin
			if (handshake_ == 1'b1) begin
				read_signal_ = 1'b1;
			end else read_signal_ = 1'b0;
		end
	end

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
