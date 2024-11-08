# Python script to turn the coefficient constants into hex values use fixed point math.
low_pass_values = [
    0.0025,
    0.0057,
    0.0147,
    0.0315,
    0.0555,
    0.0834,
    0.1099,
    0.1289,
    0.1358,
    0.1289,
    0.1099,
    0.0834,
    0.0555,
    0.0315,
    0.0147,
    0.0057,
    0.0025,
]

high_pass_values = [0.0019, -0.0031, -0.0108, 0.0, 0.0407]


def decimal_to_hex(val):
    # Calculate the result of the expression
    ans = val * (2**15)
    rounded_ans = round(ans)

    # Check if the number is negative
    if rounded_ans < 0:
        # Apply two's complement for 16-bit representation
        rounded_ans = (1 << 16) + rounded_ans

    # Format to hexadecimal with zero-padding for two bytes
    hex_value = f'X"{rounded_ans:04X}"'
    return hex_value


# print("\n-- low pass values")
# num = 0
# for i in low_pass_values:
#     print(f"datab_signals({num})  <= {decimal_to_hex(i)};")
#     num = num + 1


# print("\n-- high pass values")
# num = 0
# for i in high_pass_values:
#     print(f"datab_signals({num})  <= {decimal_to_hex(i)};")
#     num = num + 1


def float_to_hex(val):
    temp = val * (2**15)
    temp = f'X"{temp:04X}"'

    return temp


print("\n-- high pass values")
num = 0
for i in high_pass_values:
    print(f"{i} = {float_to_hex(i)};")
    num = num + 1
