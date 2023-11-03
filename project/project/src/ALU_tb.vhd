library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end ALU_tb;

architecture sim of ALU_tb is
    signal A, B, Y : std_logic_vector(3 downto 0) := (others => '0');
    signal op : std_logic_vector(1 downto 0) := "00";

begin
    -- Instantiate the unit under test (UUT)
    uut: entity work.ALU port map (
        A => A,
        B => B,
        op => op,
        Y => Y
    );

    -- Test process
    stim_proc: process
    begin
        -- Test addition
        A <= "0010"; B <= "0001"; op <= "00"; 
        wait for 100 ns;
        
        -- Test subtraction
        A <= "0010"; B <= "0001"; op <= "01"; 
        wait for 100 ns;

        wait;
    end process;

end sim;
