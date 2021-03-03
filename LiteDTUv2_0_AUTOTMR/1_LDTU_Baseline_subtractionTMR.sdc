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

constrainNet /BSL_VAL_g01A[*]
constrainNet /BSL_VAL_g01B[*]
constrainNet /BSL_VAL_g01C[*]
constrainNet /BSL_VAL_g01[*]
constrainNet /BSL_VAL_g10A[*]
constrainNet /BSL_VAL_g10B[*]
constrainNet /BSL_VAL_g10C[*]
constrainNet /BSL_VAL_g10[*]
constrainNet /DATA12_g01A[*]
constrainNet /DATA12_g01B[*]
constrainNet /DATA12_g01C[*]
constrainNet /DATA12_g01[*]
constrainNet /DATA12_g10A[*]
constrainNet /DATA12_g10B[*]
constrainNet /DATA12_g10C[*]
constrainNet /DATA12_g10[*]
constrainNet /DCLK_1
constrainNet /DCLK_10
constrainNet /DCLK_10A
constrainNet /DCLK_10B
constrainNet /DCLK_10C
constrainNet /DCLK_1A
constrainNet /DCLK_1B
constrainNet /DCLK_1C
constrainNet /dg01A[*]
constrainNet /dg01B[*]
constrainNet /dg01C[*]
constrainNet /dg01[*]
constrainNet /dg10A[*]
constrainNet /dg10B[*]
constrainNet /dg10C[*]
constrainNet /dg10[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
