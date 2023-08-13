/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 10-08-2023
// Last Modifiey  : 11-08-2023 14:47:36
// File Name   	  : axi_mas_checker.sv
// Class Name 	  : axi_mas_checker 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_CHECKER_SV
`define AXI_MAS_CHECKER_SV

class axi_mas_checker  extends uvm_subscriber #(axi_mas_seq_item);
//UVM Fectory registretion.
//uvm_subscriber is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_checker)

  function new(string name="axi_mas_checker",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  axi_mas_seq_item  m_tx_h;

  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Start of Build Phase.",UVM_HIGH)
    super.build_phase(phase);
    `uvm_info(get_name(),"End of Build Phase.",UVM_HIGH)
  endfunction

  virtual function void write(axi_mas_seq_item t);
    $cast(m_tx_h,t.clone());
    `uvm_info(get_name(),"Inside the checker.",UVM_HIGH)
    `uvm_info(get_name(),"End of task .",UVM_HIGH)
  endfunction

endclass

`endif 
