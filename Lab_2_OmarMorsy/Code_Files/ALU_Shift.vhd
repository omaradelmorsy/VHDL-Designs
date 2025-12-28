LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU_Shift IS  --Starting the entity
    PORT( 
        A       : IN     std_logic_vector (31 DOWNTO 0);
        SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
        ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
        R       : OUT    std_logic_vector (31 DOWNTO 0)
    );
-- Declarations
END ALU_Shift;

ARCHITECTURE struct OF ALU_Shift IS
    signal Fill : std_logic_vector(31 DOWNTO 0);
    
    -- Left shift intermediate signals
    signal L_0, L_1, L_2, L_3, L_4 : std_logic_vector(31 DOWNTO 0);
    
    -- Right shift intermediate signals
    signal R_0, R_1, R_2, R_3, R_4 : std_logic_vector(31 DOWNTO 0);
    
BEGIN
    -- Fill signal for arithmetic right shift
    Fill <= (others => ALUOp(0) AND A(31));
    
    -- Left shift logic (following flowchart from lab instructions)
    L_0 <= A(30 DOWNTO 0) & '0' WHEN (SHAMT(0) = '1') ELSE A;
    L_1 <= L_0(29 DOWNTO 0) & "00" WHEN (SHAMT(1) = '1') ELSE L_0;
    L_2 <= L_1(27 DOWNTO 0) & "0000" WHEN (SHAMT(2) = '1') ELSE L_1;
    L_3 <= L_2(23 DOWNTO 0) & "00000000" WHEN (SHAMT(3) = '1') ELSE L_2;
    L_4 <= L_3(15 DOWNTO 0) & "0000000000000000" WHEN (SHAMT(4) = '1') ELSE L_3;
    
    -- Right shift logic (following flowchart from lab instructions)
    R_0 <= Fill(0) & A(31 DOWNTO 1) WHEN (SHAMT(0) = '1') ELSE A;
    R_1 <= Fill(1 DOWNTO 0) & R_0(31 DOWNTO 2) WHEN (SHAMT(1) = '1') ELSE R_0;
    R_2 <= Fill(3 DOWNTO 0) & R_1(31 DOWNTO 4) WHEN (SHAMT(2) = '1') ELSE R_1;
    R_3 <= Fill(7 DOWNTO 0) & R_2(31 DOWNTO 8) WHEN (SHAMT(3) = '1') ELSE R_2;
    R_4 <= Fill(15 DOWNTO 0) & R_3(31 DOWNTO 16) WHEN (SHAMT(4) = '1') ELSE R_3;
    
    -- Selecting between left and right shift
    R <= L_4 WHEN (ALUOp(1) = '0') ELSE R_4;
END struct;