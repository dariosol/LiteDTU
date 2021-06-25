`timescale   1ns/1ps
module CernPll_v2 (

	inout VDDrx,
	inout VSSrx,
	inout VDD,
	inout VSS,
	inout VCO_decoupling,

	input 		rstA_b,
	input 		rstB_b,
	input 		rstC_b,
	input 		clk_160MHz,
	output reg	clkA_40MHz,	// from the input clock divider
	output reg	clkB_40MHz,
	output reg	clkC_40MHz,

	input 		clkTreeADisableA,
	input 		clkTreeADisableB,
	input 		clkTreeADisableC,

	input 		clkTreeBDisableA,
	input 		clkTreeBDisableB,
	input 		clkTreeBDisableC,

	input 		clkTreeCDisableA,
	input 		clkTreeCDisableB,
	input 		clkTreeCDisableC,

	input 		eclk2G56EnableA,
	input 		eclk2G56EnableB,
	input 		eclk2G56EnableC,

	input 		eclk1G28EnableA,
	input 		eclk1G28EnableB,
	input 		eclk1G28EnableC,

	input 		eclk40MEnableA,
	input 		eclk40MEnableB,
	input 		eclk40MEnableC,

	input 		eclk80MEnableA,
	input 		eclk80MEnableB,
	input 		eclk80MEnableC,

	input 		eclk160MEnableA,
	input 		eclk160MEnableB,
	input 		eclk160MEnableC,

	input 		eclk320MEnableA,
	input 		eclk320MEnableB,
	input 		eclk320MEnableC,

	input 		eclk640MEnableA,
	input 		eclk640MEnableB,
	input 		eclk640MEnableC,

	input 		enableDesA,
	input 		enableDesB,
	input 		enableDesC,

	input 		enablePhaseShifterA,
	input 		enablePhaseShifterB,
	input 		enablePhaseShifterC,

	input 		enableSerA,
	input 		enableSerB,
	input 		enableSerC,

	input 		toclkgen_disCLKA,
	input 		toclkgen_disCLKB,
	input 		toclkgen_disCLKC,
	input 		toclkgen_disDESA,
	input 		toclkgen_disDESB,
	input 		toclkgen_disDESC,
	input 		toclkgen_disEOMA,
	input 		toclkgen_disEOMB,
	input 		toclkgen_disEOMC,
	input 		toclkgen_disEXTA,
	input 		toclkgen_disEXTB,
	input 		toclkgen_disEXTC,
	input 		toclkgen_disSERA,
	input 		toclkgen_disSERB,
	input 		toclkgen_disSERC,
	input 		toclkgen_disVCOA,
	input 		toclkgen_disVCOB,
	input 		toclkgen_disVCOC,

	input[3:0] 	tocdr_BIASGEN_CONFIG,
	input[2:0] 	tocdr_CONFIG_FF_CAP,
	input[3:0] 	tocdr_CONFIG_I_CDR,
	input[3:0] 	tocdr_CONFIG_I_FLL,
	input[3:0] 	tocdr_CONFIG_I_PLL,
	input[3:0] 	tocdr_CONFIG_P_CDR,
	input[3:0] 	tocdr_CONFIG_P_FF_CDR,
	input[3:0] 	tocdr_CONFIG_P_PLL,
	input 		tocdr_ENABLE_CDR_R,
	input[3:0] 	tocdr_PLL_R_CONFIG,
	input 		tocdr_connectCDR,
	input 		tocdr_connectPLL,
	input[1:0] 	tocdr_dataMuxCfgA,
	input[1:0] 	tocdr_dataMuxCfgB,
	input[1:0] 	tocdr_dataMuxCfgC,
	input 		tocdr_disDESA,
	input 		tocdr_disDESB,
	input 		tocdr_disDESC,
	input 		tocdr_disDataCounterRef,
	input 		tocdr_enableCDR,
	input 		tocdr_enableFD,
	input 		tocdr_enablePLL,
	input 		tocdr_overrideVcA,
	input 		tocdr_overrideVcB,
	input 		tocdr_overrideVcC,
	input 		tocdr_refClkSelA,
	input 		tocdr_refClkSelB,
	input 		tocdr_refClkSelC,
	input[8:0] 	tocdr_vcoCapSelect,
	input[3:0] 	tocdr_vcoDAC,
	input 		tocdr_vcoRailMode,

	input 		tofbDiv_skipA,
	input 		tofbDiv_skipB,
	input 		tofbDiv_skipC,


	output reg	clk1G28A,
	output reg	clk1G28B,
	output reg	clk1G28C,
	output reg	clk1G28eclk,
	output reg	clk1G28ps,

	output reg	clk2G56A,
	output reg	clk2G56B,
	output reg	clk2G56C,
	output reg	clk2G56eclk,
	output reg	clk2G56ps,

	output reg	clk40MA,
	output reg	clk40MB,
	output reg	clk40MC,
	output reg	clk40Meclk,
	output reg	clk40Mps,
	output reg	clk40Mser,
	output reg	clk40Mdes,

	output clk80MA,
	output clk80MB,
	output clk80MC,
	output clk80Meclk,
	output clk80Mps,
	output clk80Mser,
	output clk80Mdes,

	output clk160MA,
	output clk160MB,
	output clk160MC,
	output clk160Meclk,
	output clk160Mps,
	output clk160Mser,
	output clk160Mdes,

	output clk320MA,
	output clk320MB,
	output clk320MC,
	output clk320Meclk,
	output clk320Mps,
	output clk320Mser,
	output clk320Mdes,

	output clk640MA,
	output clk640MB,
	output clk640MC,
	output clk640Meclk,
	output clk640Mps,
	output clk640Mser,
	output clk640Mdes,

	output reg fromcdr_clkRefA,
	output reg fromcdr_clkRefB,
	output reg fromcdr_clkRefC,

	output reg fromcdr_instlockPLL);

	parameter   ck_period 	= 0.195;

	wire clk_40MHz;
	reg  clk_80MHz;

	reg  PFD_up;
	reg  PFD_down;
	reg  PFD_rst;

	wire rst_b;
	wire eclk2G56Enable;
	wire eclk1G28Enable;
	wire eclk40MEnable;

	assign rst_b = (rstA_b & rstB_b) | (rstA_b & rstC_b) | (rstB_b & rstC_b);

	assign eclk2G56Enable = (eclk2G56EnableA & eclk2G56EnableB) | (eclk2G56EnableA & eclk2G56EnableC) | (eclk2G56EnableB & eclk2G56EnableC);
	assign eclk1G28Enable = (eclk1G28EnableA & eclk1G28EnableB) | (eclk1G28EnableA & eclk1G28EnableC) | (eclk1G28EnableB & eclk1G28EnableC);
	assign eclk40MEnable  = (eclk40MEnableA & eclk40MEnableB) | (eclk40MEnableA & eclk40MEnableC) | (eclk40MEnableB & eclk40MEnableC);

		// 40 MHz clock to the PLL init

	always @(negedge rst_b or posedge clk_160MHz) begin
		if (rst_b == 1'b0)
			clk_80MHz = 1'b0;
		else
			clk_80MHz = ~clk_80MHz;
	end

	always @(negedge rst_b or posedge clk_80MHz) begin
		if (rst_b == 1'b0) begin
			clkA_40MHz = 1'b0;
			clkB_40MHz = 1'b0;
			clkC_40MHz = 1'b0;
		end else begin
			clkA_40MHz = ~clkA_40MHz;
			clkB_40MHz = ~clkB_40MHz;
			clkC_40MHz = ~clkC_40MHz;
		end
	end

	assign clk_40MHz = (clkA_40MHz & clkB_40MHz) | (clkA_40MHz & clkC_40MHz) | (clkB_40MHz & clkC_40MHz);

		// 2.56 GHz clock

	initial begin
		clk2G56A   	= 1'b1;
		clk2G56B   	= 1'b1;
		clk2G56C   	= 1'b1;
		clk2G56eclk = eclk2G56Enable;
		clk2G56ps 	= 1'b1;
		#ck_period;
		forever begin
			clk2G56A = ~clk2G56A;
			clk2G56C = ~clk2G56C;
			clk2G56eclk = ~clk2G56eclk & eclk2G56Enable;
			clk2G56ps 	= ~clk2G56ps;
			#ck_period;
		end
	end

		// 1.28 GHz clock

	initial begin
		clk1G28A   	= 1'b1;
		clk1G28B   	= 1'b1;
		clk1G28C   	= 1'b1;
		clk1G28eclk = eclk1G28Enable;
		clk1G28ps 	= 1'b1;

		#(1.1*ck_period);	// Arbitrary initial delay

		forever begin
			#(2*ck_period);
			clk1G28A = ~clk1G28A;
			clk1G28B = ~clk1G28B;
			clk1G28C = ~clk1G28C;
			clk1G28eclk = ~clk1G28eclk & eclk1G28Enable;
			clk1G28ps 	= ~clk1G28ps;
		end
	end

		// 40 MHz clock

	initial begin
		clk40MA   	= 1'b1;
		clk40MB   	= 1'b1;
		clk40MC   	= 1'b1;
		clk40Meclk 	= eclk40MEnable;
		clk40Mps 	= 1'b1;

		#(1.1*ck_period);	// Arbitrary initial delay

		forever begin
			#(128*ck_period);
			clk40MA 	= ~clk40MA;
			clk40MB 	= ~clk40MB;
			clk40MC 	= ~clk40MC;
			clk40Meclk 	= ~clk40Meclk & eclk40MEnable;
			clk40Mps 	= ~clk40Mps;
		end
	end

		// 40 MHz reference clock

	initial begin
		fromcdr_clkRefA 	= 1'b1;
		fromcdr_clkRefB 	= 1'b1;
		fromcdr_clkRefC 	= 1'b1;

		#(1.1*ck_period);	// Arbitrary initial delay

		forever begin
			#(128*ck_period);
			fromcdr_clkRefA 	= ~fromcdr_clkRefA;
			fromcdr_clkRefB 	= ~fromcdr_clkRefB;
			fromcdr_clkRefC 	= ~fromcdr_clkRefC;
		end
	end

		// PFD and instantaneous lock detector

	always @(PFD_up or PFD_down) begin
		PFD_rst = #40 (PFD_up & PFD_down);
	end

	always @(posedge PFD_rst or posedge clk_40MHz) begin
		if (PFD_rst == 1'b1)
			#20 PFD_up = 1'b0;
		else
			#20 PFD_up = 1'b1;
	end

	always @(posedge PFD_rst or posedge clk40MA) begin
		if (PFD_rst == 1'b1)
			#20 PFD_down = 1'b0;
		else
			#20 PFD_down = 1'b1;
	end

	always @(posedge clk40MA) begin
		fromcdr_instlockPLL = ~(PFD_up | PFD_down);
	end

endmodule


