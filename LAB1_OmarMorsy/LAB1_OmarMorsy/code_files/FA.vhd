--Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 --Starting the entity
entity FA is   
	Port (  A : in STD_LOGIC;
		B : in STD_LOGIC;
		Cin  : in STD_LOGIC;
		S	 : out STD_LOGIC;
		Cout : out STD_LOGIC);
	end FA;   -- The ending of the entity
 --The archtecture
architecture arch_FA of FA is
 
--defining some signals
 signal sig_a: STD_LOGIC; 
 signal sig_b: STD_LOGIC; 
 signal sig_c: STD_LOGIC; 
 signal sig_d: STD_LOGIC; 
 signal sig_e: STD_LOGIC; 
 signal sig_f: STD_LOGIC; 
 signal sig_g: STD_LOGIC; 
 
begin
	

	sig_a <= A AND B;
	sig_b <= A AND Cin;
	sig_c <= B AND Cin;
	sig_d <= A XOR B;
	sig_e <= sig_d XOR Cin;
	sig_f <= sig_a OR sig_b;
	sig_g <= sig_b OR sig_c;
	
	Cout <= sig_f OR sig_g;
	S <= sig_e;
	
		
		
end arch_FA;   --The end of the archtecture