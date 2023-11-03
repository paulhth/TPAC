library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shift_register is
  Port ( clk : in STD_LOGIC;
         rst_n : in STD_LOGIC;
         din : in STD_LOGIC_VECTOR (3 downto 0);
         dout : out STD_LOGIC_VECTOR (3 downto 0));
end shift_register;

architecture behavioral of shift_register is
  signal reg : STD_LOGIC_VECTOR (3 downto 0);
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      reg <= (others => '0');
    elsif rising_edge(clk) then
      reg <= din;
    end if;
  end process;
  
  dout <= reg;

end behavioral;
