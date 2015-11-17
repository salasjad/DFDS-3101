--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:47:58 10/23/2014
-- Design Name:   
-- Module Name:   C:/Users/Dler/Dropbox/Code/VHDL/Stage3/tb_rx1.vhd
-- Project Name:  NeverGiveUp
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_rx
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
 
ENTITY tb_rx1 IS
END tb_rx1;
 
ARCHITECTURE behavior OF tb_rx1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_rx
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         from_rx : IN  std_logic;
         s_tick : IN  std_logic;
         to_rx_done_tick : OUT  std_logic;
         to_dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal from_rx : std_logic := '0';
   signal s_tick : std_logic := '0';

 	--Outputs
   signal to_rx_done_tick : std_logic;
   signal to_dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_rx PORT MAP (
          clk => clk,
          reset => reset,
          from_rx => from_rx,
          s_tick => s_tick,
          to_rx_done_tick => to_rx_done_tick,
          to_dout => to_dout
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
