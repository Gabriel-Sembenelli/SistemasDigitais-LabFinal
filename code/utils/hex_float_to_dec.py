# Given the hex displayed in the board, convert to its decimal format.
# Board displays H1 H2 and E, where
# H1 = hex of the first section of the fractional part (leftmost 4 bits)
# H2 = hex of the last section of the fractional part (rightmost 4 bits)
# E  = hex of the exponent
def hex_float_to_dec(h1: str, h2: str, e: str) -> float:
    # Convert concatenated H1 and H2 to a decimal integer
    fraction = int(h1 + h2, 16)
    
    # Convert exponent E to decimal
    exponent = int(e, 16)
    
    # Calculate final value: (fraction / 2^8) * 2^exponent
    return fraction * (2 ** (exponent - 8))

H1, H2, E = input().split()
print(f"Result: {hex_float_to_dec(H1, H2, E)}")