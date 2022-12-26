----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2022 02:43:26 PM
-- Design Name: 
-- Module Name: env5_top_tb - Behavioral
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
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity env5_top_tb is
generic(
constant C_CLK_PERIOD : time := 10 ns 
);
port(
    clk_s: out std_logic
    );end env5_top_tb;

architecture Behavioral of env5_top_tb is

    -- Testbench DUT generics
    procedure mosi_write_byte(
                            variable   data   : in std_logic_vector(7 downto 0);
                            signal     mosi   : out std_logic;
                            signal     spi_clk: out std_logic) is
    variable counter:integer:=0;
    begin      
        for i in 0 to 7 loop
            mosi <= data(7-i);
            spi_clk <= '1';
            wait for C_CLK_PERIOD*0.5;
            spi_clk <= '0';
            wait for C_CLK_PERIOD*0.5;
        end loop;
        mosi <= '0';
        wait for C_CLK_PERIOD*1;
    end procedure;
    
    procedure mosi_read_byte(
                            variable   data   : out std_logic_vector(7 downto 0);
                            signal   miso   : in std_logic;
                            signal     spi_clk: out std_logic) is
    variable counter:integer:=0;
    begin      
        for i in 0 to 7 loop
            spi_clk <= '1';
            wait for C_CLK_PERIOD*0.5;
            spi_clk <= '0';
            wait for C_CLK_PERIOD*0.3;
            data(7-i) := miso;
            wait for C_CLK_PERIOD*0.2;
        end loop;
        wait for C_CLK_PERIOD*1;
    end procedure;
        
    -- Testbench DUT ports
    signal spi_slave_reset:std_logic;
    
    -- Other constants
    
    signal reset : std_logic;
    signal clk:std_logic;
    signal spi_slave_sclk : std_logic;
    signal spi_slave_cs : std_logic;
    signal spi_slave_mosi : std_logic;
    signal spi_slave_miso : std_logic;
    signal spi_slave_addr : std_logic_vector(15 downto 0);
    signal spi_slave_data_out : std_logic_vector(7 downto 0);
    signal spi_slave_data_in : std_logic_vector(7 downto 0);
    signal spi_slave_out_en : std_logic;
    signal spi_slave_in_en : std_logic;

    signal test_read_data : std_logic_vector(7 downto 0);
    signal test_leds : std_logic_vector(3 downto 0);
begin
    -----------------------------------------------------------
    -- Clocks and Reset
    -----------------------------------------------------------
    CLK_GEN : process
    begin
        clk <= '1';
        wait for C_CLK_PERIOD/2;
        clk <= '0';
        wait for C_CLK_PERIOD/2;
    end process CLK_GEN;
    
    clk_s <= clk;

    RESET_GEN : process
    begin
        reset <= '1',
                 '0' after 5*C_CLK_PERIOD;
        wait;
    end process RESET_GEN;

    -----------------------------------------------------------
    -- Testbench Stimulus
    -----------------------------------------------------------
    main: process
    variable data : std_logic_vector(7 downto 0):=x"aa";
    begin 
        spi_slave_cs <='1';
        spi_slave_mosi <='0';
        spi_slave_sclk <= '0';
        wait until reset='0';
        
        wait for C_CLK_PERIOD*40965;
        data := x"80";
        wait until clk='0'; 
        spi_slave_cs<='0';
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write command
        
        data := x"00";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write address H
        
        data := x"00";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write address L
        
        data := x"09";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x99 to 0x0000
        
        data := x"08";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x88 to 0x0001
        
        data := x"07";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x77 to 0x0002
        
        data := x"06";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x66 to 0x0003

        data := x"05";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x55 to 0x0004
        
        data := x"04";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x44 to 0x0005
        
        data := x"03";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x33 to 0x0006
        
        data := x"02";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x22 to 0x0007
        
        data := x"01";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x11 to 0x0008
        
        data := x"00";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write 0x00 to 0x0009   
                     
        spi_slave_cs <= '1';
        wait for C_CLK_PERIOD;
        
        
        wait for C_CLK_PERIOD*3.51;
        data := x"40";
        wait until clk='0'; 
        spi_slave_cs<='0';
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write command
        
        data := x"00";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write address H
        
        data := x"00";
        mosi_write_byte(data, spi_slave_mosi, spi_slave_sclk); -- write address L
        
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk); 
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk); 
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
        
        mosi_read_byte(data, spi_slave_miso, spi_slave_sclk);
        test_read_data <= data;
        report "The value of 'read out' is " & integer'image(to_integer((unsigned(data))));
        wait for C_CLK_PERIOD*2;
                     
        spi_slave_cs <= '1';

        wait for C_CLK_PERIOD*2;
        wait;
    end process main;
    -----------------------------------------------------------
    -- Entity Under Test
    -----------------------------------------------------------
    uut: entity xil_defaultlib.env5_top(rtl)
    port map(
    sys_clk => clk,

    spi_clk => spi_slave_sclk,
    spi_ss_n => spi_slave_cs,
    spi_mosi => spi_slave_mosi,
    spi_miso => spi_slave_miso,
    
    leds => test_leds
   );

end Behavioral;
