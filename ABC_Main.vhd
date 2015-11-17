
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- The baud rate generator generates a sampling signal whose frequency is exactly 16 times 
-- the UART's designated baud rate. To avoid creating a new clock domain and violating the 
-- synchronous design principle, the sampling signal would should function as enable ticks rather than clock 
-- signal to the UART receiver. 

-- For the 19200 baud rate, the sampling rate has to be 307200 (i.e. 19200*16) ticks per second. Since the FPGA has
-- 100 MHz system clock, the baud

entity ABC_Main is

	generic(
	
				-- Default Setting; 
				-- 19200 baud, 8 data bits, 1 stop bit,  
				DBIT : integer := 8; -- # Data bits??
				SB_TICK : integer :=16; -- # Ticks for stop bits, 16/24/32 for 1/1.5/2 stop bits 
	         DVSR : integer := 326; -- # Baud rate divisor DVSR = 100/(16 * baud rate)
				DVSR_BIT : integer := 9; -- # Bits of DVSR
				DVSR_BIT2 : integer := 18 -- # For code converter
				);

    Port (
			  rx, clk, reset : in  STD_LOGIC;
           loudspeaker : out  STD_LOGIC;
			  leds : out std_logic_vector(7 downto 0)
			 );
end ABC_Main;

architecture Behavioral of ABC_Main is

-----------------------boud_rate_generator-----------------------------------
	
	component boud_rate_generator is

	generic (
					N : integer := 9; -- number of bits
					M : integer := 326 -- mod-m
				);
	
    Port ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           max_tick : out  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(N-1 downto 0)
			  );
	end component;

-----------------------uart_rx-----------------------------------
	
   component uart_rx is
		generic (
			  DBIT : integer := 8; -- # data bits
			  SB_TICK : integer := 16 -- # ticks for stop bits. 
			  );

    Port ( 
			  clk, reset: in std_logic;
			  from_rx: in std_logic;
           s_tick: in std_logic;
           to_rx_done_tick: out std_logic;
           to_dout: out std_logic_vector(7 downto 0)
			  );
			  
	end component; 
	
-----------------------CodeConverter-----------------------------------

	component CodeConverter is
		 Port (				  from_dout : in  STD_LOGIC_VECTOR (7 downto 0);
				  to_m_in : out  STD_LOGIC_VECTOR (17 downto 0)
				  
				 );
	end component;

-----------------------mod_m_counter-----------------------------------

	component mod_m_counter is
		generic(
					N : integer := 18 -- number of bits
		);
		 Port(
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           from_m_in : in STD_LOGIC_VECTOR(N-1 downto 0);
			  to_t_in: out std_logic
			 );
	end component;
	
-----------------------T_FF--------------------------------------------

component T_FF is
    Port ( 
			  clk, reset : in STD_LOGIC;
			  from_t_in : in  STD_LOGIC;
           from_clr_FF : in  STD_LOGIC;
           to_ldspkr : out  STD_LOGIC
			 );
end component; 

-----------------------FSM--------------------------------------------

component FSM is
	Port (
			clk, reset : in std_logic;
			from_rx_done_tick : in std_logic; 
			from_dout : in std_logic_vector(7 downto 0); 
			to_clr_FF : out std_logic	
		  );
end component; 


-----------------------Signals------------------------------------------

	signal tick : std_logic; 
	signal dout : std_logic_vector(7 downto 0);
	signal m_in : std_logic_vector(17 downto 0);
	signal rx_done_tick, t_in, clr_FF : std_logic; 
	
begin 

leds <= dout;
-----------------------Boud_rate_generator-----------------------------------
 A0 : boud_rate_generator 
				  generic map(M => DVSR, N=> DVSR_BIT)
				  port map(clk => clk,
							  reset => reset,
							  q => open, max_tick => tick);
 
 -----------------------uart_rx-----------------------------------
 
 A1 : uart_rx 
             generic map(DBIT => DBIT, SB_TICK => SB_TICK)
             port map ( clk => clk,
								reset => reset,
								from_rx => rx,
								s_tick => tick, 
								to_rx_done_tick => rx_done_tick, 
								to_dout => dout); 
								
-----------------------CodeConverter-----------------------------------

 A2 : CodeConverter port map ( from_dout => dout, 
										 to_m_in => m_in);
										 
-----------------------mod_m_counter-----------------------------------
										 
 A3 : mod_m_counter 
							generic map(N=> DVSR_BIT2)
							port map ( clk => clk,
										 reset => reset,
										 from_m_in =>  m_in,
										 to_t_in => t_in);
										 
-----------------------T_FF--------------------------------------------
										 
 A4 : T_FF port map ( clk => clk,
							 reset => reset,
							 from_t_in => t_in,
							 from_clr_FF => clr_FF,
							 to_ldspkr => loudspeaker);
							 
-----------------------FSM--------------------------------------------
							 
 A5 : FSM port map ( clk => clk,
							reset => reset,
							from_rx_done_tick => rx_done_tick,
							from_dout => dout,
							to_clr_FF => clr_FF);
							
							  
end Behavioral;

