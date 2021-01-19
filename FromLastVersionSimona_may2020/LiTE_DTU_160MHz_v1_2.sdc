set sdc_version 1.3

current_design LiTE_DTU_160MHz_v1_2

# Defining the clock
create_clock [get_ports {DCLK_1}] -name DCLK_1 -period 5.2 -waveform {0 2.6}
create_clock [get_ports {DCLK_10}] -name DCLK_10 -period 5.2 -waveform {0 2.6}
#create_clock [get_ports {CLK}] -name CLK -period 5.2 -waveform {0 2.6}
create_clock [get_ports {CLK_A}] -name CLK_A -period 5.2 -waveform {0 2.6}
create_clock [get_ports {CLK_B}] -name CLK_B -period 5.2 -waveform {0 2.6}
create_clock [get_ports {CLK_C}] -name CLK_C -period 5.2 -waveform {0 2.6}
# --- Model the clock ---

# --- Clock Transition Time ---
#set_clock_transition  0.1 [get_clocks CLK]
set_clock_transition  0.1 [get_clocks CLK_A]
set_clock_transition  0.1 [get_clocks CLK_B]
set_clock_transition  0.1 [get_clocks CLK_C]
set_clock_transition  0.1 [get_clocks DCLK_1]
set_clock_transition  0.1 [get_clocks DCLK_10]

# --- Clock Source Insertion Delay ---
#set_clock_latency -source 0.5 [get_clocks {CLK}]
set_clock_latency -source 0.5 [get_clocks {CLK_A}]
set_clock_latency -source 0.5 [get_clocks {CLK_B}]
set_clock_latency -source 0.5 [get_clocks {CLK_C}]
set_clock_latency -source 0.5 [get_clocks {DCLK_1}]
set_clock_latency -source 0.5 [get_clocks {DCLK_10}]

# --- Clock Network Insertion Delay ---
#set_clock_latency 0.5 [get_clocks {CLK}]
set_clock_latency 0.5 [get_clocks {CLK_A}]
set_clock_latency 0.5 [get_clocks {CLK_B}]
set_clock_latency 0.5 [get_clocks {CLK_C}]
set_clock_latency 0.5 [get_clocks {DCLK_1}]
set_clock_latency 0.5 [get_clocks {DCLK_10}]


# --- Clock Skew and Jitter --- 
#set_clock_uncertainty -setup 0.2 [get_clocks CLK]
set_clock_uncertainty -setup 0.2 [get_clocks CLK_A]
set_clock_uncertainty -setup 0.2 [get_clocks CLK_B]
set_clock_uncertainty -setup 0.2 [get_clocks CLK_C]
set_clock_uncertainty -setup 0.2 [get_clocks DCLK_1]
set_clock_uncertainty -setup 0.2 [get_clocks DCLK_10]
#set_clock_uncertainty -hold 0.2 [get_clocks CLK]
set_clock_uncertainty -hold 0.2 [get_clocks CLK_A]
set_clock_uncertainty -hold 0.2 [get_clocks CLK_B]
set_clock_uncertainty -hold 0.2 [get_clocks CLK_C]
set_clock_uncertainty -hold 0.2 [get_clocks DCLK_1]
set_clock_uncertainty -hold 0.2 [get_clocks DCLK_10]


set_attribute optimize_merge_flops false
#set_false_path -from [get_clocks CLK] -to [get_clocks DCLK_1]
#set_false_path -from [get_clocks DCLK_1] -to [get_clocks CLK]
#set_false_path -from [get_clocks CLK] -to [get_clocks DCLK_10]
#set_false_path -from [get_clocks DCLK_10] -to [get_clocks CLK]
set_false_path -from [get_clocks DCLK_1] -to [get_clocks DCLK_10]
set_false_path -from [get_clocks DCLK_10] -to [get_clocks DCLK_1]

set_false_path -from [get_clocks CLK_A] -to [get_clocks DCLK_1]
set_false_path -from [get_clocks DCLK_1] -to [get_clocks CLK_A]
set_false_path -from [get_clocks CLK_A] -to [get_clocks DCLK_10]
set_false_path -from [get_clocks DCLK_10] -to [get_clocks CLK_A]

set_false_path -from [get_clocks CLK_B] -to [get_clocks DCLK_1]
set_false_path -from [get_clocks DCLK_1] -to [get_clocks CLK_B]
set_false_path -from [get_clocks CLK_B] -to [get_clocks DCLK_10]
set_false_path -from [get_clocks DCLK_10] -to [get_clocks CLK_B]

set_false_path -from [get_clocks CLK_C] -to [get_clocks DCLK_1]
set_false_path -from [get_clocks DCLK_1] -to [get_clocks CLK_C]
set_false_path -from [get_clocks CLK_C] -to [get_clocks DCLK_10]
set_false_path -from [get_clocks DCLK_10] -to [get_clocks CLK_C]

set_dont_touch RST_A
set_dont_touch RST_B
set_dont_touch RST_C

set_dont_touch CLK_A
set_dont_touch CLK_B
set_dont_touch CLK_C

set_dont_use NR4*
set_dont_use I*NR4*
set_dont_use OR4*

# --- Input Delay --- 
#set_input_delay 1 -max -min -clock CLK [remove_from_collection [all_inputs] CLK]
set_input_delay 1 -max -min -clock CLK_A [remove_from_collection [all_inputs] CLK_A]
set_input_delay 1 -max -min -clock CLK_B [remove_from_collection [all_inputs] CLK_B]
set_input_delay 1 -max -min -clock CLK_C [remove_from_collection [all_inputs] CLK_C]

# --- Input Drive Resistance ---
#set_drive -max 1 [all_inputs]
#set_drive -min 0.01 [all_inputs]

# --- Output Delay --- 
#set_output_delay 1 -max -min -clock CLK [all_outputs]
set_output_delay 1 -max -min -clock CLK_A [all_outputs]
set_output_delay 1 -max -min -clock CLK_B [all_outputs]
set_output_delay 1 -max -min -clock CLK_C [all_outputs]

# --- Output Load Capacitance ---
#set_load -max 3 [all_outputs]
#set_load -min 1 [all_outputs]


set tmrgSucces 0
set tmrgFailed 0
proc constrainNet netName {
  global tmrgSucces
  global tmrgFailed
  # find nets matching netName pattern
  set nets [dc::get_net $netName]
  if {[llength $nets] != 0} {
    set_dont_touch $nets
    incr tmrgSucces
  } else {
    puts "\[TMRG\] Warning! Net(s) '$netName' not found"
    incr tmrgFailed
  }
}

constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/d_g01_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/d_g01_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/d_g01_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/DATA_gain_01[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/d_g10_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/d_g10_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/d_g10_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/B_subtraction/DATA_gain_10[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/DATA_to_enc_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/DATA_to_enc_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/DATA_to_enc_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/DATA_to_enc[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/baseline_flag_A
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/baseline_flag_B
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/baseline_flag_C
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/baseline_flag
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/GAIN_SEL_MODE[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/GAIN_SEL_MODE_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/GAIN_SEL_MODE_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Selection_TMR/GAIN_SEL_MODE_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/fsm/Current_state_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/fsm/Current_state_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/fsm/Current_state_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/fsm/Current_state[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/Load_A
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/Load_B
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/Load_C
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/Load
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/DATA_32_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/DATA_32_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/DATA_32_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Encoder/DATA_32[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_from_CU_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_from_CU_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_from_CU_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_from_CU[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/read_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/read_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/read_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/read_signal
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/write_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/write_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/write_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/write_signal
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/losing_data_A
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/losing_data_B
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/losing_data_C
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/losing_data
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_32[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_32_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_32_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/DATA_32_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/Load_data
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/Load_data_A
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/Load_data_B
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/Load_data_C
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/handshake
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/handshake_A
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/handshake_B
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/handshake_C
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/full
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/full_A
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/full_B
constrainNet /LiTE_DTU_160MHz_v1_2/Control_Unit/full_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_write_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_write_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_write_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_write[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_read_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_read_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_read_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/ptr_read[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/decode_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/decode_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/decode_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/decode_signal
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/reset_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/reset_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/reset_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/reset
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/empty_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/empty_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/empty_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/empty_signal
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/full_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/full_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/full_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/full_signal
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/read_signal
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/read_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/read_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/read_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/start_write
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/start_write_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/start_write_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/FIFO/start_write_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/CLK_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/CLK_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/CLK_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/CLK
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/reset_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/reset_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/reset_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/reset
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/DATA32_DTU_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/DATA32_DTU_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/DATA32_DTU_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/DATA32_DTU[*]
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/read_signal
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/read_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/read_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/read_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/empty_signal
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/empty_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/empty_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/StorageFIFO/empty_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_0[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_0_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_0_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_0_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_1[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_1_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_1_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_1_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_2[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_2_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_2_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_2_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_3[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_3_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_3_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_ATU_3_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_DTU[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_DTU_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_DTU_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_DTU_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_0_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_0_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_0_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_0[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_1_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_1_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_1_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_1[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_2_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_2_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_2_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_2[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_3_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_3_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_3_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/DATA32_mux/DATA32_3[*]
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY_A
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY_B
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY_C
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE_A
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE_B
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE_C

puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
