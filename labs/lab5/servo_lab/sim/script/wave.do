onerror {resume}
radix define States {
    "10'b0000000001" "SWEEP RIGHT" -color "green",
    "10'b0000000010" "INT RIGHT" -color "purple",
    "10'b0000000011" "SWEEP LEFT" -color "orange",
    "10'b0000000100" "INT LEFT" -color "red",
    "10'b0000000101" "TEST STATE" -color "blue",
    -default hexadecimal
    -defaultcolor white
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /servo_controller_tb/CLOCK_50
add wave -noupdate /servo_controller_tb/reset
add wave -noupdate /servo_controller_tb/uut/servo_top/reset
add wave -noupdate /servo_controller_tb/LEDR
add wave -noupdate /servo_controller_tb/address
add wave -noupdate /servo_controller_tb/irq
add wave -noupdate /servo_controller_tb/uut/servo_top/write
add wave -noupdate -radix unsigned -radixshowbase 0 /servo_controller_tb/writedata
add wave -noupdate /servo_controller_tb/uut/servo_top/CurrentState
add wave -noupdate /servo_controller_tb/uut/servo_top/NextState
add wave -noupdate -radix unsigned /servo_controller_tb/uut/servo_top/angle_count
add wave -noupdate -radix unsigned /servo_controller_tb/uut/servo_top/period_count
add wave -noupdate -radix unsigned /servo_controller_tb/uut/servo_top/pulse_count
add wave -noupdate /servo_controller_tb/uut/servo_top/outwave
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17350000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {262500 ns}
