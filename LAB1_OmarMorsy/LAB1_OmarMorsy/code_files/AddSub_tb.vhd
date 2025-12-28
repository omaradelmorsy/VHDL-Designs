library ieee;                                
use IEEE.STD_LOGIC_1164.ALL;                 
use IEEE.NUMERIC_STD.ALL;                    

entity AddSub_tb is
end AddSub_tb;                               

architecture TB of AddSub_tb is
    -- Internal signals to connect to DUT
    signal a_Sig     : std_logic_vector (31 downto 0);  
    signal b_Sig     : std_logic_vector (31 downto 0);  
    signal s_Sig     : std_logic_vector (31 downto 0);  
    signal SUB       : std_logic;                  
    signal Carry_out : std_logic;                 

    -- Component declaration for DUT
    component AddSub is
        Generic ( width : INTEGER := 32 ); 
        Port (
            A       : in  STD_LOGIC_VECTOR (width-1 downto 0);
            B       : in  STD_LOGIC_VECTOR (width-1 downto 0);
            SUB     : in  STD_LOGIC; 
            S       : out STD_LOGIC_VECTOR (width-1 downto 0);
            Cout    : out STD_LOGIC
        );
    end component;
begin
    UUT: AddSub
        port map (
            A    => a_Sig,
            B    => b_Sig,
            SUB  => SUB,
            S    => s_Sig,
            Cout => Carry_out
        );

    stim_proc: process
    begin
      
        
       

        -- Random Test Case 1: Addition of arbitrary numbers
        a_Sig <= x"0ABCDEF0"; 
        b_Sig <= x"12345000"; 
        SUB   <= '0';   
        wait for 10 ns;
        assert (s_Sig = x"1CE02EF0" and Carry_out = '0')
          report "Random Test Case one is failed";

        -- Random Test Case 2: Subtraction of arbitrary numbers
        a_Sig <= x"40000000"; 
        b_Sig <= x"10000000"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"30000000" and Carry_out = '1')
          report "Random Test Case two is failed";

        -- Random Test Case 3: Addition with carry out
        a_Sig <= x"FFFFFF00"; 
        b_Sig <= x"00000100"; 
        SUB   <= '0';   
        wait for 10 ns;
        assert (s_Sig = x"00000000" and Carry_out = '1')
          report "Random Test Case three is failed";

        -- Random Test Case 4: Subtraction with borrow
        a_Sig <= x"00000010"; 
        b_Sig <= x"00000020"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"FFFFFFF0" and Carry_out = '0')
          report "Random Test Case four is failed";

        -- Extra Test Case 6: Addition with zero
        a_Sig <= x"0000ABCD"; 
        b_Sig <= x"00000000"; 
        SUB   <= '0';   
        wait for 10 ns;
        assert (s_Sig = x"0000ABCD" and Carry_out = '0')
          report "Test Case six failed (Add zero)";

        --  Test Case 7: Subtraction with zero
        a_Sig <= x"0000ABCD"; 
        b_Sig <= x"00000000"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"0000ABCD" and Carry_out = '1')
          report "Test Case seven failed (Sub zero)";

        --  Test Case 8: Large equal subtraction
        a_Sig <= x"80000000"; 
        b_Sig <= x"80000000"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"00000000" and Carry_out = '1')
          report "Test Case eight failed (Large equal numbers)";
          
         
         
         
         
         
         
         --Corner test cases
          -- Test Case 1: Addition with overflow (carry out)
        a_Sig <= x"FFFFFFFE"; 
        b_Sig <= x"00000003"; 
        SUB   <= '0';   
        wait for 10 ns;
        assert (s_Sig = x"00000001" and Carry_out = '1')
          report "Test Case one is failed";

       
          
        -- Test Case 2: Simple addition without overflow
        a_Sig <= x"10000000"; 
        b_Sig <= x"20000000"; 
        SUB   <= '0';   
        wait for 10 ns;
        assert (s_Sig = x"30000000" and Carry_out = '0')
          report "Test Case two is failed";
         
          -- Test Case 3: Subtraction, result is negative (wrap-around)
        a_Sig <= x"00000005"; 
        b_Sig <= x"00000009"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"FFFFFFFC" and Carry_out = '0')
          report "Test Case three is failed";
          
           -- Test Case 4: Subtraction, result is positive
        a_Sig <= x"00004567"; 
        b_Sig <= x"00001234"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"00003333" and Carry_out = '1')
          report "Test Case four is failed";

        -- Test Case 5: Subtraction resulting in zero
        a_Sig <= x"00001234"; 
        b_Sig <= x"00001234"; 
        SUB   <= '1';   
        wait for 10 ns;
        assert (s_Sig = x"00000000" and Carry_out = '1')
          report "Test Case five is failed";


        report "All Test Cases are passed";  
        wait;  
    end process;
end TB;
