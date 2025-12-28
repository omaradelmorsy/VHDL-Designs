-- ALU Arith

library ieee;
USE ieee.std_logic_1164.all;


-- The entity
ENTITY ALU_Arith IS :
PORT (
       ALUOp : in std_logic_vector(1 downto 0);
		 
		 A : in std_logic_vector (31 downto 0);
		 B : in std_logic_vector (31 downto 0);
		 ArithR : out std_logic_vector (31 downto 0);
		 overflow : out std_logic;
		 Carryout : out std_logic;
		 Zero : out std_logic
		 );
END ALU_Arith;

Architecture ALU_ArithA of ALU_Arith IS
Begin
	 