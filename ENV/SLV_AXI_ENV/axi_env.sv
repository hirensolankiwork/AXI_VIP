

////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24/07/2023
//Description : environment wich is build the agent
/////////////////////////////////////////////////////////////////////


class axi_env extends uvm_env;

`uvm_component_utils(axi_env)

axi_slave_agent   slv_agnt ;
axi_scoreboard    axi_sb;
axi_agent_config        env_config ;
axi_slv_uvc       slv_uvc;

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
        `uvm_info(get_type_name(), " Entering Env Build Phase", UVM_DEBUG);
        //slv_agnt = axi_slave_agent::type_id::create("slv_agnt", this);
        axi_sb   = axi_scoreboard::type_id::create("axi_sb", this);
        env_config = axi_agent_config :: type_id :: create("env_config",this);
        slv_uvc    = axi_slv_uvc :: type_id :: create("slv_uvc",this);
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
        `uvm_info("", " Exit connect  Phase", UVM_DEBUG)
endfunction

endclass





