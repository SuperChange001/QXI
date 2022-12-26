set_property part xc7s6ftgb196-2 [current_project]

set_property PACKAGE_PIN H4 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports sys_clk]



#  SPI
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { spi_clk }]; # io0
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets spi_clk]
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { spi_ss_n }];# io1

set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports { spi_mosi }]; # io2
set_property -dict { PACKAGE_PIN B13 IOSTANDARD LVCMOS33 } [get_ports { spi_miso }];# io3


set_property -dict { PACKAGE_PIN P5 IOSTANDARD LVCMOS33 } [get_ports { leds[0] }];
set_property -dict { PACKAGE_PIN J1 IOSTANDARD LVCMOS33 } [get_ports { leds[1] }];
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33 } [get_ports { leds[2] }]; # io8
set_property -dict { PACKAGE_PIN E11 IOSTANDARD LVCMOS33 } [get_ports { leds[3] }]; # io9



## Configuration options, can be used for all designs
set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]










