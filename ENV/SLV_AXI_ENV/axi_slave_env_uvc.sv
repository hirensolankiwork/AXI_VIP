
////////////////////////////////////////////////////////////////////////
//devloper name : 
//date   : 
//Description : 
//////////////////////////////////////////////////////////////////////

class axi_slave_env_uvc extends uvm_env;

 `uvm_component_utils(axi_slave_env_uvc) 
  axi_slave_env_config  env_cfg;
  axi_env env; 
  
 
 function new(string str = "axi_slave_env_uvc", uvm_component parent); 
 super.new(str,parent);
 endfunction : new

 
 function void build_phase(uvm_phase phase);
 super.build_phase(phase); 
   `uvm_info("", " Build Phase", UVM_HIGH)
    env_cfg = new;
    //environment config
    //env_cfg.sagent_cfg = new[1];
    env_cfg.coverage_pin = 1'b1;
    env_cfg.scoreboard_pin = 1'b1;
    env_cfg.checker_pin   = 1'b1;
    uvm_config_db #(axi_slave_env_config)::set(this,"*","env",env_cfg);
    //create environment
    env = axi_env::type_id::create("axi_env",this);
 endfunction

 endclass
