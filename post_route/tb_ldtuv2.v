// Cometti Simona e Dellacasa Giulio INFN Torino
// Testbench for CMS Ecal LiTE_DTUv1b assembled top
// March 2020

`timescale  1ns/1ps

module tb_ldtu;
   parameter period = 6240;  // in ps
   parameter period_128 = 780;
   parameter delay = 200; 	// in ps
   parameter seed = 10;
   parameter endofcalbusy = 1000000000; 	// in ps
   // power supply and voltage references:
   wire VDDA;
   wire VDDAL;
   wire VSSA;
   wire VDDD;
   wire VSSD;
   wire VDDPllRF;
   wire VSSPllRF;
   wire VDDPllD;
   wire VSSPllD;
   wire VDDE;
   wire VSSE;
   wire VDDref2H;
   wire VDDref1H;
   // analogue signals:
   reg  VINHp;
   reg  VINHm;
   reg  VINLp;
   reg  VINLm;
   wire VDDref1L;
   wire VDDref2L;
   // digital signals:
   reg  ATM;
   wire DOUT3m;
   wire DOUT3p;
   wire DOUT2m;
   wire DOUT2p;
   wire DOUT1m;
   wire DOUT1p;
   wire DOUT0m;
   wire DOUT0p;
   wire RESYNCm;
   wire RESYNCp;
   reg  CLKINm;
   reg  CLKINp;
   reg  AdcClkInm;
   reg  AdcClkInp;
   wire CalBusy;
   reg  ADDR6;
   reg  ADDR5;
   reg  ADDR4;
   reg  ADDR3;
   reg  ADDR2;
   wire SEUA;
   wire SEUD;
   wire SCL;
   wire SDA;
   //tri1 SDA;
   wire PllClkp;
   wire PllClkm;
   wire PllDecap;
   reg  PonRstb;
   wire PllRefClk;
   wire PllLock;
   // testbench signals
   reg 	clock;
   reg 	rst_b;
   reg [7:0] input_sr;
   reg [3:0] isr_in;
   wire [7:0] isr_in_enc;
   reg 	      isr_load;
   reg 	      sda_int; //SDA and SCL testbench values
   reg 	      scl_int;
   reg 	      sda_en;
   reg 	      scl_en;
   reg [7:0]  shift_register;
   parameter  StartFrom  = 8'b00000000;	// I2C Start from register 0
   reg [7:0]  sr_pin;
   reg 	      sr_pload;
   reg 	      sr_shift;
   reg 	      I2C_clock;
   parameter ck_period_I2C = 10000;
   integer    i, j;
   reg 	      r_VDDref1H; 
   reg 	      r_VDDref1L;
   reg 	      r_VDDref2H;
   reg 	      r_VDDref2L;
   reg 	      r_VDDA;
   reg 	      r_VDDAL;
   reg 	      r_VSSA;
   reg 	      r_VDDD;
   reg 	      r_VSSD;
   reg 	      r_VDDPllRF;
   reg 	      r_VSSPllRF;
   reg 	      r_VDDPllD;
   reg 	      r_VSSPllD;
   reg 	      r_VDDE;
   reg 	      r_VSSE;
   // For the output serializers debug
   parameter pattern_idleDTU_0 = 8'b11101010;
   parameter pattern_idleATM = 8'b01011010;
   reg 	      data_aligned=1'b0;
   reg [7:0]  pattern;
   integer    index_ser0=31;
   reg [7:0]  check_pattern_0 = 8'b0;
   reg [31:0] word_ser_0 = 32'b0;
   reg [7:0]  check_pattern_1 = 8'b0;
   reg [31:0] word_ser_1 = 32'b0;
   reg [7:0]  check_pattern_2 = 8'b0;
   reg [31:0] word_ser_2 = 32'b0;
   reg [7:0]  check_pattern_3 = 8'b0;
   reg [31:0] word_ser_3 = 32'b0;
   reg [31:0] w_ser0 = 32'b0;
   reg [31:0] w_ser1 = 32'b0;
   reg [31:0] w_ser2 = 32'b0;
   reg [31:0] w_ser3 = 32'b0;
   reg [1:0]  GAIN_SEL_MODE;
   wire       CatiaTP;
   
   integer    data_file_read01, data_file_read10;
   integer    write_file_g01, write_file_g10, write_file_SER, write_file_output, write_file_outputH, write_file_outputL;
   integer    startrnd;
   reg 	      test;
   //reg eof1, eof2, close_r01, close_r10, close_g01, close_g10, close_SER;
   
   LiTE_DTU_v2 top  (
		     .VDDA(VDDA), 
		     .VSSA(VSSA), 
		     .VDDD(VDDD), 
		     .VSSD(VSSD), 
		     .VDDPllRF(VDDPllRF),
		     .VSSPllRF(VSSPllRF), 
		     .VDDPllD(VDDPllD), 
		     .VSSPllD(VSSPllD),
		     .VDDE(VDDE), 
		     .VSSE(VSSE), 
		     .VDDref2H(VDDref2H),
		     .VDDref1H(VDDref1H),
		     .VINHp(VINHp), 
		     .VINHm(VINHm), 
		     .VINLp(VINLp), 
		     .VINLm(VINLm), 
		     .VDDref1L(VDDref1L), 
		     .VDDref2L(VDDref2L),
		     .CatiaTP(CatiaTP),
		     .DOUT3m(DOUT3m), 
		     .DOUT3p(DOUT3p), 
		     .DOUT2m(DOUT2m), 
		     .DOUT2p(DOUT2p), 
		     .DOUT1m(DOUT1m), 
		     .DOUT1p(DOUT1p), 
		     .DOUT0m(DOUT0m), 
		     .DOUT0p(DOUT0p), 
		     .RESYNCm(RESYNCm), 
		     .RESYNCp(RESYNCp), 
		     .CLKINm(CLKINm), 
		     .CLKINp(CLKINp), 
		     .AdcClkInm(AdcClkInm), 
		     .AdcClkInp(AdcClkInp),
		     .CalBusy(CalBusy),
		     .ADDR6(ADDR6), 
		     .ADDR5(ADDR5), 
		     .ADDR4(ADDR4), 
		     .ADDR3(ADDR3), 
		     .ADDR2(ADDR2),
		     .SEU(SEUA),
		     .ATM(ATM),
		     .SCL(SCL), 
		     .SDA(SDA), 
		     .PllClkp(PllClkp), 
		     .PllClkm(PllClkm), 
		     .PllDecap(PllDecap),
		     .PonRstb(PonRstb), 
		     .PllRefClk(PllRefClk),
		     .PllLock(PllLock));


   // For the output serializers debug
   initial begin
      $display("POST ROUTING TESTBENCH");
      
      test = 1'b1;
      $display("testmode? %d",test);
      
      GAIN_SEL_MODE = 2'b00;

      if (test == 1'b1) begin
	 write_file_SER = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_ATM.dat","w");
	 write_file_g01= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_ATM_ing01.dat","w");
	 write_file_g10= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_ATM_ing10.dat","w");
	 write_file_outputH = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_ATM_outH.dat","w");
	 write_file_outputL = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_ATM_outL.dat","w");
      end
      if (test == 1'b0) begin
	 if (GAIN_SEL_MODE == 2'b00) begin
	    write_file_SER = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_00_SER.dat","w");
	    write_file_g01= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_00_ing01.dat","w");
	    write_file_g10= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_00_ing10.dat","w");
	    write_file_output= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_00_output.dat","w");
	 end
	 if (GAIN_SEL_MODE == 2'b01) begin
	    write_file_SER = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_01_SER.dat","w");
	    write_file_g01= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_01_ing01.dat","w");
	    write_file_g10= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_01_ing10.dat","w");
	    write_file_output= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_01-output.dat","w");
	 end
	 if (GAIN_SEL_MODE == 2'b10) begin
	    write_file_SER = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_10_SER.dat","w");
	    write_file_g01= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_10_ing01.dat","w");
	    write_file_g10= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_10_ing10.dat","w");
	    write_file_output= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_10_output.dat","w");
	 end
	 if (GAIN_SEL_MODE == 2'b11) begin
	    write_file_SER = $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_11_SER.dat","w");
	    write_file_g01= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_11_ing01.dat","w");
	    write_file_g10= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_11_ing10.dat","w");
	    write_file_output= $fopen("/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/post_route/sim_results/2021_06_17_fullASIC_DTU_GSM_11_output.dat","w");
	 end
      end
   end


   // 160 MHz Clock generation process
   initial begin
      CLKINm = 1'b0;
      CLKINp = 1'b1;
      clock = 1'b0;
      forever begin
	 #(period/2);
	 CLKINm = ~CLKINm;
	 CLKINp = ~CLKINp;
	 clock = ~clock;
      end
   end

   // 1.28 GHz Clock generation process
   initial begin
      AdcClkInm = 1'b0;
      AdcClkInp = 1'b1;
      forever begin
	 #(period_128/2);
	 AdcClkInm = ~AdcClkInm;
	 AdcClkInp = ~AdcClkInp;
      end
   end

   // I2C_clock generation
   initial begin
      I2C_clock = 1'b1;
      forever begin
	 #(ck_period_I2C/2);
	 I2C_clock = ~I2C_clock;
      end
   end

   // Resync shift register
   always @(posedge clock) begin
      if (rst_b == 0)
	input_sr = 1'b0;
      else if (isr_load == 1)
	input_sr = isr_in_enc;
      else
	input_sr = {input_sr[6:0],1'b0};
   end

   assign RESYNCp = input_sr[7]; 
   assign RESYNCm = ~RESYNCp;

   // Resync Hamming encoding
   assign isr_in_enc[0] 	= isr_in[0] ^ isr_in[1] ^ isr_in[3];
   assign isr_in_enc[1] 	= isr_in[0] ^ isr_in[2] ^ isr_in[3];
   assign isr_in_enc[2] 	= isr_in[0];
   assign isr_in_enc[3] 	= isr_in[1] ^ isr_in[2] ^ isr_in[3] ;
   assign isr_in_enc[6:4] 	= isr_in[3:1];
   assign isr_in_enc[7] 	= 1'b0;

   // I2C SDA and SCL signals assignment
   assign (supply1, pull0) SDA = sda_en ? sda_int : 1'bz;
   assign (supply1, pull0) SCL = scl_en ? scl_int : 1'bz;

   // Voltages
   assign VDDref1H = r_VDDref1H; 
   assign VDDref1L = r_VDDref1L;
   assign VDDref2H = r_VDDref2H;
   assign VDDref2L = r_VDDref2L;
   assign VDDA    = r_VDDA;
   assign VSSA     = r_VSSA;
   assign VDDD     = r_VDDD;
   assign VSSD     = r_VSSD; 
   assign VDDPllRF = r_VDDPllRF;
   assign VSSPllRF = r_VSSPllRF;
   assign VDDPllD  = r_VDDPllD;
   assign VSSPllD  = r_VSSPllD;
   assign VDDE     = r_VDDE;
   assign VSSE     = r_VSSE;




   // Init process  
   initial begin
      
      //$sdf_annotate("LiTE_DTU_v1b.sdf",tb_ldtu.I_LiTE_DTU_v1b,,,"TYPICAL","1.0:1.0:1.0","FROM_MTM");
      ///////////////////////////////////////////////
      // I2C initialization
      //////////////////////////////////////////////
      $display("I2C init");
      scl_int = 1'b1;
      sda_int = 1'b1;
      scl_en = 1'b1;
      sda_en = 1'b1;
      sr_pload = 1'b0;
      sr_shift = 1'b0;
      //ATM = 1'b0 DTU active, ATM = 1'b1 ATU active
      ATM = test;//1'b0;
      //ATM = 1'b1;
      isr_load = 1'b0;
      ADDR6 = 1'b1;
      ADDR5 = 1'b1;
      ADDR4 = 1'b1;
      ADDR3 = 1'b1;
      ADDR2 = 1'b1;
      //////////////////////////////////////////////  
      // ADC test initialization - RESET value
      /////////////////////////////////////////////
      $display("ADC Reset Value");
      // VINP
      VINHp = 1'b0;
      VINLp = 1'b0;
      // VINN
      VINHm = 1'b0;
      VINLm = 1'b0;
      // AVDDREF_STG1
      r_VDDref1H = 1'b0;  
      r_VDDref1L = 1'b0;
      // AVDDREF_STG2
      r_VDDref2H = 1'b0;
      r_VDDref2L = 1'b0;
      // AVDD
      r_VDDA = 1'b0;
      // AVSS VSS_SUB
      r_VSSA = 1'b0;
      // DVDD 
      r_VDDD = 1'b0;
      // DVSS 
      r_VSSD = 1'b0;  

      ////////////////////////////////
      // PLL reset Values
      ////////////////////////////////
      $display("PLL Reset values");
      r_VDDPllRF = 1'b0;
      r_VSSPllRF = 1'b0;
      r_VDDPllD = 1'b0;
      r_VSSPllD = 1'b0;
      r_VDDE = 1'b0;
      r_VSSE = 1'b0;


      #(2*period);
      
      // #(10.3*period_128);
      /////////////////////////////////////////////  
      // ADC test - Activation Values
      /////////////////////////////////////////////
      $display("ADC ON");
      // VINP
      VINHp = 1'b1;
      VINLp = 1'b1;
      // VINN
      VINHm = 1'b1;
      VINLm = 1'b1;
      // AVDDREF_STG1
      r_VDDref1H = 1'b1;  
      r_VDDref1L = 1'b1;
      // AVDDREF_STG2
      r_VDDref2H = 1'b1;
      r_VDDref2L = 1'b1;
      // AVDD
      r_VDDA = 1'b1;
      // AVSS VSS_SUB
      r_VSSA = 1'b0;
      // DVDD 
      r_VDDD = 1'b1;
      // DVSS 
      r_VSSD = 1'b0; 
      //CAL_A = 1'b1;
      //CAL_B = 1'b1;
      //CAL_C = 1'b1;

      ////////////////////////////////////
      // PLL Activation Values
      ///////////////////////////////////
      $display("PLL ON");
      r_VDDPllRF = 1'b1;
      r_VSSPllRF = 1'b0;
      r_VDDPllD = 1'b1;
      r_VSSPllD = 1'b0;
      r_VDDE = 1'b1;
      r_VSSE = 1'b0;
      #(8*period);

      $display("SOFT RESET");
      PonRstb = 1'b0;
      rst_b = 1'b0;
      //startrnd=$urandom(seed);
      #(4*period);
      #(delay);
      PonRstb = 1'b1;
      rst_b = 1'b1;
      #(2*period);
      //////////////////////////////////////////

      //FAST COMMANDS
      // -------------------------------------------------
      // |Code| --Encoded value--  | -- Function --      |
      // | 0x0|0x00|0 0 0 0 0 0 0 0| Stop                | <-
      // | 0x1|0x07|0 0 0 0 0 1 1 1| Start               | <-
      // | 0x2|0x19|0 0 0 1 1 0 0 1| DTU reset           | <-
      // | 0x3|0x1E|0 0 0 1 1 1 1 0| I2C interface reset |
      // | 0x4|0x2A|0 0 1 0 1 0 1 0| ADC Test Unit reset |
      // | 0x5|0x2D|0 0 1 0 1 1 0 1| DTU sync mode       | <-
      // | 0x6|0x33|0 0 1 1 0 0 1 1| DTU normal mode     | <-
      // | 0x7|0x34|0 0 1 1 0 1 0 0| DTU flush           | <-
      // | 0x8|0x4B|0 1 0 0 1 0 1 1| ADC H reset         |
      // | 0x9|0x4C|0 1 0 0 1 1 0 0| ADC H calibration   |
      // | 0xA|0x52|0 1 0 1 0 0 1 0| ADC L reset         |
      // | 0xB|0x55|0 1 0 1 0 1 0 1| ADC L calibration   |
      // | 0xC|0x61|0 1 1 0 0 0 0 1| PLL lock sequence   |
      // | 0xD|0x66|0 1 1 0 0 1 1 0| CATIA test pulse    |
      // | 0xE|0x78|0 1 1 1 1 0 0 0| BC0 marker          | <-
      // | 0xF|0x7F|0 1 1 1 1 1 1 1| RESERVED            |
      // -------------------------------------------------
      
      
      

      $display("I2C operations:");
      
      // I2C 0
      isr_in = 4'h0;//8'h00;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      // I2C Start
      $display("I2C start");
      isr_in = 4'h1;//8'h01;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      // I2C reset
      isr_in = 4'h3;//8'h03;
      $display("I2C reset");
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      //DTU Reset
      $display("DTU reset");
      isr_in = 4'h2;//8'h02;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      // ADC Test Unit Reset
      $display("TU reset");
      isr_in = 4'h4;//8'h04;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      // ADC L Reset
      $display("ADCL reset");
      isr_in = 4'hA;//8'h0A;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      // ADC H Reset
      $display("ADCH reset");
      isr_in = 4'h8;//8'h08;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      //  ADC L Calibration
      $display("ADCL calibration");
      isr_in = 4'hB;//8'h0B;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      //  ADC H Calibration
      $display("ADCH calibration");
      isr_in = 4'h9;//8'h09;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      
      //Normal Mode
      $display("Normal Mode set");
      isr_in = 4'h6;//8'h09;
      isr_load = 1'b1;
      #period;
      isr_load = 1'b0;
      #(7*period);
      
      //Flush Mode
      //$display("Flush Mode set");
      //isr_in = 4'h7;//8'h09;
      //isr_load = 1'b1;
      //#period;
      //isr_load = 1'b0;
      //#(7*period);
      //
      //
      ////Normal Mode
      //$display("Normal Mode set");
      //isr_in = 4'h6;//8'h09;
      //isr_load = 1'b1;
      //#period;
      //isr_load = 1'b0;
      //#(7*period);
      
      // Other I2C configurations

      // WRITE I2C
      #(4*period);
      sda_int  = 1'b0; // Start condition
      #(2*ck_period_I2C);
      scl_int = 1'b0;
      
      $display("SET ALL REGSTERS");
      for (i=0; i<(19); i=i+1) begin
	 $display("set reg %d\n",i);
	 
	 case (i)
	   0 : sr_pin = 8'b11111100;	// Address 0eh, write
	   1 : sr_pin = 8'b00000000;	// Start from Reg_0
	   2 : sr_pin = 8'b00011111;	// Reg_0: ND,ND,RxEnAdcClk,TxEnPLL,TxEnDrv3,TxEnDrv2,TxEnDrv1,TxEnDrv0
	   3 : sr_pin = {GAIN_SEL_MODE[0],GAIN_SEL_MODE[1],6'b000011};
	   // Reg_1: ADC_SEL,SYSCAL,ExtCalEn,ClkInv,ExtClk,DF,OM_H,OM_L
	   4 : sr_pin = 8'b00000111;	// Register 2
	   5 : sr_pin = 8'b00100000;	// Register 3
	   6 : sr_pin = 8'b00000000;	// Register 4
	   7 : sr_pin = 8'b00000000;	// Reg_5: BaselineH
	   8 : sr_pin = 8'b00000000;	// Reg_6: BaselineL
	   9 : sr_pin = 8'b10001000;	// Register 7
	   10 : sr_pin = 8'b01000000;	// Register 8
	   11 : sr_pin = 8'b00111100;	// Register 9
	   12 : sr_pin = 8'b01010101;	// Register 10
	   13 : sr_pin = 8'b00000000;	// Register 11
	   14 : sr_pin = 8'b00000000;	// Register 12
	   15 : sr_pin = 8'b00000000;	// Register 13
	   16 : sr_pin = 8'b00000100;	// Register 14
	   17 : sr_pin = 8'b01100110;	// Register 15
	   18 : sr_pin = 8'b00111100;	// Register 16
	   19 : sr_pin = 8'b11111111;	// Reg_17: SATURATION_VALUE
	   20 : sr_pin = 8'b11111111;	// Reg_18: SATURATION_VALUE
	   21 : sr_pin = 8'b00000000;	// Register 19 -- not written (it is read only)
	 endcase // case(i)
	 sr_pload = 1'b1;
	 #ck_period_I2C;
	 sr_pload = 1'b0;
	 sda_en = 1'b1;
	 
	 for (j=0; j<8; j=j+1) begin
	    sda_int = shift_register[7];
	    #ck_period_I2C;
	    scl_int = 1'b1;
	    #(2*ck_period_I2C);
	    scl_int = 1'b0;
	    sr_shift = 1'b1;
	    #ck_period_I2C;
	    sr_shift = 1'b0;
	 end
	 sda_int= 1'b0;// Acknowledge
	 sda_en = 1'b0;
	 #ck_period_I2C;
	 scl_int = 1'b1;
	 #(2*ck_period_I2C);
	 scl_int = 1'b0;
      end

      #ck_period_I2C;
      sda_en = 1'b1;
      #ck_period_I2C;   // Stop condition
      scl_int = 1'b1;
      #(2*ck_period_I2C);
      sda_int = 1'b1;
      #(10*ck_period_I2C);
      $display("END INITIALIZATION");
      ////////////////////////////

      ///////////////////////////
      if (ATM == 1'b1) begin
	 $fclose(write_file_SER);
	 $fclose(write_file_outputH);
	 $fclose(write_file_outputL);
      end else begin
	 $fclose(write_file_SER);
	 $fclose(write_file_output);
      end
      $fclose(write_file_g01);
      $fclose(write_file_g10); 
      //      $finish;
   end

   // Shift register process
   always @(rst_b or posedge I2C_clock) begin
      if (rst_b == 0)
	shift_register = 'd0;
      else if ( sr_pload == 1 )
	shift_register = sr_pin;
      else if ( sr_shift == 1 ) begin
	 shift_register = shift_register << 1;
	 shift_register[0] = 1'b1;
      end
   end
   
   reg [31:0] counter=32'h00000000;
   
   always @(posedge CLKINm) begin //AdcClkInp) begin
      if (rst_b == 1'b1) begin
	 counter = counter + 1'b1;
	 
      end 
   end
   
   reg resetdone =1'b0;
   
   always @(posedge CLKINp) begin //AdcClkInp) begin
      if (counter ==32'h555) begin
	 if(resetdone==1'b0) begin
	    $display("end counter");
	    
	    // I2C 0         
	    isr_in = 4'h0;//8'h00;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    // I2C Start
	    isr_in = 4'h1;//8'h01;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    // ADC Test Unit Reset
	    isr_in = 4'h4;//8'h04;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
////////////////////////////////////////////////////
	    // I2C 0         
	    isr_in = 4'h0;//8'h00;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    // I2C Start
	    isr_in = 4'h1;//8'h01;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    // ADC Test Unit Reset
	    isr_in = 4'h4;//8'h04;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    
	    ////////////////////////////////////
	    // I2C 0         
	    isr_in = 4'h0;//8'h00;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    // I2C Start
	    isr_in = 4'h1;//8'h01;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    // ADC Test Unit Reset
	    isr_in = 4'h4;//8'h04;
	    isr_load = 1'b1;
	    #period;
	    isr_load = 1'b0;
	    #(7*period);
	    resetdone=1'b1;
	 end
      end 
   end
   
   //   always @ (posedge CalBusy) begin
   //      // I2C 0         
   //      isr_in = 4'h0;//8'h00;
   //      isr_load = 1'b1;
   //      #period;
   //      isr_load = 1'b0;
   //      #(7*period);
   //      // I2C Start
   //      isr_in = 4'h1;//8'h01;
   //      isr_load = 1'b1;
   //      #period;
   //      isr_load = 1'b0;
   //      #(7*period);
   //      // ADC Test Unit Reset
   //      isr_in = 4'h4;//8'h04;
   //      isr_load = 1'b1;
   //      #period;
   //      isr_load = 1'b0;
   //      #(7*period);
   //   end

   ////////////////////////////////////////////////////////
   ///Output Recording:
   // For the output serializers debug
   always @ (posedge PllClkp) begin
      //if (ATM == 1'b0) begin
      if (rst_b == 1'b0) begin					// IF reset
         index_ser0 = 31;
	 data_aligned = 1'b0;
	 check_pattern_0 = 8'b0;
	 check_pattern_1 = 8'b0;
	 check_pattern_2 = 8'b0;
	 check_pattern_3 = 8'b0;
      end else begin						// END IF reset -> not reset
	 if (ATM == 1'b1) pattern = pattern_idleATM;		// IF ATM
	 else pattern = pattern_idleDTU_0;			// END IF ATM
	 if (data_aligned == 1'b0) begin				// IF data not aligned
	    check_pattern_0 = {check_pattern_0[6:0],DOUT0p};
	    check_pattern_1 = {check_pattern_1[6:0],DOUT1p};
	    check_pattern_2 = {check_pattern_2[6:0],DOUT2p};
	    check_pattern_3 = {check_pattern_3[6:0],DOUT3p};
	    if (check_pattern_0 == pattern) begin	// IF pattern = data
	       data_aligned = 1'b1;
	       word_ser_0[31]=check_pattern_0[7];
	       word_ser_0[30]=check_pattern_0[6];
	       word_ser_0[29]=check_pattern_0[5];
	       word_ser_0[28]=check_pattern_0[4];
	       word_ser_0[30]=check_pattern_0[3];
	       word_ser_0[29]=check_pattern_0[2];
	       word_ser_0[28]=check_pattern_0[1];
	       word_ser_0[27]=check_pattern_0[0];
	       word_ser_1[31:27]={check_pattern_1};
	       word_ser_2[31:27]={check_pattern_2};
	       word_ser_3[31:27]={check_pattern_3};
	       index_ser0 = index_ser0 - 8;
	    end							// END IF pattern = data
	 end else begin						// END IF data not aligned -> now aligned
	    if (index_ser0 == 0) begin				// IF index = 0
	       word_ser_0[index_ser0]=DOUT0p;
	       word_ser_1[index_ser0]=DOUT1p;
	       word_ser_2[index_ser0]=DOUT2p;
	       word_ser_3[index_ser0]=DOUT3p;	
	       w_ser0 = word_ser_0;
	       w_ser1 = word_ser_1;
	       w_ser2 = word_ser_2;
	       w_ser3 = word_ser_3;
	       index_ser0 = 31;
	    end else begin					// END IF index = 0 -> index != 0
	       word_ser_0[index_ser0]=DOUT0p;
	       word_ser_1[index_ser0]=DOUT1p;
	       word_ser_2[index_ser0]=DOUT2p;
	       word_ser_3[index_ser0]=DOUT3p;
	       index_ser0 = index_ser0 - 1;
	    end							// END IF index != 0
	 end							// END IF data now aligned
      end								// END IF not reset
      //end								// END ATM
   end								// END always @ (posedge PllClkp)
   reg [2:0] word_0_state;
   integer   frame_counter = 0;
   integer   SER_error = 0;
   always @(negedge PllClkp) begin
      if (index_ser0 == 31) begin
	 if (data_aligned == 1'b1) begin
	    if (CalBusy == 1'b0) begin
	       if (ATM == 1'b0) begin
		  if (word_ser_0[31:30]== 2'b01) begin			//BASELINE
		     word_0_state=3'b001;
		     $fwrite(write_file_SER,"%g %h - BASELINE_5\n", $time/1000, word_ser_0);//, word_ser_1, word_ser_2, word_ser_3);
		     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[5:0]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[11:6]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[17:12]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[23:18]);
		     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[29:24]);
		  end else begin  
		     if (word_ser_0[31:30]== 2'b10) begin			//BASELINE
			word_0_state=3'b010;
			$fwrite(write_file_SER,"%g %h - BASELINE_%h\n", $time/1000, word_ser_0,  word_ser_0[27:24]);//, word_ser_1, word_ser_2, word_ser_3, word_ser_0[27:24]);
			case(word_ser_0[26:24])
			  3'b001: $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[5:0]);
			  3'b010: begin
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[5:0]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[11:6]);
			  end
			  3'b011:begin
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[5:0]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[11:6]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[17:12]);
			  end
			  3'b100:begin
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[5:0]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[11:6]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[17:12]);
			     $fwrite(write_file_output,"%g * 0%h\n", $time/1000, word_ser_0[23:18]);
			  end
			  default: $fwrite(write_file_output,"%g %h - ERROR\n", $time/1000, word_ser_0);
			endcase		
		     end else begin
		 	if (word_ser_0[31:26]== 6'b001010) begin		//SIGNAL
			   word_0_state=3'b011;
			   $fwrite(write_file_SER,"%g %h - SIGNAL_2\n", $time/1000, word_ser_0);//, word_ser_1, word_ser_2, word_ser_3);
			   $fwrite(write_file_output,"%g %h %h\n", $time/1000, word_ser_0[12], word_ser_0[11:0]);
			   $fwrite(write_file_output,"%g %h %h\n", $time/1000, word_ser_0[25], word_ser_0[24:13]);
			end else begin
		    	   if (word_ser_0[31:26]== 6'b001011) begin	//SIGNAL
			      word_0_state=3'b100;
			      $fwrite(write_file_SER,"%g %h - SIGNAL_1\n", $time/1000, word_ser_0);//, word_ser_1, word_ser_2, word_ser_3);
			      $fwrite(write_file_output,"%g %h %h\n", $time/1000, word_ser_0[12], word_ser_0[11:0]);
		    	   end else begin
			      if (word_ser_0[31:28]== 4'b1110) begin	//IDLE
				 word_0_state=3'b101;
				 $fwrite(write_file_SER,"%g %h - IDLE\n", $time/1000, word_ser_0);//, word_ser_1, word_ser_2, word_ser_3);
		 	      end else begin
		    		 if (word_ser_0[31:28]== 4'b1101) begin	//TRAILER
				    word_0_state=3'b110;
				    frame_counter = frame_counter+1;
				    $fwrite(write_file_SER,"%g %h - TRAILER\n", $time/1000, word_ser_0);//, word_ser_1, word_ser_2, word_ser_3);
		    		 end else begin
				    SER_error=SER_error+1;
				    $fwrite(write_file_SER,"%g %h - SER_ERROR\n", $time/1000, word_ser_0);//, word_ser_1, word_ser_2, word_ser_3);
				 end
			      end
			   end
			end
		     end
		  end		
	       end else begin
		  $fwrite(write_file_SER,"%g %h %h %h %h \n", $time/1000, word_ser_0, word_ser_1, word_ser_2, word_ser_3);
		  $fwrite(write_file_outputH,"%g %h\n", $time/1000, word_ser_1[11:0]);
		  $fwrite(write_file_outputH,"%g %h\n", $time/1000, word_ser_0[11:0]);
		  $fwrite(write_file_outputH,"%g %h\n", $time/1000, word_ser_1[27:16]);
		  $fwrite(write_file_outputH,"%g %h\n", $time/1000, word_ser_0[27:16]);
		  $fwrite(write_file_outputL,"%g %h\n", $time/1000, word_ser_3[11:0]);
		  $fwrite(write_file_outputL,"%g %h\n", $time/1000, word_ser_2[11:0]);
		  $fwrite(write_file_outputL,"%g %h\n", $time/1000, word_ser_3[27:16]);
		  $fwrite(write_file_outputL,"%g %h\n", $time/1000, word_ser_2[27:16]);
	       end
	    end
	 end
      end
   end //END always
   //////////////////////////////////
   //////////INPUT RANDOM STIMULATION
   real rnd_val1, rnd_val2, rnd_val3;
   real input_val01, input_val10, integer_01, integer_10;
   reg [11:0] ADC_01;
   reg [11:0] ADC_10;
   always @(posedge CLKINm) begin //AdcClkInp) begin
      if (rst_b == 1'b1) begin
	 if (CalBusy == 1'b0) begin
	    rnd_val1 = $urandom_range(60000,58500);
	    rnd_val2 = rnd_val1/(-100000.0);
	    if (rnd_val1 > 59990) begin
	       rnd_val3 = ($urandom_range(13000,500))/10000.0;
	    end else begin
	       rnd_val3 = 0.0;
	    end
	 end else begin
	    rnd_val1=0.0;
	    rnd_val2=0.0;
	    rnd_val3=0.0;
	 end
	 input_val10 = rnd_val2+rnd_val3;
	 input_val01 = rnd_val2+(rnd_val3/10.0);

      end
   end
   always @(posedge CLKINm) begin //AdcClkInp) begin
      force tb_ldtu.top.LDTU.ADC_HL.ADC_H.\input_signal = input_val10;
      force tb_ldtu.top.LDTU.ADC_HL.ADC_L.\input_signal = input_val01;
      //input signal quantization
      integer_10 =  ((input_val10 + 0.6) / 1.2) * 4095;
      integer_01 =  ((input_val01 + 0.6) / 1.2) * 4095;
      //input signal conversion
      ADC_10 = (integer_10<0) ? 0 : (integer_10>4095) ? 4095 : integer_10;
      ADC_01 = (integer_01<0) ? 0 : (integer_01>4095) ? 4095 : integer_01;
      if (CalBusy == 1'b0) begin
	 $fwrite(write_file_g01,"%g %h\n", $time/1000, ADC_01);
	 $fwrite(write_file_g10,"%g %h\n", $time/1000, ADC_10); 
      end
   end
endmodule // end tb_ldtu
