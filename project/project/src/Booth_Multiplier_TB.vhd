LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Booth_Multiplier_TB IS
END Booth_Multiplier_TB;

ARCHITECTURE behavior OF Booth_Multiplier_TB IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Booth_Multiplier
        PORT (
            clk   : IN STD_LOGIC;
            start : IN STD_LOGIC;
            A     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            B     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            product: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            done  : OUT STD_LOGIC
        );
    END COMPONENT;

    --Inputs
    signal clk : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal A : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal B : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');

    --Outputs
    signal product : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal done : STD_LOGIC;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: Booth_Multiplier PORT MAP (
        clk => clk,
        start => start,
        A => A,
        B => B,
        product => product,
        done => done
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Testbench Stimulus process
    stimulus_process: process
    begin       
        -- Initialize Inputs
        A <= (others => '0');
        B <= (others => '0');
        wait for clk_period;  -- Allow time for initialization
        
        -- Test Case 1
        A <= "0010"; -- 2 in decimal
        B <= "0011"; -- 3 in decimal
        wait for clk_period;  -- Allow time for input setup
        start <= '1';         -- Start the multiplication
        wait for clk_period;  -- Wait for one clock cycle
        start <= '0';         -- Deassert start
        
        wait for 100 ns;      -- Wait long enough for the multiplication to complete
        
        -- Test Case 2
        A <= "0100"; -- 4 in decimal
        B <= "0101"; -- 5 in decimal
        wait for clk_period;  -- Allow time for input setup
        start <= '1';         -- Start the multiplication
        wait for clk_period;  -- Wait for one clock cycle
        start <= '0';         -- Deassert start
        
        wait for 100 ns;      -- Wait long enough for the multiplication to complete

        -- Add more test cases as needed

        -- Complete the simulation
        wait;
    end process;

END behavior;
