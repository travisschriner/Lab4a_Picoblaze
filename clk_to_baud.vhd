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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_to_baud is
    port ( clk         : in std_logic;
           reset       : in std_logic;
           baud_16x_en : out std_logic
        );
end clk_to_baud;

architecture Behavioral of clk_to_baud is

	signal count, count_next : unsigned(10 downto 0);

begin

	count_next <= 	count + 1 when count < 651 else
						(others => '0');
						
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				count <= (others => '0');
			else
				count <= count_next;
			end if;
		end if;
	end process;

	baud_16x_en <= 	'1' when count = 0 else
							'0';

end Behavioral;

