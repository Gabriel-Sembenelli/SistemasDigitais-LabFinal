library ieee;
use ieee.std_logic_1164.all;

entity hex_to_sseg is
    port(
        hex: in std_logic_vector(3 downto 0);
        dp: in std_logic;
        sseg: out std_logic_vector(7 downto 0)
    );
end hex_to_sseg;

architecture arch of hex_to_sseg is
begin
    with hex select
    sseg (6 downto 0) <=
        "1000000" when "0000", -- 0 1000000 
        "1111001" when "0001", -- 1 1111001
        "0100100" when "0010", -- 2 0100100
        "0110000" when "0011", -- 3 0110000
        "0011001" when "0100", -- 4 0011001
        "0010010" when "0101", -- 5 0010010
        "0000010" when "0110", -- 6 0000010
        "1111000" when "0111", -- 7 1111000
        "0000000" when "1000", -- 8 0000000
        "0010000" when "1001", -- 9 0010000
        "0001000" when "1010", -- a 0001000
        "0000011" when "1011", -- b 0000011
        "1000110" when "1100", -- c 1000110
        "0100001" when "1101", -- d 0100001
        "0000110" when "1110", -- e 0000110
        "0001110" when others; -- f 0001110
    sseg (7) <= dp;
end arch;