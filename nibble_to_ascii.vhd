----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    10:48:37 03/18/2014 
-- Design Name: 
-- Module Name:    nibble_to_ascii - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity nibble_to_ascii is
    port ( nibble : in std_logic_vector(3 downto 0);
           ascii  : out std_logic_vector(7 downto 0)
         );
end nibble_to_ascii;

architecture Behavioral of nibble_to_ascii is

begin


end Behavioral;

