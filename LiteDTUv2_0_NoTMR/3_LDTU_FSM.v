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
//	 4.02.21 : Manual triplication removed - Gianni
//
// *************************************************************************************************

`timescale	 1ns/1ps
module LDTU_FSM(
		   CLK,
		   rst_b,
		   fallback,
		   Orbit,
		   Orbit_FB,
		   baseline_flag,
		   Current_state,
		   Current_state_FB
//		   SeuError
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

   input CLK;
   input rst_b;
   input fallback;
   input Orbit;
   input Orbit_FB;
   input baseline_flag;
   output reg[SIZE:0] Current_state;   
//   output 	       SeuError;

   reg [SIZE:0]        nState;


//////////////////////////////////////////////////////
//Fallback registers
   parameter SIZE_FB=3;
   output reg [SIZE_FB:0] Current_state_FB;
   reg [SIZE_FB:0]     nState_FB;

   
   
   parameter IDLE_FB=3'b000;
   parameter data_odd=3'b001;
   parameter latency1=3'b010;
   parameter data_even=3'b011;
   parameter latency2=3'b100;
   parameter data_odd_bc0=3'b101;
   parameter data_even_bc0=3'b110;
   
/////////////////////////////////////////////////////
//   wire 	       tmrError = 1'b0;
//   assign                SeuError = tmrError;
      
   

   //Standard FSM
   always @( posedge CLK ) begin : FSM_SEQ
      if (rst_b==1'b0 || fallback==1'b1) begin
	 Current_state <= IDLE;
      end else begin
	 Current_state <= nState;
      end
   end

   always @( Current_state or baseline_flag or Orbit ) begin : FSM_COMB
      nState = IDLE;
       case (Current_state)		  
	IDLE : 
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       nState = bas_0;	     
	     else if (Orbit == 1'b1)
	       nState = header;	     
	     else
	       nState = sign_0;
	  end
	bas_0_bis : //**********************
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       nState = sign_0_bis;
             else if(Orbit == 1'b1)
               nState = bc0_s0_bis;		        
	     else
	       nState = sign_0;
	  end
	bas_0 : ///////////////////////////
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       nState = bas_1;
	     else if(Orbit == 1'b1)
	       nState = bc0_1;
	     else
	       nState = bas_1_bis;
	  end
	bas_1_bis : //**********************
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       nState = sign_0_bis;
	     else if(Orbit == 1'b1)
               nState = bc0_s0_bis;
	     else
	       nState = sign_0;
	  end
	bas_1 : ////////////////////////////////
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       nState = bas_2;
	     else if(Orbit == 1'b1)
	       nState = bc0_2;
	     else
	       nState = bas_2_bis;
	  end
	
	bas_2_bis : //**********************
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       nState = sign_0_bis;
	     else if(Orbit == 1'b1)
               nState = bc0_s0_bis;	     
	     else
	       nState = sign_0;
	  end
	bas_2 : ///////////////////////////
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       nState = bas_3;
	     else if(Orbit == 1'b1)
	       nState = bc0_3;
	     else
	       nState = bas_3_bis;
	  end
	bas_3_bis : //**********************
	  begin
	     if (baseline_flag==1'b1 && Orbit == 1'b0)
	       nState = sign_0_bis;
	     else if(Orbit == 1'b1)
               nState = bc0_s0_bis;
	     else
	       nState = sign_0;
	  end
	bas_3 : ////////////////////////////
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       nState = bas_4;
	     else if(Orbit == 1'b1)
	       nState = bc0_4;
	     else
	       nState = bas_4_bis;
	  end
	bas_4_bis : //**********************
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       nState = sign_0_bis;
	     else if(Orbit == 1'b1)
               nState = bc0_s0_bis;
	     else
	       nState = sign_0;
	  end
	bas_4 : /////////////////////////////////
	  begin
	     if (baseline_flag==1'b1  && Orbit == 1'b0)
	       nState = bas_0;
	     else if(Orbit == 1'b1)
	       nState = bc0_0;
	     else
	       nState = bas_0_bis;
	  end
	sign_0_bis : //sssssssssssssssssssssssssssss
	  begin
	     if (baseline_flag==1'b0 && Orbit == 1'b0)
	       nState = bas_0_bis;	
             else if( Orbit == 1'b1)
               nState = bc0_0;	   
	     else
	       nState = bas_0;
	  end
	sign_0 : //s22222222222222222222222222222222222
	  begin
	     if (baseline_flag==1'b0  && Orbit == 1'b0)
	       nState = sign_1;
             else if(Orbit == 1'b1)
               nState = bc0_s0;				
	     else
	       nState = sign_1_bis;
	  end
	sign_1_bis : //sssssssssssssssssssssssssssss
	  begin
	     if (baseline_flag==1'b0 && Orbit == 1'b0)
	       nState = bas_0_bis;
             else if( Orbit == 1'b1)
               nState = bc0_0;			       
	     else
	       nState = bas_0;
	  end
	sign_1 : //s11111111111111111111111111111111
	  begin
	     if (baseline_flag==1'b0 && Orbit == 1'b0)
	       nState = sign_0;
	     else if( Orbit == 1'b1)
               nState = bc0_s0_bis;				     
	     else
	       nState = sign_0_bis;
	  end

	
	bc0_0 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = header_s0;
	     else
	       nState = header_b0;
	  end

	bc0_1 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = header_s0;
	     else
	       nState = header_b0;
	  end

	bc0_2 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = header_s0;
	     else
	       nState = header_b0;
	  end
	
	bc0_3 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = header_s0;
	     else
	       nState = header_b0;
	  end

	bc0_4 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = header_s0;
	     else
	       nState = header_b0;
	  end		       
	
	bc0_s0:
	  begin
	       nState = header;
	  end
	
	bc0_s0_bis :
	  begin
	     if (baseline_flag==1'b0)
	       nState = header_s0;
	      else
	       nState = header_b0;	     
	  end
	
	header :
	  begin
	     if (baseline_flag==1'b0)
	       nState = sign_0;
	     else
	       nState = bas_0;
	  end

	
	header_s0 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = sign_0;
	     else
	       nState = sign_0_bis;
	  end


	header_b0 :
	  begin
	     if (baseline_flag==1'b0)
	       nState = bas_0_bis;
	     else
	       nState = bas_0;
	  end

	default : nState = IDLE;
      endcase
   end



   //FALLBACK FSM
      always @( posedge CLK ) begin : FSM_SEQ_FB
      if (rst_b==1'b0 || fallback==1'b0) begin
	 Current_state_FB <= IDLE_FB;
      end else begin
	 Current_state_FB <= nState_FB;
      end
   end



   always @( Current_state_FB or Orbit_FB ) begin : FSM_COMB_FB
      nState_FB = IDLE_FB;
      
      case (Current_state_FB)
	IDLE_FB :
	  begin
		nState_FB = data_odd;
	  end 

	data_odd:
	  begin
	     nState_FB = latency1;
	  end
	
        latency1:
	  begin
	     if(Orbit_FB == 1'b0) begin
		nState_FB = data_even;
		end
	      else begin
		nState_FB = data_even_bc0;
	      end
	  end

	data_even:
	  begin
	     nState_FB = latency2;
	  end

	latency2:
	  begin
	     if(Orbit_FB == 1'b0) begin
		nState_FB = data_odd;
		end
	      else begin
		nState_FB = data_odd_bc0;
	      end
	  end
       
	default : nState_FB = IDLE_FB;
	
      endcase // case (Current_state)
   end // block: FSM_COMB_FB


endmodule
