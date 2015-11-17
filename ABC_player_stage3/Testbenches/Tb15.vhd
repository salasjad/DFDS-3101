--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:11:22 10/24/2014
-- Design Name:   
-- Module Name:   C:/Users/Dler/Dropbox/Code/VHDL/Stage3/Tb15.vhd
-- Project Name:  NeverGiveUp
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ABC_Main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Tb15 IS
END Tb15;
 
ARCHITECTURE behavior OF Tb15 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ABC_Main
    PORT(
         rx : IN  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic;
         txUt : OUT  std_logic;
         loudspeaker : OUT  std_logic;
         play : IN  std_logic;
         recordi : IN  std_logic;
         leds : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rx : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal play : std_logic := '0';
   signal recordi : std_logic := '0';

 	--Outputs
   signal txUt : std_logic;
   signal loudspeaker : std_logic;
   signal leds : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ABC_Main PORT MAP (
          rx => rx,
          clk => clk,
          reset => reset,
          txUt => txUt,
          loudspeaker => loudspeaker,
          play => play,
          recordi => recordi,
          leds => leds
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

    -- Stimulus process
   stim_proc: process
   begin		
      reset <= '1';
		play <= '0';
		recordi <= '0';
      wait for 100 ns;
		reset <= '0';
		rx <= '1';		-- idle for a while
      wait for clk_period*10;
		
		wait for 3 ms;  
		
		recordi <= '1'; 
		
		wait for 3 ms;
		
		-- send data word 01100111 (msb at left): g5: 67H (g) 
		rx <= '0';		-- start bit
      wait for 52083 ns;
		rx <= '1';		-- data bit #1 (lsb)
      wait for 52083 ns;
		rx <= '1';		-- data bit #2
      wait for 52083 ns;
		rx <= '1';		-- data bit #3
      wait for 52083 ns;
		rx <= '0';		-- data bit #4
      wait for 52083 ns;
		rx <= '0';		-- data bit #5
      wait for 52083 ns;
		rx <= '1';		-- data bit #6
      wait for 52083 ns;
		rx <= '1';		-- data bit #7
      wait for 52083 ns;
		rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
		rx <= '1';		-- stop bit
      wait for 52083 ns;
		rx <= '1';		-- idle for a while
      wait for clk_period*10;
		
		wait for 3 ms; 
		
		-- send data word 01000110 (msb at left): F4: 46H (F) 
		rx <= '0';		-- start bit
      wait for 52083 ns;
		rx <= '0';		-- data bit #1 (lsb)
      wait for 52083 ns;
		rx <= '1';		-- data bit #2
      wait for 52083 ns;
		rx <= '1';		-- data bit #3
      wait for 52083 ns;
		rx <= '0';		-- data bit #4
      wait for 52083 ns;
		rx <= '0';		-- data bit #5
      wait for 52083 ns;
		rx <= '0';		-- data bit #6
      wait for 52083 ns;
		rx <= '1';		-- data bit #7
      wait for 52083 ns;
		rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
		rx <= '1';		-- stop bit
      wait for 52083 ns;
		rx <= '1';		-- idle for a while
      wait for clk_period*10;
		
	   wait for 3 ms;   
		
		-- send data word 01100100 (msb at left): d5: 64H (d)
		rx <= '0';		-- start bit
      wait for 52083 ns;
		rx <= '0';		-- data bit #1 (lsb)
      wait for 52083 ns;
		rx <= '0';		-- data bit #2
      wait for 52083 ns;
		rx <= '1';		-- data bit #3
      wait for 52083 ns;
		rx <= '0';		-- data bit #4
      wait for 52083 ns;
		rx <= '0';		-- data bit #5
      wait for 52083 ns;
		rx <= '1';		-- data bit #6
      wait for 52083 ns;
		rx <= '1';		-- data bit #7
      wait for 52083 ns;
		rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
		rx <= '1';		-- stop bit
      wait for 52083 ns;
		rx <= '1';		-- idle for a while
      wait for clk_period*10;  
		
		wait for 3 ms; 
		
		recordi <= '0';
		
--		play <= '1';
--		wait for clk_period*10;
--		play <= '0';

--      wait for 22000000 ns;
		
--		play <= '1'
--		wait for clk_period*10;

 --     wait for 8000000 ns;		
		
      wait;
   end process;


			  --  when "01000011" =>   to_m_in <= "101110101010001001"; -- C4: 43H (C)
			  --  when "01000100" =>   to_m_in <= "101001100100010110"; -- D4: 44H (D) 
			  --  when "01000101" =>   to_m_in <= "100101000010000110"; -- E4: 45H (E) 
			  --  when "01000110" =>   to_m_in <= "100010111101000101"; -- F4: 46H (F) 
			  --  when "01000111" =>   to_m_in <= "011111001001000001"; -- G4: 47H (G) 
			  --  when "01000001" =>   to_m_in <= "011011101111100100"; -- A4: 41H (A) 
			  --  when "01000010" =>   to_m_in <= "011000101101110111"; -- B4: 42H (B) 
			  --  when "01100011" =>   to_m_in <= "010111010101000100"; -- c5: 63H (c) 
			  --  when "01100100" =>   to_m_in <= "010100110010001011"; -- d5: 64H (d) 
			  --  when "01100101" =>   to_m_in <= "010010100001000011"; -- e5: 65H (e) 
			  --  when "01100110" =>   to_m_in <= "010001011110100010"; -- f5: 66H (f) 
			  --  when "01100111" =>   to_m_in <= "001111100100100000"; -- g5: 67H (g) 
			  --  when "01100001" =>   to_m_in <= "001101110111110010"; -- a5: 61H (a) 
			  --  when "01100010" =>   to_m_in <= "001100010110111011"; -- b5: 62H (b) 

END;
