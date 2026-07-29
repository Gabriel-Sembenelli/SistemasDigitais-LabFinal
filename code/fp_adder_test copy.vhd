library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_test is
    port(
        MAX10_CLK1_50 : in std_logic;
        SW            : in std_logic_vector(9 downto 0);
        KEY           : in std_logic_vector(1 downto 0);
        HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(7 downto 0)
    );
end fp_adder_test;

architecture arch of fp_adder_test is
    -- Internal registers initialized to zero
    signal sign1, sign2: std_logic := '0';
    signal exp1, exp2: std_logic_vector(3 downto 0) := (others => '0');
    signal frac1, frac2: std_logic_vector(7 downto 0) := (others => '0');
    
    -- Outputs from fp_adder
    signal sign_out: std_logic;
    signal exp_out: std_logic_vector(3 downto 0);
    signal frac_out: std_logic_vector(7 downto 0);
begin

    -- Sequential logic for time-multiplexing inputs
    process(MAX10_CLK1_50)
    begin
        if rising_edge(MAX10_CLK1_50) then
            if KEY(1) = '0' then
                if KEY(0) = '0' then
                    sign1 <= SW(9);
                    frac1 <= SW(8 downto 4) & "000"; -- Pad the 3 missing bits
                    exp1  <= SW(3 downto 0);
                else
                    sign2 <= SW(9);
                    frac2 <= SW(8 downto 4) & "000"; -- Pad the 3 missing bits
                    exp2  <= SW(3 downto 0);
                end if;
            end if;
        end if;
    end process;

    -- Instantiate fp adder
    fp_add_unit: entity work.fp_adder
        port map (
            sign1=>sign1, sign2=>sign2, exp1=>exp1, exp2=>exp2,
            frac1=>frac1, frac2=>frac2,
            sign_out=>sign_out, exp_out=>exp_out,
            frac_out=>frac_out
        );

    -- HEX5: Signal / Sign ('-' if 1, blank if 0)
    HEX5 <= "10111111" when sign_out = '1' else "11111111";

    -- HEX4: Just a dot (Bit 7 is DP)
    HEX4 <= "01111111";

    -- HEX3: 4 MSBs of fraction
    sseg_unit_frac_high: entity work.hex_to_sseg
        port map (hex=>frac_out(7 downto 4), dp=>'1', sseg=>HEX3);

    -- HEX2: 4 LSBs of fraction
    sseg_unit_frac_low: entity work.hex_to_sseg
        port map (hex=>frac_out(3 downto 0), dp=>'1', sseg=>HEX2);

    -- HEX1: Letter 'E' as an abbreviation of "times 2 to the power of"
    HEX1 <= "10000110";

    -- 6. HEX0: Exponent
    sseg_unit_exp: entity work.hex_to_sseg
        port map (hex=>exp_out, dp=>'1', sseg=>HEX0);

end arch;