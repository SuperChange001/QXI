----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2022 01:29:32 PM
-- Design Name: 
-- Module Name: env5_top_reconfig - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

library xil_defaultlib;
use xil_defaultlib.all;

library fpgamiddlewarelibs;
use fpgamiddlewarelibs.userlogicinterface.all;


entity env5_top_reconfig is
  port (
    sys_clk      : in std_logic;
    
    spi_clk      : in std_logic;
    spi_ss_n     : in std_logic;
    spi_mosi     : in std_logic;
    spi_miso     : out std_logic;
    
    leds         : out std_logic_vector(3 downto 0)
  );
end env5_top_reconfig;

architecture rtl of env5_top_reconfig is
    signal reset : std_logic := '0';
    signal spi_reset_n : std_logic := '0';
    
    type buf_t is array (0 to 13) of std_logic_vector(7 downto 0);
    signal data_buf : buf_t := (x"ee", x"dd", x"cc", x"bb", x"aa", x"99", x"88", x"77", x"66", x"55", x"44", x"33", x"22", x"11");
    
    signal sram_address : std_logic_vector(15 downto 0);
    signal sram_data_in, sram_data_out : std_logic_vector(7 downto 0);
    signal sram_wr, sram_rd : std_logic;
    signal spi_miso_s : std_logic;
    
    
    signal mw_leds : std_logic_vector(3 downto 0);
    signal mw_flash_unavailable : std_logic; -- '1' means can be use by the FPGA, '0' means it is hold by the MCU
    
    -- signals for user logic
    signal userlogic_reset, userlogic_rd, userlogic_wr : std_logic;
    signal userlogic_data_in : std_logic_vector(7 downto 0);
    signal userlogic_data_out : std_logic_vector(7 downto 0);
    signal userlogic_address : std_logic_vector(15 downto 0);
    
    
begin
    leds <= mw_leds;

    rtx_process: process(sys_clk)
    variable addr_var : integer range 0 to 20000;
    begin
        if rising_edge(sys_clk) then
            addr_var := to_integer(unsigned(userlogic_address));
            
            if addr_var < 14 then
                if userlogic_wr='1' then
                    data_buf(addr_var) <= userlogic_data_in;
                end if;
                
                if userlogic_rd='1' then
                    userlogic_data_out <= data_buf(addr_var);
                end if;
            elsif addr_var = 2000 then
                if userlogic_rd='1' then
                    userlogic_data_out <= x"11";
                end if;
            end if;
        end if;
    end process rtx_process;
    
    i_spi_slaver: entity xil_defaultlib.spi_slave(rtl)
    port map(
        reset_n => spi_reset_n,
        sclk => spi_clk,
        ss_n => spi_ss_n,
        mosi => spi_mosi,
        miso => spi_miso,
        clk => sys_clk,
        addr => sram_address,
        data_wr => sram_data_in, -- tx_data,
        data_rd => sram_data_out, -- rx_data,
        we => sram_wr, -- tx_en,
        re => sram_rd -- rx_en
    );
    spi_reset_n <= not reset;
    
    i_middleware: entity fpgamiddlewarelibs.middleware(rtl)
    port map(
        reset => reset,
        clk => sys_clk,
        
        -- userlogic
        userlogic_reset => userlogic_reset,
        userlogic_data_in => userlogic_data_in,
        userlogic_data_out => userlogic_data_out,
        userlogic_address => userlogic_address,
        userlogic_rd => userlogic_rd,
        userlogic_wr => userlogic_wr,
        
        -- debug
        interface_leds => mw_leds,
        
        -- flash
        flash_unavailable => mw_flash_unavailable,
        
        -- psram
        sram_address => sram_address,
        sram_data_out => sram_data_out,
        sram_data_in => sram_data_in,
        sram_rd => sram_rd,
        sram_wr => sram_wr
    );

    -- process to delay reset for fsm
	process (sys_clk, reset)
		constant reset_count : integer := 1000000; -- 1ms @ 100MHz
		variable count : integer range 0 to reset_count := 0;
	begin
		if reset = '1' then	
			
			if rising_edge(sys_clk) then
				if count < reset_count then
					count := count + 1;
					reset <= '1';
				else
					reset <= '0';
				end if;
			end if;
		end if;
	end process;
	
end rtl;
