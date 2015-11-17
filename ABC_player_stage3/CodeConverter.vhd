
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 


entity CodeConverter is
    Port (			  from_dout : in  STD_LOGIC_VECTOR (7 downto 0);
           to_m_in : out  STD_LOGIC_VECTOR (17 downto 0)
			  );
end CodeConverter;

	
architecture Behavioral of CodeConverter is

begin

process(from_dout)

begin		
	case from_dout is						
				 when "01000011" =>   to_m_in <= "101110101010001001"; -- C4: 43H (C)
			    when "01000100" =>   to_m_in <= "101001100100010110"; -- D4: 44H (D) 
			    when "01000101" =>   to_m_in <= "100101000010000110"; -- E4: 45H (E) 
			    when "01000110" =>   to_m_in <= "100010111101000101"; -- F4: 46H (F) 
			    when "01000111" =>   to_m_in <= "011111001001000001"; -- G4: 47H (G) 
			    when "01000001" =>   to_m_in <= "011011101111100100"; -- A4: 41H (A) 
			    when "01000010" =>   to_m_in <= "011000101101110111"; -- B4: 42H (B) 
			    when "01100011" =>   to_m_in <= "010111010101000100"; -- c5: 63H (c) 
			    when "01100100" =>   to_m_in <= "010100110010001011"; -- d5: 64H (d) 
			    when "01100101" =>   to_m_in <= "010010100001000011"; -- e5: 65H (e) 
			    when "01100110" =>   to_m_in <= "010001011110100010"; -- f5: 66H (f) 
			    when "01100111" =>   to_m_in <= "001111100100100000"; -- g5: 67H (g) 
			    when "01100001" =>   to_m_in <= "001101110111110010"; -- a5: 61H (a) 
			    when "01100010" =>   to_m_in <= "001100010110111011"; -- b5: 62H (b) 
			    when others 	  =>   to_m_in <= "000000000000000001";    
	end case; 
end process; 

end Behavioral;


