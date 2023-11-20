library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 

entity ControlUnit is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
			--input
        start : in STD_LOGIC;
        multiplicand : in STD_LOGIC_VECTOR(3 downto 0);
        multiplier : in STD_LOGIC_VECTOR(3 downto 0);	
			--output
        product : out STD_LOGIC_VECTOR(7 downto 0);
        done : out STD_LOGIC
    );
end entity;

-- Start of the architecture for the ControlUnit entity
architecture rtl of ControlUnit is
    -- State type declaration
    type state_type is (Idle, Load, Add, Subtract, Shift, Check, Finish); -- Declaration of states
    signal current_state, next_state : state_type; -- Current and next states

    -- Signals for ALU and SHREG
    signal aluOp : STD_LOGIC;
    signal aluResult : STD_LOGIC_VECTOR(3 downto 0);
    signal shiftReg : STD_LOGIC_VECTOR(7 downto 0);
    signal loadVal : STD_LOGIC;	   
	signal shift_signal : STD_LOGIC; -- Signal to control the shift operation	 
	
		
	-- Declaration of ALU	
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

    -- Instantiating components
    begin
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

    -- FSM for Booth Multiplier
    process(clk,reset)
    begin
        if reset = '1' then
			current_state <= Idle;	
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;	
	
	process(current_state, start)
	variable count : integer := 0; -- Counter for the number of shifts
	begin	   
		done <= '0';
        case current_state is
            when Idle => -- Wait for start signal
                if start = '1' then
                    next_state <= Load;
                else
                    next_state <= Idle;
                end if;
				
			when Check =>
			-- Check if we have to add or subtract
				if (shiftReg(2) = '0' and shiftReg(1) = '0' and shiftReg(0) = '1') or
          		   (shiftReg(2) = '0' and shiftReg(1) = '1' and shiftReg(0) = '0') then
					 next_state <= Add;
				elsif (shiftReg(2) = '1' and shiftReg(1) = '0' and shiftReg(0) = '1') or
          		   	  (shiftReg(2) = '1' and shiftReg(1) = '1' and shiftReg(0) = '0')  then
					 next_state <= Subtract; 
				else
					next_state <= Shift;
				end if;
            
			 when Load =>
                    -- Load multiplier and multiplicand  
					shift_signal <= '0';
					shiftReg <= multiplicand & "0000"; -- Initialize A and Q 
					loadVal <= '1'; -- Load the data into the shift register
                    next_state <= Check; -- Go to Check state to start algorithm

					
			
			 when Add =>
                    -- Add multiplicand to the upper bits of the shift register
                    aluOp <= '0'; -- Set ALU for addition
                    loadVal <= '1'; -- Load the result into the shift register
                    next_state <= Shift; -- After adding, go to Shift state
					
					
			 when Subtract =>
                    -- Subtract multiplicand from the upper bits of the shift register
                    aluOp <= '1'; -- Set ALU for subtraction
                    loadVal <= '1'; -- Load the result into the shift register
                    next_state <= Shift; -- After subtracting, go to Shift state
					
			
			  when Shift =>
                    -- Right shift the shift register
                    loadVal <= '0'; -- No loading, just shifting
                    shift_signal <= '1'; -- Enable shifting	
					count := count + 1;
                    -- Check if the operation is complete
                    if count = 7 then
                        next_state <= Finish; -- If LSB is 1, add the multiplicand
                    else
                        next_state <= Check; -- If second LSB is 1, subtract the multiplicand
                    end if;

			
			  when Finish =>
                    -- Complete the operation
                    done <= '1'; -- Signal that operation is complete
                    next_state <= Idle; -- Return to Idle state
			
			
			

            when others =>
                next_state <= Idle;
        end case; 
		end process;

	
	product <= shiftReg;
    done <= '1' when (current_state = Finish) else '0';

end rtl;