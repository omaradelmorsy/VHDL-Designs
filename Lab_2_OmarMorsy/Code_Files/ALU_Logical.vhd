LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU_Logical IS     --Starting the entity
    PORT( 
        A   : IN     std_logic_vector (31 DOWNTO 0);
        B   : IN     std_logic_vector (31 DOWNTO 0);
        Op  : IN     std_logic_vector (1 DOWNTO 0);
        R   : OUT    std_logic_vector (31 DOWNTO 0)
    );
-- Declarations
END ALU_Logical;

ARCHITECTURE struct OF ALU_Logical IS
    signal AND_result : std_logic_vector(31 DOWNTO 0);
    signal OR_result  : std_logic_vector(31 DOWNTO 0);
    signal XOR_result : std_logic_vector(31 DOWNTO 0);
    signal NOR_result : std_logic_vector(31 DOWNTO 0);
BEGIN
    -- Performing all operations in parallel
    AND_result <= A AND B;
    OR_result  <= A OR B;
    XOR_result <= A XOR B;
    NOR_result <= A NOR B;
    
    -- Selecting the result based on Op
    R <= AND_result WHEN (Op = "00") ELSE
         OR_result  WHEN (Op = "01") ELSE
         XOR_result WHEN (Op = "10") ELSE
         NOR_result WHEN (Op = "11") ELSE
         (others => '0');
END struct;