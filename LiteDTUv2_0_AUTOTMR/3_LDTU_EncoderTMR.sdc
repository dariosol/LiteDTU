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

constrainNet /CLK
constrainNet /CLKA
constrainNet /CLKB
constrainNet /CLKC
constrainNet /Current_stateA[*]
constrainNet /Current_stateB[*]
constrainNet /Current_stateC[*]
constrainNet /Current_state[*]
constrainNet /Current_state_FBA[*]
constrainNet /Current_state_FBB[*]
constrainNet /Current_state_FBC[*]
constrainNet /Current_state_FB[*]
constrainNet /DATA_to_encA[*]
constrainNet /DATA_to_encB[*]
constrainNet /DATA_to_encC[*]
constrainNet /DATA_to_enc[*]
constrainNet /baseline_flag
constrainNet /baseline_flagA
constrainNet /baseline_flagB
constrainNet /baseline_flagC
constrainNet /fallback
constrainNet /fallbackA
constrainNet /fallbackB
constrainNet /fallbackC
constrainNet /fsm/CLK
constrainNet /fsm/CLKA
constrainNet /fsm/CLKB
constrainNet /fsm/CLKC
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
constrainNet /fsm/rCurrent_stateA[*]
constrainNet /fsm/rCurrent_stateB[*]
constrainNet /fsm/rCurrent_stateC[*]
constrainNet /fsm/rCurrent_state[*]
constrainNet /fsm/rCurrent_state_FBA[*]
constrainNet /fsm/rCurrent_state_FBB[*]
constrainNet /fsm/rCurrent_state_FBC[*]
constrainNet /fsm/rCurrent_state_FB[*]
constrainNet /fsm/rst_b
constrainNet /fsm/rst_bA
constrainNet /fsm/rst_bB
constrainNet /fsm/rst_bC
constrainNet /rDATA_32A[*]
constrainNet /rDATA_32B[*]
constrainNet /rDATA_32C[*]
constrainNet /rDATA_32[*]
constrainNet /rDATA_32_FBA[*]
constrainNet /rDATA_32_FBB[*]
constrainNet /rDATA_32_FBC[*]
constrainNet /rDATA_32_FB[*]
constrainNet /rLoad
constrainNet /rLoadA
constrainNet /rLoadB
constrainNet /rLoadC
constrainNet /rLoad_FB
constrainNet /rLoad_FBA
constrainNet /rLoad_FBB
constrainNet /rLoad_FBC
constrainNet /rst_b
constrainNet /rst_bA
constrainNet /rst_bB
constrainNet /rst_bC


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
