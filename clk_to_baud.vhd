----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:49:36 03/18/2014 
-- Design Name: 
-- Module Name:    clk_to_baud - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_to_baud is
	 generic(
					N: integer
				);
    port ( clk         : in std_logic;
           reset       : in std_logic;
           baud_16x_en : out std_logic
        );
end clk_to_baud;

architecture Behavioral of clk_to_baud is

signal count 		 : integer;
signal baud_ripple :	std_logic;

begin
	process(clk)
	begin
		if(reset = '1') then
			baud_ripple <= '0';
			count <= 0;
		elsif(rising_edge(clk)) then
			if(count = N) then
				baud_ripple <='1';
				count <= 0;
			else
				baud_ripple <= '0';
				count <= count+1;
			end if;
		end if;
	end process;



baud_16x_en <= baud_ripple;
end Behavioral;

