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


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
