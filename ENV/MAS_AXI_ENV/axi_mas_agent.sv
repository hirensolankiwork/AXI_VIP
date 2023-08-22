/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 18-08-2023 15:54:22
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
//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using 
//`uvm_component_utils macro.
  `uvm_component_utils(axi_mas_agent)

//new counstructore declaration.
  function new(string name="magent_h",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

//--------------------------------------------------------------------------
 
  virtual axi_inf                       m_vif;
  axi_mas_drv                           mdrv_h;
  axi_mas_mon                           mmon_h;
  axi_mas_seqr                          mseqr_h;
  axi_mas_agent_cfg                     mcfg_h;
  uvm_analysis_export #(axi_mas_seq_item) m_agent_ap;

//------------------------------------------------------------------------
// Function  : Build Phase  
//------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Build Phase",UVM_HIGH)
    super.build_phase(phase);
    if(!uvm_config_db #(axi_mas_agent_cfg)::get(this,
                                                "*",
                                                "axi_master_agent_config",
                                                mcfg_h))
      `uvm_fatal(get_name(),"Master Agent Configuration is Faild !!!!")

    m_agent_ap = new("M_AGENT_AP",this);
    mmon_h = axi_mas_mon::type_id::create("mmon_h",this);
    if(mcfg_h.is_active==UVM_ACTIVE)begin
      `uvm_info(get_name(),"[UVM_ACTIVE]",UVM_DEBUG)
      mdrv_h = axi_mas_drv::type_id::create("mdrv_h",this);
      mseqr_h= axi_mas_seqr::type_id::create("mseqr_h",this);
    end
    if(!uvm_config_db #(virtual axi_inf)::get(this,
                                              "",
                                              "vif_0",
                                              m_vif))
      `uvm_fatal(get_name(),"Interface Configuration is Faild !!!!")
    `uvm_info(get_name(),"Ending of Build Phase",UVM_HIGH)
  endfunction
//------------------------------------------------------------------------
// Function  : Connect Phase  
//------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Connect Phase",UVM_HIGH)
    super.connect_phase(phase);
    if(mcfg_h.is_active==UVM_ACTIVE) begin
      mdrv_h.seq_item_port.connect(mseqr_h.seq_item_export);
      mdrv_h.m_vif = m_vif;
    end
    mmon_h.m_vif = m_vif;
    mmon_h.m_mon_ap.connect(this.m_agent_ap);
    `uvm_info(get_name(),"Ending of connect Phase",UVM_HIGH)
  endfunction 


endclass 

`endif 
