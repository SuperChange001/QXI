library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;


library xil_defaultlib;
use xil_defaultlib.all;

library fpgamiddlewarelibs;
use fpgamiddlewarelibs.UserLogicInterface.all;

--!--! @brief      Main class for connecting all the components involved in the
--!             middleware
--!
entity middleware is
	port (
		reset  			: in std_logic;
		clk 				: in std_ulogic;	--! Clock 32 MHz

		-- userlogic
		userlogic_reset: out std_logic;
		userlogic_busy	: in std_logic;
		userlogic_data_in: out uint8_t;
		userlogic_data_out: in uint8_t;
		-- userlogic_address	: out uint16_t;
		userlogic_rd	: out std_logic;
		userlogic_wr	: out std_logic;
		
		-- debug
		interface_leds	: out std_logic_vector(3 downto 0);
		
		-- uart
		rx				: in std_logic;
		tx 				: out std_logic;

		flash_unavailable	: in std_logic;
		
		mcu_cs			: out std_logic;
		
		-- sram
		sram_address 	: in uint16_t;
		sram_data_out	: out uint8_t; -- for reading from ext ram
		sram_data_in 	: in uint8_t; 	-- for writing to ext ram
		sram_rd			: in std_logic;
		sram_wr			: in std_logic
	);
end middleware;


architecture Behavioral of middleware is

signal clk_icap 				: std_logic := '0';
signal icap_address				: uint32_t_interface;

-- uart variables
signal uart_en					: std_logic := '0';
signal uart_rx					: uint8_t_interface; -- std_logic_vector(7 downto 0);
signal uart_tx					: uint8_t_interface; -- std_logic_vector(7 downto 0);
signal uart_tx_done				: std_logic;
signal uart_tx_active			: std_logic;


begin

	-- Instantiate the Unit Under Test (UUT)
   fsm: entity fpgamiddlewarelibs.InterfaceStateMachine(Behavior) PORT MAP (
		 clk => clk,
		 reset => reset,
		 icap_address => icap_address,
		 sram_address => sram_address,
		 sram_data_out => sram_data_out,
		 sram_data_in => sram_data_in,
		 sram_rd => sram_rd,
		 sram_wr => sram_wr,
		 userlogic_reset => userlogic_reset,
		 userlogic_busy => userlogic_busy,
		 userlogic_data_in => userlogic_data_in,
		 -- userlogic_address => userlogic_address,
		 userlogic_data_out => userlogic_data_out,
		 userlogic_rd => userlogic_rd,
		 userlogic_wr => userlogic_wr,
		 leds => interface_leds
	  );



	
	-- outgoing_data <= multiboot_address(23 downto 16);
	
	--! ICAP interface initialisation
	process(clk, reset)
	begin
		if reset = '1' then	
			clk_icap <= '0';
		else
			if clk'event and clk = '1' then
				clk_icap <= not clk_icap;
			end if;
		end if;
	end process;
	
	ic : entity fpgamiddlewarelibs.icapInterface(Behavioral) generic map (goldenboot_address => (others => '0')) port map (clk => clk_icap, reset => reset, enable => icap_address.ready, flash_unavailable => flash_unavailable, status_running => open, multiboot_address => std_logic_vector(icap_address.data));

	
	
end Behavioral;
