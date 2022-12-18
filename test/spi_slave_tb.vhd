library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library xil_defaultlib;
use xil_defaultlib.all;
-----------------------------------------------------------

entity spi_slave_tb is
port(
    clk_s: out std_logic
    );
end entity ;

-----------------------------------------------------------

architecture testbench of spi_slave_tb is

    -- Testbench DUT generics
    procedure mosi_write_byte(
                            signal   clock  : in std_logic;
                            variable   data   : in std_logic_vector(7 downto 0);
                            signal   mosi   : out std_logic) is
    variable counter:integer:=0;
    begin      
        for i in 0 to 7 loop
            mosi <= data(7-i);
            wait until clock='0';   
        end loop;
        mosi <= '0';
    end procedure;
    
    procedure mosi_read_byte(
                            signal   clock  : in std_logic;
                            variable   data   : out std_logic_vector(7 downto 0);
                            signal   miso   : in std_logic) is
    variable counter:integer:=0;
    begin      
        for i in 0 to 7 loop
            wait until clock='1';   
            data(7-i) := miso;
            wait until clock='0'; 
        end loop;
        
    end procedure;
    
    -- Testbench DUT ports
    signal spi_slave_reset:std_logic;
    
    -- Other constants
    constant C_CLK_PERIOD : time := 10 ns;  
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
    type buf_t is array (0 to 10) of std_logic_vector(7 downto 0);
    signal data_buf : buf_t := (others=>(others=>'0'));
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
    
    BUF_GEN : process(clk)
    begin
        if rising_edge(clk) then
            if spi_slave_out_en='1' then
                data_buf(to_integer(unsigned(spi_slave_addr))) <= spi_slave_data_out;
            end if;
            
        end if;
        if falling_edge(clk) then
            if spi_slave_in_en='1' then
                spi_slave_data_in <= data_buf(to_integer(unsigned(spi_slave_addr)));
            end if;
        end if;
    end process;

    -----------------------------------------------------------
    -- Testbench Stimulus
    -----------------------------------------------------------
    main: process
    variable data : std_logic_vector(7 downto 0):=x"aa";
    begin 
        spi_slave_cs <='1';
        spi_slave_mosi <='0';
        wait until reset='0';
--        mosi_write_byte(clk, command, spi_slave_mosi);
        
        wait for C_CLK_PERIOD*3.51;
        data := x"80";
        wait until clk='0'; 
        spi_slave_cs<='0';
        mosi_write_byte(clk, data, spi_slave_mosi); -- write command
        
        data := x"00";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write address H
        
        data := x"00";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write address L
        
        data := x"99";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x99 to 0x0000
        
        data := x"88";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x88 to 0x0001
        
        data := x"77";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x77 to 0x0002
        
        data := x"66";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x66 to 0x0003

        data := x"55";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x55 to 0x0004
        
        data := x"44";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x44 to 0x0005
        
        data := x"33";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x33 to 0x0006
        
        data := x"22";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x22 to 0x0007
        
        data := x"11";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x11 to 0x0008
        
        data := x"00";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x00 to 0x0009   
                     
        spi_slave_cs <= '1';
        wait for C_CLK_PERIOD;
        
        
        wait for C_CLK_PERIOD*3.51;
        data := x"40";
        wait until clk='0'; 
        spi_slave_cs<='0';
        mosi_write_byte(clk, data, spi_slave_mosi); -- write command
        
        data := x"00";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write address H
        
        data := x"01";
        mosi_write_byte(clk, data, spi_slave_mosi); -- write address L
        
        
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
        mosi_read_byte(clk, data, spi_slave_miso);
--        data := x"99";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x99 to 0x0000
        
--        data := x"88";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x88 to 0x0001
        
--        data := x"77";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x77 to 0x0002
        
--        data := x"66";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x66 to 0x0003

--        data := x"55";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x55 to 0x0004
        
--        data := x"44";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x44 to 0x0005
        
--        data := x"33";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x33 to 0x0006
        
--        data := x"22";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x22 to 0x0007
        
--        data := x"11";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x11 to 0x0008
        
--        data := x"00";
--        mosi_write_byte(clk, data, spi_slave_mosi); -- write 0x00 to 0x0009   
                     
        spi_slave_cs <= '1';
        wait for C_CLK_PERIOD;
--        spi_slave_cs <= '1';
        
--        data <= x"33";
--        mosi_write_byte(clk, data, spi_slave_mosi, spi_slave_cs); -- write address L
--        spi_slave_cs <= '1';
        
        
        wait for C_CLK_PERIOD*2;
        wait;
    end process main;
    -----------------------------------------------------------
    -- Entity Under Test
    -----------------------------------------------------------
    uut: entity xil_defaultlib.spi_slave(rtl)
    port map(
    reset_n => spi_slave_reset,
    sclk => spi_slave_sclk,
    ss_n => spi_slave_cs,
    mosi => spi_slave_mosi,
    miso => spi_slave_miso,
    addr => spi_slave_addr,
    data_out => spi_slave_data_out,
    data_in => spi_slave_data_in,
    out_en => spi_slave_out_en,
    in_en => spi_slave_in_en
    );
    spi_slave_sclk <= clk;
    spi_slave_reset <= not reset;

end architecture testbench;