# Diego Lopez
# Based on template by Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "int_lab"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name QIP_FILE ../../nios_system/synthesis/nios_system.qip
set_global_assignment -name VHDL_FILE ../../src/top.vhd

# 3] assign signals
set_location_assignment PIN_AF14 -to CLOCK_50

set_location_assignment PIN_Y16 -to KEY[3]
set_location_assignment PIN_W15 -to KEY[2]
set_location_assignment PIN_AA15 -to KEY[1]
set_location_assignment PIN_AA14 -to KEY[0]

set_location_assignment PIN_Y21 -to LEDR[9]
set_location_assignment PIN_W21 -to LEDR[8]
set_location_assignment PIN_W20 -to LEDR[7]
set_location_assignment PIN_Y19 -to LEDR[6]
set_location_assignment PIN_W19 -to LEDR[5]
set_location_assignment PIN_W17 -to LEDR[4]
set_location_assignment PIN_V18 -to LEDR[3]
set_location_assignment PIN_V17 -to LEDR[2]
set_location_assignment PIN_W16 -to LEDR[1]
set_location_assignment PIN_V16 -to LEDR[0]

set_location_assignment PIN_AE12 -to SW[9]
set_location_assignment PIN_AD10 -to SW[8]
set_location_assignment PIN_AC9 -to SW[7]
set_location_assignment PIN_AE11 -to SW[6]
set_location_assignment PIN_AD12 -to SW[5]
set_location_assignment PIN_AD11 -to SW[4]
set_location_assignment PIN_AF10 -to SW[3]
set_location_assignment PIN_AF9 -to SW[2]
set_location_assignment PIN_AC12 -to SW[1]
set_location_assignment PIN_AB12 -to SW[0]

set_location_assignment PIN_AE26 -to HEX0[0]
set_location_assignment PIN_AE27 -to HEX0[1]
set_location_assignment PIN_AE28 -to HEX0[2]
set_location_assignment PIN_AG27 -to HEX0[3]
set_location_assignment PIN_AF28 -to HEX0[4]
set_location_assignment PIN_AG28 -to HEX0[5]
set_location_assignment PIN_AH28 -to HEX0[6]

# set_location_assignment PIN_AJ29 -to HEX1[0]
# set_location_assignment PIN_AH29 -to HEX1[1]
# set_location_assignment PIN_AH30 -to HEX1[2]
# set_location_assignment PIN_AG30 -to HEX1[3]
# set_location_assignment PIN_AF29 -to HEX1[4]
# set_location_assignment PIN_AF30 -to HEX1[5]
# set_location_assignment PIN_AD27 -to HEX1[6]

# set_location_assignment PIN_AB23 -to HEX2[0]
# set_location_assignment PIN_AE29 -to HEX2[1]
# set_location_assignment PIN_AD29 -to HEX2[2]
# set_location_assignment PIN_AC28 -to HEX2[3]
# set_location_assignment PIN_AD30 -to HEX2[4]
# set_location_assignment PIN_AC29 -to HEX2[5]
# set_location_assignment PIN_AC30 -to HEX2[6]

# set_location_assignment PIN_AD26 -to HEX3[0]
# set_location_assignment PIN_AC27 -to HEX3[1]
# set_location_assignment PIN_AD25 -to HEX3[2]
# set_location_assignment PIN_AC25 -to HEX3[3]
# set_location_assignment PIN_AB28 -to HEX3[4]
# set_location_assignment PIN_AB25 -to HEX3[5]
# set_location_assignment PIN_AB22 -to HEX3[6]

# set_location_assignment PIN_AA24 -to HEX4[0]
# set_location_assignment PIN_Y23  -to HEX4[1]
# set_location_assignment PIN_Y24  -to HEX4[2]
# set_location_assignment PIN_W22  -to HEX4[3]
# set_location_assignment PIN_W24  -to HEX4[4]
# set_location_assignment PIN_V23  -to HEX4[5]
# set_location_assignment PIN_W25  -to HEX4[6]

# set_location_assignment PIN_V25  -to HEX5[0]
# set_location_assignment PIN_AA28 -to HEX5[1]
# set_location_assignment PIN_Y27  -to HEX5[2]
# set_location_assignment PIN_AB27 -to HEX5[3]
# set_location_assignment PIN_AB26 -to HEX5[4]
# set_location_assignment PIN_AA26 -to HEX5[5]
# set_location_assignment PIN_AA25 -to HEX5[6]

execute_flow -compile
project_close