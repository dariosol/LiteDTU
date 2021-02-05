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

`timescale	 1ps/1ps
module LDTU_Encoder(
		       CLK_,
		       reset_,
		       Orbit,
		       fallback_,
		       baseline_flag,
		       DATA_to_enc,
		       DATA_32,
		       Load,
		       DATA_32_FB,
		       Load_FB,
		       tmrError
		       );

   parameter SIZE=4;

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
   parameter Initial_FB=32'b00000000000000000000000000000000;
   /////////////////////////////////////////////////////////////////
   //v1.2
   parameter header_synch  = 13'b1111000001111;
   parameter IDLE=5'b00000;
   parameter bas_0=5'b00001;
   parameter bas_1=5'b00010;
   parameter bas_2=5'b00011;
   parameter bas_3=5'b00100;
   parameter bas_4=5'b00101;
   parameter sign_0=5'b00110;
   parameter sign_1=5'b00111;
   parameter bas_0_bis=5'b01000;
   parameter bas_1_bis=5'b01001;
   parameter bas_2_bis=5'b01010;
   parameter bas_3_bis=5'b01011;
   parameter bas_4_bis=5'b01100;
   parameter sign_0_bis=5'b01101;
   parameter sign_1_bis=5'b01110;
   //////////////////////////////////////////////
   //Registers for orbits
   parameter bc0_0     = 5'b01111;
   parameter bc0_1     = 5'b10000;
   parameter bc0_2     = 5'b10001;
   parameter bc0_3     = 5'b10010;
   parameter bc0_4     = 5'b10011;
   parameter header    = 5'b10100;
   parameter header_b0 = 5'b10101;
   parameter bc0_s0    = 5'b10110;
   parameter header_s0 = 5'b10111;
   parameter bc0_s0_bis= 5'b11000;
   //////////////////////////////////////////////
   //FallBack
   parameter SIZE_FB=3;   
   
   parameter IDLE_FB=3'b000;
   parameter data_odd=3'b001;
   parameter latency1=3'b010;
   parameter data_even=3'b011;
   parameter latency2=3'b100;
   
   //////////////////////////////////////////////
   //PORTS
   input CLK_;
   input reset_;
   input Orbit;
   input fallback_;
   input baseline_flag;
   input [Nbits_12:0] DATA_to_enc;
   output [Nbits_32-1:0] DATA_32;
   output 		 Load;
   output [Nbits_32-1:0] DATA_32_FB;
   output 		 Load_FB;
   output 		 tmrError;

   wire [1:0] 		 code_sel_bas;
   wire [5:0] 		 code_sel_sign;
   wire [Nbits_12:0] 	 dDATA_to_enc;


   reg [Nbits_6-1:0] 	 Ld_bas_1_;
   reg [Nbits_6-1:0] 	 Ld_bas_2_;
   reg [Nbits_6-1:0] 	 Ld_bas_3_;
   reg [Nbits_6-1:0] 	 Ld_bas_4_;
   reg [Nbits_6-1:0] 	 Ld_bas_5_;
   reg [Nbits_12:0] 	 Ld_sign_1_;
   reg [Nbits_12:0] 	 Ld_sign_2_;
   reg [Nbits_32-1:0] 	 DATA_32_;
   reg 			 Load_;
   reg 			 Load_B;
   reg 			 Load_C;
   wire [SIZE:0] 	 Current_state_;
   wire [Nbits_12:0] 	 dDATA_to_enc_;
   wor 			 LoadTmrError;
   wor 			 DATA_32TmrError;
   wire 		 fsm_TmrError;

   reg [Nbits_12:0] 	 Ld_sign_FB_;
   reg [Nbits_32-1:0] 	 DATA_32_FB_;
   reg 			 Load_FB_;
   wire [SIZE_FB:0] 	 Current_state_FB_;
   wor 			 LoadTmrError_FB;
   wor 			 DATA_32TmrError_FB;
   wire 		 fsm_TmrError_FB;

   Delay_enc delay_ (CLK_, reset_, DATA_to_enc, dDATA_to_enc_);

   LDTU_FSMTMR fsm(.CLK_(CLK_), .reset_(reset_), .baseline_flag(baseline_flag),.Orbit(Orbit),.fallback_(fallback_),
		   .Current_state_(Current_state_), 
		   .Current_state_FB_(Current_state_FB_),
		   .tmrError(fsm_TmrError));

   assign code_sel_bas = (baseline_flag==1'b1) ? code_sel_bas1 : code_sel_bas2;
   assign code_sel_sign = (baseline_flag==1'b0) ? code_sel_sign1 : code_sel_sign2;



   always @( posedge CLK_ )
     begin : FSM_seq_output
	if (reset_==1'b0 || fallback_==1'b1)
	  begin
	     Ld_bas_1_ <= 6'b0;
	     Ld_bas_2_ <= 6'b0;
	     Ld_bas_3_ <= 6'b0;
	     Ld_bas_4_ <= 6'b0;
	     Ld_bas_5_ <= 6'b0;
	     Ld_sign_1_ <= 13'b0;
	     Ld_sign_2_ <= 13'b0;
	     Load_ <= 1'b0;
	     DATA_32_ <= Initial;
end
	else
	  begin
       	     case (Current_state_)
       	       bc0_0 : //close previous baseline
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_bas2,one,Ld_bas_1_};
       		    Ld_sign_1_ <= dDATA_to_enc_ ;
       		 end 
	       
       	       bc0_1 : //close previous baseline
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_bas2,two,Ld_bas_2_,Ld_bas_1_};
                    Ld_sign_1_ <= dDATA_to_enc_;
       	    	 end
	       
       	       bc0_2 : //close previous baseline
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_bas2,three,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
                    Ld_sign_1_ <= dDATA_to_enc_;
       	    	 end
	       
       	       bc0_3 : //close previous baseline
       		 begin
       		    Load_ <= 1'b1;
                    DATA_32_ <= {code_sel_bas2,four,Ld_bas_4_,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
                    Ld_sign_1_<= dDATA_to_enc_;
       	    	 end
	       
       	       bc0_4 : //close previous baseline
       		 begin
       		    Load_ <= 1'b1;
                    DATA_32_ <= {code_sel_bas1,Ld_bas_5_,Ld_bas_4_,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
                    Ld_sign_1_<= dDATA_to_enc_;
       	    	 end
	       
       	       bc0_s0 : //Close previous signal
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_sign1,Ld_sign_2_,Ld_sign_1_};
       		    Ld_sign_1_ <= dDATA_to_enc_;
       		 end
	       
       	       bc0_s0_bis : // BC0 with signal
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_sign2,sync,Ld_sign_1_};
       		    Ld_sign_1_ <= dDATA_to_enc_;
       		 end  
	       
       	       
       	       header_s0 : // BC0 with signal
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_sign2,header_synch,Ld_sign_1_};
       		    Ld_bas_1_ <= dDATA_to_enc_;
       		    Ld_sign_1_ <= dDATA_to_enc_;
       		 end
	       
	       
       	       header : // go  back normal stream
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_sign2,header_synch,Ld_sign_1_};
       		    Ld_bas_1_ <= dDATA_to_enc_;
       		    Ld_sign_1_ <= dDATA_to_enc_;
       	 	 end
	       
               header_b0 : // go back to normal stream
       		 begin
       		    Load_ <= 1'b1;
       		    DATA_32_ <= {code_sel_sign2,header_synch,Ld_sign_1_};
       		    Ld_bas_1_ <= dDATA_to_enc_[Nbits_6-1:0] ;
       		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       
	       IDLE : 
		 begin
		    Load_ <= 1'b0;
		    DATA_32_ <= Initial;
end
	       bas_0 : 
		 begin
		    Load_ <= 1'b0;
		    Ld_bas_2_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       bas_0_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_bas2,one,Ld_bas_1_};
		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       bas_1 : 
		 begin
		    Load_ <= 1'b0;
		    Ld_bas_3_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       bas_1_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_bas2,two,Ld_bas_2_,Ld_bas_1_};
		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       bas_2 : 
		 begin
		    Load_ <= 1'b0;
		    Ld_bas_4_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       bas_2_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_bas2,three,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       bas_3 : 
		 begin
		    Load_ <= 1'b0;
		    Ld_bas_5_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       bas_3_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_bas2,four,Ld_bas_4_,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       bas_4 : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_bas1,Ld_bas_5_,Ld_bas_4_,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
		    Ld_bas_1_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       bas_4_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_bas1,Ld_bas_5_,Ld_bas_4_,Ld_bas_3_,Ld_bas_2_,Ld_bas_1_};
		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       sign_0 : 
		 begin
		    Load_ <= 1'b0;
		    Ld_sign_2_ <= dDATA_to_enc_;
		 end
	       sign_0_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_sign2,sync,Ld_sign_1_};
		    Ld_bas_1_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       sign_1 : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_sign1,Ld_sign_2_,Ld_sign_1_};
		    Ld_sign_1_ <= dDATA_to_enc_;
		 end
	       sign_1_bis : 
		 begin
		    Load_ <= 1'b1;
		    DATA_32_ <= {code_sel_sign1,Ld_sign_2_,Ld_sign_1_};
		    Ld_bas_1_ <= dDATA_to_enc_[Nbits_6-1:0] ;
		 end
	       default : 
		 begin
		    Load_ <= 1'b0;
		    DATA_32_ <= Initial;
end
	     endcase
	  end
     end





   always @( posedge CLK_ )
     begin : FSM_seq_output_FB_
	if (reset_==1'b0 || fallback_==1'b0)
	  begin
	     Load_FB_ <= 1'b0;
	     DATA_32_FB_ <= Initial;
             Ld_sign_FB_<=13'b0;
         end
	else
	  begin
       	     case (Current_state_FB_)
       	       data_odd : //close previous baseline
       		 begin
       		    Load_FB_ <= 1'b0;
       		    Ld_sign_FB_ <= dDATA_to_enc_;
       		 end 
	       latency1 :
		 begin
		    Load_FB_ <=1'b0;
		 end
	       data_even :
		 begin
		    Load_FB_<=1'b1;
	            DATA_32_FB_ <= {2'b11,2'b11, ~^dDATA_to_enc_, ~^Ld_sign_FB_, dDATA_to_enc_, Ld_sign_FB_};
		 end

	       latency2 :
		 begin
		    Load_FB_ <=1'b0;
		 end
	       
	       default :
		 begin
		    Load_FB_ <= 1'b0;		    
		    DATA_32_FB_ <= Initial;
   
end
	     endcase // case (Current_state_)
	  end // else: !if(reset_==1'b0 || fallback_==1'b0)
     end // block: FSM_seq_output_FB_
   assign tmrError = LoadTmrError | DATA_32TmrError | fsm_TmrError | LoadTmrError_FB | DATA_32TmrError_FB | fsm_TmrError_FB;



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
