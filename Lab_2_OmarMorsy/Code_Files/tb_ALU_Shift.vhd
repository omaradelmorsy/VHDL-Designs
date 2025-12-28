-- Shifter Unit Testbench
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb_ALU_Shift IS
-- Declarations
END tb_ALU_Shift;

ARCHITECTURE testbench OF tb_ALU_Shift IS
    COMPONENT ALU_Shift
        PORT( 
            A       : IN     std_logic_vector (31 DOWNTO 0);
            SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
            ALUOp   : IN     std_logic_vector (1 DOWNTO 0);
            R       : OUT    std_logic_vector (31 DOWNTO 0)
        );
    END COMPONENT;
    
    signal A_tb     : std_logic_vector(31 DOWNTO 0);
    signal SHAMT_tb : std_logic_vector(4 DOWNTO 0);
    signal ALUOp_tb : std_logic_vector(1 DOWNTO 0);
    signal R_tb     : std_logic_vector(31 DOWNTO 0);
    
BEGIN
    UUT: ALU_Shift PORT MAP (
        A => A_tb,
        SHAMT => SHAMT_tb,
        ALUOp => ALUOp_tb,
        R => R_tb
    );
    
    stimulus: process
    begin
        -- Test with negative number 
        A_tb <= X"FEDCBA98";
        
        -- Test SLL (Shift Left Logical) - ALUOp = "00"
        ALUOp_tb <= "00";
        SHAMT_tb <= "00000";  -- No shift
        wait for 10 ns;
        assert R_tb = X"FEDCBA98" report "SLL by 0 failed" severity error;
        
        SHAMT_tb <= "00001";  -- Shift by 1
        wait for 10 ns;
        assert R_tb = X"FDB97530" report "SLL by 1 failed" severity error;
        
        SHAMT_tb <= "00010";  -- Shift by 2
        wait for 10 ns;
        assert R_tb = X"FB72EA60" report "SLL by 2 failed" severity error;
        
        SHAMT_tb <= "00100";  -- Shift by 4
        wait for 10 ns;
        assert R_tb = X"EDCBA980" report "SLL by 4 failed" severity error;
        
        -- Test SRL (Shift Right Logical) - ALUOp = "10"
        ALUOp_tb <= "10";
        SHAMT_tb <= "00000";  -- No shift
        wait for 10 ns;
        assert R_tb = X"FEDCBA98" report "SRL by 0 failed" severity error;
        
        SHAMT_tb <= "00001";  -- Shift by 1
        wait for 10 ns;
        assert R_tb = X"7F6E5D4C" report "SRL by 1 failed" severity error;
        
        SHAMT_tb <= "00010";  -- Shift by 2
        wait for 10 ns;
        assert R_tb = X"3FB72EA6" report "SRL by 2 failed" severity error;
        
        SHAMT_tb <= "00100";  -- Shift by 4
        wait for 10 ns;
        assert R_tb = X"0FEDCBA9" report "SRL by 4 failed" severity error;
        
        -- Test SRA (Shift Right Arithmetic) - ALUOp = "11"
        ALUOp_tb <= "11";
        SHAMT_tb <= "00000";  -- No shift
        wait for 10 ns;
        assert R_tb = X"FEDCBA98" report "SRA by 0 failed" severity error;
        
        SHAMT_tb <= "00001";  -- Shift by 1
        wait for 10 ns;
        assert R_tb = X"FF6E5D4C" report "SRA by 1 failed" severity error;
        
        SHAMT_tb <= "00010";  -- Shift by 2
        wait for 10 ns;
        assert R_tb = X"FFB72EA6" report "SRA by 2 failed" severity error;
        
        SHAMT_tb <= "00100";  -- Shift by 4
        wait for 10 ns;
        assert R_tb = X"FFEDCBA9" report "SRA by 4 failed" severity error;
        
        -- Test with positive number (as requested in lab)
        A_tb <= X"7EDCBA98";
        ALUOp_tb <= "11";  -- SRA
        SHAMT_tb <= "00001";
        wait for 10 ns;
        assert R_tb = X"3F6E5D4C" report "SRA positive by 1 failed" severity error;
        
        SHAMT_tb <= "00100";
        wait for 10 ns;
        assert R_tb = X"07EDCBA9" report "SRA positive by 4 failed" severity error;
        
        report "Shifter Unit testbench completed successfully" severity note;
        wait;
    end process;
END testbench;
