/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 25-07-2023 14:36:16
// File Name   	  : axi_sb.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_SB_SV
`define AXI_SB_SV

//--------------------------------------------------------------------------
// class  : axi_sb 
//--------------------------------------------------------------------------
class axi_sb extends uvm_scoreboard;

  `uvm_analysis_imp_decl(_mas)
//  `uvm_analysis_imp_decl(_slv)

  axi_mas_seq_item mexp_q[$];
  axi_mas_seq_item mact_q[$];
  axi_mas_seq_item mexp_h;
  axi_mas_seq_item mact_h;
/*axi_slv_seq_item sexp_q[$];
  axi_slv_seq_item sact_q[$];
  axi_slv_seq_item sexp_h;
  axi_slv_seq_item sact_h;
*/

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_sb)

// Add necessary TLM exports to receive transactions from other
// components and instantiat them in build_phase
  uvm_analysis_imp_mas #(axi_mas_seq_item,axi_sb) mas_ap_imp;  
//  uvm_analysis_imp_slv #(axi_slv_seq_item,axi_sb) slv_ap_imp;  
//new counstructore declaration.
  function new(string name="axi_sb",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mas_ap_imp = new("ms_ap_imp",this);
  //  slv_ap_imp = new("ms_ap_imp",this);
  endfunction 

//--------------------------------------------------------------------------
// Function  : write_mas
//--------------------------------------------------------------------------
  function void write_mas(axi_mas_seq_item trans_h);
    trans_h.print();
    mexp_q.push_back(trans_h);
    mact_q.push_back(trans_h);
  endfunction 
//--------------------------------------------------------------------------
// Function  : write_slv
//--------------------------------------------------------------------------
/*  function void write_slv(axi_slv_seq_item trans_h);
    trans_h.print();
    sexp_q.push_back(trans_h);
    sact_q.push_back(trans_h);
  endfunction 
*/
//--------------------------------------------------------------------------
// Task : run phase
//--------------------------------------------------------------------------

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_DEBUG)
    `uvm_info(get_full_name(),"Before Forever loop start",UVM_DEBUG)
    forever begin
    `uvm_info(get_full_name(),"Starting of Forever loop",UVM_DEBUG)
      wait( mexp_q.size != 0 && mact_q.size !=0);
      mexp_h = mexp_q.pop_front();
      mact_h = mact_q.pop_front();
      pridict_data();
      check_data();
    end
    `uvm_info(get_full_name(),"End of Forever loop",UVM_DEBUG)
  endtask
//--------------------------------------------------------------------------
// Task : Pridict_data
//--------------------------------------------------------------------------

  task pridict_data();  
  endtask 
//--------------------------------------------------------------------------
// Task : check_data
//--------------------------------------------------------------------------

  task check_data();  
  endtask 
endclass 

`endif 