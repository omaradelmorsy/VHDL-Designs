
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU_Imp IS
    PORT( 
        A       : IN     std_logic_vector (31 DOWNTO 0);
        B       : IN     std_logic_vector (31 DOWNTO 0);
        ALUOp   : IN     std_logic_vector (3 DOWNTO 0);
        SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
        R       : OUT    std_logic_vector (31 DOWNTO 0);
        Zero    : OUT    std_logic;
        Overflow: OUT    std_logic
    );
-- Declarations
END ALU_Imp;

ARCHITECTURE struct OF ALU_Imp IS
    -- Component declarations 
    COMPONENT ALU_Logical
        PORT( 
            A   : IN     std_logic_vector (31 DOWNTO 0);
            B   : IN     std_logic_vector (31 DOWNTO 0);
            Op  : IN     std_logic_vector (1 DOWNTO 0);
            R   : OUT    std_logic_vector (31 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Arith_Unit
        GENERIC (n : positive := 32);
        PORT( 
            A       : IN     std_logic_vector (n-1 DOWNTO 0);
            B       : IN     std_logic_vector (n-1 DOWNTO 0);
            C_op    : IN     std_logic_vector (1 DOWNTO 0);
            CO      : OUT    std_logic;
            OFL     : OUT    std_logic;
            S       : OUT    std_logic_vector (n-1 DOWNTO 0);
            Z       : OUT    std_logic
        );
    END COMPONENT;
    
    COMPONENT ALU_Comp
        PORT( 
            A_31    : IN     std_logic;
            B_31    : IN     std_logic;
            S_31    : IN     std_logic;
            CO      : IN     std_logic;
            ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
            R       : OUT    std_logic_vector (31 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT ALU_Shift
        PORT( 
            A       : IN     std_logic_vector (31 DOWNTO 0);
            SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
            ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
            R       : OUT    std_logic_vector (31 DOWNTO 0)
        );
    END COMPONENT;
    
    -- Internal signals
    signal LogicalR : std_logic_vector(31 DOWNTO 0);
    signal ArithR   : std_logic_vector(31 DOWNTO 0);
    signal CompR    : std_logic_vector(31 DOWNTO 0);
    signal ShiftR   : std_logic_vector(31 DOWNTO 0);
    signal Carryout : std_logic;
    signal ArithZ   : std_logic;
    signal ArithOFL : std_logic;
    
BEGIN
    -- Instantiate all units
    U_Logic: ALU_Logical PORT MAP (
        A => A,
        B => B,
        Op => ALUOp(1 DOWNTO 0),
        R => LogicalR
    );
    
    U_Arith: Arith_Unit 
    GENERIC MAP (n => 32)
    PORT MAP (
        A => A,
        B => B,
        C_op => ALUOp(1 DOWNTO 0),
        CO => Carryout,
        OFL => ArithOFL,
        S => ArithR,
        Z => ArithZ
    );
    
    U_Comp: ALU_Comp PORT MAP (
        A_31 => A(31),
        B_31 => B(31),
        S_31 => ArithR(31),
        CO => Carryout,
        ALUOp => ALUOp(1 DOWNTO 0),
        R => CompR
    );
    
    U_Shift: ALU_Shift PORT MAP (
        A => A,
        SHAMT => SHAMT,
        ALUOp => ALUOp(1 DOWNTO 0),
        R => ShiftR
    );
    
    -- Final multiplexer 
    R <= LogicalR WHEN (ALUOp(3 DOWNTO 2) = "00") ELSE  -- Logic operations
         ArithR   WHEN (ALUOp(3 DOWNTO 2) = "01") ELSE  -- Arithmetic operations
         CompR    WHEN (ALUOp(3 DOWNTO 2) = "10") ELSE  -- Comparison operations
         ShiftR   WHEN (ALUOp(3 DOWNTO 2) = "11") ELSE  -- Shift operations
         (others => '0');
    
    -- Output flags (only meaningful for arithmetic operations)
    Zero <= ArithZ WHEN (ALUOp(3 DOWNTO 2) = "01") ELSE '0';
    Overflow <= ArithOFL WHEN (ALUOp(3 DOWNTO 2) = "01") ELSE '0';
    
END struct;