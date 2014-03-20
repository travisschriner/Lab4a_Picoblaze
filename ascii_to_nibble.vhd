----------------------------------------------------------------------------------
-- Company: USAFA DFEC	
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    10:43:49 03/18/2014 
-- Design Name: 
-- Module Name:    ascii_to_nibble - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ascii_to_nibble is
    port ( ascii : in std_logic_vector(7 downto 0);
           nibble  : out std_logic_vector(3 downto 0)
         );
end ascii_to_nibble;

architecture Behavioral of ascii_to_nibble is

begin
		process(ascii)
		begin
		--if statements wont work...
		case ascii is
			when x"30" =>
				nibble  <= x"0";
			when x"31" =>
				nibble  <= x"1";
			when x"32" =>
				nibble  <= x"2";
			when x"33" =>
				nibble  <= x"3";
			when x"34" =>
				nibble  <= x"4";
			when x"35" =>
				nibble  <= x"5";
			when x"36" =>
				nibble  <= x"6";
			when x"37" =>
				nibble  <= x"7";
			when x"38" =>
				nibble  <= x"8";
			when x"39" =>
				nibble  <= x"9";
			when x"41" =>
				nibble  <= x"A";
			when x"42" =>
				nibble 	<= x"B";
			when x"43" =>
				nibble 	<= x"C";
			when x"44" =>
				nibble 	<= x"D";
			when x"45" =>
				nibble 	<= x"E";
			when x"46" =>
				nibble 	<= x"F";
			when	others =>
				nibble 	<= x"0";
		end case;
end process;
end Behavioral;

