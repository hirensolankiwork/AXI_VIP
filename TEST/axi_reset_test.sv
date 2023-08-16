/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 31-07-2023
// Last Modifiey  : 13-08-2023 16:10:18
// File Name   	  : axi_reset_test.sv
// Class Name 	  : axi_reset_test 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_RESET_TEST_SV
`define AXI_RESET_TEST_SV
//------------------------------------------------------------------------
// class  : axi_reset_test 
//------------------------------------------------------------------------
class axi_reset_test extends axi_base_test;

//UVM Fectory registretion.
//axi_base_test is Component that's why we are using 
//`uvm_component_utils macro.
  `uvm_component_utils(axi_reset_test)

//new counstructore declaration.
  function new(string name="AXI_RESET_TEST",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  axi_mas_reset_seq     mseqs_h;
  axi_slave_base_seq    sseqs_h;
  function void build_phase(uvm_phase phase);
    super.no_seq_xtn=3;
    super.delay_cycle=1;
    super.build_phase(phase);
  endfunction 

  task run_phase(uvm_phase phase);
    `uvm_info(get_name(),"Start of Run Phase",UVM_HIGH)
    phase.raise_objection(this,{get_name(),"Raise of the objection in run phase"});
    fork
      begin
		    mseqs_h = axi_mas_reset_seq::type_id::create("MSEQS_H");
		    mseqs_h.start(env_h.magent_h[0].mseqr_h);
		  end
		  begin
		    sseqs_h = axi_slave_base_seq::type_id::create("SSEQS_H");
        sseqs_h.start(env_uvc.env.agent_uvc.slv_agnt.slv_seqr);
		  end 
    join_any
    phase.phase_done.set_drain_time(this,200) ;
	  phase.drop_objection(this,{get_name(),"Drop of the objection in run phase"});
    `uvm_info(get_name(),"End of Run Phase",UVM_HIGH)
  endtask 

 
endclass  : axi_reset_test 

`endif 
