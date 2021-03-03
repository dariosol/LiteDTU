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

constrainNet /Orbit
constrainNet /OrbitA
constrainNet /OrbitB
constrainNet /OrbitC
constrainNet /baseline_flag
constrainNet /baseline_flagA
constrainNet /baseline_flagB
constrainNet /baseline_flagC
constrainNet /fallback
constrainNet /fallbackA
constrainNet /fallbackB
constrainNet /fallbackC
constrainNet /nStateA[*]
constrainNet /nStateB[*]
constrainNet /nStateC[*]
constrainNet /nStateVotedA[*]
constrainNet /nStateVotedB[*]
constrainNet /nStateVotedC[*]
constrainNet /nState_FBA[*]
constrainNet /nState_FBB[*]
constrainNet /nState_FBC[*]
constrainNet /nState_FBVotedA[*]
constrainNet /nState_FBVotedB[*]
constrainNet /nState_FBVotedC[*]
constrainNet /rCurrent_stateA[*]
constrainNet /rCurrent_stateB[*]
constrainNet /rCurrent_stateC[*]
constrainNet /rCurrent_state[*]
constrainNet /rCurrent_state_FBA[*]
constrainNet /rCurrent_state_FBB[*]
constrainNet /rCurrent_state_FBC[*]
constrainNet /rCurrent_state_FB[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
