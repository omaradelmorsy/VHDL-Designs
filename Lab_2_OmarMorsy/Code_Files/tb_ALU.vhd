LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb_ALU IS
-- Declarations
END tb_ALU;

ARCHITECTURE testbench OF tb_ALU IS
    COMPONENT ALU_Imp  
        PORT( 
            A       : IN     std_logic_vector (31 DOWNTO 0);
            B       : IN     std_logic_vector (31 DOWNTO 0);
            ALUOp   : IN     std_logic_vector (3 DOWNTO 0);
            SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
            R       : OUT    std_logic_vector (31 DOWNTO 0);
            Zero    : OUT    std_logic;
            Overflow: OUT    std_logic
        );
    END COMPONENT;
    
    signal A_tb       : std_logic_vector(31 DOWNTO 0) := (others => '0');  
    signal B_tb       : std_logic_vector(31 DOWNTO 0) := (others => '0');
    signal ALUOp_tb   : std_logic_vector(3 DOWNTO 0) := "0000";
    signal SHAMT_tb   : std_logic_vector(4 DOWNTO 0) := "00000";
    signal R_tb       : std_logic_vector(31 DOWNTO 0);
    signal Zero_tb    : std_logic;
    signal Overflow_tb: std_logic;
    
BEGIN
    UUT: ALU_Imp PORT MAP (  
        A => A_tb,
        B => B_tb,
        ALUOp => ALUOp_tb,
        SHAMT => SHAMT_tb,
        R => R_tb,
        Zero => Zero_tb,
        Overflow => Overflow_tb
    );
    
    stimulus: process
    begin
        -- Waiting for initialization
        wait for 1 ns;
        
        -- Initialize
        SHAMT_tb <= "00000";
        wait for 1 ns;  --Small delay after initialization
        
        -- Test 1: AND operation (ALUOp = "0000")
        A_tb <= X"AAAAAAAA";
        B_tb <= X"CCCCCCCC";
        ALUOp_tb <= "0000";
        wait for 10 ns;
        assert R_tb = X"88888888" report "Test 1: AND operation failed" severity error;
        report "Test 1: AND - PASSED";
        
        -- Test 2: OR operation (ALUOp = "0001")
        ALUOp_tb <= "0001";
        wait for 10 ns;
        assert R_tb = X"EEEEEEEE" report "Test 2: OR operation failed" severity error;
        report "Test 2: OR - PASSED";
        
        -- Test 3: XOR operation (ALUOp = "0010")
        ALUOp_tb <= "0010";
        wait for 10 ns;
        assert R_tb = X"66666666" report "Test 3: XOR operation failed" severity error;
        report "Test 3: XOR - PASSED";
        
        -- Test 4: NOR operation (ALUOp = "0011")
        ALUOp_tb <= "0011";
        wait for 10 ns;
        assert R_tb = X"11111111" report "Test 4: NOR operation failed" severity error;
        report "Test 4: NOR - PASSED";
        
        -- Test 5: ADD Signed operation (ALUOp = "0100")
        A_tb <= X"00000005";
        B_tb <= X"00000003";
        ALUOp_tb <= "0100";
        wait for 10 ns;
        assert R_tb = X"00000008" report "Test 5: ADD operation failed" severity error;
        assert Zero_tb = '0' report "Test 5: ADD Zero flag incorrect" severity error;
        report "Test 5: ADD - PASSED";
        
        -- Test 6: ADD Unsigned operation (ALUOp = "0101")
        ALUOp_tb <= "0101";
        wait for 10 ns;
        assert R_tb = X"00000008" report "Test 6: ADDU operation failed" severity error;
        report "Test 6: ADDU - PASSED";
        
        -- Test 7: SUB Signed operation (ALUOp = "0110")
        A_tb <= X"00000008";
        B_tb <= X"00000003";
        ALUOp_tb <= "0110";
        wait for 10 ns;
        assert R_tb = X"00000005" report "Test 7: SUB operation failed" severity error;
        report "Test 7: SUB - PASSED";
        
        -- Test 8: SUB Unsigned operation (ALUOp = "0111")
        ALUOp_tb <= "0111";
        wait for 10 ns;
        assert R_tb = X"00000005" report "Test 8: SUBU operation failed" severity error;
        report "Test 8: SUBU - PASSED";
        
        -- Test 9: SLT operation (ALUOp = "1010")
        A_tb <= X"00000003";
        B_tb <= X"00000005";
        ALUOp_tb <= "1010";
        wait for 10 ns;
        assert R_tb = X"00000001" report "Test 9: SLT operation failed" severity error;
        report "Test 9: SLT - PASSED";
        
        -- Test 10: SLTU operation (ALUOp = "1011")
        ALUOp_tb <= "1011";
        wait for 10 ns;
        assert R_tb = X"00000001" report "Test 10: SLTU operation failed" severity error;
        report "Test 10: SLTU - PASSED";
        
        -- Test 11: SLL operation (ALUOp = "1100")
        A_tb <= X"FEDCBA98";
        SHAMT_tb <= "00001";
        ALUOp_tb <= "1100";
        wait for 10 ns;
        assert R_tb = X"FDB97530" report "Test 11: SLL operation failed" severity error;
        report "Test 11: SLL - PASSED";
        
        -- Test 12: SRL operation (ALUOp = "1110")
        ALUOp_tb <= "1110";
        wait for 10 ns;
        assert R_tb = X"7F6E5D4C" report "Test 12: SRL operation failed" severity error;
        report "Test 12: SRL - PASSED";
        
        -- Test 13: SRA operation (ALUOp = "1111")
        ALUOp_tb <= "1111";
        wait for 10 ns;
        assert R_tb = X"FF6E5D4C" report "Test 13: SRA operation failed" severity error;
        report "Test 13: SRA - PASSED";
        
        -- Additional Tests
        
        -- Test Zero Flag
        A_tb <= X"00000005";
        B_tb <= X"00000005";
        ALUOp_tb <= "0110"; -- SUB
        SHAMT_tb <= "00000";
        wait for 10 ns;
        assert R_tb = X"00000000" report "Zero test: SUB result incorrect" severity error;
        assert Zero_tb = '1' report "Zero test: Zero flag not set" severity error;
        report "Test Zero Flag - PASSED";
        
        -- Test Overflow (positive + positive = negative)
        A_tb <= X"7FFFFFFF"; -- Max positive 32-bit signed
        B_tb <= X"00000001";
        ALUOp_tb <= "0100"; -- ADD
        wait for 10 ns;
        assert R_tb = X"80000000" report "Overflow test: Result incorrect" severity error;
        assert Overflow_tb = '1' report "Overflow test: Overflow flag not set" severity error;
        report "Test Overflow Flag - PASSED";
        
        -- Test Large Shift
        A_tb <= X"FEDCBA98";
        SHAMT_tb <= "01000"; -- Shift by 8
        ALUOp_tb <= "1100"; -- SLL
        wait for 10 ns;
        assert R_tb = X"DCBA9800" report "Large shift test failed" severity error;
        report "Test Large Shift - PASSED";
        
        report "===  ALU Testbench - ALL TESTS PASSED ===";
        wait;
    end process;
END testbench;