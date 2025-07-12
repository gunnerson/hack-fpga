## Generated SDC file "HACK.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.0.0 Build 595 04/25/2017 SJ Standard Edition"

## DATE    "Sat Jul 12 15:21:06 2025"

##
## DEVICE  "10M50DAF484C6GES"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {MAX10_CLK1_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {MAX10_CLK1_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {u0|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {u0|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 2 -master_clock {MAX10_CLK1_50} [get_pins {u0|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {MAX10_CLK1_50}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -rise_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {MAX10_CLK1_50}] -fall_to [get_clocks {u0|altpll_component|auto_generated|pll1|clk[0]}]  0.010  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[0]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[0]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[1]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[1]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[2]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[2]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[3]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[3]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[4]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[4]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[5]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[5]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[6]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[6]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[7]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[7]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[8]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[8]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[9]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[9]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[10]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[10]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[11]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[11]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[12]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[12]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[13]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[13]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[14]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[14]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[15]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[15]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[16]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[16]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[17]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[17]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[18]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[18]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[19]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[19]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[20]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[20]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[21]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[21]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[22]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[22]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[23]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[23]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[24]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[24]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[25]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[25]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[26]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[26]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[27]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[27]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[28]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[28]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[29]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[29]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[30]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[30]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[31]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[31]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[32]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[32]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[33]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[33]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[34]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[34]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {GPIO[35]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {GPIO[35]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {KEY[0]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {KEY[0]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {KEY[1]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {KEY[1]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[0]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[0]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[1]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[1]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[2]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[2]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[3]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[3]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[4]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[4]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[5]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[5]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[6]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[6]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[7]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[7]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[8]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[8]}]
set_input_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  3.000 [get_ports {SW[9]}]
set_input_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {SW[9]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX0[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX0[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX1[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX1[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX2[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX2[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX3[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX3[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX4[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX4[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {HEX5[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {HEX5[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[4]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[5]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[6]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[7]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[8]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {LEDR[9]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {LEDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_B[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_B[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_B[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_B[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_B[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_B[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_B[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_B[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_G[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_G[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_G[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_G[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_G[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_G[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_G[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_G[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_HS}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_HS}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_R[0]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_R[0]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_R[1]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_R[1]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_R[2]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_R[2]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_R[3]}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_R[3]}]
set_output_delay -add_delay -max -clock [get_clocks {MAX10_CLK1_50}]  2.000 [get_ports {VGA_VS}]
set_output_delay -add_delay -min -clock [get_clocks {MAX10_CLK1_50}]  1.000 [get_ports {VGA_VS}]


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

