set_property PACKAGE_PIN H4 [get_ports clk_100]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100]

#set_property IOSTANDARD LVCMOS33 [get_ports rst_n] 
#set_property PACKAGE_PIN M13  [get_ports rst_n]

#  SPI
#set_property IOSTANDARD LVCMOS33 [get_ports spi_fss]
#set_property PACKAGE_PIN P12  [get_ports spi_fss]

#set_property IOSTANDARD LVCMOS33 [get_ports spi_clk]
#set_property PACKAGE_PIN N11 [get_ports spi_clk]

#set_property IOSTANDARD LVCMOS33 [get_ports spi_in]
#set_property PACKAGE_PIN P11  [get_ports spi_in]

#set_property IOSTANDARD LVCMOS33 [get_ports spi_out]
#set_property PACKAGE_PIN M12  [get_ports spi_out]

set_property IOSTANDARD LVCMOS33 [get_ports leds[1]]
set_property PACKAGE_PIN J1  [get_ports leds[1]]

set_property IOSTANDARD LVCMOS33 [get_ports leds[2]]
set_property PACKAGE_PIN A13  [get_ports leds[2]]

## Configuration options, can be used for all designs
set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]










