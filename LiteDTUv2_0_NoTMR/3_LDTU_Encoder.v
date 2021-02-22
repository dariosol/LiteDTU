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
		       CLK,
		       rst_b,
		       Orbit,
		       fallback,
		       baseline_flag,
		       DATA_to_enc,
		       DATA_32,
		       Load,
		       DATA_32_FB,
		       Load_FB,
		       SeuError
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
   input CLK;
   input rst_b;
   input Orbit;
   input fallback;
   input baseline_flag;
   input [Nbits_12:0] DATA_to_enc;
   output [Nbits_32-1:0] DATA_32;
   output 		 Load;
   output [Nbits_32-1:0] DATA_32_FB;
   output 		 Load_FB;
   output 		 SeuError;

   wire [1:0] 		 code_sel_bas;
   wire [5:0] 		 code_sel_sign;



   reg [Nbits_6-1:0] 	 Ld_bas_1;
   reg [Nbits_6-1:0] 	 Ld_bas_2;
   reg [Nbits_6-1:0] 	 Ld_bas_3;
   reg [Nbits_6-1:0] 	 Ld_bas_4;
   reg [Nbits_6-1:0] 	 Ld_bas_5;
   reg [Nbits_12:0] 	 Ld_sign_1;
   reg [Nbits_12:0] 	 Ld_sign_2;
   reg [Nbits_32-1:0] 	 DATA_32;
   reg 			 Load;
   wire [SIZE:0] 	 Current_state;
   wire [Nbits_12:0] 	 dDATA_to_enc;
   reg [Nbits_12:0] 	 Ld_sign_FB;
   reg [Nbits_32-1:0] 	 DATA_32_FB;
   reg 			 Load_FB;
   wire [SIZE_FB:0] 	 Current_state_FB;

   wire 		 SeuError_FSM;
   
   wire 		 tmrError = 1'b0;
   wire                  tmrErrorVoted = tmrError;
   assign                SeuError = tmrErrorVoted | SeuError_FSM;
   
   Delay_enc delay(CLK, rst_b, DATA_to_enc, dDATA_to_enc);

   LDTU_FSM fsm(.CLK(CLK), .rst_b(rst_b), .baseline_flag(baseline_flag),.Orbit(Orbit),.fallback(fallback),
		   .Current_state(Current_state), 
		   .Current_state_FB(Current_state_FB),
		   .SeuError(SeuError_FSM));

   assign code_sel_bas = (baseline_flag==1'b1) ? code_sel_bas1 : code_sel_bas2;
   assign code_sel_sign = (baseline_flag==1'b0) ? code_sel_sign1 : code_sel_sign2;



   always @( posedge CLK)
     begin : FSM_seq_output
	if (rst_b==1'b0 || fallback==1'b1)
	  begin
	     Ld_bas_1 <= 6'b0;
	     Ld_bas_2 <= 6'b0;
	     Ld_bas_3 <= 6'b0;
	     Ld_bas_4 <= 6'b0;
	     Ld_bas_5 <= 6'b0;
	     Ld_sign_1 <= 13'b0;
	     Ld_sign_2 <= 13'b0;
	     Load <= 1'b0;
	     DATA_32 <= Initial;
end
	else
	  begin
       	     case (Current_state)
       	       bc0_0 : //close previous baseline
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_bas2,one,Ld_bas_1};
       		    Ld_sign_1 <= dDATA_to_enc ;
       		 end 
	       
       	       bc0_1 : //close previous baseline
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_bas2,two,Ld_bas_2,Ld_bas_1};
                    Ld_sign_1 <= dDATA_to_enc;
       	    	 end
	       
       	       bc0_2 : //close previous baseline
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_bas2,three,Ld_bas_3,Ld_bas_2,Ld_bas_1};
                    Ld_sign_1 <= dDATA_to_enc;
       	    	 end
	       
       	       bc0_3 : //close previous baseline
       		 begin
       		    Load <= 1'b1;
                    DATA_32 <= {code_sel_bas2,four,Ld_bas_4,Ld_bas_3,Ld_bas_2,Ld_bas_1};
                    Ld_sign_1 <= dDATA_to_enc;
       	    	 end
	       
       	       bc0_4 : //close previous baseline
       		 begin
       		    Load <= 1'b1;
                    DATA_32 <= {code_sel_bas1,Ld_bas_5,Ld_bas_4,Ld_bas_3,Ld_bas_2,Ld_bas_1};
                    Ld_sign_1 <= dDATA_to_enc;
       	    	 end
	       
       	       bc0_s0 : //Close previous signal
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_sign1,Ld_sign_2,Ld_sign_1};
       		    Ld_sign_1 <= dDATA_to_enc;
       		 end
	       
       	       bc0_s0_bis : // BC0 with signal
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_sign2,sync,Ld_sign_1};
       		    Ld_sign_1 <= dDATA_to_enc;
       		 end  
	       
       	       
       	       header_s0 : // BC0 with signal
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_sign2,header_synch,Ld_sign_1};
       		    Ld_bas_1 <= dDATA_to_enc;
       		    Ld_sign_1 <= dDATA_to_enc;
       		 end
	       
	       
       	       header : // go  back normal stream
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_sign2,header_synch,Ld_sign_1};
       		    Ld_bas_1 <= dDATA_to_enc;
       		    Ld_sign_1 <= dDATA_to_enc;
       	 	 end
	       
               header_b0 : // go back to normal stream
       		 begin
       		    Load <= 1'b1;
       		    DATA_32 <= {code_sel_sign2,header_synch,Ld_sign_1};
       		    Ld_bas_1 <= dDATA_to_enc[Nbits_6-1:0] ;
       		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       
	       IDLE : 
		 begin
		    Load <= 1'b0;
		    DATA_32 <= Initial;
end
	       bas_0 : 
		 begin
		    Load <= 1'b0;
		    Ld_bas_2 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       bas_0_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_bas2,one,Ld_bas_1};
		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       bas_1 : 
		 begin
		    Load <= 1'b0;
		    Ld_bas_3 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       bas_1_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_bas2,two,Ld_bas_2,Ld_bas_1};
		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       bas_2 : 
		 begin
		    Load <= 1'b0;
		    Ld_bas_4 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       bas_2_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_bas2,three,Ld_bas_3,Ld_bas_2,Ld_bas_1};
		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       bas_3 : 
		 begin
		    Load <= 1'b0;
		    Ld_bas_5 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       bas_3_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_bas2,four,Ld_bas_4,Ld_bas_3,Ld_bas_2,Ld_bas_1};
		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       bas_4 : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_bas1,Ld_bas_5,Ld_bas_4,Ld_bas_3,Ld_bas_2,Ld_bas_1};
		    Ld_bas_1 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       bas_4_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_bas1,Ld_bas_5,Ld_bas_4,Ld_bas_3,Ld_bas_2,Ld_bas_1};
		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       sign_0 : 
		 begin
		    Load <= 1'b0;
		    Ld_sign_2 <= dDATA_to_enc;
		 end
	       sign_0_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_sign2,sync,Ld_sign_1};
		    Ld_bas_1 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       sign_1 : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_sign1,Ld_sign_2,Ld_sign_1};
		    Ld_sign_1 <= dDATA_to_enc;
		 end
	       sign_1_bis : 
		 begin
		    Load <= 1'b1;
		    DATA_32 <= {code_sel_sign1,Ld_sign_2,Ld_sign_1};
		    Ld_bas_1 <= dDATA_to_enc[Nbits_6-1:0] ;
		 end
	       default : 
		 begin
		    Load <= 1'b0;
		    DATA_32 <= Initial;
end
	     endcase
	  end
     end





   always @( posedge CLK )
     begin : FSM_seq_output_FB
	if (rst_b==1'b0 || fallback==1'b0)
	  begin
	     Load_FB <= 1'b0;
	     DATA_32_FB <= Initial;
             Ld_sign_FB<=13'b0;
         end
	else
	  begin
       	     case (Current_state_FB)
       	       data_odd : //close previous baseline
       		 begin
       		    Load_FB <= 1'b0;
       		    Ld_sign_FB <= dDATA_to_enc;
       		 end 
	       latency1 :
		 begin
		    Load_FB <=1'b0;
		 end
	       data_even :
		 begin
		    Load_FB<=1'b1;
	            DATA_32_FB <= {2'b11,2'b11, ~^dDATA_to_enc, ~^Ld_sign_FB, dDATA_to_enc, Ld_sign_FB};
		 end

	       latency2 :
		 begin
		    Load_FB <=1'b0;
		 end
	       
	       default :
		 begin
		    Load_FB <= 1'b0;		    
		    DATA_32_FB <= Initial;
   
end
	     endcase // case (Current_state_)
	  end // else: !if(rst_b==1'b0 || fallback==1'b0)
     end // block: FSM_seq_output_FB
//   assign DATA_32 = DATA_32;
//   assign DATA_32_FB = DATA_32_FB;
   


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
