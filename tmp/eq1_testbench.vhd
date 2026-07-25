-- Listing 1.1b - Testbench (adaptação)
library ieee;
use ieee.std_logic_1164.all;

entity eq1_testbench is
end eq1_testbench;

architecture tb_arch of eq1_testbench is
   signal test_in0, test_in1: std_logic;
   signal test_out: std_logic;
begin
   -- instancia o circuito sob test (uut - unit under test)
   uut: entity work.eq1(sop_arch)
      port map(i0=>test_in0, i1=>test_in1, eq=>test_out);
   -- gerador dos vetores de teste
   process
   begin
      -- vetor de teste 1
      test_in0 <= '0';
      test_in1 <= '0';
      wait for 200 ns;
	 -- vetor de teste 2
      test_in0 <= '0';
      test_in1 <= '1';
      wait for 200 ns;
      -- vetor de teste 3
      test_in0 <= '1';
      test_in1 <= '0';
      wait for 200 ns;
      -- vetor de teste 4
      test_in0 <= '1';
      test_in1 <= '1';
      wait for 200 ns;
      wait;
end process;
end tb_arch;
