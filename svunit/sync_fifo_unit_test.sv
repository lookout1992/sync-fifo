`include "svunit_defines.svh"
`include "sync_fifo.sv"

module Msync_fifo_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "Msync_fifo_ut";
  svunit_testcase svunit_ut;


  initial begin
   $fsdbDumpfile("sync_fifo.fsdb");
   $fsdbDumpvars("+all");
  end


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  Msync_fifo my_Msync_fifo();


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN



  `SVUNIT_TESTS_END

endmodule
