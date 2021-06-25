module CLPS_Tx (
	input DataIn,
	input TxEn,
	input ClkBitRate,
	input boost,
	input InvertData,
	input[2:0] DrvStrength,
	input[1:0] PEmode,
	input[2:0] PEstrength,
	input[2:0] PEwidth,
	output outp,
	output outm,
	inout VDD,
	inout VSS,
	inout VDDPST,
	inout VSSPST);

	assign outp = (InvertData) ? (~DataIn):DataIn;
	assign outm = (InvertData) ? DataIn:(~DataIn);

endmodule

module CLPS_Rx (
	input inp,
	input inm,
	input RxEn,
	input setCM,
	input termEn,
	input InvertData,
	input[1:0] equalizer,
	output out,
	inout VDD,
	inout VSS,
	inout VDDPST,
	inout VSSPST);

	assign out = (InvertData) ? inm:inp;

endmodule


module CLPS_Rx_DiffOut (
	input inp,
	input inm,
	input RxEn,
	input setCM,
	input termEn,
	input InvertData,
	input[1:0] equalizer,
	output outp,
	output outm,
	inout VDD,
	inout VSS,
	inout VDDPST,
	inout VSSPST);

	assign outp = (InvertData) ? inm:inp;
	assign outm = (InvertData) ? inp:inm;

endmodule


