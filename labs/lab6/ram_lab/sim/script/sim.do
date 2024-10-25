vlib work
vcom -93 -work work ../../src/components.vhd
vcom -93 -work work ../../src/top.vhd
vcom -93 -work work ../../src/servo_controller.vhd
vcom -93 -work work ../src/servo_controller_tb.vhd

vsim -voptargs=+acc servo_controller_tb
do wave.do
run 250 us