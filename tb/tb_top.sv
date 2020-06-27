`timescale 1ns/1ps
module tb_top();
  
   //===================================
   // This is the UUT that we're 
   // running the Unit Tests on
   //===================================
   Msync_fifo my_Msync_fifo();

   // fsdb
   initial begin
      $fsdbDumpfile("tb_top.fsdb");
      $fsdbDumpvars("+all");
   end
   
endmodule
