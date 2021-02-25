-- File>>> LDTUv1b_SeuTest_TB0.vhd
--
-- Date: Wed Jul 1 13:15:11 CET 2020
-- Author: gianni
--
-- Test bench 2 for the ToASt digital code
--
-- Revision history:
--
--	26.11.20 : Vref removed
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;  -- I/O for logic types

library STD;
use STD.textio.all;							 -- Basic I/O

library work;
use work.all;

entity LDTUv1b_SeuTest_TB0e is
  generic (
    constant filename : string := "/export/elt159xl/disk0/users/soldi/LiTE-DTU_v2.0_2021_Simulations/pre-synth/AuxiliaryForSimulation/LDTUv1b_dp_tb2.dataraw";
    constant ck_period : time := 6 ns );
end LDTUv1b_SeuTest_TB0e;

-- Test bench architecture

architecture LDTUv1b_SeuTest_TB0a of LDTUv1b_SeuTest_TB0e is

  component LDTUv1b_SeuTeste
    port (
      reset 				: in std_logic;
      clock 				: in std_logic;
      data_in	   			: in std_logic_vector(31 downto 0);
      data_write 			: in std_logic;
      data_errors 		: out std_logic_vector(4 downto 0);
      crc_error 			: out std_logic;
      nwords_error 		: out std_logic;
      nidle_error 		: out std_logic;		
      nsamples_error 		: out std_logic;
      nframe_error 		: out std_logic;		
      read_fd_error		: out std_logic;
      read_idle_error	 	: out std_logic;
      read_data_errors 	: out std_logic);
  end component;

  signal reset 				: std_logic;
  signal clock 				: std_logic;
  signal data_in	   			: std_logic_vector(31 downto 0);
  signal data_write 			: std_logic;
  signal data_errors 			: std_logic_vector(4 downto 0);
  signal crc_error 			: std_logic;
  signal nwords_error 		: std_logic;
  signal nidle_error 			: std_logic;		
  signal nsamples_error 		: std_logic;
  signal nframe_error 		: std_logic;		
  signal read_fd_error		: std_logic;
  signal read_idle_error	 	: std_logic;
  signal read_data_errors 	: std_logic;

  signal end_sim 				: std_logic;


  ----check
 signal totalDataErrors      : std_logic_vector(32 downto 0);
 signal totalCRCErrors       : std_logic_vector(32 downto 0);  
 signal totalNwordsErrors    : std_logic_vector(32 downto 0);
 signal totalFrameErrors     : std_logic_vector(32 downto 0);
 signal totalNSamplesErrors  : std_logic_vector(32 downto 0);
 signal totalIdleErrors      : std_logic_vector(32 downto 0);
  
begin

  I_SeuTest : LDTUv1b_SeuTeste
    port map (
      reset 			=> reset, 			clock 			=> clock,
      data_in 		=> data_in, 		data_write 		=> data_write,
      data_errors		=> data_errors, 	crc_error 		=> crc_error,
      nwords_error 	=> nwords_error, 	nidle_error		=> nidle_error,
      nsamples_error 	=> nsamples_error, 	nframe_error	=> nframe_error,
      read_fd_error 	=> read_fd_error, 	read_idle_error => read_idle_error,
      read_data_errors => read_data_errors);

  -- Clock generation process

  generate_clock : process 
  begin
    clock   <= '1';
    wait for ck_period/2;
    clock   <= '0';
    wait for ck_period/2;
  end process;

  test_patterns : process
    file		fp_in : text;
    variable 	fp_in_status : FILE_OPEN_STATUS;
    variable 	buf_in 		: LINE;
    variable 	input_data 	: std_logic_vector(31 downto 0);
  begin

    file_open(fp_in_status,fp_in,filename,READ_MODE);
    if (fp_in_status /= OPEN_OK) then
      assert FALSE report "Error in opening input file" severity FAILURE;
    end if;

    reset 		<= '1';
    data_in 	<= (others => '0');
    data_write 	<= '0';
    end_sim 	<= '0';

    wait for (4.1*ck_period);
    reset 	<= '0';
    wait for (4*ck_period);

    -- Main loop

    while not (endfile(fp_in)) loop
      readline(fp_in, buf_in);
      hread(buf_in, input_data);
      data_in <= input_data;
      wait for ck_period;
      data_write <= '1';
      wait for ck_period;
      data_write <= '0';
      wait for (2*ck_period);
    end loop;

    -- End of simulation

    file_close(fp_in);
    end_sim 	<= '1';
    wait for 10 ns;
    assert FALSE report "End of simulation" severity FAILURE;

  end process;

  checkdata : process(reset, clock)
begin
  if(reset='1') then
    totalDataErrors      <= (others => '0');
    totalCRCErrors       <= (others => '0');
    totalNwordsErrors    <= (others => '0');
    totalFrameErrors     <= (others => '0');
    totalNSamplesErrors  <= (others => '0');
    totalIdleErrors      <= (others => '0');
    
  elsif(clock'event and clock='1') then

    if (read_data_errors = '1') then
      totalDataErrors <= totalDataErrors + ("000000000000000000000000000" & data_errors);
      
    elsif(read_fd_error = '1') then
      if(crc_error='1') then
        totalCRCErrors <= totalCRCErrors + X"0001";
      end if;
      if(nwords_error='1') then
        totalNwordsErrors <= totalCRCErrors + X"0001";
      end if;
      if(nframe_error='1') then
        totalFrameErrors <= totalFrameErrors + X"0001";
      end if;
      if(nsamples_error='1'  ) then
        totalNSamplesErrors <= totalNSamplesErrors + X"0001";
      end if;
      
    elsif (read_idle_error ='1' ) then
      if(nidle_error='1') then
        totalIdleErrors <= totalIdleErrors + X"0001";
      end if;
    end if;
    end if;     
end process;
-- Test bench configuration

end LDTUv1b_SeuTest_TB0a;


configuration LDTUv1b_SeuTest_TB0c of LDTUv1b_SeuTest_TB0e is
  for LDTUv1b_SeuTest_TB0a
    for all: LDTUv1b_SeuTeste
      use entity work.LDTUv1b_SeuTeste(rtl);
    end for;
  end for;
end LDTUv1b_SeuTest_TB0c;

