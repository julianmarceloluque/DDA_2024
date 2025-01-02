// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Sun Nov 22 17:02:13 2020
// Host        : einstein running 64-bit Linux Mint 19 Tara
// Command     : write_verilog -force -mode synth_stub
//               /home/apola/projects/ddaunit6/DDA2019/rtl/micro/design_1/ip/design_1_clk_wiz_1_0/design_1_clk_wiz_1_0_stub.v
// Design      : design_1_clk_wiz_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module design_1_clk_wiz_1_0(clk_out1, resetn, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,resetn,locked,clk_in1" */;
  output clk_out1;
  input resetn;
  output locked;
  input clk_in1;
endmodule
