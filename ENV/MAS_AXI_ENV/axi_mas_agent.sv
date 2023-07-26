/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 26-07-2023 17:02:18
// File Name   	  : axi_mas_agent.sv
// Class Name 	  : axi_mas_agent 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_AGENT_SV
`define AXI_MAS_AGENT_SV

//------------------------------------------------------------------------
// class  : axi_mas_agent 
//------------------------------------------------------------------------
class axi_mas_agent extends uvm_agent;

  virtual axi_inf     m_vif;
  axi_mas_drv         mdrv_h;
  axi_mas_mon         mmon_h;
  axi_mas_seqr        mseqr_h;
  axi_mas_cfg         mcfg_h;

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using 
//`uvm_component_utils macro.
  `uvm_component_utils(axi_mas_agent)

//new counstructore declaration.
  function new(string name="axi_mas_agent",uvm_component parent=null);
    super.new(name,parent);
    mcfg_h = axi_mas_cfg::type_id::create("mcfg_h");
  endfunction 

//------------------------------------------------------------------------
// Function  : Build Phase  
//------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    mmon_h = axi_mas_mon::type_id::create("mmon_h",this);
    if(mcfg_h.is_active==UVM_ACTIVE)begin
      mdrv_h = axi_mas_drv::type_id::create("mdrv_h",this);
      mseqr_h= axi_mas_seqr::type_id::create("mseqr_h",this);
    end
    if(!uvm_config_db #(virtual axi_inf)::get(this,"*","m_vif",m_vif))
      `uvm_fatal(get_name(),"Interface Configuration is Faild !!!!")
    `uvm_info(get_name(),"Ending of Build Phase",UVM_DEBUG)
  endfunction
//------------------------------------------------------------------------
// Function  : Connect Phase  
//------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Connect Phase",UVM_DEBUG)
    super.connect_phase(phase);
    if(mcfg_h.is_active==UVM_ACTIVE) begin
      mdrv_h.seq_item_port.connect(mseqr_h.seq_item_export);
      mdrv_h.m_vif = m_vif;
    end
    mmon_h.m_vif = m_vif;
    `uvm_info(get_name(),"Ending of connect Phase",UVM_DEBUG)
  endfunction 


endclass 

`endif 
