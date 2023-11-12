library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Add this line

entity ALU is
    Port (
        A : in STD_LOGIC_VECTOR(3 downto 0);
        B : in STD_LOGIC_VECTOR(3 downto 0);
        op : in STD_LOGIC_VECTOR(1 downto 0);
        Y : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(A, B, op)
    begin
        case op is
            when "00" => -- Assume op "00" is addition
                Y <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B)); -- Use SIGNED for signed arithmetic
            when "01" => -- Assume op "01" is subtraction
                Y <= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B)); -- Use SIGNED for signed arithmetic
            -- Add more operations as needed
            when others =>
                Y <= (others => '0'); -- Default case
        end case;
    end process;
end Behavioral;
