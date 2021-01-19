set sdc_version 1.3

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

constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/d_g01_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/d_g01_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/d_g01_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/DATA_gain_01[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/d_g10_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/d_g10_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/d_g10_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_BSTMR/DATA_gain_10[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/DATA_to_enc_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/DATA_to_enc_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/DATA_to_enc_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/DATA_to_enc[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/baseline_flag_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/baseline_flag_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/baseline_flag_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/baseline_flag[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/GAIN_SEL_MODE[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/GAIN_SEL_MODE_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/GAIN_SEL_MODE_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_iFIFOTMR/GAIN_SEL_MODE_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/LDTU_FSMTMR/Current_state_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/LDTU_FSMTMR/Current_state_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/LDTU_FSMTMR/Current_state_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/LDTU_FSMTMR/Current_state[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/Load_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/Load_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/Load_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/Load
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/DATA_32_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/DATA_32_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/DATA_32_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_EncoderTMR/DATA_32[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_from_CU_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_from_CU_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_from_CU_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_from_CU[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/read_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/read_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/read_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/read_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/write_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/write_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/write_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/write_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/losing_data_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/losing_data_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/losing_data_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/losing_data
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_32[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_32_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_32_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/DATA_32_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/Load_data
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/Load_data_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/Load_data_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/Load_data_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/handshake
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/handshake_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/handshake_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/handshake_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/full
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/full_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/full_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_CUTMR/full_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_write_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_write_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_write_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_write[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_read_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_read_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_read_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/ptr_read
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/decode_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/decode_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/decode_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/decode_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/reset_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/reset_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/reset_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/reset
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/empty_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/empty_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/empty_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/empty_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/full_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/full_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/full_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/full_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/read_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/read_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/read_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/read_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/start_write
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/start_write_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/start_write_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/LDTU_oFIFOTMR/start_write_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/CLK_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/CLK_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/CLK_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/CLK
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/reset_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/reset_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/reset_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/reset
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/DATA32_DTU_A[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/DATA32_DTU_B[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/DATA32_DTU_C[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/DATA32_DTU[*]
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/read_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/read_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/read_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/read_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/empty_signal
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/empty_signal_A
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/empty_signal_B
constrainNet /LiTE_DTU_160MHz_v1_2/LDTU_oFIFO_top/empty_signal_C
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY_A
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY_B
constrainNet /LiTE_DTU_160MHz_v1_2/CALIBRATION_BUSY_C
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE_A
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE_B
constrainNet /LiTE_DTU_160MHz_v1_2/TEST_ENABLE_C

puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
