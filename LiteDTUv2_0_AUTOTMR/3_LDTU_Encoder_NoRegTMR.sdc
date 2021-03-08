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

constrainNet /DATA_32_FB_synchA[*]
constrainNet /DATA_32_FB_synchB[*]
constrainNet /DATA_32_FB_synchC[*]
constrainNet /DATA_32_FB_synch[*]
constrainNet /DATA_32_synchA[*]
constrainNet /DATA_32_synchB[*]
constrainNet /DATA_32_synchC[*]
constrainNet /DATA_32_synch[*]
constrainNet /DATA_to_encA[*]
constrainNet /DATA_to_encB[*]
constrainNet /DATA_to_encC[*]
constrainNet /DATA_to_enc[*]
constrainNet /Load_FB_synch
constrainNet /Load_FB_synchA
constrainNet /Load_FB_synchB
constrainNet /Load_FB_synchC
constrainNet /Load_synch
constrainNet /Load_synchA
constrainNet /Load_synchB
constrainNet /Load_synchC
constrainNet /baseline_flag
constrainNet /baseline_flagA
constrainNet /baseline_flagB
constrainNet /baseline_flagC
constrainNet /fallback
constrainNet /fallbackA
constrainNet /fallbackB
constrainNet /fallbackC
constrainNet /fsm/Orbit
constrainNet /fsm/OrbitA
constrainNet /fsm/OrbitB
constrainNet /fsm/OrbitC
constrainNet /fsm/baseline_flag
constrainNet /fsm/baseline_flagA
constrainNet /fsm/baseline_flagB
constrainNet /fsm/baseline_flagC
constrainNet /fsm/fallback
constrainNet /fsm/fallbackA
constrainNet /fsm/fallbackB
constrainNet /fsm/fallbackC


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
