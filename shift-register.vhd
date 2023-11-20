library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_register is
    generic (n : natural := 4);
    Port ( clk   : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           din   : in STD_LOGIC;
           shift : in STD_LOGIC;
           dout  : out STD_LOGIC_VECTOR(n - 1 downto 0));
end shift_register;

architecture Behavioral of shift_register is
    signal temp_reg : STD_LOGIC_VECTOR(n - 1 downto 0) := (others => '0');
begin
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            temp_reg <= (others => '0'); -- Asynchronous reset
        elsif rising_edge(clk) then
            if shift = '1' then
                -- Perform the shift operation ensuring the result is n bits wide
                temp_reg <= std_logic_vector(shift_left(unsigned(temp_reg), 1)(n-1 downto 1)) & din;
            end if;
        end if;
    end process;

    dout <= temp_reg; -- Output the value of the internal register
end Behavioral;
