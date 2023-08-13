/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 31-07-2023
// Last Modifiey  : 08-08-2023 11:47:00
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
    super.delay_cycle = 0;
    super.build_phase(phase);
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
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
    phase.phase_done.set_drain_time(this,100) ;
	  phase.drop_objection(this);
  endtask 

 
endclass  : axi_reset_test 

`endif 
