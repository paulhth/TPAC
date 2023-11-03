library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_tb is
end shift_register_tb;

architecture sim of shift_register_tb is
    signal clk: std_logic := '0';          -- Initializing clk to '0'
    signal rst_n: std_logic := '0';        -- Initializing to reset state
    signal din: std_logic_vector(3 downto 0) := (others => '0');
    signal dout: std_logic_vector(3 downto 0);

    -- Clock period definitions
    constant clk_period: time := 10 ns;

begin
    -- Instantiate the unit under test (UUT)
    uut: entity work.shift_register port map (
        clk => clk,
        rst_n => rst_n,
        din => din,
        dout => dout
    );

    -- Clock process definition
    clk_process: process
    begin
        clk <= not clk;              -- Toggle clock
        wait for clk_period/2;
    end process;

    -- Test process definition
    stim_proc: process
    begin
        -- Assert reset for 2 clock cycles
        rst_n <= '0';
        wait for 2 * clk_period;
        
        -- Release reset
        rst_n <= '1';  
        wait for clk_period;    

        -- Test data shift
        din <= "0001";
        wait for clk_period;
        din <= "0010";
        wait for clk_period;
        din <= "0100";
        wait for clk_period;
        din <= "1000";
        wait for clk_period;

        -- Finish the simulation
        wait;
    end process;

end sim;
