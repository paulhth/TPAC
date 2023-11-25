LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ControlUnit IS
	PORT
	(
		clk : IN STD_LOGIC;
		reset: in STD_LOGIC; 
			--input
		start : IN STD_LOGIC;
		multiplicand: IN STD_LOGIC_VECTOR(3 DOWNTO 0);	   
		multiplier: in STD_LOGIC_VECTOR(3 downto 0);
			--output
		product : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		done : OUT STD_LOGIC
	);
END ControlUnit;

architecture Behavioral of ControlUnit is
	type state_type IS (Idle, Load, Operation, Finish);

	SIGNAL state : state_type := Idle;
	SIGNAL A_reg, B_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Q, M, Q_reg, M_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL M_neg : STD_LOGIC;
	SIGNAL counter : INTEGER := 0;
	SIGNAL result_reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL aluOp : STD_LOGIC;
	SIGNAL aluResult : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL loadVal : STD_LOGIC;
	SIGNAL shift_signal : STD_LOGIC; -- Signal to control the shift operation 
	SIGNAL initData_signal : STD_LOGIC_VECTOR(8 downto 0);
	-------------------------------------------------------
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
            initData : in STD_LOGIC_VECTOR(8 downto 0);
            shift : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR(8 downto 0)
        );
    end component;
	-------------------------------------------------------
	
	
	
begin
	-------------------------------------------------------
	alu_inst: ALU
            Port Map (
                A => A_reg,
                B => multiplier,
                op => aluOp,
                Y => aluResult
            );

        shiftReg_inst: BoothShiftRegister
            Port Map (
            clk => clk,
            reset => reset,
            load => loadVal,
			initData => initData_signal,
            shift => shift_signal -- Use the dedicated signal for shifting   
        );
	-------------------------------------------------------
	process (clk, reset)
	begin
		if reset = '1' then
			state <= Idle;
			counter <= 0;
			result_reg <= (others => '0');
		elsif rising_edge(clk) then
			case state is
				WHEN Idle =>
					IF start = '1' THEN
						state <= Load;
					END IF;
				WHEN Load =>
					A_reg <= multiplicand;
					B_reg <= multiplier;
					M <= (OTHERS => '0');
					Q <= (OTHERS => '0');
					Q_reg <= (OTHERS => '0');
					M_reg <= (OTHERS => '0');
					M_neg <= '0';
					state <= Operation;	  
					
				WHEN Operation =>
					IF counter < 4 THEN
						IF Q(0) & Q_reg(0) = "01" THEN
							M_neg <= NOT M_neg;
							M <= Q_reg + B_reg;
						ELSIF Q(0) & Q_reg(0) = "10" THEN
							M <= Q_reg - B_reg;
						ELSE
							M <= M_reg;
						END IF;
						Q_reg <= Q;
						Q(0) <= Q_reg(4);
						Q(4 DOWNTO 1) <= Q_reg(3 DOWNTO 0);
						Q(4) <= A_reg(3);
						A_reg <= A_reg(2 DOWNTO 0) & '0';
						M_reg <= M;
						B_reg <= "0" & B_reg(3 DOWNTO 1);
						counter <= counter + 1;
					ELSE
						state <= Finish;
					END IF;
					
				WHEN Finish =>
					result_reg <= Q_reg(3 DOWNTO 0) & M(3 DOWNTO 0);
					done <= '1';
					state <= Idle;
					
				WHEN OTHERS =>
					state <= Idle;
			END CASE;
		END IF;
	END PROCESS;
	product <= result_reg;
END Behavioral;