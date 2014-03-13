
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_level_testbench IS
END top_level_testbench;
 
ARCHITECTURE behavior OF top_level_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT atlys_remote_terminal_pb
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         switch : IN  std_logic_vector(7 downto 0);
         btn : IN  std_logic_vector(3 downto 0);
         led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal switch : std_logic_vector(7 downto 0) := (others => '0');
   signal btn : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: atlys_remote_terminal_pb PORT MAP (
          clk => clk,
          reset => reset,
          switch => switch,
          btn => btn,
          led => led
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		reset <= '1';
		switch <= (others => '0');
		btn <= (others => '0');
		wait for clk_period*4;
		reset <= '0';
		
      wait for clk_period*20;
		
		switch <= "00001111";
		wait for clk_period*20;
		switch <= "00001111";
		wait for clk_period*20;
		btn <= "1111";
		wait for clk_period*20;
		btn <= "1100";
		wait for clk_period*20;
		
		
		

      

      wait;
   end process;

END;
