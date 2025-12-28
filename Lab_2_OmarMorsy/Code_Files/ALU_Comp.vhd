-- ALU COMP
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU_Comp IS
    PORT( 
        A_31    : IN     std_logic;
        B_31    : IN     std_logic;
        S_31    : IN     std_logic;
        CO      : IN     std_logic;
        ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
        R       : OUT    std_logic_vector (31 DOWNTO 0)
    );
-- Declarations
END ALU_Comp;

ARCHITECTURE struct OF ALU_Comp IS
    signal result_bit : std_logic;
    signal SLT_result : std_logic;
    signal SLTU_result : std_logic;
BEGIN
    -- SLT logic (signed comparison)
    SLT_result <= '1' WHEN (A_31 = '1' AND B_31 = '0') ELSE  -- A negative, B positive
                  '0' WHEN (A_31 = '0' AND B_31 = '1') ELSE  -- A positive, B negative
                  S_31;  -- Same signs, check result sign
    
    -- SLTU logic (unsigned comparison)
    SLTU_result <= NOT CO;  -- No carry out means A < B for unsigned
    
    -- Selecting result based on operation
    result_bit <= SLT_result WHEN (ALUOp = "10") ELSE
                  SLTU_result WHEN (ALUOp = "11") ELSE
                  '0';
    
    -- Setting output
    R(0) <= result_bit;
    R(31 DOWNTO 1) <= (others => '0');
END struct;