# Given a decimal integer, get its representation binary float
def dec_to_bin_float(n: int) -> str:
    if n == 0:
        return "0.00000000 * 2^0"
        
    # Get binary representation without '0b' prefix
    bin_str = bin(n)[2:]
    
    # The exponent is the length of the binary string
    #exponent_bin = bin(len(bin_str))[2:]
    exponent_bin = f"{len(bin_str):04b}"
    
    # Get the first 8 bits for the fraction, pad with right-side zeros if smaller
    fraction_bin = bin_str.ljust(8, '0')[:8]
    
    return f"0.{fraction_bin} * 2^{exponent_bin}"

n = int(input("Enter a base 10 number: "))
print(f"Binary float: {dec_to_bin_float(n)}")