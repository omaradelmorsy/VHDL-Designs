-- Logical Unit Testbench
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb_ALU_Logical IS
-- Declarations
END tb_ALU_Logical;

ARCHITECTURE testbench OF tb_ALU_Logical IS
    COMPONENT ALU_Logical
        PORT( 
            A   : IN     std_logic_vector (31 DOWNTO 0);
            B   : IN     std_logic_vector (31 DOWNTO 0);
            Op  : IN     std_logic_vector (1 DOWNTO 0);
            R   : OUT    std_logic_vector (31 DOWNTO 0)
        );
    END COMPONENT;
    
    signal A_tb   : std_logic_vector(31 DOWNTO 0);
    signal B_tb   : std_logic_vector(31 DOWNTO 0);
    signal Op_tb  : std_logic_vector(1 DOWNTO 0);
    signal R_tb   : std_logic_vector(31 DOWNTO 0);
    
BEGIN
    UUT: ALU_Logical PORT MAP (
        A => A_tb,
        B => B_tb,
        Op => Op_tb,
        R => R_tb
    );
    
    stimulus: process
    begin
        -- Test AND operation (Op = "00")
        A_tb <= X"AAAAAAAA";
        B_tb <= X"CCCCCCCC";
        Op_tb <= "00";
        wait for 10 ns;
        assert R_tb = X"88888888" report "AND operation failed" severity error;
        
        -- Test OR operation (Op = "01")
        Op_tb <= "01";
        wait for 10 ns;
        assert R_tb = X"EEEEEEEE" report "OR operation failed" severity error;
        
        -- Test XOR operation (Op = "10")
        Op_tb <= "10";
        wait for 10 ns;
        assert R_tb = X"66666666" report "XOR operation failed" severity error;
        
        -- Test NOR operation (Op = "11")
        Op_tb <= "11";
        wait for 10 ns;
        assert R_tb = X"11111111" report "NOR operation failed" severity error;
        
        -- Additional test cases
        A_tb <= X"FFFFFFFF";
        B_tb <= X"00000000";
        
        -- Test AND with all 1s and all 0s
        Op_tb <= "00";
        wait for 10 ns;
        assert R_tb = X"00000000" report "AND with 0s failed" severity error;
        
        -- Test OR with all 1s and all 0s
        Op_tb <= "01";
        wait for 10 ns;
        assert R_tb = X"FFFFFFFF" report "OR with 1s failed" severity error;
        
        report "Logical Unit testbench completed successfully" severity note;
        wait;
    end process;
END testbench;
