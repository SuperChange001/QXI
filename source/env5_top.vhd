----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2022 01:29:32 PM
-- Design Name: 
-- Module Name: env5_top - Behavioral
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

entity env5_top is
  port (
    sys_clk      : in std_logic;
    
    spi_clk      : in std_logic;
    spi_ss_n     : in std_logic;
    spi_mosi     : in std_logic;
    spi_miso     : out std_logic;
    
    leds         : out std_logic_vector(3 downto 0)
  );
end env5_top;

architecture rtl of env5_top is
    signal spi_reset_n : std_logic := '0';
    
    type buf_t is array (0 to 13) of std_logic_vector(7 downto 0);
    signal data_buf : buf_t := (x"ee", x"dd", x"cc", x"bb", x"aa", x"99", x"88", x"77", x"66", x"55", x"44", x"33", x"22", x"11");
    
    signal address : std_logic_vector(15 downto 0);
    signal tx_data, rx_data : std_logic_vector(7 downto 0);
    signal tx_en, rx_en : std_logic;
    signal spi_miso_s : std_logic;
begin

leds(0) <= spi_miso_s; --io8
leds(3) <= not spi_miso_s; --io9

leds(1) <= tx_en;
leds(2) <= rx_en;
spi_reset_process: process(sys_clk, spi_reset_n)
    variable reset_counting : integer range 0 to 40960 := 0;
begin
    if rising_edge(sys_clk) and spi_reset_n='0' then
        reset_counting := reset_counting + 1;
        if reset_counting = 40960 then
            spi_reset_n <= '1';
        end if;
    end if;
end process spi_reset_process;

rtx_process: process(sys_clk)
variable addr_var : integer range 0 to 13;
begin
    if rising_edge(sys_clk) then
        addr_var := to_integer(unsigned(address));
        
        if tx_en='1' then
            data_buf(addr_var) <= tx_data;
        end if;
        
        if rx_en='1' then
            rx_data <= data_buf(addr_var);
        end if;
    end if;
end process rtx_process;

i_spi_slaver: entity xil_defaultlib.spi_slave(rtl)
port map(
    reset_n => spi_reset_n,
    sclk => spi_clk,
    ss_n => spi_ss_n,
    mosi => spi_mosi,
    miso => spi_miso_s,
    clk => sys_clk,
    addr => address,
    data_wr => tx_data,
    data_rd => rx_data,
    we => tx_en,
    re => rx_en
);
spi_miso <= spi_miso_s;

--rx_data <= x"aa";

end rtl;
