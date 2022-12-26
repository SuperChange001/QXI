----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2022 09:45:55 PM
-- Design Name: 
-- Module Name: spi_slave - Behavioral
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

entity spi_slave IS
port(
    reset_n      : in     std_logic;  --reset from master
    sclk         : in     std_logic;  --spi clk from master
    ss_n         : in     std_logic;  --active low slave select
    mosi         : in     std_logic;  --master out, slave in
    miso         : OUT    std_logic; --master in, slave out
    
    clk          : in std_logic;
    -- Parallel interface to control the skeleton
    addr         : OUT    std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');  -- which address of the user logic to read/write
    
    we           : OUT    std_logic;    -- enable writing to user logic
    data_wr     : OUT    std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');  -- data writing to user logic
    re        : OUT    std_logic;
    data_rd      : in     std_logic_vector(7 DOWNTO 0) := (OTHERS => '0')  --logic provide data to transmit register
);

END spi_slave;

ARCHITECTURE rtl OF spi_slave IS
    SIGNAL mode    : std_logic;  --groups modes by clock polarity relation to data
    SIGNAL bit_cnt_s : integer;  --'1' for active transaction bit

    SIGNAL rx_buf  : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
    SIGNAL tx_buf  : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');  --transmit buffer
    SIGNAL command  : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
    
    TYPE state_type IS (s_idle, s_cmd, s_addr_h, s_addr_l, s_data);
    SIGNAL state   : state_type;
    SIGNAL addr_offset : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addr_s : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addr_read, addr_write : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
    signal out_trigger : std_logic;
    
    signal re_s, we_s : std_logic;
    
BEGin
    re <= re_s;
    we <= we_s;
    
    addr <= addr_read when re_s='1' else
            addr_write when we_s='1';

    --keep track of miso/mosi bit counts for data alignmnet
    process(ss_n, sclk, reset_n)
    variable rx_buf_var : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
    variable bit_count_var : integer range 0 to 8;
    variable bytes_counter : integer range 0 to 1023;
    begin
        if(ss_n = '1' or reset_n = '0') then                         --this slave is not selected or being reset
            state <= s_idle;
            out_trigger <= '0';
            bit_count_var := 0;
            re_s <= '0';
        else                                                         --this slave is selected

            IF(falling_edge(sclk)) then                                  --new bit on miso/mosi
            
                rx_buf_var(7-bit_count_var) := mosi;
                bit_count_var := bit_count_var+1;
                
                if bit_count_var=8 then
                    bit_count_var :=0 ;
                    if state = s_cmd then
                        command <= rx_buf_var;
                        state <= s_addr_h;
                        if rx_buf_var=x"40" then
                            re_s <= '1';
                        end if;
                    elsif state = s_addr_h then
                        addr_offset(15 DOWNTO 8) <= rx_buf_var;
                        state <= s_addr_l;
                    elsif state = s_addr_l then
                        state <= s_data;
                        addr_offset(7 DOWNTO 0) <= rx_buf_var;
                        
                        addr_read <= std_logic_vector(unsigned(addr_offset)); -- first addr
                        addr_write <= std_logic_vector(unsigned(addr_offset));
                        bytes_counter := 1;
                    elsif state = s_data then
                        addr_write <= addr_read;
                        addr_read <= std_logic_vector(unsigned(addr_offset)+to_unsigned(bytes_counter,addr'length)); -- increase the address
                        bytes_counter := bytes_counter+1;
                        data_wr <= rx_buf_var;
                        if command=x"80" then
                            out_trigger <= '1';
                        end if;
                    end if;
                elsif bit_count_var=2 then
                        if state = s_idle then
                            state <= s_cmd;
                        end if;
                        out_trigger <= '0';
                end if;
                

                
            end if;
            
        end if;
        bit_cnt_s <= bit_count_var;
    end process;
    
    process(sclk,ss_n,reset_n)
    begin
        if(ss_n = '1' or reset_n = '0') then                         --this slave is not selected or being reset
            miso <= '0';
        else
            if rising_edge(sclk) then
                    if command=x"40" and state=s_data then  --write status register to master
                    miso <= data_rd(7-bit_cnt_s);                  --send transmit register data to master
                    else
                    miso <= '0';
                    end if;
                end if;
        end if;
    end process;
    
    
    process(reset_n, clk, out_trigger)
    variable timer_down:integer range 0 to 4;
    begin
        if reset_n='0' then
            we_s <= '0';
        elsif(rising_edge(clk)) then
        
            if out_trigger='1' then
                we_s <= '1';
                timer_down := 4;
            end if;
            timer_down := timer_down-1;
            if timer_down=0 then
                we_s <= '0';
            end if;
        end if;
    end process;

END rtl;