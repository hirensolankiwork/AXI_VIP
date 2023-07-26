/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 25-07-2023 15:40:26
// File Name   	  : axi_env_pkg.sv
// Package Name   : axi_env_pkg
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////


`ifndef AXI_ENV_PKG_SV
`define AXI_ENV_PKG_SV

`include "axi_inf.sv"
`include "axi_interface.sv"
package axi_env_pkg;

  import uvm_pkg::*;
 
  `include "uvm_macros.svh";
  
  `include "axi_define.sv";
  `include "axi_mas_cfg.sv";
  `include "axi_mas_seq_item.sv";
  `include "axi_mas_drv.sv";
  `include "axi_mas_seqr.sv";
  `include "axi_mas_mon.sv";
  `include "axi_mas_agent.sv";
 // `include "axi_mas_uvc.sv";
  `include "axi_config.sv";
  `include "axi_trans.sv";
  `include "axi_slave_driver.sv";
  `include "slave_sequencer.sv";
  `include "axi_slave_monitor.sv";
  `include "axi_slave_agent.sv";
  `include "axi_slv_uvc.sv";
 
 `include "axi_mas_base_seqs.sv";
 `include "axi_slave_base_seq.sv";
  `include "axi_sb.sv";  
  `include "axi_env.sv";
  
endpackage

`endif
