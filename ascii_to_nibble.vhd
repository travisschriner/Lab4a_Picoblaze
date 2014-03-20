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
		
		if(ascii >= x"30" and ascii <= x"39) then
			nibble <= ascii-30;
		else if (ascii = x"41") then
			nibble <= x"A";
		else if (ascii = x"42") then
			nibble <= x"B";
		else if (ascii = x"43") then
			nibble <= x"C";
		else if (ascii = x"44") then
			nibble <= x"D";
		else if (ascii = x"45") then
			nibble <= x"E";
		else if (ascii = x"46") then
			nibble <= x"F";
		else 
			nibble <= x"0";
		end if
	end process;

end Behavioral;

