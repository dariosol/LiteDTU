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

`timescale	 1ps/1ps
module LDTU_FSM(
		CLK_,
		reset_,
		fallback_,
		Orbit,
		baseline_flag,
		Current_state_,
		tmrError,
		Current_state_FB_,
		);

   parameter SIZE=4;
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
   ///////////////////////////////////////////////
   parameter bc0_0      = 5'b01111;
   parameter bc0_1      = 5'b10000;
   parameter bc0_2      = 5'b10001;
   parameter bc0_3      = 5'b10010;
   parameter bc0_4      = 5'b10011;
   parameter header     = 5'b10100;
   parameter header_b0  = 5'b10101;
   parameter bc0_s0     = 5'b10110;
   parameter header_s0  = 5'b10111;
   parameter bc0_s0_bis = 5'b11000;

   input CLK_;
   input reset_;
   input fallback_;
   input Orbit;
   input baseline_flag;
   output reg [SIZE:0] Current_state_;
   output 	       tmrError;

   wor 		       Current_stateTmrError;
   wire [SIZE:0]       Current_state;
   reg [SIZE:0]        Next_state;

   //////////////////////////////////////////////////////
   //Fallback registers
   parameter SIZE_FB=3;
   output reg [SIZE_FB:0] Current_state_FB_;

   wor 			  Current_state_FBTmrError;
   wire [SIZE_FB:0] 	  Current_state_FB;
   reg [SIZE_FB:0] 	  Next_state_FB;
   
   parameter IDLE_FB=3'b000;
   parameter data_odd=3'b001;
   parameter latency1=3'b010;
   parameter data_even=3'b011;
   parameter latency2=3'b100;
   
   /////////////////////////////////////////////////////


   //Standard FSM
   always @( posedge CLK_ ) begin : FSM_SEQ
      if (reset_==1'b0 || fallback_==1'b1) begin
	 Current_state_ <= IDLE;
      end else begin
	 Current_state_ <= Next_state;
      end
   end


   always @( Current_state or baseline_flag or Orbit ) begin : FSM_COMB
      Next_state = IDLE;
      case (Current_state)		  
	IDLE : 
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       Next_state = bas_0;	     
	     else if (Orbit == 1'b1)
	       Next_state = header;	     
	     else
	       Next_state = sign_0;
	  end
	bas_0_bis : //**********************
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       Next_state = sign_0_bis;
             else if(Orbit == 1'b1)
               Next_state = bc0_s0_bis;		        
	     else
	       Next_state = sign_0;
	  end
	bas_0 : ///////////////////////////
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       Next_state = bas_1;
	     else if(Orbit == 1'b1)
	       Next_state = bc0_1;
	     else
	       Next_state = bas_1_bis;
	  end
	bas_1_bis : //**********************
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       Next_state = sign_0_bis;
	     else if(Orbit == 1'b1)
               Next_state = bc0_s0_bis;
	     else
	       Next_state = sign_0;
	  end
	bas_1 : ////////////////////////////////
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       Next_state = bas_2;
	     else if(Orbit == 1'b1)
	       Next_state = bc0_2;
	     else
	       Next_state = bas_2_bis;
	  end
	
	bas_2_bis : //**********************
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       Next_state = sign_0_bis;
	     else if(Orbit == 1'b1)
               Next_state = bc0_s0_bis;	     
	     else
	       Next_state = sign_0;
	  end
	bas_2 : ///////////////////////////
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       Next_state = bas_3;
	     else if(Orbit == 1'b1)
	       Next_state = bc0_3;
	     else
	       Next_state = bas_3_bis;
	  end
	bas_3_bis : //**********************
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       Next_state = sign_0_bis;
	     else if(Orbit == 1'b1)
               Next_state = bc0_s0_bis;
	     else
	       Next_state = sign_0;
	  end
	bas_3 : ////////////////////////////
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       Next_state = bas_4;
	     else if(Orbit == 1'b1)
	       Next_state = bc0_4;
	     else
	       Next_state = bas_4_bis;
	  end
	bas_4_bis : //**********************
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       Next_state = sign_0_bis;
	     else if(Orbit == 1'b1)
               Next_state = bc0_s0_bis;
	     else
	       Next_state = sign_0;
	  end
	bas_4 : /////////////////////////////////
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       Next_state = bas_0;
	     else if(Orbit == 1'b1)
	       Next_state = bc0_0;
	     else
	       Next_state = bas_0_bis;
	  end
	sign_0_bis : //sssssssssssssssssssssssssssss
	  begin
	     if (baseline_flag==1'b0 && Orbit == 1'b0)
	       Next_state = bas_0_bis;	
             else if( Orbit == 1'b1)
               Next_state = bc0_0;	   
	     else
	       Next_state = bas_0;
	  end
	sign_0 : //s22222222222222222222222222222222222
	  begin
	     if (baseline_flag==1'b0  && Orbit == 1'b0)
	       Next_state = sign_1;
             else if(Orbit == 1'b1)
               Next_state = bc0_s0;				
	     else
	       Next_state = sign_1_bis;
	  end
	sign_1_bis : //sssssssssssssssssssssssssssss
	  begin
	     if (baseline_flag==1'b0 && Orbit == 1'b0)
	       Next_state = bas_0_bis;
             else if( Orbit == 1'b1)
               Next_state = bc0_0;			       
	     else
	       Next_state = bas_0;
	  end
	sign_1 : //s11111111111111111111111111111111
	  begin
	     if (baseline_flag==1'b0 && Orbit == 1'b0)
	       Next_state = sign_0;
	     else if( Orbit == 1'b1)
               Next_state = bc0_s0_bis;				     
	     else
	       Next_state = sign_0_bis;
	  end

	
	bc0_0 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = header_s0;
	     else
	       Next_state = header_b0;
	  end

	bc0_1 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = header_s0;
	     else
	       Next_state = header_b0;
	  end

	bc0_2 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = header_s0;
	     else
	       Next_state = header_b0;
	  end
	
	bc0_3 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = header_s0;
	     else
	       Next_state = header_b0;
	  end

	bc0_4 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = header_s0;
	     else
	       Next_state = header_b0;
	  end		       
	
	bc0_s0:
	  begin
	     Next_state = header;
	  end
	
	bc0_s0_bis :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = header_s0;
	     else
	       Next_state = header_b0;	     
	  end
	
	header :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = sign_0;
	     else
	       Next_state = bas_0;
	  end

	
	header_s0 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = sign_0;
	     else
	       Next_state = sign_0_bis;
	  end


	header_b0 :
	  begin
	     if (baseline_flag==1'b0)
	       Next_state = bas_0_bis;
	     else
	       Next_state = bas_0;
	  end



	
	
	
	default : Next_state = IDLE;
      endcase
   end



   //FALLBACK FSM
   always @( posedge CLK_ ) begin : FSM_SEQ_FB_
      if (reset_==1'b0 || fallback_==1'b0) begin
	 Current_state_FB_ <= IDLE_FB;
      end else begin
	 Current_state_FB_ <= Next_state_FB;
      end
   end


   always @( Current_state_FB or Orbit ) begin : FSM_COMB_FB
      Next_state_FB = IDLE_FB;
      
      case (Current_state_FB)
	IDLE_FB :
	  begin
	     Next_state_FB = data_odd;
	  end 

	data_odd:
	  begin
	     Next_state_FB = latency1;
	  end
	
        latency1:
	  begin
	     Next_state_FB = data_even;
	  end

	data_even:
	  begin
	     Next_state_FB = latency2;
	  end

	latency2:
	  begin
	     Next_state_FB = data_odd;
	  end
	
	default : Next_state_FB = IDLE_FB;
	
      endcase // case (Current_state)
   end // block: FSM_FS_

   




   

   assign tmrError = Current_stateTmrError | Current_state_FBTmrError;


endmodule
