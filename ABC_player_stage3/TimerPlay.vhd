-- Timer delay counter (simply a down counter with parallel load)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimerDelay is
   generic(
      N: integer := 26;    -- number of bits (to count M clk cycles @ 100 MHz)
  		M: std_logic_vector := "10111110101111000010000000"  -- M = 50 000 000 (0.5 s @ 100 MHz)

--    N: integer := 20;    -- number of bits (to count M clk cycles @ 100 MHz)
--		M: std_logic_vector := "11110100001001000000"  -- M = 1 000 000 (10 us @ 100 MHz)
		
-- M and N will have to be adjusted according to the duration required for each note
-- e.g. for 0.5 sec we will have M = 50 000 000 and N = 26 bits
		
		);
   port(
      clk, reset: in std_logic;
		from_td_on: in std_logic;
      to_td_done: out std_logic
   );
end TimerDelay;

architecture arch of TimerDelay is
signal r_next, r_reg: unsigned(N-1 downto 0);

begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
	
   -- next-state logic
	process(r_reg, from_td_on)
   begin
		r_next <= r_reg;
      if (from_td_on = '1') then
			if (r_reg /= 0) then
				r_next <= r_reg - 1;
			else
				r_next <= unsigned(M);
			end if;
      end if;
   end process;
	
   -- output logic
   to_td_done <= '1' when r_reg=1 else '0';
	-- Comparing with 1 instead of 0 makes no difference in what concerns the value of the 
	-- delay (it's 1 in 50000000), and prevents the reset signal to assert the td_done output
	
end arch;