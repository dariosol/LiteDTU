// File>>> deglitch.v
//
// Date: Wed Mar  4 13:15:26 CET 2020
// Author: gianni
//
// Revision history:
//
// Deglitch circuit
//
`timescale  1ps/1ps
module deglitch (
	input  A,
	output Z);

	wire net0;
	wire net1;

	assign #10 net0 = A; 
	assign #10 net1 = net0;
	assign #1 Z = A | net1;
endmodule

