//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  File    : S3ADS160M12BT65LP_1V0.v
//  Module  : S3ADS160M12BT65LP
//  Purpose : Verilog behavioral model
//  Version : 1V0
//  Date    : 19-Sept-2018
//  Project : Sul
//  Author  : Helder Santos, S3GROUP
//  Revision history :
//			 	- 0V1: 27-June-2018
//                  Preliminary version
//			 	- 1V0: 25-Sept-2018
//                 Added triple inputs for TRM on pins OM ; DF and CAL
//                 Updated number of Calibration and Latency DCLK clock cycles
//                 Updated CAL recognition behaviour
//				- 16-Apr-2020 - Gianni
//				   SDA_O_N set to 0 as default 
//				- 21-Apr-2020 - Gianni
//				   CAL_run_ndclk reduced to shorten the simulation
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale   1ns/1ps

module S3ADS160M12BT65LP ( CAL_BUSY, DCLK, D, SEU, OVF, AVDD, AVDDREF_STG1, AVDDREF_STG2, 
AVSS, VSS_SUB, CAL_A, CAL_B,CAL_C, CLK, DF_A, DF_B, DF_C, DVDD, DVSS, CLK_ST, OM_A, OM_B, OM_C,
VINP, VINN, SDA_I, SDA_O_N, SCLA, SCLB, SCLC, RSTA_N, RSTB_N, RSTC_N, I2C_ADDR );

//******************************************ADC I/Os DEFINITION AND DESCRIPTION**************************************************************************************************************
  input VINP;		// Positive analog input, signal is considered applied when set to logic value '1'
  input VINN;		// Negative analog input, signal is considered applied when set to logic value '1'

  input AVDDREF_STG1;	// ADC reference voltage for ADC pipeline STG1, signal is considered applied when set to logic value '1'
  input AVDDREF_STG2;	// ADC reference voltage for ADC pipeline STG2, signal is considered applied when set to logic value '1'

  input AVDD;		// ADC Analog supply voltage (1.2V), it is considered properly supplied when AVDD is set to logic value '1'
  input AVSS;		// ADC Analog ground (0V), it is considered properly supplied when AVSS is set to logic value '0'
  input VSS_SUB;		// ADC Substract Analog ground (0V), it is considered properly supplied when AVSS_SUB is set to logic value '0'
  input DVDD;		// Digital supply voltage (1.2V), it is considered properly supplied when DVDD is set to logic value '1'
  input DVSS;		// Digital ground (0V), it is considered properly supplied when DVSS is set to logic value '0'

  input CLK;			// Clock input 320MHz to 1.28GHz frequency

  input CLK_ST;		// Clock input 40MHz to 160MHz frequency; start of sampling synchronization clock

  input OM_A;		// Operation Mode control
  input OM_B;		// Operation Mode control 
  input OM_C;		// Operation Mode control 
  						//  0: Power-Down Mode --> clock OFF and all ADC sub-blocks OFF.
  						//  1: Active Mode --> Normal operation, all blocks active.	
  input DF_A; 		// Output data format control, Asynchronous
  input DF_B; 		// Output data format control, Asynchronous
  input DF_C; 		// Output data format control, Asynchronous
  					// 0: binary format
  					// 1: two's complement format
					// DF is a static configuration signal to be changed only in PD mode. 
					// DF changes during ACTIVE and IDLE modes are not supported, therefore this model undefines all the ADC outputs ('x') when that happens.
  input CAL_A;			// Calibration control:
  input CAL_B;			// Calibration control:
  input CAL_C;			// Calibration control:
  					// 0: Calibration OFF.
					// 1: Calibration ON.

  output DCLK;		// Data CLK. ADC output data is updated with the falling edge of DCLK. 
  					// Acquiring ADC output data with DCLK rising edge is recommended. 
  output  [11:0] D;	//ADC Digital outputs
  output  OVF;		//Over-Range flag - logic value goes '1' when the first code '00..0' or the fullscale code '11..1' are reached.

  output CAL_BUSY;	//Calibration operations Flag:
					// '0' --> No calibration operations being performed
					// '1' --> On-Going calibration operations

  output SEU;		// SEU (Single Event Upset) Indicator;
					// 	Modelled through an internal variable assignment.

  input  RSTA_N;				// I2C Interface: Asynchronous reset; active low; 	Not modelled.
  input  RSTB_N;				// I2C Interface: Asynchronous reset; active low; 	Not modelled.
  input  RSTC_N;				// I2C Interface: Asynchronous reset; active low; 	Not modelled.
  input  SCLA;				// I2C Interface: Serial Clock; 						Not modelled.
  input  SCLB;				// I2C Interface: Serial Clock; 						Not modelled.
  input  SCLC;				// I2C Interface: Serial Clock; 						Not modelled.
  input  [6:0] I2C_ADDR; 	// I2C Interface: Memory adress code; 				Not modelled.
  input  SDA_I;				// I2C Interface: Serial Data input; 				Not modelled.
  output SDA_O_N;			// I2C Interface: Serial Data output;	 			Not modelled.


//*******************************************MODEL PARAMETERS*********************************************************************************************************************************			
  //parameter integer CAL_run_ndclk = 26762;   	// Number of DCLK cycles for calibration:
  parameter integer CAL_run_ndclk = 1000;		// Reduced to shorten the simulation - Gianni 21.4.2020

  parameter real tSD = 0.5;	// Input Sample Delay (ns)
  // parameter real tSD = 500;		// Input Sample Delay (ps) 					- Gianni 18.05.2020
  parameter real tCDO = 0.9;	// CLK-to-DCLK Propagation Delay (ns)
  // parameter real tCDO = 900;	// CLK-to-DCLK Propagation Delay (ps) 		- Gianni 18.05.2020
  parameter real tPD = 0.35;		// Output Propagation Delay (ns)
  // parameter real tPD = 350;		// Output Propagation Delay (ps) 			- Gianni 18.05.2020
  parameter integer L = 12;   	// Output Data Latency (DCLK cycles)
  parameter real VSR = 1.2;		// Differential input signal range (1.2Vpp diff.)                    

//**************Initial begin: Reseting Latency Pipeline state to undefined*******************************
  integer clk_count;				// clock division counter
  integer counter_latency;		// counter for maintaining the CAL_BUSY active during pipeline data latency
  integer counter_pup;			// counter for power-up time (DCLK cycles)
  integer i;						// general loop counter
  integer seu_event;				// SEU event internal variable (can be set externally to model an event upset)
  integer counter_CAL;
  reg 	  cal_busy_reg;			// CAL_BUSY state internal register synchronized with falling edge of DCLK
  reg seu_event_reg;
  reg seu_event_sinc;
  reg [11:0] ADC_pipe[0:L-2];		// queue modeling pipeline delay
  reg clk_int;					// Internal clock = CLK / 8
  reg rst_count;
  reg pup_recovered;				// ADC has been fully powered-up
  reg cal_rst_reg;				// CAL = 1 ADC reset register

  real input_signal = 0;			// differential input voltage

  integer ADC_integer = 0;			// quantized ADC input
  reg [11:0] ADC_limited = 12'b0;	// ADC quantized data (limited to 12 bit range)

  initial begin
    //Initializing ADC latency Pipeline
    for (i = 0; i < (L-2); i = i + 1) begin 
		ADC_pipe[i] = 0; 
	end
	cal_rst_reg <= 0;
	clk_count = 0;
	clk_int = 0;
	rst_count = 0;
	seu_event = 0;
	seu_event_reg = 0;
	seu_event_sinc = 0;
    counter_latency = 0;
	cal_busy_reg = 0;
	counter_CAL = 0;
	counter_pup = 0;
	pup_recovered = 0;
  end

//**************CLK division by 8*******************************

  always @(posedge CLK_ST) begin
	rst_count = 1;
	clk_int <= 1;
	clk_count = 	0;
  end

  always @(negedge CLK) begin
	if (rst_count == 1) begin
		rst_count = 0;
	end
  end

  always @(posedge CLK) begin
	if (rst_count == 0) begin
		if(clk_count < 3)
			clk_count = 	clk_count + 1;
		else
		clk_int <= 0;
	end			
  end

//**********************************************OMs LOGICAL CONDITIONS***************************************************
  wire powered;			// whether all power supplies are properly supplied (set to logic value '1') and grounds grounded (set to logic value '0')
  wire pd_mode; 			// ADC not powered or powered but PD mode selected
  wire active_mode;		// ADC powered and active mode selected
  wire signal_applied;	// signal properly applied in channel I
  wire OM_tmr;			// Operating mode enable signal majority value
  wire DF_tmr;			// Data-Format enable signal majority value
  wire CAL_tmr;			// Calibration Mode enable signal majority value
  
  assign powered = AVDD & ~AVSS & ~VSS_SUB & DVDD & ~DVSS; 
  assign OM_tmr = (OM_A & OM_B) || (OM_A & OM_C) || (OM_B & OM_C);
  assign DF_tmr = (DF_A & DF_B) || (DF_A & DF_C) || (DF_B & DF_C);
  assign CAL_tmr = (CAL_A & CAL_B) || (CAL_A & CAL_C) || (CAL_B & CAL_C);
  assign pd_mode = OM_tmr==1'b0;
  assign active_mode = powered & (OM_tmr == 1'b1) & pup_recovered;
  assign signal_applied = (VINP & VINN);

//***********************HANDLING RECOVERY FROM POWER-DOWN **********************************************************
  reg CAL_running = 0;			//ADC Performing calibration operations 
  reg ADC_calibrated = 0;		//whether ADC is operational for providing accurate A to D convertions
  wire ADC_starting_up; 			//whether the ADC is starting up
  wire ADC_ready_to_stream_out; 	//whether the ADC is ready to start streaming out data
  reg invalid_DF_change = 0; 	//whether DF is changed with the ADC in ACTIVE

  always @(posedge OM_tmr or posedge powered) 
	if(OM_tmr) pup_recovered <= 1;
  always @(negedge OM_tmr or negedge powered) begin
	pup_recovered = 0;
  end

//*****************Handling invalid_DF_change************************
  always @(posedge DF_tmr or negedge DF_tmr) if(!pd_mode) invalid_DF_change <= 1; 
  always @(posedge pd_mode) invalid_DF_change <= 0;

//*****************************Handling ADC_ready_to_stream_out************************
   assign ADC_ready_to_stream_out = active_mode & ADC_calibrated & AVDDREF_STG1 & AVDDREF_STG2;

//*****Generating the Sampling Phase Signal (delayed version of CLK) - informs when the ADC is sampling the analog inputs********
  wire sampling_phase;

  assign #tSD sampling_phase = clk_int & ADC_ready_to_stream_out ;


//********************Handling Calibration Wait*********************************************
  //Entering calibration (runs when recovering from Power-Down)
  always @(posedge active_mode) begin
		CAL_running <= 1;
  end


  //Counting number of cycles for calibration steps
  always @(negedge clk_int) begin
	if(CAL_running && active_mode) begin
		ADC_calibrated <= 0;
		counter_CAL = counter_CAL + 1;
		cal_busy_reg = 1;
		if (counter_CAL == CAL_run_ndclk + 1) begin
			counter_CAL = 0;
			CAL_running <= 0;
			ADC_calibrated <= 1;
		end
	end else if (cal_busy_reg == 1 && active_mode) begin
		counter_latency = counter_latency +1 ; 
		if (counter_latency >= L) begin
			cal_busy_reg = 0;
			counter_latency = 0;
		end
	end
  end


  always @(negedge CAL_tmr) begin
	if (active_mode) begin
		cal_rst_reg <= 0;
		CAL_running <= 1;
	end
  end

  always @(negedge clk_int) begin
    if (active_mode & CAL_tmr == 1) begin		// hardware reset before calibration
		cal_rst_reg <= 1;
		CAL_running <= 0;
		cal_busy_reg = 0;
		ADC_calibrated <= 0;
		counter_CAL = 0;
    	for (i = 0; i < (L-2); i = i + 1) begin 
			ADC_pipe[i] = 0; 
		end
	end
  end

  //Reset counter_CAL whenever entering on calibration
  always @(posedge CAL_running) counter_CAL = 0;

  //CAL_running goes low whenever the ADC leaves active_mode
  always @(negedge active_mode) begin
	CAL_running <= 0;
	cal_busy_reg = 0;
	ADC_calibrated <= 0;
	counter_CAL = 0;
  end

// Input signal generation - Gianni 21.4.2020

 always @(negedge clk_int) begin
	input_signal = ($random%2048)*VSR/4096;	
 end

//**************************************Input Signals conversion*********************************************************
  
  always @(negedge sampling_phase) begin
    //input signal quantization
    ADC_integer =  ((input_signal + VSR/2) / VSR) * 4095;
	//input signal conversion
    ADC_limited = active_mode ? signal_applied ? (ADC_integer<0) ? 0 : (ADC_integer>4095) ? 4095 : ADC_integer : 12'bx : 12'bx;
  end

//*****************ADC Latency Pipeline**************************************
  always @(negedge clk_int) begin
    // pipeline latency of L clock cycles
 	if (ADC_ready_to_stream_out) begin   
		ADC_pipe[0] <= ADC_limited;
		for (i = 1; i < (L-1); i = i + 1) begin
			ADC_pipe[i] <= ADC_pipe[i - 1]; 	// shift the queue
		end
	end else begin
		for (i = 0; i < (L-1); i = i + 1) begin
			ADC_pipe[i] <= 12'b0; 			// ADC in power-down or not calibrated
		end
		ADC_integer = 0;
		ADC_limited = 0;
	end
  end  

//*****************SEU synch with DCLK and 4 DCLK minimum duration***********
  always @(negedge clk_int or posedge seu_event) begin
	if (seu_event == 1 & !seu_event_reg)				// seu_event variable set through testbech assignment to model an SEU event
		seu_event_reg <= 1;
    else if (seu_event_reg & seu_event == 1)
		seu_event_sinc <= 1;
    else if (seu_event_reg & seu_event == 0 & active_mode) begin
		seu_event_sinc <= 0;
		seu_event_reg <= 0;
	end			
  end

//******************Output assignments****************************************************************
  assign #tCDO DCLK = powered ? active_mode ? clk_int : 1'b0 : 1'bz;
  assign #(tCDO+tPD) D = powered ? !invalid_DF_change ? !cal_busy_reg ? ADC_ready_to_stream_out ? DF_tmr ? ADC_pipe[L-2] ^ 2048 : ADC_pipe[L-2] : 12'b0 : 12'b0 : 12'bx : 12'bz;
  assign #(tCDO+tPD) OVF = powered ? !invalid_DF_change ? !cal_busy_reg ? !cal_rst_reg ? active_mode ? (ADC_pipe[L-2] == 0 || ADC_pipe[L-2] == 4095) : 1'b0  : 1'b0 : 1'b0 : 12'bx : 1'bz;
  assign #(tCDO+tPD) CAL_BUSY = powered ?  !invalid_DF_change ? cal_busy_reg : 12'bx : 1'bz;
  assign #(tCDO+tPD) SEU = powered ? seu_event_sinc : 1'bz;
	// Set to 0 - Gianni 16.04.2020
  assign #(tCDO+tPD) SDA_O_N = powered ? 1'b0 : 1'bz;

endmodule
