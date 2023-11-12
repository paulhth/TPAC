library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	 --has std_logic and std_logic_vector
use IEEE.NUMERIC_STD.ALL;		 --has SIGNED() and UNSIGNED() functions


ENTITY Control_Unit IS
    GENERIC (tp: TIME := 5ns);
    PORT (
        input_bit: in STD_LOGIC;
        clock: in STD_LOGIC;
        control_signals: OUT STD_LOGIC_VECTOR(1 downto 0)
    );
END ENTITY;

ARCHITECTURE process_architecture OF Control_Unit IS
    TYPE states IS (idle, add, subtract, shift);
    SIGNAL current_state: states;

BEGIN

    PROCESS (clock)
        VARIABLE state: states := idle;
    BEGIN
        IF clock = '0' AND clock'EVENT THEN
            -- set control signals based on the current state
            CASE state IS
                WHEN idle =>
                    control_signals <= "00" after tp; -- NOP
                    IF input_bit = '0' THEN 
                        state := idle;
                    ELSE 
                        state := shift;
                    END IF;
                WHEN add =>
                    control_signals <= "01" after tp; -- +
                    IF input_bit = '0' THEN 
                        state := subtract;
                    ELSE 
                        state := shift;
                    END IF;
                WHEN subtract =>
                    control_signals <= "10" after tp; -- -
                    IF input_bit = '0' THEN 
                        state := add;
                    ELSE 
                        state := shift;
                    END IF;
                WHEN shift =>
                    control_signals <= "11" after tp; -- shift
                    IF input_bit = '0' THEN 
                        state := add;
                    ELSE 
                        state := idle;
                    END IF;
            END CASE;
            current_state <= state; -- update state
        END IF;
    END PROCESS;
END ARCHITECTURE;
