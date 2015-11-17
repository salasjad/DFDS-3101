
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity boud_rate_generator is

	generic (
					N : integer := 9; -- number of bits
					M : integer := 326 -- mod-m
				);
	
    Port ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           max_tick : out  STD_LOGIC; -- Connect this to 
           q : out  STD_LOGIC_VECTOR(N-1 downto 0)
			  
			  );
end boud_rate_generator;

architecture Behavioral of boud_rate_generator is
	
		
	signal r_reg : unsigned(N-1 downto 0) := (others => '0');
	signal r_next : unsigned(N-1 downto 0):= (others => '0');
	
begin
-- register
	process(clk, reset)
	begin
		if(reset = '1') then
			r_reg <= (others => '0');
		elsif (clk'event and clk='1') then
			r_reg <= r_next;
		end if; 
	end process; 
	--  next - state logic
	r_next <= (others=> '0') when r_reg = (M-1) else 
		r_reg + 1; 
	-- output logic
		q <= std_logic_vector(r_reg);
		max_tick <= '1' when r_reg = (M-1) else '0';
		
end Behavioral;

