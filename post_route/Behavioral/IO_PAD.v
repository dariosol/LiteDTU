module IO_PAD (
	inout Internal,
	inout IO,
	inout VDDPST,
	inout VSSPST);

	assign Internal = IO;

endmodule

module IO_PAD_noRes (
	inout IO,
	inout VDDPST,
	inout VSSPST);

endmodule

module IO_PAD_DIGIO (
	inout  IO,	
	input  A,
	input  OEN,
	input  DS,
	input  PEN,
	input  UD,
	output Z,
	output Zh,
	inout  VDD,
	inout  VSS,
	inout  VDDPST,
	inout  VSSPST);

	bufif1(IO,A,OEN);
	assign Z  = IO;
	assign Zh = IO; 

endmodule

module IO_PAD_VDDPST (
	inout VDD,
	inout VSS,
	inout VDDPST,
	inout VSSPST);

endmodule

module IO_PAD_VSSPST (
	inout VDD,
	inout VSS,
	inout VDDPST,
	inout VSSPST);

endmodule

module IO_PAD_VDD (
	inout VDD,
	inout VSS,
	inout VSSPST);

endmodule

module IO_PAD_VSS (
	inout VDD,
	inout VSS,
	inout VSSPST);

endmodule

