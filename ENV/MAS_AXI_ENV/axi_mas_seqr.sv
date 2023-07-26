/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 24-07-2023 15:51:54
// File Name   	  : axi_mas_seqr.sv
// Class Name 	  : axi_mas_seqr 
// Project Name	  : AXI_3 VIP
// Description	  : this the Sequencer component which genraets the sequence
// item from sequence and route it to the driver component.
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_SEQR_SV
`define AXI_MAS_SEQR_SV
  
//--------------------------------------------------------------------------
// class  : axi_mas_seqr 
//--------------------------------------------------------------------------
class axi_mas_seqr extends uvm_sequencer #(axi_mas_seq_item);

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_seqr)

//new counstructore declaration.
  function new(string name="axi_mas_seqr",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

endclass  : axi_mas_seqr 

`endif 
