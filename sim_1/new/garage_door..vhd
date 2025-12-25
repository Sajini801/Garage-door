library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity garage_door is
end entity;

architecture sim of garage_door is

    -- Inputs
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal remt  : std_logic := '0';
    signal sen1  : std_logic := '0';
    signal sen2  : std_logic := '1'; -- start fully closed

    -- Outputs
    signal ctr       : std_logic_vector(1 downto 0);
    signal output_state_encoding : std_logic_vector(2 downto 0);
    signal next_state_encoding : std_logic_vector(2 downto 0);

begin

    -- Instantiate top-level compiled codes
   uut: entity work.garage_moore
    port map (
        clk => clk,
        rst => rst,
        remt => remt,
        sen1 => sen1,
        sen2 => sen2,
        ctr => ctr,
        output_state_encoding => output_state_encoding,
        next_state_encoding => next_state_encoding
    );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 25 ns;
            clk <= '1';
            wait for 25 ns;
        end loop;
    end process;

    stim : process
    begin
        rst  <= '1';
        remt <= '0';
        sen1 <= '0';
        sen2 <= '1';
        wait until rising_edge(clk);

        rst <= '0';
        wait until rising_edge(clk);

        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        sen2 <= '0';

        wait until rising_edge(clk);

        --opening to open
        sen1 <= '1';
        wait until rising_edge(clk);

        --open to closing
        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        sen1 <= '0';

        wait until rising_edge(clk);
        --closing to closed
        sen2 <= '1';
        wait until rising_edge(clk);

        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        sen2 <= '0';
        wait until rising_edge(clk);

        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        wait until rising_edge(clk);

        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        wait until rising_edge(clk);

        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        wait until rising_edge(clk);


        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        wait until rising_edge(clk);
 
 
      --opening to open
        sen1 <= '1';
        wait until rising_edge(clk);
        wait;
       
        --open to closing
        remt <= '1';
        wait until rising_edge(clk);
        remt <= '0';
        sen1 <= '0';
        
         wait until rising_edge(clk);
        --closing to closed
        sen2 <= '1';
        wait until rising_edge(clk);
        
        
    end process;

end architecture;

  

