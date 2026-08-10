-- parametros para executar
-- ghdl -r fp_adder_test_tb --wave=wave_fp_adder_test.ghw --stop-time=700ns
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_test_tb is
end entity;

architecture sim of fp_adder_test_tb is

    component fp_adder_test is
        port(
            MAX10_CLK1_50 : in std_logic;
            SW            : in std_logic_vector(9 downto 0);
            KEY           : in std_logic_vector(1 downto 0);
            HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal operation_boundary : std_logic := '0';
    signal SW  : std_logic_vector(9 downto 0) := (others => '0');
    signal KEY : std_logic_vector(1 downto 0) := "11";  -- idle = no load
    signal HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 20 ns;  -- 50 MHz

    -- Loads one operand into the DUT via SW/KEY, one clock edge, then
    -- de-asserts KEY so nothing else gets clocked in by accident.
        procedure load_operand(
        signal   SW_sig  : out std_logic_vector(9 downto 0);
        signal   KEY_sig : out std_logic_vector(1 downto 0);
        constant sign    : std_logic;
        constant frac_hi : std_logic_vector(4 downto 0); -- frac(7 downto 3), low 3 bits padded 0
        constant exp     : std_logic_vector(3 downto 0);
        constant sel     : std_logic  -- '0' -> operand1, '1' -> operand2
    ) is
    begin
        SW_sig  <= sign & frac_hi & exp;
        KEY_sig <= '0' & sel;
        wait until rising_edge(clk);
        wait for 1 ns;           -- let the clocked assignment resolve
        KEY_sig <= "11";         -- stop loading
        wait for 1 ns;
    end procedure;

begin

    uut: fp_adder_test
        port map (
            MAX10_CLK1_50 => clk,
            SW   => SW,
            KEY  => KEY,
            HEX5 => HEX5, HEX4 => HEX4, HEX3 => HEX3,
            HEX2 => HEX2, HEX1 => HEX1, HEX0 => HEX0
        );

    clk_gen: process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim: process
    begin

        wait for 5 ns;

        
        -- test vector 1: sum with no special cases in normalization
        operation_boundary <= '1';
        load_operand(SW, KEY, '0', "10000", "0111", '0'); -- SW, KEY, sign, frac[7:3], exp, selector
        load_operand(SW, KEY, '0', "11000", "0101", '1');
        operation_boundary <= '0';
        wait for CLK_PERIOD * 2;
 
        -- test vector 2: sum with carry out
        operation_boundary <= '1';
        load_operand(SW, KEY, '0', "10000", "0100", '0'); -- aqui vai dar diferenca no testbench do fp_adder, já que estamos limitados a 10 bits
        load_operand(SW, KEY, '0', "10000", "0100", '1');
        operation_boundary <= '0';
        wait for CLK_PERIOD * 2;
 
        -- test vector 3: subtraction with left shift
        operation_boundary <= '1';
        load_operand(SW, KEY, '0', "10001", "0101", '0');
        load_operand(SW, KEY, '1', "10000", "0101", '1');
        operation_boundary <= '0';
        wait for CLK_PERIOD * 2;
 
        -- test vector 4: subtraction w/ too small result
        operation_boundary <= '1';
        load_operand(SW, KEY, '0', "11101", "0011", '0');
        load_operand(SW, KEY, '1', "11100", "0011", '1'); -- aqui tbm
        operation_boundary <= '0';
        wait for CLK_PERIOD * 2;

        wait for 5000 ns;
    end process;

end architecture;
