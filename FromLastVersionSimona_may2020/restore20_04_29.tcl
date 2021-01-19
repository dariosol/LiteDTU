
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s038
#
#
# You can restore this configuration with:
#
#      ncsim -cdslib /export/elt159xl/disk0/users/cometti/project/LiTE-DTU_v1.2-simulations/pre-synth/cds.lib -logfile ncsim.log -errormax 15 -status worklib.tb_LDTU_presynth:module -tcl -update -input /export/elt159xl/disk0/users/cometti/project/LiTE-DTU_v1.2-simulations/pre-synth/restore20_04_29.tcl
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
probe -create -database waves tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrErrorC tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrErrorB tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrErrorA tb_LDTU_presynth.toptoplevel.tadc_test_unit.tmrError tb_LDTU_presynth.toptoplevel.tadc_test_unit.test_enable tb_LDTU_presynth.toptoplevel.tadc_test_unit.rst_bC tb_LDTU_presynth.toptoplevel.tadc_test_unit.rst_bB tb_LDTU_presynth.toptoplevel.tadc_test_unit.rst_bA tb_LDTU_presynth.toptoplevel.tadc_test_unit.clockC tb_LDTU_presynth.toptoplevel.tadc_test_unit.clockB tb_LDTU_presynth.toptoplevel.tadc_test_unit.clockA tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutLo tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutLe tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutHo tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataOutHe tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataInL tb_LDTU_presynth.toptoplevel.tadc_test_unit.DataInH tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.BSL_VAL_g01 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.BSL_VAL_g10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CALIBRATION_BUSY_10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CLK_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CLK_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.CLK_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA12_g01 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA12_g10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_0 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_2 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_3 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_ATU_0 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_ATU_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_ATU_2 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_ATU_3 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DCLK_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DCLK_10 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.GAIN_SEL_MODE tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RST_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RST_B tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.RST_C tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.SATURATION_value tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.TEST_ENABLE tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.handshake tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.losing_data tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.totalError tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.CLK_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.RST_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.CALIBRATION_BUSY_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.TEST_ENABLE_A tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.DATA32_DTU tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.DATA32_ATU_0 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.DATA32_ATU_1 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.DATA32_ATU_2 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.DATA32_ATU_3 tb_LDTU_presynth.toptoplevel.top_level_LiTE_DTU.DATA32_mux.DATA32_0
probe -create -database waves tb_LDTU_presynth.toptoplevel.Serializers.DataIn0 tb_LDTU_presynth.toptoplevel.Serializers.DataIn1 tb_LDTU_presynth.toptoplevel.Serializers.DataIn2 tb_LDTU_presynth.toptoplevel.Serializers.DataIn3 tb_LDTU_presynth.toptoplevel.Serializers.DataOut0 tb_LDTU_presynth.toptoplevel.Serializers.DataOut1 tb_LDTU_presynth.toptoplevel.Serializers.DataOut2 tb_LDTU_presynth.toptoplevel.Serializers.DataOut3 tb_LDTU_presynth.toptoplevel.Serializers.clock tb_LDTU_presynth.toptoplevel.Serializers.handshake tb_LDTU_presynth.toptoplevel.Serializers.rst_bA tb_LDTU_presynth.toptoplevel.Serializers.rst_bB tb_LDTU_presynth.toptoplevel.Serializers.rst_bC

simvision -input restore20_04_29.tcl.svcf
