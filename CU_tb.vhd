LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ControlUnit_tb IS
END ControlUnit_tb;

ARCHITECTURE behavior OF ControlUnit_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ControlUnit
    PORT(
        clk : IN  std_logic;
        reset : IN  std_logic;
        start : IN  std_logic;
        multiplicand : IN  std_logic_vector(3 downto 0);
        multiplier : IN  std_logic_vector(3 downto 0);
        product : OUT  std_logic_vector(7 downto 0);
        done : OUT  std_logic
        );
    END COMPONENT;
   
    --Inputs
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal start : std_logic := '0';
    signal multiplicand : std_logic_vector(3 downto 0) := (others => '0');
    signal multiplier : std_logic_vector(3 downto 0) := (others => '0');

    --Outputs
    signal product : std_logic_vector(7 downto 0);
    signal done : std_logic;

    -- Clock period definition
    constant clk_period : time := 10 ns;
 
BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: ControlUnit PORT MAP (
        clk => clk,
        reset => reset,
        start => start,
        multiplicand => multiplicand,
        multiplier => multiplier,
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

    -- Testbench statements
    stim_proc: process
    begin
        -- Initialize Inputs
        reset <= '1';
        wait for 20 ns;
        reset <= '0'; 

        -- Apply test values
        multiplicand <= "0011"; -- Example multiplicand (3)
        multiplier <= "0101"; -- Example multiplier (5)
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Wait for the multiplication to complete
        wait until done = '1' or now > 1000 ns; -- Timeout to prevent hanging simulation

        -- Check the result
        assert product = "00011111" -- Expected product 3 * 5 = 15
        report "Multiplication result is incorrect"
        severity error;

        -- Add additional test cases as necessary
        -- Consider checking the state of the product after each clock cycle for intermediate operations

        -- Finish the test
        wait;
    end process;

END;
