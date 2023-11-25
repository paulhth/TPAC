LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ControlUnit_tb IS
END ControlUnit_tb;
ARCHITECTURE TB_ARCH OF ControlUnit_tb IS
	SIGNAL clk, reset, start : std_logic := '0';
	SIGNAL multiplicand, multiplier : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL product : std_logic_vector(7 DOWNTO 0);
	SIGNAL done : std_logic;
	CONSTANT clock_period : TIME := 5 ns; -- Adjust the clock period as needed
	-- Instantiate the BoothMultiplier component
	COMPONENT ControlUnit
		PORT
		(
			clk, reset : IN STD_LOGIC;
			start : IN STD_LOGIC;
			multiplicand, multiplier : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			product : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			done : OUT STD_LOGIC
		);
	END COMPONENT;
BEGIN
	-- Instantiate the BoothMultiplier component
	UUT : ControlUnit
	PORT MAP(clk, reset, start, multiplicand, multiplier, product, done);
	-- Clock process
	PROCESS
	BEGIN
		WHILE now < 1000 ns LOOP -- Simulate for 1000 ns
		clk <= '0';
		WAIT FOR clock_period / 2;
		clk <= '1';
		WAIT FOR clock_period / 2;
	END LOOP;
	WAIT;
	END PROCESS;
	-- Stimulus process
	PROCESS
	BEGIN
		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 10 ns;
		start <= '1';
		multiplicand <= "1011"; -- Example input values
		multiplier <= "1101";
		WAIT UNTIL done = '1'; -- Wait for multiplication to complete
		WAIT;
	END PROCESS;
END TB_ARCH;