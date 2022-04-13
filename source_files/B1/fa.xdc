## BUTTONS
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_port {a}];
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_port {b}];
set_property -dict { PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_port {c_in}];

## LED
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_port {s}];
set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_port {c_out}];

## Configuration options
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property INTERNAL_VREF 0.675 [get_iobanks 34]