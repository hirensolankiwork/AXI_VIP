/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 10-08-2023 11:32:49
// File Name   	  : axi_mas_agent_cfg.sv
// Class Name 	  : axi_mas_agent_cfg
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_AGENT_CFG_SV
`define AXI_MAS_AGENT_CFG_SV

//--------------------------------------------------------------------------
// class  : axi_mas_agent_cfg 
//--------------------------------------------------------------------------
class axi_mas_agent_cfg extends uvm_object;

//UVM Fectory registretion.
//uvm_sequencer is Object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils(axi_mas_agent_cfg)

//new counstructore declaration.
  function new(string name="AXI_MAS_AGENT_CFG");
    super.new(name);
  endfunction 

//To set Agent to be active or passive agent we using is_active here.
  uvm_active_passive_enum is_active = UVM_ACTIVE;

//to set the noumber of monitore or dirver in agent.
  static int axi_mon_count_h;
	static int axi_drv_count_h;

	bit driver_mode=0;
//base on delay_cycle we can delay ready or valid signal do driver.  
  bit [4:0]delay_cycle=1;

//This is just the sequencer counter.  
  int no_seq_xtn;
  
  int m_write_interleave;
 	int m_write_out_order_resp;
  
 	int m_read_interleave;
 	int m_read_out_order_resp;

// virtual interface 
  virtual axi_inf m_cfg_vif;

endclass 

`endif 
