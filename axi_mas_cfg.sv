/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 24-07-2023 15:49:54
// File Name   	  : axi_mas_agent_cfg.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_CFG_SV
`define AXI_MAS_CFG_SV

//--------------------------------------------------------------------------
// class  : axi_mas_agent_cfg 
//--------------------------------------------------------------------------
class axi_mas_cfg extends uvm_object;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

//UVM Fectory registretion.
//uvm_sequencer is Object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils_begin(axi_mas_cfg)
    `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_PRINT)
  `uvm_object_utils_end

//new counstructore declaration.
  function new(string name="axi_mas_cfg");
    super.new(name);
  endfunction 


endclass 

`endif 
