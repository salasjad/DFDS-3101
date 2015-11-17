library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
--

entity T_FF is
    Port ( 
			clk, reset: in std_logic;
			from_t_in: in std_logic;
			from_clr_FF: in std_logic;
			to_ldspkr: out std_logic
			);
end T_FF;

architecture Behavioral of T_FF is

signal r_reg, r_next: std_logic;

begin
	-- T FF
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <='0';
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
	
   -- next-state logic
	process(r_reg, from_clr_FF, from_t_in)
   begin
	if (from_clr_FF = '1') then
		r_next <= '0';
	elsif (from_t_in = '1') then
		r_next <= not(r_reg);
	else
		r_next <= r_reg;
	end if;
	end process;

   -- output logic
   to_ldspkr <= r_reg;
	
end Behavioral;