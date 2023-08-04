/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 03-08-2023 17:06:15
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
class axi_mas_agent_cfg extends uvm_object;
//To set Agent to be active or passive agent we using is_active here.
  uvm_active_passive_enum is_active = UVM_ACTIVE;

//UVM Fectory registretion.
//uvm_sequencer is Object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils_begin(axi_mas_agent_cfg)
    `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_PRINT)
  `uvm_object_utils_end

//new counstructore declaration.
  function new(string name="AXI_MAS_AGENT_CFG");
    super.new(name);
  endfunction 



//to set Score boaed conected to score board weusing has_sb .
  bit has_sb = 0; 

//to set coverage we using has_cvg .
  bit has_cvg = 0;

//
endclass 

`endif 
