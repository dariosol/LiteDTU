onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {NO TMR}
add wave -noupdate -divider INPUT
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DCLK_1
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DCLK_10
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/Orbit
add wave -noupdate /tb_LDTU_presynth/toptoplevel/DATA12_g10
add wave -noupdate /tb_LDTU_presynth/toptoplevel/DATA12_g01
add wave -noupdate -divider -height 30 {BASELINE SUB}
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/BSL_VAL_g01
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/BSL_VAL_g10
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/B_subtraction/DATA12_g01
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/B_subtraction/DATA12_g10
add wave -noupdate -divider -height 30 iFIFO
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Selection/DATA_gain_01
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Selection/DATA_gain_10
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Selection/DATA_to_enc
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Selection/baseline_flag
add wave -noupdate -divider -height 30 ENCODER
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/fsm/Current_state
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/fsm/baseline_flag
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/DATA_to_enc
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/Current_state
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/Load
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Encoder/DATA_32
add wave -noupdate -divider -height 30 {Control Unit}
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/handshake
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/Load_data
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/DATA_32
add wave -noupdate -radix unsigned /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/NSample
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/NFrame
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/read_signal
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/write_signal
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/DATA_from_CU
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/wireTrailer
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/losing_data
add wave -noupdate -color Red -itemcolor Red /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/full
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/Control_Unit/check_limit
add wave -noupdate -divider -height 30 oFIFO
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/data_in_32
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/Hamming_32_38/start_write
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/Hamming_32_38/data_input
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/full_signal
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/read_signal
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/data_input
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/decode_signal
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/data_output
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/Hamming_32_38/write_signal
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/start_write
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/ptr_write
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/ptr_read
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/FIFO/memory
add wave -noupdate /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/StorageFIFO/DATA32_DTU
add wave -noupdate -divider -height 30 {OUTPUT DATA}
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_0
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_1
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_2
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_3
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_ATU_0
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_ATU_1
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_ATU_2
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_ATU_3
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/GAIN_SEL_MODE
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/SATURATION_value
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/TEST_ENABLE
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/losing_data
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/totalError
add wave -noupdate -color {Spring Green} -itemcolor {Spring Green} -radix hexadecimal -childformat {{{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[31]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[30]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[29]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[28]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[27]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[26]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[25]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[24]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[23]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[22]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[21]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[20]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[19]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[18]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[17]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[16]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[15]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[14]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[13]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[12]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[11]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[10]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[9]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[8]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[7]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[6]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[5]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[4]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[3]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[2]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[1]} -radix hexadecimal} {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[0]} -radix hexadecimal}} -subitemconfig {{/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[31]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[30]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[29]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[28]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[27]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[26]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[25]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[24]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[23]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[22]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[21]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[20]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[19]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[18]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[17]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[16]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[15]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[14]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[13]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[12]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[11]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[10]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[9]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[8]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[7]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[6]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[5]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[4]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[3]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[2]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[1]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal} {/tb_LDTU_presynth/toptoplevel/Serializers/DataIn0[0]} {-color {Spring Green} -height 16 -itemcolor {Spring Green} -radix hexadecimal}} /tb_LDTU_presynth/toptoplevel/Serializers/DataIn0
add wave -noupdate -color {Spring Green} -itemcolor {Spring Green} -radix hexadecimal /tb_LDTU_presynth/toptoplevel/Serializers/DataIn1
add wave -noupdate -color {Spring Green} -itemcolor {Spring Green} -radix hexadecimal /tb_LDTU_presynth/toptoplevel/Serializers/DataIn2
add wave -noupdate -color {Spring Green} -itemcolor {Spring Green} -radix hexadecimal /tb_LDTU_presynth/toptoplevel/Serializers/DataIn3
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/Serializers/rst_bA
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/Serializers/rst_bB
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/Serializers/rst_bC
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_1
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_2
add wave -noupdate -color White /tb_LDTU_presynth/toptoplevel/top_level_LiTE_DTU/DATA32_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {305760000 ps} 0} {{Cursor 2} {319056 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 160
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {3996601984 ps}
