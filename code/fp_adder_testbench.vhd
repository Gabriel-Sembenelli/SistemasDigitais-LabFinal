library ieee;
use ieee.std_logic_1164.all;

entity fp_adder_tb is
end fp_adder_tb;

architecture tb_arch of fp_adder_tb is
    -- input signals
    signal t_sign1, t_sign2: std_logic;
    signal t_exp1, t_exp2: std_logic_vector(3 downto 0);
    signal t_frac1, t_frac2: std_logic_vector(7 downto 0);

    -- output signals
    signal t_sign_out: std_logic;
    signal t_exp_out: std_logic_vector(3 downto 0);
    signal t_frac_out: std_logic_vector(7 downto 0);
begin
    -- instantiate the unit under test (uut)
    uut: entity work.fp_adder(arch)
        port map(
            sign1 => t_sign1, sign2 => t_sign2,
            exp1 => t_exp1, exp2 => t_exp2,
            frac1 => t_frac1, frac2 => t_frac2,
            sign_out => t_sign_out,
            exp_out => t_exp_out,
            frac_out => t_frac_out
        );

    -- generate test vectors
    process
    begin
        -- test vector 1: sum with no special cases in normalization
        t_sign1 <= '0';
        t_exp1  <= "0111";
        t_frac1 <= "10000000";
        t_sign2 <= '0';
        t_exp2  <= "0101";
        t_frac2 <= "11000000";
        wait for 200 ns;

        -- test vector 2: sum with carry out
        t_sign1 <= '0';
        t_exp1  <= "0100";
        t_frac1 <= "10000000";
        t_sign2 <= '0';
        t_exp2  <= "0100";
        t_frac2 <= "10000000";
        wait for 200 ns;

        -- test vector 3: subtraction with left shift
        t_sign1 <= '0';
        t_exp1  <= "0101";
        t_frac1 <= "10001000";
        t_sign2 <= '1';
        t_exp2  <= "0101";
        t_frac2 <= "10000000";
        wait for 200 ns;
        
        -- test vector 4: subtraction w/ too small result
        t_sign1 <= '0';
        t_exp1  <= "0011";
        t_frac1 <= "11101000";
        t_sign2 <= '1';
        t_exp2  <= "0011";
        t_frac2 <= "11100000";
        wait for 200 ns;
        
        -- test vector 5: sum w/ exponent overflow
        t_sign1 <= '0';
        t_exp1  <= "1111";
        t_frac1 <= "11111000";
        t_sign2 <= '0';
        t_exp2  <= "1011";
        t_frac2 <= "10000000";
        wait for 200 ns;
        
        -- test vector 6: subtraction of equals w/ nonzero exponent
        t_sign1 <= '0';
        t_exp1  <= "1111";
        t_frac1 <= "11110000";
        t_sign2 <= '1';
        t_exp2  <= "1111";
        t_frac2 <= "11110000";
        wait for 200 ns;
        
        wait;
    end process;
end tb_arch;