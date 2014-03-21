----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    08:04:38 03/13/2014 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
-- Project Name: 	 Lab4A picoblaze
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity atlys_remote_terminal_pb is
    port (
             clk        : in  std_logic;
             reset      : in  std_logic;
             serial_in  : in  std_logic;
             serial_out : out std_logic;
             switch     : in  std_logic_vector(7 downto 0);
				 Led        : out std_logic_vector(7 downto 0)
				 
         );
end atlys_remote_terminal_pb;


architecture Behavioral of atlys_remote_terminal_pb is


--===========================================================================
---------------------------------COMPONENTS----------------------------------
--===========================================================================


  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;



  component requiredRom                            
    generic(   C_FAMILY : string := "S6"; 
               C_RAM_SIZE_KWORDS : integer := 1;
               C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;
  
  COMPONENT nibble_to_ascii
	PORT(
		nibble : IN std_logic_vector(3 downto 0);          
		ascii : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ascii_to_nibble
	PORT(
		ascii : IN std_logic_vector(7 downto 0);          
		nibble : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
  
  COMPONENT uart_rx6
	PORT(
		serial_in : IN std_logic;
		en_16_x_baud : IN std_logic;
		buffer_read : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0);
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT uart_tx6
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		en_16_x_baud : IN std_logic;
		buffer_write : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_logic;          
		serial_out : OUT std_logic;
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic
		);
	END COMPONENT;

--===========================================================================
---------------------------------SIGNALS-------------------------------------
--===========================================================================

signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;
signal       cpu_reset : std_logic;
signal             rdl : std_logic;
signal     int_request : std_logic;
signal s_in, s_out, swt : std_logic;
signal baud					: std_logic;
signal rx_out, in_port_buff, switch_high, switch_low, led_high, led_low  : std_logic_vector (7 downto 0);
signal led_low_nibble, led_high_nibble : std_logic_vector (3 downto 0);
signal read_data_present, write_data_present, tx_out, rx_in, poop : std_logic;

--==================================================================
------------------BEGIN PROGRAM-------------------------------------
--==================================================================


begin

  processor: kcpsm6
    generic map ( 
			hwbuild => X"00", 
         interrupt_vector => X"3FF",
         scratch_pad_memory_size => 64)
    port map(      
			address => address,
         instruction => instruction,
         bram_enable => bram_enable,
         port_id => port_id,
         write_strobe => write_strobe,
         k_write_strobe => k_write_strobe,
         out_port => out_port,
         read_strobe => read_strobe,
         in_port => in_port,
         interrupt => '0',
         interrupt_ack => interrupt_ack,
         sleep => '0',
         reset => kcpsm6_reset,
         clk => clk
		);
 

  program_rom: requiredRom                    --Name to match your PSM file
    generic map(             
			C_FAMILY => "S6",            --Family 'S6', 'V6' or '7S'
         C_RAM_SIZE_KWORDS => 1,      --Program size '1', '2' or '4'
         C_JTAG_LOADER_ENABLE => 1)   --Include JTAG Loader when set to '1' 
    port map(     
			address => address,      
			instruction => instruction,
         enable => bram_enable,
         rdl => kcpsm6_reset,
         clk => clk
		);

	--reads in from terminal
	Inst_uart_rx6: uart_rx6 
	PORT MAP(
		serial_in => serial_in,
		en_16_x_baud => baud,
		data_out => in_port_buff,
		buffer_read => read_data_present,
		buffer_data_present => poop,
		buffer_half_full => open,
		buffer_full =>open,
		buffer_reset => reset,
		clk => clk
	);
		
	--writes out to terminal 	
	Inst_uart_tx6: uart_tx6 
	PORT MAP(
		data_in => out_port,
		en_16_x_baud => baud,
		serial_out => serial_out ,
		buffer_write => write_data_present,
		buffer_data_present => open,
		buffer_half_full =>open ,
		buffer_full => open,
		buffer_reset => reset,
		clk => clk
	);
		
	Inst_clk_to_baud: entity work.clk_to_baud(Behavioral) 
	PORT MAP(
		clk => clk,
		reset => reset,
		baud_16x_en => baud
	);
			


----===============================================================
-----------------------STROBE_LOGIC--------------------------------
----===============================================================
read_data_present <= '1' when port_id = x"07" and read_strobe = '1'
							  else '0';
							  
write_data_present <= '1' when port_id = x"07" and write_strobe = '1'
							  else '0';
							  
process(port_id)
begin
if(rising_edge(clk)) then
	case port_id is
		when  x"07" => 
			in_port <= in_port_buff;
		when  x"08" => 
			in_port <= switch_high;
			
		when  x"09" => 
			in_port <= switch_low;
			
		when x"0A" =>
			in_port <= "0000000"& poop;
		when others => 
			in_port <= "00000000";
	end case;
end if;
end process;

 
 led_low <= out_port when write_strobe = '1' and port_id <= x"08";
 led_high <= out_port when write_strobe = '1' and port_id <= x"09";
 
				
----===============================================================
--------------------------LED_LOGIC--------------------------------
----===============================================================

	Hi_nibble_to_ascii: nibble_to_ascii PORT MAP(
		nibble => switch (7 downto 4),
		ascii =>  switch_high
	);
	
	Low_nibble_to_ascii: nibble_to_ascii PORT MAP(
		nibble => switch (3 downto 0),
		ascii => switch_low
	);
	
	High_ascii_to_nibble: ascii_to_nibble PORT MAP(
		ascii => led_high,
		nibble => led_high_nibble
	);
	
	Low_ascii_to_nibble: ascii_to_nibble PORT MAP(
		ascii => led_low,
		nibble => led_low_nibble
	);

		Led <= led_high_nibble & led_low_nibble;
	

end Behavioral;