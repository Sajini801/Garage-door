library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity garage_moore is
    port (
  
        clk  : in std_logic;
        rst  : in std_logic;
        remt : in std_logic;     -- Remote
        sen1 : in std_logic;     -- Door Open sensor (1 = Fully Ppen)
        sen2 : in std_logic;     -- Door Close sensor (1 = Fully Closed)
        
        ctr  : out std_logic_vector(1 downto 0); -- Motor On/Off & Direction
        
        -- These are outputs to see the Behaviour and output of the Next-State Logic Block and the Output logic
        -- In implementation these would be commented out
        
        output_state_encoding : out std_logic_vector(2 downto 0);   -- ctr(1)=motor ON/OFF, ctr(0)=direction
        next_state_encoding : out std_logic_vector(2 downto 0)
    );
end entity;
architecture rtl of garage_moore is

    -- States
    type state_type is (CLOSED, OPENING, OPENED, CLOSING, STOPPED_OPEN, STOPPED_CLOSE);
    signal state, next_state : state_type;

begin

    
    -- State Register
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= CLOSED;
            else
                state <= next_state;
            end if;
        end if;
    end process;





    -- Next-State Logic (Sensors checked INSIDE the states)
    process(state, remt, sen1, sen2)
    begin
        next_state <= state;  -- default

        case state is

            -- CLOSED state
            when CLOSED =>
                if sen2 = '1' then     -- ensure fully closed
                    if remt = '1' then
                        next_state <= OPENING;
                    end if;
                end if;
                
                
            -- OPENING state
            when OPENING =>
                if sen1 = '1' then           -- reached fully open
                    next_state <= OPENED;
                elsif remt = '1' then        -- stop midway
                    next_state <= STOPPED_OPEN;
                else
                    next_state <= OPENING;   -- continue moving
                end if;

            -- OPENED state
            when OPENED =>
                if sen1 = '1' then           -- ensure fully open
                    if remt = '1' then
                        next_state <= CLOSING;
                    end if;
                end if;

            -- CLOSING state
            when CLOSING =>
                if sen2 = '1' then           -- reached fully closed
                    next_state <= CLOSED;
                elsif remt = '1' then        -- stop midway
                    next_state <= STOPPED_CLOSE;
                else
                    next_state <= CLOSING;   -- continue
                end if;

            -- STOPPED while OPENING
            when STOPPED_OPEN =>
                if remt = '1' then
                    next_state <= CLOSING;   -- reverse direction
                end if;

            -- STOPPED while CLOSING
            when STOPPED_CLOSE =>
                if remt = '1' then
                    next_state <= OPENING;   -- reverse direction
                end if;

            when others =>
                next_state <= CLOSED;

        end case;
    end process;
    
    
    
     process(next_state)
    begin
        case next_state is
            when CLOSED         => next_state_encoding <= "000";
            when OPENING        => next_state_encoding <= "001";
            when OPENED         => next_state_encoding <= "010";
            when CLOSING        => next_state_encoding <= "011";
            when STOPPED_OPEN   => next_state_encoding <= "100";
            when STOPPED_CLOSE  => next_state_encoding <= "101";
        end case;
    end process;

  
    -- Output Logic (Moore outputs depend only on the current state)
process(state)
    begin
        case state is

            when CLOSED =>
                ctr <= "00"; output_state_encoding <= "000";      -- motor OFF

            when OPENING =>
                ctr <= "10"; output_state_encoding <= "001";       -- motor ON, direction 0 (open)

            when OPENED =>
                ctr <= "00"; output_state_encoding <= "010";      -- motor OFF

            when CLOSING =>
                 ctr <= "11"; output_state_encoding <= "011";        -- motor ON, direction 1 (close)

            when STOPPED_OPEN =>
               ctr <= "00"; output_state_encoding <= "100";       -- motor OFF, last direction = open

            when STOPPED_CLOSE =>
                ctr <= "01"; output_state_encoding <= "101";       -- motor OFF, last direction = close
                
        end case;
    end process;

end rtl;