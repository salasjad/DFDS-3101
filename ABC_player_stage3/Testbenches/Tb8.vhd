
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Tb8 IS
END Tb8;
 
ARCHITECTURE behavior OF Tb8 IS 
 
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
