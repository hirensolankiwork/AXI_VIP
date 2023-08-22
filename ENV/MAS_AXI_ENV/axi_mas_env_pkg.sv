/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 17-08-2023 14:32:40
// File Name   	  : axi_mas_env_pkg.sv
// Package Name   : axi_mas_env_pkg
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////


`ifndef AXI_MAS_ENV_PKG_SV
`define AXI_MAS_ENV_PKG_SV

`include "axi_inf.sv"
`include "axi_interface.sv"
package axi_mas_env_pkg;

  import uvm_pkg::*;
 
  `include "uvm_macros.svh";
  
  `include "axi_define.sv";
  `include "axi_mas_agent_cfg.sv";
  `include "axi_slave_env_config.sv";
  `include "axi_slave_agent_config.sv";
  `include "axi_mas_seq_item.sv";
  `include "axi_mas_env_cfg.sv";
  `include "axi_mas_drv.sv";
  `include "axi_mas_seqr.sv";
  `include "axi_mas_mon.sv";
  `include "axi_mas_agent.sv";
// `include "axi_mas_uvc.sv";
  `include "axi_slave_seq_item.sv";
  `include "slave_sequencer.sv";
  `include "axi_slave_driver.sv";
  `include "axi_slave_monitor.sv";
  `include "axi_slave_agent.sv";
  `include "axi_slave_agent_uvc.sv";
//`include "axi_slv_uvc.sv";
 
  `include "axi_mas_base_seqs.sv";
  `include "axi_slave_base_seq.sv";
  `include "axi_mas_collector.sv";
  `include "axi_mas_checker.sv";
  `include "axi_mas_sb.sv";  
  `include "axi_mas_env.sv";
  `include  "axi_env.sv"
  `include "axi_slave_env_uvc.sv"
 
endpackage

`endif
