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

constrainNet /DATA_32A[*]
constrainNet /DATA_32B[*]
constrainNet /DATA_32C[*]
constrainNet /DATA_32[*]
constrainNet /DATA_32_FBA[*]
constrainNet /DATA_32_FBB[*]
constrainNet /DATA_32_FBC[*]
constrainNet /DATA_32_FB[*]
constrainNet /DATA_from_CU_synchA[*]
constrainNet /DATA_from_CU_synchB[*]
constrainNet /DATA_from_CU_synchC[*]
constrainNet /DATA_from_CU_synch[*]
constrainNet /Load_data
constrainNet /Load_dataA
constrainNet /Load_dataB
constrainNet /Load_dataC
constrainNet /Load_data_FB
constrainNet /Load_data_FBA
constrainNet /Load_data_FBB
constrainNet /Load_data_FBC
constrainNet /fallback
constrainNet /fallbackA
constrainNet /fallbackB
constrainNet /fallbackC
constrainNet /full
constrainNet /fullA
constrainNet /fullB
constrainNet /fullC
constrainNet /handshake
constrainNet /handshakeA
constrainNet /handshakeB
constrainNet /handshakeC
constrainNet /losing_data_synch
constrainNet /losing_data_synchA
constrainNet /losing_data_synchB
constrainNet /losing_data_synchC
constrainNet /read_signal_synch
constrainNet /read_signal_synchA
constrainNet /read_signal_synchB
constrainNet /read_signal_synchC
constrainNet /write_signal_synch
constrainNet /write_signal_synchA
constrainNet /write_signal_synchB
constrainNet /write_signal_synchC


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
