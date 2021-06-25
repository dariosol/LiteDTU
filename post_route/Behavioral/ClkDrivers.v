
// Behavioural models for internal clock drivers

module ClkDrvD (
	input  inp,
	input  inm,
	output outp,
	output outm,
	inout  VDD,
	inout  VSS);

	assign outp = inp;
	assign outm = inm;

endmodule

module ClkSE2D (
	input  in,
	output outp,
	output outm,
        inout  VDD,
        inout  VSS);

	assign outp = in;
	assign outm = ~in;

endmodule

module ClkD2SE (
	input  inp,
	input  inm,
	output out,
        inout  VDD,
        inout  VSS);

	assign out = inp;

endmodule

