// File>>> LDTUv1b_ser.v
//
// Date: Thu Apr 23 15:42:04 CET 2020
// Authors: gianni, simona
//
// Revision history:
//
// Serializer Unit for the LiTE-DTU v1b
//

module LDTUv1b_ser (
	input 	rst_b,
	input 	clock,
	input[31:0] 	DataIn0,
	input[31:0] 	DataIn1,
	input[31:0] 	DataIn2,
	input[31:0] 	DataIn3,
	output 			handshake,
	output 			DataOut0,
	output 			DataOut1,
	output 			DataOut2,
	output 			DataOut3);

	reg[4:0] 		pointer_ser;
	reg[31:0] 		bitShiftReg0;
	reg[31:0] 		bitShiftReg1;
	reg[31:0] 		bitShiftReg2;
	reg[31:0] 		bitShiftReg3;
	reg 			load_ser;

	reg 			int_hshake;

		// Serializer counter

	always @(posedge clock) begin
		if (rst_b == 1'b0) begin
			pointer_ser <= 5'b0;
		end else begin
			pointer_ser <= pointer_ser + 5'b00001;
		end
	end

		// Serializer handshake generation

	always @(posedge clock) begin
		if (rst_b == 1'b0) 
			int_hshake <= 1'b0;
		else begin
			if (pointer_ser == 5'b00010) 
				int_hshake <= 1'b1;
			else if (pointer_ser == 5'b01010)
				int_hshake <= 1'b0;
		end
	end

	assign handshake = int_hshake;

		// Serializer load generation

	always @(posedge clock) begin
		if (rst_b == 1'b0) 
			load_ser <= 1'b1;
		else begin
			if (pointer_ser == 5'b11111) 
				load_ser <= 1'b1;
			else 
				load_ser <= 1'b0;
		end
	end

		// Serializer

	always @( posedge clock ) begin
		if (rst_b == 1'b0 | load_ser == 1'b1) begin
			bitShiftReg0 <= DataIn0;
			bitShiftReg1 <= DataIn1;
			bitShiftReg2 <= DataIn2;
			bitShiftReg3 <= DataIn3;
		end else begin
      		bitShiftReg0 <= {bitShiftReg0[30:0], 1'b0};
      		bitShiftReg1 <= {bitShiftReg1[30:0], 1'b0};
      		bitShiftReg2 <= {bitShiftReg2[30:0], 1'b0};
      		bitShiftReg3 <= {bitShiftReg3[30:0], 1'b0};
		end
	end

	assign DataOut0 = bitShiftReg0[31];
	assign DataOut1 = bitShiftReg1[31];
	assign DataOut2 = bitShiftReg2[31];
	assign DataOut3 = bitShiftReg3[31];

endmodule

