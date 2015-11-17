---

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
				DVSR_BIT2 : integer := 18; -- # For code converter
				
				ADDR_WIDTH: integer:=12; -- Adresses
				DATA_WIDTH: integer :=8 -- Ascii code 8 bits
			
			  );

    Port ( 
			  rx, clk, reset : in  STD_LOGIC;
			  txUt : out std_logic; 
           loudspeaker : out  STD_LOGIC;
			  play : in std_logic; 
			  recordi : in std_logic; 
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
   generic(
      ADDR_WIDTH: integer:=12;
      DATA_WIDTH: integer:=8
   );
    Port ( from_play : in  STD_LOGIC;
			  recordd : in std_logic; -- Change recordd
			  startTxFraFSM : out std_logic; 
			  from_rx_done_tick : in  STD_LOGIC;
			  from_tx_done_tick : in std_logic; 
           from_dout : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			  to_abus : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
			  to_wr_en : out  STD_LOGIC;
			  from_rdbus : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			  to_td_on : out  STD_LOGIC;
			  from_td_done : in  STD_LOGIC;
           to_clr_FF : out  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC);
			  
end component;


-----------------------RAM--------------------------------------------
component RAM is
generic (
	ADDR_WIDTH: integer:=12;
	DATA_WIDTH: integer :=8
	);
	port(
		clk: in std_logic;
		we: in std_logic;
		addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		wrbus: in std_logic_vector(DATA_WIDTH-1 downto 0);
		rdbus: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end component;

-----------------------TimerDelay------------------------------------------

component TimerDelay is
   port(
     clk, reset : in std_logic;
	  from_td_on : in std_logic;
	  to_td_done : out std_logic
   );
end component;


-----------------------tx_uart------------------------------------------

component tx_uart is	

generic(	DBIT: integer:=8; --#data bits
			SB_TICK: integer:=16 --#ticks for stop bits
		 );
	port(
			clk, reset : in std_logic;
			tx_start : in std_logic;
			from_s_tick : in std_logic;
			to_din : in std_logic_vector(7 downto 0);
			to_tx_done_tick : out std_logic;
			tx : out std_logic
		);
end component;


			
-----------------------Signals------------------------------------------

	signal tick : std_logic; --
	signal dout : std_logic_vector(7 downto 0);
	signal m_in : std_logic_vector(17 downto 0);
	signal rx_done_tick, t_in, clr_FF : std_logic; 
	signal tx_done_tick : std_logic; 
	signal abus : std_logic_vector(11 downto 0);
	signal wr_en : std_logic; 
	signal ram_data : std_logic_vector(7 downto 0);
	signal td_on, td_done : std_logic;
	signal start: std_logic; 
	
	
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
							 
 A5 : FSM 	
 generic map(ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => DATA_WIDTH)
 port map ( 
			  from_play => play,
			  recordd => recordi, 
			  startTxFraFSM => start,
			  from_rx_done_tick => rx_done_tick,
			  from_tx_done_tick => tx_done_tick, 
           from_dout =>  dout,
			  to_abus => abus,
			  to_wr_en => wr_en,
			  from_rdbus => ram_data,
			  to_td_on => td_on,
			  from_td_done => td_done,
           to_clr_FF => clr_FF,
           reset => reset,
           clk => clk );
			
A6 : RAM 
			generic map(ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => DATA_WIDTH)
			port map(clk => clk,
						we => wr_en,
						addr => abus,
						wrbus => dout,
						rdbus => ram_data);
			
A7 : TimerDelay port map( clk => clk,
								 reset => reset,
								 from_td_on => td_on, 
								 to_td_done => td_done); 
								 
A8 : tx_uart 
				generic map (DBIT => DBIT, SB_TICK => SB_TICK)
				port map (clk => clk,
							 reset => reset, 
							 tx_start => start,
							 from_s_tick => tick,
							 to_din => ram_data,
							 to_tx_done_tick => tx_done_tick,
							 tx => txUt);

							 
end Behavioral;

