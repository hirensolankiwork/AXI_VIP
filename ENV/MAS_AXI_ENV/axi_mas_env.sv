/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 18-08-2023 13:55:28
// File Name   	  : axi_mas_env.sv
// Class Name 	  : axi_mas_env 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_ENV_SV
`define AXI_MAS_ENV_SV

//--------------------------------------------------------------------------
// class  : axi_mas_env 
//--------------------------------------------------------------------------
class axi_mas_env extends uvm_env;

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_env)

//new counstructore declaration.
  function new(string name="AXI_MAS_ENV",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  axi_mas_agent         magent_h[];
  axi_slave_agent       sagent_h[];
  axi_mas_sb            sb_h[];
  axi_mas_collector     m_colect_h[];
  axi_mas_checker       m_check_h[];
  axi_mas_env_cfg       m_env_cfg_h;
//axi_slave_agent_uvc   slv_uvc;
//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Build Phase",UVM_HIGH)
    super.build_phase(phase);
    if(!uvm_config_db #(axi_mas_env_cfg)::get(this,
                                              "",
                                              "axi_mas_env_config",
                                              m_env_cfg_h))
      `uvm_fatal("[CONFIG]","cannot get() axi_mas_env_cfg_h from uvm_config_db. Have you set() it?")
    if(m_env_cfg_h.has_magent)begin
      magent_h = new[m_env_cfg_h.no_dut];
      foreach(magent_h[i])begin
        uvm_config_db #(axi_mas_agent_cfg)::set(this,
                                                $sformatf("*magent_h[%0d]*",i),
                                                "axi_master_agent_config",
                                                m_env_cfg_h.m_agent_cfg_h[i]);
        `uvm_info(get_name(),$sformatf("%p",m_env_cfg_h.m_agent_cfg_h[i]),UVM_DEBUG)
        magent_h[i] = axi_mas_agent::type_id::create($sformatf("magent_h[%0d]",i),this);
      end
    end
    
    if(m_env_cfg_h.has_sagent)begin
      sagent_h = new[m_env_cfg_h.no_dut];
      foreach(sagent_h[i])begin
        uvm_config_db #(axi_slave_agent_config)::set(this,
                                               $sformatf("*sagent_h[%0d]*",i),
                                               "slv_cfg",
                                               m_env_cfg_h.s_agent_cfg_h[i]);
        sagent_h[i] = axi_slave_agent::type_id::create($sformatf("sagent_h[%0d]",i),this);
      end
      
     //slv_uvc = axi_slave_agent_uvc::type_id::create("slv_uvc",this);   

    
    
    end

    if(m_env_cfg_h.has_scoreboard)begin
      sb_h = new[m_env_cfg_h.no_dut];
      foreach(sb_h[i])begin
        sb_h[i] = axi_mas_sb::type_id::create($sformatf("sb_h[%0d]",i),this);
      end
    end    
    if(m_env_cfg_h.has_mcollector)begin
      m_colect_h = new[m_env_cfg_h.no_dut];
      foreach(m_colect_h[i])begin
        m_colect_h[i] = axi_mas_collector::type_id::create($sformatf("m_colect_h[%0d]",i),this);
      end
    end    
    if(m_env_cfg_h.has_mchecker)begin
      m_check_h = new[m_env_cfg_h.no_dut];
      foreach(m_check_h[i])begin
        m_check_h[i] = axi_mas_checker::type_id::create($sformatf("m_check_h[%0d]",i),this);
      end
    end  
    `uvm_info(get_name(),"Ending of Build Phase",UVM_HIGH)

  endfunction
//--------------------------------------------------------------------------
// Function  : Connect Phase  
//--------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Connect Phase",UVM_HIGH)
    super.connect_phase(phase);
//TODO: config for score board.
    if(m_env_cfg_h.has_scoreboard)begin
      foreach(magent_h[i])begin
        magent_h[i].m_agent_ap.connect(sb_h[i].m_mon_aimp);
      end
    end    
    if(m_env_cfg_h.has_mcollector)begin
      foreach(magent_h[i])begin
        magent_h[i].m_agent_ap.connect(m_colect_h[i].analysis_export);
      end
    end    
    if(m_env_cfg_h.has_mchecker)begin
      foreach(magent_h[i])begin
        magent_h[i].m_agent_ap.connect(m_check_h[i].analysis_export);
      end
    end     `uvm_info(get_name(),"Ending of connect Phase",UVM_HIGH)
  endfunction 

endclass 

`endif 
