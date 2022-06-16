set_property -dict { PACKAGE_PIN R2    IOSTANDARD SSTL135 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_34 Sch=ddr3_clk[200]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5.000}  [get_ports { CLK }];

#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L20N_T3_A19_15 Sch=sw[0]
#set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; #IO_L21P_T3_DQS_15 Sch=sw[1]
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; #IO_L21N_T3_DQS_A18_15 Sch=sw[2]
#set_property -dict { PACKAGE_PIN M5    IOSTANDARD SSTL135 } [get_ports { SW[3] }]; #IO_L6N_T0_VREF_34 Sch=sw[3]

set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { BTN }]; #IO_L18N_T2_A23_15 Sch=btn[0]
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { BTN[1] }]; #IO_L19P_T3_A22_15 Sch=btn[1]
#set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { BTN[2] }]; #IO_L19N_T3_A21_VREF_15 Sch=btn[2]
#set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS33 } [get_ports { BTN[3] }]; #IO_L20P_T3_A20_15 Sch=btn[3]

## LEDs
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; #IO_L16N_T2_A27_15 Sch=led[2]
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; #IO_L17P_T2_A26_15 Sch=led[3]
#set_property -dict { PACKAGE_PIN E13   IOSTANDARD LVCMOS33 } [get_ports { LED[2] }]; #IO_L17N_T2_A25_15 Sch=led[4]
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { LED[3] }]; #IO_L18P_T2_A24_15 Sch=led[5]


## RGB LEDs
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { RGB[2] }]; #IO_L23N_T3_FWE_B_15 Sch=led0_r
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { RGB[1] }]; #IO_L14N_T2_SRCC_15 Sch=led0_g
set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { RGB[0] }]; #IO_L13N_T2_MRCC_15 Sch=led0_b

#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { ledrgb1[2] }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=led1_r
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { ledrgb1[1] }]; #IO_L16P_T2_A28_15 Sch=led1_g
#set_property -dict { PACKAGE_PIN E14   IOSTANDARD LVCMOS33 } [get_ports { ledrgb1[0] }]; #IO_L15P_T2_DQS_15 Sch=led1_b

set_property -dict { PACKAGE_PIN C18   IOSTANDARD LVCMOS33 } [get_ports { RESN }]; #IO_L11N_T1_SRCC_15



## Configuration options, can be used for all designs
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## SW3 is assigned to a pin M5 in the 1.35v bank. This pin can also be used as
## the VREF for BANK 34. To ensure that SW3 does not define the reference voltage
## and to be able to use this pin as an ordinary I/O the following property must
## be set to enable an internal VREF for BANK 34. Since a 1.35v supply is being
## used the internal reference is set to half that value (i.e. 0.675v). Note that
## this property must be set even if SW3 is not used in the design.
set_property INTERNAL_VREF 0.675 [get_iobanks 34]