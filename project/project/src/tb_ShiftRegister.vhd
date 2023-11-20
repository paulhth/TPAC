library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ShiftRegister is
-- Testbench has no ports
end tb_ShiftRegister;

architecture behavior of tb_ShiftRegister is

    -- Component Declaration for the ShiftRegister
    component BoothShiftRegister
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           load : in STD_LOGIC;
           initData : in STD_LOGIC_VECTOR (7 downto 0);
           shift : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    --Inputs
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal load : STD_LOGIC := '0';
    signal initData : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal shift : STD_LOGIC := '0';

    --Outputs
    signal Q : STD_LOGIC_VECTOR (7 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: BoothShiftRegister Port Map (
          clk => clk,
          reset => reset,
          load => load,
          initData => initData,
          shift => shift,
          Q => Q
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 1: Load initial data and perform shift
        initData <= "10000000";
        load <= '1';  -- Load initial data
        wait for clk_period;
        load <= '0';
        shift <= '1'; -- Enable shift
        wait for 8*clk_period; -- Perform two shifts

        -- Test 2: Reset the register
        reset <= '1'; -- Activate reset
        wait for clk_period;
        reset <= '0';

        -- Stop the simulation
        wait;
    end process;

end behavior;
