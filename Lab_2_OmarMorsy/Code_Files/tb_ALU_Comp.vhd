-- Comparison Unit Testbench
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb_ALU_Comp IS
-- Declarations
END tb_ALU_Comp;

ARCHITECTURE testbench OF tb_ALU_Comp IS
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
    
    signal A_31_tb  : std_logic;
    signal B_31_tb  : std_logic;
    signal S_31_tb  : std_logic;
    signal CO_tb    : std_logic;
    signal ALUOp_tb : std_logic_vector(1 DOWNTO 0);
    signal R_tb     : std_logic_vector(31 DOWNTO 0);
    
BEGIN
    UUT: ALU_Comp PORT MAP (
        A_31 => A_31_tb,
        B_31 => B_31_tb,
        S_31 => S_31_tb,
        CO => CO_tb,
        ALUOp => ALUOp_tb,
        R => R_tb
    );
    
    stimulus: process
    begin
        -- Test cases based on truth table from lab instructions
        
        -- Undefined operations (ALUOp = "00" and "01")
        ALUOp_tb <= "00";
        A_31_tb <= '0'; B_31_tb <= '0'; S_31_tb <= '0'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000000" report "Undefined op 00 failed" severity error;
        
        ALUOp_tb <= "01";
        wait for 10 ns;
        assert R_tb = X"00000000" report "Undefined op 01 failed" severity error;
        
        -- SLT (ALUOp = "10") test cases
        ALUOp_tb <= "10";
        
        -- Case: both positive, A >= B (result positive)
        A_31_tb <= '0'; B_31_tb <= '0'; S_31_tb <= '0'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000000" report "SLT case 1 failed" severity error;
        
        -- Case: both positive, A < B (result negative)
        A_31_tb <= '0'; B_31_tb <= '0'; S_31_tb <= '1'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000001" report "SLT case 2 failed" severity error;
        
        -- Case: both negative, A >= B (result positive)
        A_31_tb <= '1'; B_31_tb <= '1'; S_31_tb <= '0'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000000" report "SLT case 3 failed" severity error;
        
        -- Case: both negative, A < B (result negative)
        A_31_tb <= '1'; B_31_tb <= '1'; S_31_tb <= '1'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000001" report "SLT case 4 failed" severity error;
        
        -- Case: A negative, B positive (A < B always)
        A_31_tb <= '1'; B_31_tb <= '0'; S_31_tb <= '0'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000001" report "SLT case 5 failed" severity error;
        
        -- Case: A positive, B negative (A >= B always)
        A_31_tb <= '0'; B_31_tb <= '1'; S_31_tb <= '0'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000000" report "SLT case 6 failed" severity error;
        
        -- SLTU (ALUOp = "11") test cases
        ALUOp_tb <= "11";
        
        -- Case: carry out present (A >= B)
        A_31_tb <= '0'; B_31_tb <= '0'; S_31_tb <= '0'; CO_tb <= '1';
        wait for 10 ns;
        assert R_tb = X"00000000" report "SLTU case 1 failed" severity error;
        
        -- Case: no carry out (A < B)
        A_31_tb <= '0'; B_31_tb <= '0'; S_31_tb <= '0'; CO_tb <= '0';
        wait for 10 ns;
        assert R_tb = X"00000001" report "SLTU case 2 failed" severity error;
        
        report "Comparison Unit testbench completed successfully" severity note;
        wait;
    end process;
END testbench;