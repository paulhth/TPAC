library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_tb is
end shift_register_tb;

architecture sim of shift_register_tb is
    constant n : natural := 8; -- Define the width of the shift register
    signal clk, rst_n, din, shift : std_logic := '0';
    signal dout : std_logic_vector(n - 1 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the unit under test (UUT)
    uut: entity work.shift_register
        generic map (n => n)
        port map (
            clk => clk,
            rst_n => rst_n,
            din => din,
            shift => shift,
            dout => dout
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process
    stim_proc : process
    begin
        -- Reset the shift register
        rst_n <= '0';
        wait for 2 * clk_period;
        rst_n <= '1';

        -- Start shifting after reset
        din <= '1'; -- Set input bit to 1
        shift <= '1'; -- Enable shifting
        wait for n * clk_period; -- Shift for n clock cycles

        -- Stop shifting
        shift <= '0';
        wait for 2 * clk_period;

        -- Finish the simulation
        assert FALSE report "End of simulation" severity NOTE;
        wait;
    end process;
end sim;
