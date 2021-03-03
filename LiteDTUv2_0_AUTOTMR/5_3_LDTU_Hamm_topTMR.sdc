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
constrainNet /FIFO/CLK
constrainNet /FIFO/CLKA
constrainNet /FIFO/CLKB
constrainNet /FIFO/CLKC
constrainNet /FIFO/data_inputA[*]
constrainNet /FIFO/data_inputB[*]
constrainNet /FIFO/data_inputC[*]
constrainNet /FIFO/data_input[*]
constrainNet /FIFO/full_signal
constrainNet /FIFO/full_signalA
constrainNet /FIFO/full_signalB
constrainNet /FIFO/full_signalC
constrainNet /FIFO/ptr_readA[*]
constrainNet /FIFO/ptr_readB[*]
constrainNet /FIFO/ptr_readC[*]
constrainNet /FIFO/ptr_read[*]
constrainNet /FIFO/ptr_writeA[*]
constrainNet /FIFO/ptr_writeB[*]
constrainNet /FIFO/ptr_writeC[*]
constrainNet /FIFO/ptr_write[*]
constrainNet /FIFO/rst_b
constrainNet /FIFO/rst_bA
constrainNet /FIFO/rst_bB
constrainNet /FIFO/rst_bC
constrainNet /FIFO/start_write
constrainNet /FIFO/start_writeA
constrainNet /FIFO/start_writeB
constrainNet /FIFO/start_writeC
constrainNet /data_in_38A[*]
constrainNet /data_in_38B[*]
constrainNet /data_in_38C[*]
constrainNet /data_in_38[*]
constrainNet /data_out_32A[*]
constrainNet /data_out_32B[*]
constrainNet /data_out_32C[*]
constrainNet /data_out_32[*]
constrainNet /decode_signal
constrainNet /decode_signalA
constrainNet /decode_signalB
constrainNet /decode_signalC
constrainNet /empty_signal
constrainNet /empty_signalA
constrainNet /empty_signalB
constrainNet /empty_signalC
constrainNet /read_signal
constrainNet /read_signalA
constrainNet /read_signalB
constrainNet /read_signalC
constrainNet /rst_b
constrainNet /rst_bA
constrainNet /rst_bB
constrainNet /rst_bC
constrainNet /start_write
constrainNet /start_writeA
constrainNet /start_writeB
constrainNet /start_writeC


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
