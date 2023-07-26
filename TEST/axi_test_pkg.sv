/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 25-07-2023 14:04:38
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
 
  `include "uvm_macros.svh";
  
  import axi_env_pkg::*;
  
    `include "axi_base_test.sv";
  
endpackage

`endif 
