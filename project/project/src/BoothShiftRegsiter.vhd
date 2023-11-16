library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BoothShiftRegister is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           load : in STD_LOGIC;
           initData : in STD_LOGIC_VECTOR (7 downto 0);
           shift : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (7 downto 0));
end BoothShiftRegister;

architecture Behavioral of BoothShiftRegister is
    signal temp_Q : STD_LOGIC_VECTOR (7 downto 0); -- Internal signal
begin
    process(clk, reset)
    begin
        if reset = '1' then
            temp_Q <= (others => '0'); -- Reset the register
        elsif rising_edge(clk) then
            if load = '1' then
                temp_Q <= initData; -- Load initial data
            elsif shift = '1' then
                temp_Q <= temp_Q(6 downto 0) & '0'; -- Right shift and append '0'
            end if;
        end if;
    end process;

    Q <= temp_Q; -- Assign internal signal to output port
end Behavioral;