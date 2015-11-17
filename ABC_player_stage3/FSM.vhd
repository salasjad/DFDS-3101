  library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

  entity FSM is
     generic(
        ADDR_WIDTH: integer:=12;
        DATA_WIDTH: integer:=8
     );
      Port ( from_play : in  STD_LOGIC;
          recordd : in std_logic; -- Change recordd
          startTxFraFSM : out std_logic; 
          from_rx_done_tick : in  STD_LOGIC;
          from_tx_done_tick : in std_logic; -- Change here
          from_dout : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
          to_abus : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0); -- Signal going into addr in ram. 
          to_wr_en : out  STD_LOGIC;
          from_rdbus : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
          to_td_on : out  STD_LOGIC;
          from_td_done : in  STD_LOGIC;
          to_clr_FF : out  STD_LOGIC;
          reset : in  STD_LOGIC;
          clk : in  STD_LOGIC);
          
  end FSM;

  architecture Behavioral of FSM is
  type state_type is (mute, play, rec0, rec1, rec2, transmit0, transmit1);

  signal state_next, state_reg : state_type;
  signal pcntr_next, pcntr_reg : unsigned (ADDR_WIDTH-1 downto 0); -- program counter (to_abus) for address
  signal temp_next, temp_reg : unsigned(DATA_WIDTH-1 downto 0); -- program counter for temp. 

  begin
  -- state register
  process(clk, reset)
    begin
    if (reset = '1') then
      state_reg <= mute;
      pcntr_reg <= (others => '0');
      temp_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
      state_reg <= state_next;
      pcntr_reg <= pcntr_next;
      temp_reg <= temp_next; 
    end if;
  end process;

  -- next state and output logic
  process(recordd, state_reg, pcntr_reg, temp_reg, from_rx_done_tick, from_tx_done_tick)
    begin
    state_next <= state_reg;
    pcntr_next <= pcntr_reg;
    temp_next <= temp_reg; 
    to_clr_FF <= '0';
    to_td_on <= '0';
    to_wr_en <= '0';
    startTxFraFSM <= '0';
    
    case state_reg is
      
      when mute => 
          to_clr_FF <= '1'; 
          if(from_rx_done_tick = '1') then
            if (from_dout = X"43" or from_dout = X"44" or from_dout = X"45" or from_dout = X"46"  
              or from_dout = X"47" or from_dout = X"41" or from_dout = X"42" -- octave 4
              or  from_dout = X"63" or from_dout = X"64" or from_dout = X"65" or from_dout = X"66" 
              or from_dout = X"67" or from_dout = X"61" or from_dout = X"62") then -- octave 5
              state_next <= play;
            end if; 
          end if; 
          
      when play =>
        if(recordd = '0') then 
          if(from_rx_done_tick = '1') then
              if (from_dout = X"43" or from_dout = X"44" or from_dout = X"45" or from_dout = X"46"  
                or from_dout = X"47" or from_dout = X"41" or from_dout = X"42" -- octave 4
                or from_dout = X"63" or from_dout = X"64" or from_dout = X"65" or from_dout = X"66" 
                or from_dout = X"67" or from_dout = X"61" or from_dout = X"62") then -- octave 5
              else
                state_next <= mute; 
              end if;
          end if; 
        else
          state_next <= rec0; 
        end if; 
        
      when rec0 =>
        pcntr_next <= (others => '0'); -- pcntr_next <= pcntr_reg; -- done
        temp_next <= (others => '0'); -- temp_next <= temp_reg; -- done
          if (from_rx_done_tick = '1') then
            if (from_dout = X"43" or from_dout = X"44" or from_dout = X"45" or from_dout = X"46"  
              or from_dout = X"47" or from_dout = X"41" or from_dout = X"42" -- octave 4
              or from_dout = X"63" or from_dout = X"64" or from_dout = X"65" or from_dout = X"66" 
              or from_dout = X"67" or from_dout = X"61" or from_dout = X"62") then -- octave 5
              state_next <= rec1;
            end if;
          end if;

      when rec1 =>
        to_wr_en <= '1';
        temp_next <= temp_reg + 1;  
        pcntr_next <= pcntr_reg + 1;
        state_next <= rec2;
        
      when rec2 =>
      if(recordd = '1') then
        if (from_rx_done_tick = '1') then
          if (from_dout = X"43" or from_dout = X"44" or from_dout = X"45" or from_dout = X"46"  
             or from_dout = X"47" or from_dout = X"41" or from_dout = X"42" -- octave 4
             or from_dout = X"63" or from_dout = X"64" or from_dout = X"65" or from_dout = X"66" 
             or from_dout = X"67" or from_dout = X"61" or from_dout = X"62") then -- octave 
             state_next <= rec1; 
          end if;
        end if; 
      else 
        state_next <= transmit0; 
      end if; 
    
          when transmit0 =>
               to_clr_FF <= '1';
              pcntr_next <= (others => '0'); -- done
                state_next <= transmit1; 
            
          when transmit1 =>
            to_clr_FF <= '1';
            startTxFraFSM <= '1'; -- 
            
            if (temp_reg = pcntr_reg) then
              state_next <=  mute; 
            else
					if(from_tx_done_tick = '1') then 
							pcntr_next <= pcntr_reg + 1; 	
							state_next <= transmit1; 
					end if; 
            end if; 
            
      end case;
  end process;
  --1010101
    to_abus <= std_logic_vector(pcntr_reg); -- NB! Don't forget this. (after process)

  end Behavioral;
