
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s038
#
#
# You can restore this configuration with:
#
#      ncsim -cdslib /export/elt159xl/disk0/users/cometti/project/LiTE-DTU_v1.2-simulations/pre-synth/cds.lib -logfile ncsim.log -errormax 15 -status worklib.tb_LDTU_presynth:module -tcl -update -input restore20_04_27_2.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.AAA tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.BBB tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.BSL_VAL_g01 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.BSL_VAL_g10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CCC tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CLK_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CLK_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA12_g01 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA12_g10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA_32 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA_from_CU tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA_gain_01 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA_gain_10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA_to_enc tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DCLK_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DCLK_10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.GAIN_SEL_MODE tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.Load tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RD_to_SERIALIZER tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RST_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RST_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RST_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.SATURATION_value tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.TEST_ENABLE tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.TEST_ENABLE_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.TEST_ENABLE_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.TEST_ENABLE_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.baseline_flag tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.decode_signal tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.full tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.empty_signal tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CLK_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.read_signal tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.handshake tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_to_SER_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_to_SER_2 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_to_SER_3 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_to_SER_4 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.losing_data tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.write_signal tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.data_output_0_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.data_output_0_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.data_output_0_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.signal_flag tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.tmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.pointer_ser_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.pointer_ser_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.pointer_ser_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.pointer_serTmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.pointer_ser tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.output_ser_4 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.output_ser_3 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.output_ser_2 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.output_ser_1 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.handshake_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.handshake_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.handshake_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.handshakeTmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.handshake tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.decode_signal_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.decode_signal_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.decode_signal_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.decode_signal tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_4_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_4_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_4_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_3_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_3_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_3_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_2_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_2_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.data_to_ser_2_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.TEST_ENABLE_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.TEST_ENABLE_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.TEST_ENABLE_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.TEST_ENABLE tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.Serializer_4tmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.Serializer_3tmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.Serializer_2tmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.Serializer_1tmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.START_SER_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.START_SER_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.START_SER_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.START_SERTmrError tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.START_SER tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.RST_C tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.RST_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.RST_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.CLK_SRL
probe -create -database waves tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.CALIBRATION_BUSY_1 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.CALIBRATION_BUSY_10 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_ATU_1 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_ATU_2 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_ATU_3 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_ATU_4 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_1 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_2 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_3 tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_4
probe -create -database waves tb_LDTU_presynth.w_ser0 tb_LDTU_presynth.w_ser1 tb_LDTU_presynth.w_ser2 tb_LDTU_presynth.w_ser3 tb_LDTU_presynth.word_ser_0 tb_LDTU_presynth.word_ser_1 tb_LDTU_presynth.word_ser_2 tb_LDTU_presynth.word_ser_3 tb_LDTU_presynth.word
probe -create -database waves tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataInH tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataInL tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutHe tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutHo tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutLe tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutLo tb_LDTU_presynth.toptoplevel.tadc_test_unit.clockA tb_LDTU_presynth.toptoplevel.tadc_test_unit.clockB tb_LDTU_presynth.toptoplevel.tadc_test_unit.clockC tb_LDTU_presynth.toptoplevel.tadc_test_unit.rst_bA tb_LDTU_presynth.toptoplevel.tadc_test_unit.rst_bB tb_LDTU_presynth.toptoplevel.tadc_test_unit.rst_bC tb_LDTU_presynth.toptoplevel.tadc_test_unit.test_enable tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrError tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrErrorA tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrErrorB tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrErrorC
probe -create -database waves tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.empty_signal_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.empty_signal_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.StorageFIFO.empty_signal_C
probe -create -database waves tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_1_B tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_1_A tb_LDTU_presynth.toptoplevel.top_level_SER_TMRG.DATA32_DTU_1_C

simvision -input restore20_04_27_2.tcl.svcf
