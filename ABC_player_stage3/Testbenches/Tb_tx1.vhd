
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Tb_tx1 IS
END Tb_tx1;
 
ARCHITECTURE behavior OF Tb_tx1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT tx_uart
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         tx_start : IN  std_logic;
         from_s_tick : IN  std_logic;
         to_din : IN  std_logic_vector(7 downto 0);
         to_tx_done_tick : OUT  std_logic;
         tx : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tx_start : std_logic := '0';
   signal from_s_tick : std_logic := '0';
   signal to_din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal to_tx_done_tick : std_logic;
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tx_uart PORT MAP (
          clk => clk,
          reset => reset,
          tx_start => tx_start,
          from_s_tick => from_s_tick,
          to_din => to_din,
          to_tx_done_tick => to_tx_done_tick,
          tx => tx
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

  stim_proc: process
   begin		
      reset <= '1';
		play <= '0';
		recordi <= '0';
		recordi <= '0';
      wait for 100 ns;
		reset <= '0';
		rx <= '1';		-- idle for a while
      wait for clk_period*10;
		
--		wait for 1000000 ns;  
		
		recordi <= '1'; 
		
--		wait for 1000000 ns;
		
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
		
--		wait for 1000000 ns; 
		
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
		
--	   wait for 1000000 ns;  
		
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

