-- File>>> LDTUv1b_SeuTest.vhd
--
-- Date: Mon Feb 22 12:12:17 CET 2021
-- Author: gianni
--
-- Code to detect SEU errors in the DTU unit :
--
--		reset			: asynchronous reset
--		clock			: 160 MHz input clock (to be checked with RJW)
--		data_in 		: 32 bits input bus
--		data_write 	 	: new data is ready
--		data_error	 	: n. of errors in a word
--		crc_error	 	: error in the crc
--		nwords_error 	: error in the number of words in a frame
--		nsamples_error	: error in the number of samples in a frame
--		wait_fd			: high when the frame delimiter does not arrive when
--						  expected
--
-- All output signals are active one clock cycle per error, except wait_fd which is
-- active from when the frame delimiter was due to when it actually arrives
--
--Baseline Format (01 000000 000000 000000 0000000 000000)

-- Revision history:
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;  -- I/O for logic types

library std;
use std.textio.all;                             -- Basic I/O

entity LDTUv1b_SeuTeste is
  port (
    reset 		: in std_logic;
    clock 		: in std_logic;
    data_in       	: in std_logic_vector(31 downto 0);
    data_write 	        : in std_logic;

    data_errors 	: out std_logic_vector(4 downto 0);
    crc_error 		: out std_logic;
    nwords_error 	: out std_logic;
    nidle_error 	: out std_logic;        
    nsamples_error 	: out std_logic;
    nframe_error 	: out std_logic;        
    read_fd_error       : out std_logic;
    read_idle_error     : out std_logic;
    read_data_errors    : out std_logic
    );

end LDTUv1b_SeuTeste;

architecture rtl of LDTUv1b_SeuTeste is

  signal s_data_valid  : std_logic_vector(31 downto 0);
  signal s_data_errors : std_logic_vector(4 downto 0);
  signal s_nsamples    : std_logic_vector(7 downto 0);
  signal s_nwords      : std_logic_vector(7 downto 0);
  signal s_nframe      : std_logic_vector(7 downto 0);     
  
  component DataTest is
    Port(
      A : in STD_LOGIC_VECTOR(29 downto 0);
      ones : out STD_LOGIC_VECTOR(4 downto 0)
      );
  end component;

begin
-- component port map
  --check that all the baseline bits are equal to 0, else, counts how many bits
  --are set to 1.
  DataTest_inst : DataTest port map (
    A => data_in(29 downto 0), -- Input not registered
    ones => s_data_errors
    );
  
  process (reset, clock) is
  begin
    if (reset = '1') then
      s_data_valid <= (others => '0');
      
    elsif (clock'event and clock = '1') then
      if (data_write = '1') then
        s_data_valid <= data_in;
      else
        s_data_valid <= (others => '0');        
      end if;
    end if;
  end process;

  --Check Process:
  process(reset,clock) is --data can be always the same,
                                   --check every time I write
  begin
    if(reset = '1') then
      --reset counters:
      s_nwords           <= (others => '0');
      s_nsamples         <= (others => '0');
      s_nframe           <= (others => '0');
      data_errors        <= (others =>  '0');
      --reset errors:
      nsamples_error     <= '0';
      nwords_error       <= '0';
      nframe_error       <= '0';
      nidle_error        <= '0';
      crc_error          <= '0';
      read_fd_error      <= '0';
      read_idle_error   <= '0';
      read_data_errors   <= '0';

    elsif (clock'event and clock = '1') then
      
      if (s_data_valid(31 downto 30) = "01") then --baseline

        data_errors <= s_data_errors; -- Timing???? 

        s_nsamples <= s_nsamples + X"05"; -- I sum 5 for every baseline word
        s_nwords <= s_nwords +  X"01"; -- I sum 1 for every word 

        s_nframe   <= s_nframe;
        
        nsamples_error     <= '0';
        nwords_error       <= '0';
        crc_error          <= '0';
        nframe_error       <= '0';        
        nidle_error        <= '0';        

        read_fd_error      <= '0';
        read_idle_error    <= '0';
        read_data_errors   <= '1';
        
      elsif(s_data_valid(31 downto 28) = "1110") then --idle keep the counters at
                                                      --the same value
        if(s_data_valid(27 downto 0) /= "1010101010101010101010101010") then
          nidle_error        <= '1';
        else
          nidle_error        <= '0';
        end if;

        data_errors <= (others => '0');
        s_nwords <= s_nwords; 
        s_nsamples <= s_nsamples;
        s_nframe   <= s_nframe;

        nframe_error       <= '0';
        nsamples_error     <= '0';
        nwords_error       <= '0';
        crc_error          <= '0';

        read_fd_error      <= '0';
        read_idle_error   <= '1';
        read_data_errors   <= '0';
        
      elsif(s_data_valid(31 downto 28) = "1101") then --frame delimiter

        s_nframe <= s_nframe + "00000001"; --increase frame number

        if(s_data_valid(27 downto 20)) /= s_nsamples then
          nsamples_error <= '1';
        end if;
        
        if(s_nwords /= X"32") then --50 words + fd (not counted)
          nwords_error <='1';
        end if;

        if(s_nframe /= s_data_valid(7 downto 0)) then --
          nframe_error <='1';
        end if;

        read_fd_error      <= '1';
        read_idle_error    <= '0';
        read_data_errors   <= '0';

        nidle_error        <= '0';        
        data_errors  <= (others => '0');

        s_nwords     <= (others => '0');
        s_nsamples   <= (others => '0');
        
      else 
        data_errors  <= (others =>'0');
        s_nwords     <= s_nwords;
        s_nsamples   <= s_nsamples;
        s_nframe     <= s_nframe;
        nidle_error        <= '0';
        nwords_error       <= '0';
        nsamples_error     <= '0';
        read_fd_error      <= '0';
        read_idle_error    <= '0';
        read_data_errors   <= '0';
      end if;
    end if;
  end process;        
end rtl;

