//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4.1 (lin64) Build 2117270 Tue Jan 30 15:31:13 MST 2018
//Date        : Fri Nov 22 22:58:45 2019
//Host        : jxj-xps running 64-bit Ubuntu 18.04.3 LTS
//Command     : generate_target fifo32_1clk.bd
//Design      : fifo32_1clk
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "fifo32_1clk,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=fifo32_1clk,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "fifo32_1clk.hwdef" *) 
module fifo32_1clk
   (CLK,
    DATAO,
    DI,
    EMPTY,
    FULL,
    RDEN,
    RST,
    WREN,
    data_count);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN fifo32_1clk_CLK, FREQ_HZ 100000000, PHASE 0.000" *) input CLK;
  output [31:0]DATAO;
  input [31:0]DI;
  output EMPTY;
  output FULL;
  input RDEN;
  input RST;
  input WREN;
  output [13:0]data_count;

  wire CLK_1;
  wire [31:0]DI_1;
  wire RDEN_1;
  wire RST_1;
  wire WREN_1;
  wire [13:0]fifo_generator_0_data_count;
  wire [31:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_full;

  assign CLK_1 = CLK;
  assign DATAO[31:0] = fifo_generator_0_dout;
  assign DI_1 = DI[31:0];
  assign EMPTY = fifo_generator_0_empty;
  assign FULL = fifo_generator_0_full;
  assign RDEN_1 = RDEN;
  assign RST_1 = RST;
  assign WREN_1 = WREN;
  assign data_count[13:0] = fifo_generator_0_data_count;
  fifo32_1clk_fifo_generator_0_0 fifo_generator_0
       (.clk(CLK_1),
        .data_count(fifo_generator_0_data_count),
        .din(DI_1),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .full(fifo_generator_0_full),
        .rd_en(RDEN_1),
        .rst(RST_1),
        .wr_en(WREN_1));
endmodule
