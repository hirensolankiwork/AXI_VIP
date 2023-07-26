/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 25-07-2023 17:47:11
// File Name   	  : axi_env.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_ENV_SV
`define AXI_ENV_SV

//--------------------------------------------------------------------------
// class  : axi_env 
//--------------------------------------------------------------------------
class axi_env extends uvm_env;

  axi_mas_agent    magent_h;
  axi_slave_agent  sagent_h;
  axi_agent_config s_cfg;
  axi_sb           sb_h;
//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_env)

//new counstructore declaration.
  function new(string name="axi_env",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    magent_h = axi_mas_agent::type_id::create("magent_h",this);
    sagent_h = axi_slave_agent::type_id::create("sagent_h",this);
 //Set slave config.
    s_cfg = axi_agent_config::type_id::create("s_cfg");
    sb_h     = axi_sb::type_id::create("sb_h",this);
    s_cfg.active=UVM_ACTIVE;
    uvm_config_db #(axi_agent_config)::set(this,"*","slv_cfg",s_cfg);
    
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_DEBUG)
  endfunction
//--------------------------------------------------------------------------
// Function  : Connect Phase  
//--------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Connect Phase",UVM_DEBUG)
    super.connect_phase(phase);
    magent_h.mmon_h.mas_ap.connect(sb_h.mas_ap_imp);
    `uvm_info(get_full_name(),"Ending of connect Phase",UVM_DEBUG)
  endfunction 

endclass 

`endif 
