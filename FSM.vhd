
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 



entity FSM is
port (
		clk, reset : in std_logic;
		from_rx_done_tick : in std_logic; 
		from_dout : in std_logic_vector(7 downto 0); 
		to_clr_FF : out std_logic
);

end FSM;

architecture Behavioral of FSM is

	type state_type is (mute,play);
	signal state_next, state_reg: state_type; 
	
begin
	--state register
process(clk, reset)	
	begin 
		if(reset = '1') then
			state_reg <= mute; 		elsif(clk'event and clk ='1') then
			state_reg <= state_next; 
		end if; 
 end process; 
 
 
 -- next state and output logic
 process(state_reg, from_rx_done_tick, from_dout)
	begin
		state_next <= state_reg;
		to_clr_FF <= '0';
		
			case state_reg is
				when mute =>
				 to_clr_FF <= '1';
				 if (from_rx_done_tick = '1') then
					   if (from_dout <= "00110001") then
							state_next <= play;  
						end if;  
				 end if;
			
				when play =>
					if(from_rx_done_tick = '1') then
						if (from_dout <= "00110001") then
						state_next <= play;
						else
						state_next <= mute;
						end if;
				end if; 
	end case;
end process;

end Behavioral;

