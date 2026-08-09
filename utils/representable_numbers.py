# Get all the numbers that the board can represent (ignoring signal)
representable_numbers = set()

for i in range(512):
    # Get the 9-bit binary string representation
    b = f"{i:09b}"
    
    # Split into fractional (first 5 bits) and exponent bits (last 4 bits)
    fractional_bits = b[:5] + "000" # Rightmost three bits are fixed in 0
    exponent_bits = b[5:]
    
    # "0.B1 B2 B3 B4 B5 0 0 0" in binary is the integer value of those bits divided by 2^8
    fractional = int(fractional_bits, 2) / 2**8
    
    # Exponent is straightforward base 2 conversion
    exponent = int(exponent_bits, 2)
    
    # Calculate final decimal value
    value = fractional * (2 ** exponent)
    representable_numbers.add(value)

# Print sorted, unique values
for num in sorted(representable_numbers):
    print(f"{num:g}")
