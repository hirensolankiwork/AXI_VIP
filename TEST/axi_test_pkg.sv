/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 31-08-2023 11:09:21
// File Name   	  : axi_test_pkg.sv
// Package Name   : axi_test_pkg
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_TEST_PKG_SV
`define AXI_TEST_PKG_SV
package axi_test_pkg;

  `include "axi_define.sv"
  import uvm_pkg::*;
 
  `include "uvm_macros.svh"
  
  import axi_mas_env_pkg::*;
  
    `include "axi_base_test.sv"
    `include "axi_rand_test.sv"

    `include "axi_mas_reset_seq.sv"
    `include "axi_reset_test.sv"

    `include "axi_incr_seq.sv"
    `include "axi_incr_test.sv"

    `include "axi_wrap_seq.sv"
    `include "axi_wrap_test.sv"

    `include "axi_interleave_seq.sv"
    `include "axi_interleave_test.sv"

endpackage

`endif 
