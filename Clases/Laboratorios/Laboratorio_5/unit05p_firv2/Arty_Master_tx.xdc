## Clock signal

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clock]
create_clock -period 20.000 -name clock -waveform {0.000 10.0} -add [get_ports clock]

##Switches

set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports i_reset]




set_property PACKAGE_PIN E18 [get_ports {o_data[7]}]
set_property PACKAGE_PIN D18 [get_ports {o_data[6]}]
set_property PACKAGE_PIN G18 [get_ports {o_data[5]}]
set_property PACKAGE_PIN F18 [get_ports {o_data[4]}]
set_property PACKAGE_PIN J17 [get_ports {o_data[3]}]
set_property PACKAGE_PIN J18 [get_ports {o_data[2]}]
set_property PACKAGE_PIN K15 [get_ports {o_data[1]}]
set_property PACKAGE_PIN J15 [get_ports {o_data[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {o_data[0]}]
set_property PACKAGE_PIN K16 [get_ports i_enable]
set_property IOSTANDARD LVCMOS18 [get_ports i_enable]
