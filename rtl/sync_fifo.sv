/*
 Module : sync_fifo.sv
 author : liangwang
 Create Time : 2020-05-24 21:15:05
 */
/* ---------设计介绍
 reg* valid&&ready时序规则：
 1.reg0 && reg1都是用switch_en方式，
   即当sync_fifo_num>0时，reg1_mux2_vld==1，
     当sync_fifo_num>1时，reg0_mux1_vld==1。
 sync_fifo 空满判断规则：
 1.sram_reg_vld_pre==0,reg0_mux1_vld==0,reg1_mux2_vld==0时，sync_fifo 为空。
 2.mux0_sram_rdy==0,reg0_mux1_vld==1,reg1_mux2_vld==1时，sync_fifo 为满。
 mux*_sel 判断选择规则：
 1.mux0_sel默认2;mux1_sel默认1；mux2_sel默认1；
 2.reg1_mux2_vld==0，且rd==1时，mux0_sel=2,mux2_sel=1'd1;
 3.reg1_mux2_vld==0，且wr==1，rd!=1时，mux0_sel=1,mux1_sel=1,mux2_sel=0;
 4.reg1_mux2_vld==1，mux0_sel=0,mux1_sel=0,mux2_sel=0; 
 */

module Msync_fifo #(parameter DW=32, // data width
		    parameter FP=32  // fifo depth
		    )
   (
    input 	    clk,
    input 	    rst_n,

    // write
    input 	    wr,
    input [DW-1:0]  din,

    // read
    input 	    rd,
    output [DW-1:0] dout,

    // full&&empty
    output 	    empty, // for read
    output 	    full   // for write    
    );
   
   // ==============================================================
   // define register && wire
   // ==============================================================
   // ---------------------model valid&ready&data-------------------
   // sync_fifo -- input // mux0 -- input
   logic 	    wr;
   logic 	    full;
   logic [DW-1:0]   din;   
   // sync_fifo -- output // mux2 -- output
   logic 	    rd;
   logic 	    empty;
   logic [DW-1:0]   dout;
   // mux0 -- output
   logic 	    mux0_sram_vld,mux0_sram_rdy;
   logic 	    mux0_mux1_vld,mux0_mux1_rdy;
   logic 	    mux0_mux2_vld,mux0_mux2_rdy;
   logic [DW-1:0]   mux0_sram;
   logic [DW-1:0]   mux0_mux1;
   logic [DW-1:0]   mux0_mux2;
   // sram -- output
   logic 	    sram_reg0_vld,sram_reg0_rdy;
   logic 	    sram_reg0_vld_pre; // 由于sram滞后输出，真实vld为pre寄存器输出，用于sram信号逻辑判断
   logic 	    sram_reg0_rdy_r;   // 同上，rdy_r为rdy寄存器输出，用于sram信号逻辑判断
   logic [DW-1:]    sram_reg0;
   // reg0 -- output
   logic 	    reg0_mux1_vld,reg0_mux1_rdy;
   logic [DW-1:0]   reg0_mux1;
   // mux1 -- output
   logic 	    mux1_reg1_vld,mux1_reg1_rdy;
   logic [DW-1:0]   mux1_reg1;
   // reg1 -- output
   logic 	    reg1_mux2_vld,reg1_mux2_rdy;
   logic [DW-1:0]   reg1_mux2;
   // ---------------------model sel--------------------------------
   logic [1:0] 	    mux0_sel; // 0:sram;1:mux1;2:mux2
   logic 	    mux1_sel; // 0:reg0;1:mux0
   logic 	    mux2_sel; // 0:reg1;1:mux0
   

   

   
   
   
endmodule 	//Msync_fifo
