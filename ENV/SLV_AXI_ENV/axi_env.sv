

 ////////////////////////////////////////////////////////////////////////
 //devloper name : Siddharth 
 //date   :  24/07/2023
 //Description : environment wich is build the agent
 /////////////////////////////////////////////////////////////////////
 
 
  class axi_env extends uvm_env;
 
 `uvm_component_utils(axi_env)
  axi_slave_agent       slv_agnt ;
  axi_mas_sb            axi_sb;
  axi_slave_env_config  env_cfg;
  axi_slave_agent_uvc   agent_uvc;  
 
 
 ////////////////////////////////////////////////////////////////////////
 //Method name : new constructor 
 //Arguments   :  str and parent
 //Description :  when axi_test call the create method this function will call 
 //////////////////////////////////////////////////////////////////////
 function new(string str = "axi_env", uvm_component parent);
   super.new(str,parent);
 endfunction : new
 
 ////////////////////////////////////////////////////////////////////////
 //Method name : build phase
 //Arguments   :  uvm_phase
 //Description : it will build the slave agent slave scoreboard and environment config
 //////////////////////////////////////////////////////////////////////
 function void build_phase(uvm_phase phase);
   super.build_phase(phase); 
   `uvm_info(get_type_name(), " Entering Env Build Phase", UVM_DEBUG)
    axi_sb   = axi_mas_sb::type_id::create("axi_sb", this);
    
    //environment config get
    uvm_config_db #(axi_slave_env_config)::get(this,"*","env",env_cfg);
    agent_uvc = axi_slave_agent_uvc::type_id::create("agent_uvc", this);
   `uvm_info(get_name(), "Exit Build Phase", UVM_HIGH)
 endfunction
 
 ////////////////////////////////////////////////////////////////////////
 //Method name : connect phase 
 //Arguments   :  phase
 //Description : it will connect the slave agent's monitor's analysis port to scoreboard analysis imp port
 //////////////////////////////////////////////////////////////////////
 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase); 
   `uvm_info(get_name(), " Entering Connect Phase...", UVM_DEBUG)
    agent_uvc.slv_agnt.mon2sb.connect(axi_sb.s_ap_imp);
   `uvm_info("", " Exit connect  Phase", UVM_DEBUG)
 endfunction
 
 endclass





