library IEEE;                               -- Importing standard IEEE library
use IEEE.STD_LOGIC_1164.ALL;                -- For std_logic and std_logic_vector
use IEEE.NUMERIC_STD.ALL;                   -- For numeric operations on vectors

entity AddSub is
    Generic ( Width : INTEGER := 32 );      -- Generic parameter: word size (default = 32 bits)
    Port (  
        A       : in  STD_LOGIC_VECTOR (width-1 downto 0);  --  This is Input operand A
        B       : in  STD_LOGIC_VECTOR (width-1 downto 0);  -- This is Input operand B
        SUB : in  STD_LOGIC;                            -- Control: '0' = add, '1' = subtract
        S       : out STD_LOGIC_VECTOR (width-1 downto 0);  -- Result  is(sum or difference)
        Cout    : out STD_LOGIC                             -- Final carry/borrow output
    ); 
end AddSub;
-- The archtecture
architecture AddSub_arch of AddSub is
   
    signal New_B : STD_LOGIC_VECTOR (width-1 downto 0);       -- B after XOR with ADD_SUB (used for subtraction)
    signal SEG          : STD_LOGIC_VECTOR (width downto 0);         -- Carry chain (one extra bit for final carry)
   
begin
    -- XOR B with all bits of ADD_SUB.
    -- If ADD_SUB = '0': New_B = B (normal addition)
    -- If ADD_SUB = '1': New_B = NOT B (two's complement subtraction step)
    New_B <= B XOR (B'range => SUB);

    -- Setting the initial carry-in.
    -- If ADD_SUB = '0': C(0) = 0 (addition)
    -- If ADD_SUB = '1': C(0) = 1 (completes two's complement subtraction)
    SEG(0) <= SUB;

    -- Generating the full-adder chain for each bit of A and B_modified
    adderz : for i in 0 to width-1 generate
    begin
        addero : entity work.FA(arch_FA)   -- Instantiating the 1-bit full adder (FA entity, struct architecture)
            port map (
                A    => A(i),                  -- i-th bit of input A
                B    => New_B(i),         -- i-th bit of modified B
                Cin  => SEG(i),                  -- Carry-in from previous stage
                S    => S(i),                  -- i-th bit of result (sum/difference)
                Cout => SEG(i+1)                 -- Carry-out to next stage
            );
    end generate adderz;

    -- The last carry-out from the chain is the final Cout
    Cout <= SEG(width);
end AddSub_arch;

