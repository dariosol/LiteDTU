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

constrainNet /B_subtraction/BSL_VAL_g01A[*]
constrainNet /B_subtraction/BSL_VAL_g01B[*]
constrainNet /B_subtraction/BSL_VAL_g01C[*]
constrainNet /B_subtraction/BSL_VAL_g01[*]
constrainNet /B_subtraction/BSL_VAL_g10A[*]
constrainNet /B_subtraction/BSL_VAL_g10B[*]
constrainNet /B_subtraction/BSL_VAL_g10C[*]
constrainNet /B_subtraction/BSL_VAL_g10[*]
constrainNet /B_subtraction/DATA12_g01A[*]
constrainNet /B_subtraction/DATA12_g01B[*]
constrainNet /B_subtraction/DATA12_g01C[*]
constrainNet /B_subtraction/DATA12_g01[*]
constrainNet /B_subtraction/DATA12_g10A[*]
constrainNet /B_subtraction/DATA12_g10B[*]
constrainNet /B_subtraction/DATA12_g10C[*]
constrainNet /B_subtraction/DATA12_g10[*]
constrainNet /B_subtraction/DCLK_1
constrainNet /B_subtraction/DCLK_10
constrainNet /B_subtraction/DCLK_10A
constrainNet /B_subtraction/DCLK_10B
constrainNet /B_subtraction/DCLK_10C
constrainNet /B_subtraction/DCLK_1A
constrainNet /B_subtraction/DCLK_1B
constrainNet /B_subtraction/DCLK_1C
constrainNet /B_subtraction/dg01_synchA[*]
constrainNet /B_subtraction/dg01_synchB[*]
constrainNet /B_subtraction/dg01_synchC[*]
constrainNet /B_subtraction/dg01_synch[*]
constrainNet /B_subtraction/dg10_synchA[*]
constrainNet /B_subtraction/dg10_synchB[*]
constrainNet /B_subtraction/dg10_synchC[*]
constrainNet /B_subtraction/dg10_synch[*]
constrainNet /CALIBRATION_BUSY
constrainNet /CALIBRATION_BUSYA
constrainNet /CALIBRATION_BUSYB
constrainNet /CALIBRATION_BUSYC
constrainNet /Control_Unit/DATA_32A[*]
constrainNet /Control_Unit/DATA_32B[*]
constrainNet /Control_Unit/DATA_32C[*]
constrainNet /Control_Unit/DATA_32[*]
constrainNet /Control_Unit/DATA_32_FBA[*]
constrainNet /Control_Unit/DATA_32_FBB[*]
constrainNet /Control_Unit/DATA_32_FBC[*]
constrainNet /Control_Unit/DATA_32_FB[*]
constrainNet /Control_Unit/DATA_from_CU_synchA[*]
constrainNet /Control_Unit/DATA_from_CU_synchB[*]
constrainNet /Control_Unit/DATA_from_CU_synchC[*]
constrainNet /Control_Unit/DATA_from_CU_synch[*]
constrainNet /Control_Unit/Load_data
constrainNet /Control_Unit/Load_dataA
constrainNet /Control_Unit/Load_dataB
constrainNet /Control_Unit/Load_dataC
constrainNet /Control_Unit/Load_data_FB
constrainNet /Control_Unit/Load_data_FBA
constrainNet /Control_Unit/Load_data_FBB
constrainNet /Control_Unit/Load_data_FBC
constrainNet /Control_Unit/fallback
constrainNet /Control_Unit/fallbackA
constrainNet /Control_Unit/fallbackB
constrainNet /Control_Unit/fallbackC
constrainNet /Control_Unit/full
constrainNet /Control_Unit/fullA
constrainNet /Control_Unit/fullB
constrainNet /Control_Unit/fullC
constrainNet /Control_Unit/handshake
constrainNet /Control_Unit/handshakeA
constrainNet /Control_Unit/handshakeB
constrainNet /Control_Unit/handshakeC
constrainNet /Control_Unit/losing_data_synch
constrainNet /Control_Unit/losing_data_synchA
constrainNet /Control_Unit/losing_data_synchB
constrainNet /Control_Unit/losing_data_synchC
constrainNet /Control_Unit/read_signal_synch
constrainNet /Control_Unit/read_signal_synchA
constrainNet /Control_Unit/read_signal_synchB
constrainNet /Control_Unit/read_signal_synchC
constrainNet /Control_Unit/write_signal_synch
constrainNet /Control_Unit/write_signal_synchA
constrainNet /Control_Unit/write_signal_synchB
constrainNet /Control_Unit/write_signal_synchC
constrainNet /DATA32_mux/DATA32_0_synchA[*]
constrainNet /DATA32_mux/DATA32_0_synchB[*]
constrainNet /DATA32_mux/DATA32_0_synchC[*]
constrainNet /DATA32_mux/DATA32_0_synch[*]
constrainNet /DATA32_mux/DATA32_1_synchA[*]
constrainNet /DATA32_mux/DATA32_1_synchB[*]
constrainNet /DATA32_mux/DATA32_1_synchC[*]
constrainNet /DATA32_mux/DATA32_1_synch[*]
constrainNet /DATA32_mux/DATA32_2_synchA[*]
constrainNet /DATA32_mux/DATA32_2_synchB[*]
constrainNet /DATA32_mux/DATA32_2_synchC[*]
constrainNet /DATA32_mux/DATA32_2_synch[*]
constrainNet /DATA32_mux/DATA32_3_synchA[*]
constrainNet /DATA32_mux/DATA32_3_synchB[*]
constrainNet /DATA32_mux/DATA32_3_synchC[*]
constrainNet /DATA32_mux/DATA32_3_synch[*]
constrainNet /DATA32_mux/DATA32_ATU_0A[*]
constrainNet /DATA32_mux/DATA32_ATU_0B[*]
constrainNet /DATA32_mux/DATA32_ATU_0C[*]
constrainNet /DATA32_mux/DATA32_ATU_0[*]
constrainNet /DATA32_mux/DATA32_ATU_1A[*]
constrainNet /DATA32_mux/DATA32_ATU_1B[*]
constrainNet /DATA32_mux/DATA32_ATU_1C[*]
constrainNet /DATA32_mux/DATA32_ATU_1[*]
constrainNet /DATA32_mux/DATA32_ATU_2A[*]
constrainNet /DATA32_mux/DATA32_ATU_2B[*]
constrainNet /DATA32_mux/DATA32_ATU_2C[*]
constrainNet /DATA32_mux/DATA32_ATU_2[*]
constrainNet /DATA32_mux/DATA32_ATU_3A[*]
constrainNet /DATA32_mux/DATA32_ATU_3B[*]
constrainNet /DATA32_mux/DATA32_ATU_3C[*]
constrainNet /DATA32_mux/DATA32_ATU_3[*]
constrainNet /DATA32_mux/DATA32_DTUA[*]
constrainNet /DATA32_mux/DATA32_DTUB[*]
constrainNet /DATA32_mux/DATA32_DTUC[*]
constrainNet /DATA32_mux/DATA32_DTU[*]
constrainNet /Encoder/DATA_32_FB_synchA[*]
constrainNet /Encoder/DATA_32_FB_synchB[*]
constrainNet /Encoder/DATA_32_FB_synchC[*]
constrainNet /Encoder/DATA_32_FB_synch[*]
constrainNet /Encoder/DATA_32_synchA[*]
constrainNet /Encoder/DATA_32_synchB[*]
constrainNet /Encoder/DATA_32_synchC[*]
constrainNet /Encoder/DATA_32_synch[*]
constrainNet /Encoder/DATA_to_encA[*]
constrainNet /Encoder/DATA_to_encB[*]
constrainNet /Encoder/DATA_to_encC[*]
constrainNet /Encoder/DATA_to_enc[*]
constrainNet /Encoder/Load_FB_synch
constrainNet /Encoder/Load_FB_synchA
constrainNet /Encoder/Load_FB_synchB
constrainNet /Encoder/Load_FB_synchC
constrainNet /Encoder/Load_synch
constrainNet /Encoder/Load_synchA
constrainNet /Encoder/Load_synchB
constrainNet /Encoder/Load_synchC
constrainNet /Encoder/baseline_flag
constrainNet /Encoder/baseline_flagA
constrainNet /Encoder/baseline_flagB
constrainNet /Encoder/baseline_flagC
constrainNet /Encoder/fallback
constrainNet /Encoder/fallbackA
constrainNet /Encoder/fallbackB
constrainNet /Encoder/fallbackC
constrainNet /Encoder/fsm/baseline_flag
constrainNet /Encoder/fsm/baseline_flagA
constrainNet /Encoder/fsm/baseline_flagB
constrainNet /Encoder/fsm/baseline_flagC
constrainNet /Encoder/fsm/fallback
constrainNet /Encoder/fsm/fallbackA
constrainNet /Encoder/fsm/fallbackB
constrainNet /Encoder/fsm/fallbackC
constrainNet /Selection/DATA_gain_01A[*]
constrainNet /Selection/DATA_gain_01B[*]
constrainNet /Selection/DATA_gain_01C[*]
constrainNet /Selection/DATA_gain_01[*]
constrainNet /Selection/DATA_gain_10A[*]
constrainNet /Selection/DATA_gain_10B[*]
constrainNet /Selection/DATA_gain_10C[*]
constrainNet /Selection/DATA_gain_10[*]
constrainNet /Selection/DCLK_1
constrainNet /Selection/DCLK_10
constrainNet /Selection/DCLK_10A
constrainNet /Selection/DCLK_10B
constrainNet /Selection/DCLK_10C
constrainNet /Selection/DCLK_1A
constrainNet /Selection/DCLK_1B
constrainNet /Selection/DCLK_1C
constrainNet /Selection/GAIN_SEL_MODEA[*]
constrainNet /Selection/GAIN_SEL_MODEB[*]
constrainNet /Selection/GAIN_SEL_MODEC[*]
constrainNet /Selection/GAIN_SEL_MODE[*]
constrainNet /Selection/SATURATION_valueA[*]
constrainNet /Selection/SATURATION_valueB[*]
constrainNet /Selection/SATURATION_valueC[*]
constrainNet /Selection/SATURATION_value[*]
constrainNet /Selection/bsflag
constrainNet /Selection/bsflagA
constrainNet /Selection/bsflagB
constrainNet /Selection/bsflagC
constrainNet /Selection/d2encA[*]
constrainNet /Selection/d2encB[*]
constrainNet /Selection/d2encC[*]
constrainNet /Selection/d2enc[*]
constrainNet /Selection/shift_gain_10A[*]
constrainNet /Selection/shift_gain_10B[*]
constrainNet /Selection/shift_gain_10C[*]
constrainNet /Selection/shift_gain_10[*]
constrainNet /StorageFIFO/CLK
constrainNet /StorageFIFO/CLKA
constrainNet /StorageFIFO/CLKB
constrainNet /StorageFIFO/CLKC
constrainNet /StorageFIFO/DATA32_DTU_synchA[*]
constrainNet /StorageFIFO/DATA32_DTU_synchB[*]
constrainNet /StorageFIFO/DATA32_DTU_synchC[*]
constrainNet /StorageFIFO/DATA32_DTU_synch[*]
constrainNet /StorageFIFO/FIFO/CLK
constrainNet /StorageFIFO/FIFO/CLKA
constrainNet /StorageFIFO/FIFO/CLKB
constrainNet /StorageFIFO/FIFO/CLKC
constrainNet /StorageFIFO/FIFO/data_inputA[*]
constrainNet /StorageFIFO/FIFO/data_inputB[*]
constrainNet /StorageFIFO/FIFO/data_inputC[*]
constrainNet /StorageFIFO/FIFO/data_input[*]
constrainNet /StorageFIFO/FIFO/ptr_readA[*]
constrainNet /StorageFIFO/FIFO/ptr_readB[*]
constrainNet /StorageFIFO/FIFO/ptr_readC[*]
constrainNet /StorageFIFO/FIFO/ptr_read[*]
constrainNet /StorageFIFO/FIFO/ptr_writeA[*]
constrainNet /StorageFIFO/FIFO/ptr_writeB[*]
constrainNet /StorageFIFO/FIFO/ptr_writeC[*]
constrainNet /StorageFIFO/FIFO/ptr_write[*]
constrainNet /StorageFIFO/FIFO/r_decode_signal
constrainNet /StorageFIFO/FIFO/r_decode_signalA
constrainNet /StorageFIFO/FIFO/r_decode_signalB
constrainNet /StorageFIFO/FIFO/r_decode_signalC
constrainNet /StorageFIFO/FIFO/r_empty_signal
constrainNet /StorageFIFO/FIFO/r_empty_signalA
constrainNet /StorageFIFO/FIFO/r_empty_signalB
constrainNet /StorageFIFO/FIFO/r_empty_signalC
constrainNet /StorageFIFO/FIFO/r_full_signal
constrainNet /StorageFIFO/FIFO/r_full_signalA
constrainNet /StorageFIFO/FIFO/r_full_signalB
constrainNet /StorageFIFO/FIFO/r_full_signalC
constrainNet /StorageFIFO/FIFO/rst_b
constrainNet /StorageFIFO/FIFO/rst_bA
constrainNet /StorageFIFO/FIFO/rst_bB
constrainNet /StorageFIFO/FIFO/rst_bC
constrainNet /StorageFIFO/FIFO/start_write
constrainNet /StorageFIFO/FIFO/start_writeA
constrainNet /StorageFIFO/FIFO/start_writeB
constrainNet /StorageFIFO/FIFO/start_writeC
constrainNet /StorageFIFO/data_in_38A[*]
constrainNet /StorageFIFO/data_in_38B[*]
constrainNet /StorageFIFO/data_in_38C[*]
constrainNet /StorageFIFO/data_in_38[*]
constrainNet /StorageFIFO/data_out_32A[*]
constrainNet /StorageFIFO/data_out_32B[*]
constrainNet /StorageFIFO/data_out_32C[*]
constrainNet /StorageFIFO/data_out_32[*]
constrainNet /StorageFIFO/empty_signal
constrainNet /StorageFIFO/empty_signalA
constrainNet /StorageFIFO/empty_signalB
constrainNet /StorageFIFO/empty_signalC
constrainNet /StorageFIFO/fiforeset
constrainNet /StorageFIFO/fiforesetA
constrainNet /StorageFIFO/fiforesetB
constrainNet /StorageFIFO/fiforesetC
constrainNet /StorageFIFO/flush_b
constrainNet /StorageFIFO/flush_bA
constrainNet /StorageFIFO/flush_bB
constrainNet /StorageFIFO/flush_bC
constrainNet /StorageFIFO/read_signal
constrainNet /StorageFIFO/read_signalA
constrainNet /StorageFIFO/read_signalB
constrainNet /StorageFIFO/read_signalC
constrainNet /StorageFIFO/rst_b
constrainNet /StorageFIFO/rst_bA
constrainNet /StorageFIFO/rst_bB
constrainNet /StorageFIFO/rst_bC
constrainNet /StorageFIFO/start_write
constrainNet /StorageFIFO/start_writeA
constrainNet /StorageFIFO/start_writeB
constrainNet /StorageFIFO/start_writeC
constrainNet /StorageFIFO/synch
constrainNet /StorageFIFO/synchA
constrainNet /StorageFIFO/synchB
constrainNet /StorageFIFO/synchC
constrainNet /StorageFIFO/synch_patternA[*]
constrainNet /StorageFIFO/synch_patternB[*]
constrainNet /StorageFIFO/synch_patternC[*]
constrainNet /StorageFIFO/synch_pattern[*]
constrainNet /TEST_ENABLE
constrainNet /TEST_ENABLEA
constrainNet /TEST_ENABLEB
constrainNet /TEST_ENABLEC
constrainNet /shift_gain_10A[*]
constrainNet /shift_gain_10B[*]
constrainNet /shift_gain_10C[*]
constrainNet /shift_gain_10[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
