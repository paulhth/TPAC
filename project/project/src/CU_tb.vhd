									   LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Control_Unit_TB IS
END Control_Unit_TB;

ARCHITECTURE behavior OF Control_Unit_TB IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Control_Unit
    GENERIC (
        tp : TIME := 5 ns
    );
    PORT (
        input_bit : IN  bit;
        clock : IN  bit;
        control_signals : OUT  bit_vector(1 downto 0)
    );
    END COMPONENT;
   
    --Inputs
    signal input_bit : bit := '0';
    signal clock : bit := '0';

    --Outputs
    signal control_signals : bit_vector(1 downto 0);

    -- Clock period definitions
    constant clock_period : time := 10 ns;

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: Control_Unit PORT MAP (
        input_bit => input_bit,
        clock => clock,
        control_signals => control_signals
    );

    -- Clock process definitions
    clock_process :process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin       
        -- Initialize Inputs
        input_bit <= '0';

        -- Wait for the global reset
        wait for 20 ns;  
        
        -- Test a sequence of input bits
        input_bit <= '0'; 
        wait for 10 ns;
        input_bit <= '1'; 
        wait for 10 ns;
        input_bit <= '0'; 
        wait for 10 ns;
        input_bit <= '1'; 
        wait for 10 ns;
        input_bit <= '0'; 
        wait for 10 ns;

        -- Add more test cases as needed

        -- Complete the simulation
        wait;
    end process;

END;
