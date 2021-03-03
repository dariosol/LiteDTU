
`timescale    1ps/1ps
module LDTU_DATA32_ATU_DTU(
			   CLK,
			   RST,
			   CALIBRATION_BUSY,
			   TEST_ENABLE,
			   DATA32_ATU_0,
			   DATA32_ATU_1,
			   DATA32_ATU_2,
			   DATA32_ATU_3,
			   DATA32_DTU,
			   DATA32_0,
			   DATA32_1,
			   DATA32_2,
			   DATA32_3,
			   SeuError
  			   );

   parameter Nbits_32=32;
   parameter idle_patternEA = 32'b11101010101010101010101010101010;   
   parameter idle_pattern5A = 32'b01011010010110100101101001011010;


   input CLK;
   input RST;
   input CALIBRATION_BUSY;
   input TEST_ENABLE;
   input [Nbits_32-1:0] DATA32_ATU_0;
   input [Nbits_32-1:0] DATA32_ATU_1;
   input [Nbits_32-1:0] DATA32_ATU_2;
   input [Nbits_32-1:0] DATA32_ATU_3;
   input [Nbits_32-1:0] DATA32_DTU;
   output reg [Nbits_32-1:0] DATA32_0;
   output reg [Nbits_32-1:0] DATA32_1;
   output reg [Nbits_32-1:0] DATA32_2;
   output reg [Nbits_32-1:0] DATA32_3;
   output 		     SeuError;
  

   
//   wire tmrError = 1'b0;
//   assign SeuError = tmrError;
   

   always @(posedge CLK) begin
      if (RST == 1'b0) begin
 	 if (TEST_ENABLE == 1'b0) DATA32_0 = idle_patternEA;
	 else DATA32_0 = idle_pattern5A;
	 DATA32_1 = idle_pattern5A;
	 DATA32_2 = idle_pattern5A;
	 DATA32_3 = idle_pattern5A;
      end else begin
	 if (TEST_ENABLE == 1'b0) begin
	    if (CALIBRATION_BUSY == 1'b0) DATA32_0 = DATA32_DTU;
	    else DATA32_0 = idle_patternEA;
	    DATA32_1 = idle_pattern5A;
	    DATA32_2 = idle_pattern5A;
	    DATA32_3 = idle_pattern5A;
	 end else begin
	    DATA32_0 = DATA32_ATU_0;
	    DATA32_1 = DATA32_ATU_1;
	    DATA32_2 = DATA32_ATU_2;
	    DATA32_3 = DATA32_ATU_3;
	 end //TEST_ENABLE
      end //RST
   end //always






   

endmodule
