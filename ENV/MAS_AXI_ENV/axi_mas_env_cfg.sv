/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 04-08-2023
// Last Modifiey  : 01-09-2023 14:22:21
// File Name   	  : axi_mas_env_cfg.sv
// Class Name 	  : axi_mas_env_cfg
// Project Name	  : AXI_3 VIP 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_CFG_SV
`define AXI_MAS_CFG_SV

//--------------------------------------------------------------------------
// class  : axi_mas_env_cfg 
//--------------------------------------------------------------------------
class axi_mas_env_cfg extends uvm_object;

//UVM Fectory registretion.
//uvm_sequencer is Object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils(axi_mas_env_cfg)


  
  static int axi_drv_count_h;
  static int axi_mon_count_h;

//Various Agents
  bit has_magent=1;
  bit has_sagent=1;

//Set to have virtual sequencer.
  bit has_virtual_sequener=0;

//to set Score boaed conected to score board weusing has_sb .
  bit has_scoreboard=1; 

//to set coverage.
  bit has_mcollector=0;
  bit has_scollector=0;

//to set checker.
  bit has_mchecker=0;
  bit has_schecker=0; 

//dynamic array Configuration handles for the sub_components.
  axi_mas_agent_cfg       m_agent_cfg_h[];
  axi_slave_agent_config  s_agent_cfg_h[];

//Set the noumber of DUT.
  int no_dut=1;
//new counstructore declaration.
  function new(string name="AXI_MAS_ENV_CFG");
    super.new(name);
    m_agent_cfg_h = new[no_dut];
    s_agent_cfg_h = new[no_dut];
  endfunction 

endclass  : axi_mas_env_cfg

`endif 
