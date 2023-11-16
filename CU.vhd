library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        start : in STD_LOGIC;
        multiplicand : in STD_LOGIC_VECTOR(3 downto 0);
        multiplier : in STD_LOGIC_VECTOR(3 downto 0);
        product : out STD_LOGIC_VECTOR(7 downto 0);
        done : out STD_LOGIC
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    -- State type declaration
    type state_type is (Idle, Load, Add, Subtract, Shift, Finish);
    signal current_state, next_state : state_type;

    -- Instantiating ALU and Shift Register
    signal aluOp : STD_LOGIC;
    signal aluResult : STD_LOGIC_VECTOR(3 downto 0);
    signal shiftReg : STD_LOGIC_VECTOR(7 downto 0);
    signal loadVal : STD_LOGIC;    
    signal shift_signal : STD_LOGIC; -- Signal to control the shift operation
    signal count : integer := 0; -- Counter for the number of shifts

    component ALU
        Port (
            A : in STD_LOGIC_VECTOR(3 downto 0);
            B : in STD_LOGIC_VECTOR(3 downto 0);
            op : in STD_LOGIC;
            Y : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component BoothShiftRegister
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            load : in STD_LOGIC;
            initData : in STD_LOGIC_VECTOR(7 downto 0);
            shift : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin
    -- Instantiating components
    alu_inst: ALU
        Port Map (
            A => shiftReg(7 downto 4),
            B => multiplicand,
            op => aluOp,
            Y => aluResult
        );

    shiftReg_inst: BoothShiftRegister
        Port Map (
            clk => clk,
            reset => reset,
            load => loadVal,
            initData => shiftReg,
            shift => shift_signal, -- Use the dedicated signal for shifting
            Q => shiftReg
        );

    -- Single FSM for Booth Multiplier
    process(clk, reset)
    begin
        if reset = '1' then
            -- Initialize all signals
            current_state <= Idle;
            aluOp <= '0';
            loadVal <= '0';
            shift_signal <= '0';
            shiftReg <= (others => '0');
            aluResult <= (others => '0');
            count <= 0;
            done <= '0';
        elsif rising_edge(clk) then
            case current_state is
                when Idle =>
                    if start = '1' then
                        next_state <= Load;
                        loadVal <= '1';
                        shiftReg <= "0000" & multiplier;
                        count <= 4; -- For 4-bit multiplication, we need 4 shifts
                    else
                        next_state <= Idle;
                    end if;

                when Load =>
                    next_state <= Shift; -- After loading, go to Shift state

                when Add =>
                    -- Add operation logic
                    next_state <= Shift;

                when Subtract =>
                    -- Subtract operation logic
                    next_state <= Shift;

                when Shift =>
                    -- Perform the shift operation
                    if count > 0 then
                        -- Shift and decrement count
                        shift_signal <= '1';
                        count <= count - 1;
                    end if;
                    if count = 0 then
                        next_state <= Finish;
                    else
                        next_state <= current_state; -- Remain in Shift state
                    end if;

                when Finish =>
                    -- Complete the operation
                    done <= '1';
                    next_state <= Idle;

                when others =>
                    next_state <= Idle;
            end case;
            current_state <= next_state; -- Update current state at clock edge
        end if;
    end process;

    -- Output assignments
    product <= shiftReg; -- The product is in the shift register
    -- Note: Make sure that the product is correct at the end of the multiplication process

end Behavioral;
