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

constrainNet /DATA_gain_01A[*]
constrainNet /DATA_gain_01B[*]
constrainNet /DATA_gain_01C[*]
constrainNet /DATA_gain_01[*]
constrainNet /DATA_gain_10A[*]
constrainNet /DATA_gain_10B[*]
constrainNet /DATA_gain_10C[*]
constrainNet /DATA_gain_10[*]
constrainNet /DCLK_1
constrainNet /DCLK_10
constrainNet /DCLK_10A
constrainNet /DCLK_10B
constrainNet /DCLK_10C
constrainNet /DCLK_1A
constrainNet /DCLK_1B
constrainNet /DCLK_1C
constrainNet /GAIN_SEL_MODEA[*]
constrainNet /GAIN_SEL_MODEB[*]
constrainNet /GAIN_SEL_MODEC[*]
constrainNet /GAIN_SEL_MODE[*]
constrainNet /SATURATION_valueA[*]
constrainNet /SATURATION_valueB[*]
constrainNet /SATURATION_valueC[*]
constrainNet /SATURATION_value[*]
constrainNet /bsflag
constrainNet /bsflagA
constrainNet /bsflagB
constrainNet /bsflagC
constrainNet /d2encA[*]
constrainNet /d2encB[*]
constrainNet /d2encC[*]
constrainNet /d2enc[*]
constrainNet /shift_gain_10A[*]
constrainNet /shift_gain_10B[*]
constrainNet /shift_gain_10C[*]
constrainNet /shift_gain_10[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
