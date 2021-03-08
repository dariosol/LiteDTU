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
constrainNet /DATA_32A[*]
constrainNet /DATA_32B[*]
constrainNet /DATA_32C[*]
constrainNet /DATA_32[*]
constrainNet /Load_data
constrainNet /Load_dataA
constrainNet /Load_dataB
constrainNet /Load_dataC
constrainNet /check_limit
constrainNet /check_limitA
constrainNet /check_limitB
constrainNet /check_limitC
constrainNet /fallback
constrainNet /fallbackA
constrainNet /fallbackB
constrainNet /fallbackC
constrainNet /full
constrainNet /fullA
constrainNet /fullB
constrainNet /fullC
constrainNet /rst_b
constrainNet /rst_bA
constrainNet /rst_bB
constrainNet /rst_bC
constrainNet /wireTrailerA[*]
constrainNet /wireTrailerB[*]
constrainNet /wireTrailerC[*]
constrainNet /wireTrailer[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
