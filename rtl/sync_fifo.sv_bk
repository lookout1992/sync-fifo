/*
 Module : sync_fifo.sv
 author : liangwang
 Create Time : 2020-05-24 21:15:05
 */

// `include "sram_32x32_wrap.sv"

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

   // mux 0~2
   logic [1:0] 	    mux0_sel;
   logic 	    mux1_sel;
   logic 	    mux2_sel;  
   logic [DW-1:0]   mux0_sram;
   logic [DW-1:0]   mux0_mux1; 
   logic [DW-1:0]   mux0_mux2;
   logic [DW-1:0]   sram_reg0;
   logic [DW-1:0]   reg0_mux1;	       // reg0 output
   logic [DW-1:0]   mux1_reg1;	       // reg1 input
   logic [DW-1:0]   reg1_mux2;	       // reg1 output
   logic 	    mux0_vld,mux0_rdy; // mux1 input
   logic 	    reg0_vld,reg0_rdy; // reg0 output
   logic 	    mux1_vld,mux1_rdy; // reg1 input
   logic 	    reg1_vld,reg1_rdy; // reg1 output
   
   logic 	    reg0_switch;
   logic 	    sram_empty_r;   
   logic 	    reg1_switch;
   
   logic 	    wr_sram;
   logic 	    rd_sram;
   logic 	    sram_full;
   logic 	    sram_empty;
   logic [DW-1:0]   megm[FP-1:0];
   logic 	    m2m_rd_r;

   logic 	    wr_flag;   
   logic 	    rd_flag;
   logic 	    rd_sram_r;   		// delay 1 clock
   logic [$clog2(FP)-1:0] wr_addr;
   logic [$clog2(FP)-1:0] rd_addr;
   
   // mux0 stage
   assign mux0_sram = mux0_sel==2'd0 ? din : {DW{1'b0}}; 
   assign mux0_mux1 = mux0_sel==2'd1 ? din : {DW{1'b0}}; 
   assign mux0_mux2 = mux0_sel==2'd2 ? din : {DW{1'b0}};

   // mux1 stage
   assign mux1_reg1 = mux1_sel==1'b0 ? reg0_mux1 : mux0_mux1;

   // mux2 stage
   assign dout = mux2_sel==1'b0 ? reg1_mux2 : mux0_mux2;

   // register logic
   // reg0
   assign reg0_switch = !(reg0_vld&(!reg0_rdy));
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 sram_empty_r <= 'd0;
      end
      else begin
	 sram_empty_r  <= !sram_empty;
      end
   end
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 reg0_mux1 <= 'd0;
	 reg0_vld  <= 'd0;
      end
      else if(reg0_switch)begin
	 reg0_mux1 <= sram_reg0;
	 reg0_vld  <= !sram_empty_r;
      end
   end
   assign rd_sram = reg0_switch&(!sram_empty);
   
   // reg1

   assign mux1_vld = mux1_sel==1'b1 ? mux0_vld : reg0_vld;   
   
   assign reg1_switch = !(reg1_vld&(!reg1_rdy));
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 reg1_mux2 <= 'd0;
	 reg1_vld  <= 'd0;
      end
      else if(reg1_switch)begin
	 reg1_mux2 <= mux1_reg1;
	 reg1_vld  <= mux1_vld;
      end
   end
   assign mux1_rdy = reg1_switch;

   // valid && ready
   // mux0
   assign full = mux0_sel==2'd0 ? sram_full :
		 (mux0_sel==2'd1)&(mux1_sel==1'b1) ? !mux1_rdy :
		 mux0_sel==2'd2 ? !rd : 1'b1;
   // reg0
   assign reg0_rdy = (!mux1_sel)&mux1_rdy;
   // reg1
   assign reg1_rdy = (!mux2_sel)&rd;
   // mux2
   assign empty = !((!sram_empty)|reg0_vld|reg1_vld|wr);
   
   // ---------------------------------------------------------
   // sram
   // ---------------------------------------------------------
   // sram
   assign wr_sram = (mux0_sel==2'd0)&wr;
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 wr_addr <= 'd0;
	 wr_flag <= 'd0;	 
      end
      else if(wr_sram&(wr_addr==FP-1))begin
	 wr_addr <= 'd0;
	 wr_flag <= ~wr_flag;
      end
      else if(wr_sram&(!sram_full))begin
	 wr_addr <= wr_addr + 'd1;
      end
   end
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 rd_addr <= 'd0;
	 rd_flag <= 'd1;	 
      end
      else if(rd_sram&(rd_addr==FP-1))begin
	 rd_addr <= 'd0;
	 rd_flag <= ~rd_flag;
      end
      else if(rd_sram&(!sram_empty))begin
	 rd_addr <= rd_addr + 'd1;
      end
   end

   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 rd_sram_r <= 'd0;	 
      end
      else begin
	 rd_sram_r <= rd_sram;
      end
   end
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 sram_full <= 'd0;
      end
      else if(rd_sram_r&sram_full)begin
	 sram_full <= 'd0;
      end
      else if(wr_sram&(wr_addr==rd_addr-'d1)&(!rd_sram_r)&(wr_flag^~rd_flag))begin
	 sram_full <= 'd1;
      end
   end   
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 sram_empty <= 'd0;
      end
      else if(wr_sram&sram_empty)begin
	 sram_empty <= 'd0;
      end
      else if(rd_sram&(rd_addr==wr_addr-'d1)&(!wr_sram)&(wr_flag^rd_flag))begin
	 sram_empty <= 'd1;
      end
   end

   // ---------------------------------------------------------
   // virtual sram
   // ---------------------------------------------------------
   logic [DW-1:0] mem[FP-1:0];
   initial begin
      @(!rst_n)
	for(int i=0; i<FP; i=i+1)begin
	   mem[i] = 'd0;
	end
   end
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 m2m_rd_r <= 'd0;	 
      end
      else begin
	 m2m_rd_r <= rd_sram;
      end
   end
   always @ (posedge clk or negedge rst_n)begin
      if(wr_sram)begin
	 mem[wr_addr] <= mux0_sram;
      end
   end
   always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
	 sram_reg0 <= 'd0;	 
      end
      else if(m2m_rd_r)begin
	 sram_reg0 <= mem[rd_addr];
      end
   end   
   
   // // ---------------------------------------------------------
   // // logic control
   // // ---------------------------------------------------------
   // // mux0
   // assign mux0_sel = 
   
   
   
   
endmodule 	//Msync_fifo
