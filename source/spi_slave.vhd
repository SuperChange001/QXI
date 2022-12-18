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

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

ENTITY spi_slave IS
  GENERIC(
    d_width : INTEGER := 8);     --data width in bits
  PORT(
    reset_n      : IN     STD_LOGIC;  --reset from master
    sclk         : IN     STD_LOGIC;  --spi clk from master
    ss_n         : IN     STD_LOGIC;  --active low slave select
    mosi         : IN     STD_LOGIC;  --master out, slave in
    miso         : OUT    STD_LOGIC := ('Z'); --master in, slave out
    
    addr         : OUT    STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');  --receive register output to logic
    data_out     : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receive register output to logic
    data_in      : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --logic provide data to transmit register
    out_en       : OUT    STD_LOGIC;
    in_en        : OUT    STD_LOGIC
    );
    
END spi_slave;

ARCHITECTURE rtl OF spi_slave IS
    SIGNAL mode    : STD_LOGIC;  --groups modes by clock polarity relation to data
    SIGNAL clk     : STD_LOGIC;  --clock
    SIGNAL bit_cnt_s : integer;  --'1' for active transaction bit

    SIGNAL rx_buf  : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
    SIGNAL tx_buf  : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --transmit buffer
    SIGNAL command  : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
    
    TYPE STATE_TYPE IS (s_idle, s_cmd, s_addr_h, s_addr_l, s_data);
    SIGNAL state   : STATE_TYPE;
    SIGNAL addr_offset : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addr_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    signal out_trigger : std_logic;
    
BEGIN
    
--    addr <= addr_s;
    ----adjust clock so writes are on rising edge and reads on falling edge
    --mode <= cpol XOR cpha;  --'1' for modes that write on rising edge

    --WITH mode SELECT
    --    clk <= sclk WHEN '1',
    --        NOT sclk WHEN OTHERS;

    clk <= sclk;

    --keep track of miso/mosi bit counts for data alignmnet
    process(ss_n, clk)
    variable rx_buf_var : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');
    variable bit_count_var : integer range 0 to 8;
    variable bytes_counter : integer range 0 to 1023;
    begin
        if(ss_n = '1' or reset_n = '0') then                         --this slave is not selected or being reset
            state <= s_idle;
            out_trigger <= '0';
            bit_count_var := 0;
        else                                                         --this slave is selected

            IF(rising_edge(clk)) then                                  --new bit on miso/mosi
                
                rx_buf_var(7-bit_count_var) := mosi;
                bit_count_var := bit_count_var+1;
                
                if bit_count_var=8 then
                    bit_count_var :=0 ;
                    if state = s_cmd then
                        command <= rx_buf_var;
                        state <= s_addr_h;
                        if rx_buf_var=x"40" then
                            in_en <= '1';
                        end if;
                    elsif state = s_addr_h then
                        addr_offset(15 DOWNTO 8) <= rx_buf_var;
                        state <= s_addr_l;
                    elsif state = s_addr_l then
                        state <= s_data;
                        addr_offset(7 DOWNTO 0) <= rx_buf_var;
                        bytes_counter := 0;
                    elsif state = s_data then
                        addr <= std_logic_vector(unsigned(addr_offset)+to_unsigned(bytes_counter,addr'length)); -- increase the address
                        bytes_counter := bytes_counter+1;
                        data_out <= rx_buf_var;
                        if command=x"80" then
                            out_trigger <= '1';
                        end if;
                     end if;
                elsif bit_count_var=1 then
                        if state = s_idle then
                            state <= s_cmd;
                        end if;
                        out_trigger <= '0';
                end if;
                
            end if;
            
            if falling_edge(clk) then
                miso <= data_in(bit_count_var);                  --send transmit register data to master
            end if;
            
        end if;
        bit_cnt_s <= bit_count_var;
    end process;
    
    process(reset_n, clk, out_trigger)
    variable timer_down:integer range 0 to 4;
    begin
            if reset_n='0' then
                out_en <= '0';
            elsif(rising_edge(out_trigger)) then
                out_en <= '1';
                timer_down := 4;
            elsif(falling_edge(clk)) then 
                timer_down := timer_down-1;
                if timer_down=0 then
                    out_en <= '0';
                end if;
            end if;
    end process;
    
--    PROCESS(reset_n, ss_n, clk)
--    BEGIN
----        --write address register ('0' for receive, '1' for status)
----        IF(bit_cnt(1) = '1' AND rising_edge(clk)) THEN
----            wr_add <= mosi;
----        END IF;
        
----        --read address register ('0' for transmit, '1' for status)
----        IF(bit_cnt(2) = '1' AND rising_edge(clk)) THEN
----            rd_add <= mosi;
----        END IF;
        
--        --receive registers
--        --write to the receive register from master
----        IF(reset_n = '0') THEN
----            rx_buf <= (OTHERS => '0');
----        ELSE
----            FOR i IN 0 TO 7 LOOP          
----                IF( bit_cnt(i+1) = '1' AND rising_edge(clk)) THEN
----                    rx_buf(7-i) <= mosi;
----                END IF;
----            END LOOP;
----        END IF;
        
--        --transmit registers
--        IF(reset_n = '0') THEN
--            tx_buf <= (OTHERS => '0');
--        ELSE
--            tx_buf <= data_in;
--        END IF;

--        --miso output register
--        IF(ss_n = '1' OR reset_n = '0') THEN           --no transaction occuring or reset
--            miso <= 'Z';
--        ELSIF(rising_edge(clk)) THEN
--            IF command=x"40" and state=s_data THEN  --write status register to master
                
--            END IF;
--        END IF;
--    END PROCESS;

END rtl;