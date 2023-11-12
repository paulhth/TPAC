LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Booth_Multiplier IS
    PORT (
        clk   : IN STD_LOGIC;
        start : IN STD_LOGIC;
        A     : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Multiplicand
        B     : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Multiplier
        product: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Result
        done  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF Booth_Multiplier IS

    -- Component Declarations for ALU, Shift Register, and Control Unit
    COMPONENT ALU
        PORT (
            A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            op: IN STD_LOGIC;
            Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT shift_register
        GENERIC (n : natural := 8);
        PORT (
            clk   : IN STD_LOGIC;
            rst_n : IN STD_LOGIC;
            din   : IN STD_LOGIC;
            shift : IN STD_LOGIC;
            dout  : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Control_Unit
        GENERIC (tp : TIME := 5 ns);
        PORT (
            input_bit : IN STD_LOGIC;
            clock : IN STD_LOGIC;
            control_signals : OUT STD_LOGIC_VECTOR(1 downto 0)
        );
    END COMPONENT;

    -- Internal Signals
    SIGNAL alu_op, shift_signal, reset_n : STD_LOGIC;
    SIGNAL alu_result, multiplicand, accumulator, internal_register : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL next_bit : STD_LOGIC;
    SIGNAL control_signals : STD_LOGIC_VECTOR(1 downto 0); -- Signal for control signals  
		
	SIGNAL iteration : INTEGER range 0 to 4 := 0; -- Declaration for iteration counter
    SIGNAL temp_bit : STD_LOGIC;                 -- Temporary bit for shifting operations

BEGIN

    -- Instantiations
    alu_inst: ALU
        PORT MAP (
            A => internal_register(7 DOWNTO 4),  -- Most significant half of internal register
            B => multiplicand(3 DOWNTO 0),       -- Lower 4 bits of multiplicand
            op => alu_op,
            Y => alu_result(3 DOWNTO 0)
        );

    shift_reg_inst: shift_register
        GENERIC MAP (n => 8)
        PORT MAP (
            clk => clk,
            rst_n => reset_n,
            din => internal_register(6),         -- MSB-1 as input for shifting
            shift => shift_signal,
            dout => internal_register
        );

    control_unit_inst: Control_Unit
        PORT MAP (
            input_bit => next_bit,
            clock => clk,
            control_signals => control_signals
        );

    -- Control Logic for Booth's Algorithm
    process(clk, start)
        variable state: std_logic := '0'; -- State variable for controlling the multiplication process
    begin
        if rising_edge(clk) then
            if start = '1' then
                -- Initialize for new multiplication
                -- ... [Initialization logic]
                -- Set iteration to start at 0
                iteration <= 0;
                state := '1'; -- Set state to active
            elsif state = '1' then
                reset_n <= '1'; -- Release reset of shift register
                -- Booth Multiplication Steps
                if iteration < 4 then  -- Assuming a 4-bit multiplier
                    -- Determine action based on the two least significant bits of internal_register
                    case internal_register(1 downto 0) is
                        when "01" => 
                            -- Add multiplicand to accumulator
                            alu_op <= '0'; -- Assuming '0' is addition in ALU
                            -- Perform ALU operation here and update accumulator
                        when "10" =>
                            -- Subtract multiplicand from accumulator
                            alu_op <= '1'; -- Assuming '1' is subtraction in ALU
                            -- Perform ALU operation here and update accumulator
                        when others =>
                            -- No operation, just shift
                    end case;

                    -- Perform the shift operation on the combined register
                    -- Concatenate accumulator and internal_register, shift, then split
                    -- [Perform shift logic here]

                    -- Update next_bit for the next iteration
                    next_bit <= internal_register(0);

                    -- Prepare for next iteration
                    iteration <= iteration + 1;
                else
                    -- Multiplication complete
                    state := '0';
                    done <= '1';
                    product <= accumulator; -- Assign final product to output
                end if;
            end if;
        end if;
    end process;

    -- Output Assignment
    product <= accumulator; -- Assign final product to output
    -- done signal logic (if needed)

END ARCHITECTURE;
