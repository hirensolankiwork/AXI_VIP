/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 31-08-2023
// Last Modifiey  : 01-09-2023 11:01:16
// File Name   	  : axi_interleave_test.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_INTERLRAVE_TEST_SV
`define AXI_INTERLRAVE_TEST_SV

//------------------------------------------------------------------------
// class  : axi_interleave_test 
//------------------------------------------------------------------------

class axi_interleave_test extends axi_base_test;
//UVM Fectory registretion.
//axi_base_test is Component that's why we are using 
//`uvm_component_utils macro.
  `uvm_component_utils(axi_interleave_test)

//new counstructore declaration.
  function new(string name="axi_interleave_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  axi_interleave_seq    mseqs_h;
  axi_slave_base_seq    sseqs_h;
  
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Start of Build Phase",UVM_HIGH)
    super.write_interleave = 1;
    super.build_phase(phase);
    `uvm_info(get_name(),"End of Build Phase",UVM_HIGH)
  endfunction 

  task run_phase (uvm_phase phase);
    `uvm_info(get_name(),"Start of Run Phase",UVM_HIGH)
    phase.raise_objection(this,{get_name(),"Raise of the objection in run phase"});
      fork
        begin
		      mseqs_h = axi_interleave_seq::type_id::create("MSEQS_H");
          mseqs_h.count = 20;
		      mseqs_h.start(env_h.magent_h[0].mseqr_h);
		    end
		    begin
		      sseqs_h = axi_slave_base_seq::type_id::create("SSEQS_H");
          sseqs_h.start(env_uvc.env.agent_uvc.slv_agnt.slv_seqr);
		    end 
      join_any
	  phase.drop_objection(this,{get_name(),"Drop of the objection in run phase"});
    phase.phase_done.set_drain_time(this,200) ;
    `uvm_info(get_name(),"End of Run Phase",UVM_HIGH)
  endtask

endclass  : axi_interleave_test

`endif 
