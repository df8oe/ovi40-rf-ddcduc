## Generated SDC file "RFBoard1.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

## DATE    "Sat Mar  6 13:40:52 2021"

##
## DEVICE  "10CL016ZU256I8G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clock_10M} -period 100.000 -waveform { 0.000 50.000 } [get_ports {clock_10M}]
create_clock -name {adc_clock} -period 6.510 -waveform { 0.000 3.255 } [get_ports {adc_clock}]
create_clock -name {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req} -period 1.000 -waveform { 0.000 0.500 } [get_registers {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}]
create_clock -name {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK} -period 1.000 -waveform { 0.000 0.500 } [get_registers {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]
create_clock -name {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]} -period 1.000 -waveform { 0.000 0.500 } [get_registers {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}]
create_clock -name {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]} -period 1.000 -waveform { 0.000 0.500 } [get_registers {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {trx|p10M|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {trx|p10M|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 100 -master_clock {clock_10M} [get_pins {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {trx|p10M|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {trx|p10M|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 5 -master_clock {clock_10M} [get_pins {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {trx|prx|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {trx|prx|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -phase 270.000 -master_clock {adc_clock} [get_pins {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {trx|prx|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {trx|prx|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 4 -divide_by 25 -master_clock {adc_clock} [get_pins {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {trx|prx|altpll_component|auto_generated|pll1|clk[2]} -source [get_pins {trx|prx|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -phase 90.000 -master_clock {adc_clock} [get_pins {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Receiver:rx|firX8R8:fir2|wstate[0]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {adc_clock}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {adc_clock}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {adc_clock}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {adc_clock}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {adc_clock}] -rise_to [get_clocks {adc_clock}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {adc_clock}] -fall_to [get_clocks {adc_clock}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {adc_clock}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {adc_clock}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {adc_clock}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {adc_clock}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {adc_clock}] -rise_to [get_clocks {adc_clock}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {adc_clock}] -fall_to [get_clocks {adc_clock}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|FirInterp8:tx_fir|req}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -rise_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}] -fall_to [get_clocks {transceiver:trx|Transmitter:tx|cdc_sync:p_clk|sigb[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[2]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[1]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {transceiver:trx|i2s_master_clocks:i2s_master_clocks|BCLK}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|prx|altpll_component|auto_generated|pll1|clk[0]}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {trx|p10M|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

