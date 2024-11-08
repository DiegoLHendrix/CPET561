# Overview
1. Developed the low pass and high pass filter VHDL component based on the specified requirements:
    - Inputs: 50 MHz clock, inverse reset, filter enable, 16-bit vector data_in.
    - Outputs: 16-bit vector data_out.
2. In quartus, I generated an LPM_MULT IP to use in the filters.
3. Created two 16-bit arrays: one to hold 16 std_logic_vector elements (each 16 bits), and another to store 32-bit data output values.
4. Wrote a Python script to convert the filter coefficient constants into hexadecimal values using 16-bit fixed-point math.
5. Used generate to instantiate 16 instances of the multiplier IP.

# Low Pass Filter Architucture
1. 