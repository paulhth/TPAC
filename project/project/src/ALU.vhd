library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	 --has std_logic and std_logic_vector
use IEEE.NUMERIC_STD.ALL;		 --has SIGNED() and UNSIGNED() functions

entity ALU is
    Port (
        A : in STD_LOGIC_VECTOR(3 downto 0);
        B : in STD_LOGIC_VECTOR(3 downto 0);
        op : STD_LOGIC;
        Y : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(A, B, op)
    begin
			if op = '1' then
				Y<= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B)); 
			else 
				Y<= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
        end if;
    end process;
end Behavioral;


-- SIGNED(A) tells VHDL that A is a vector of bits representing a signed number
