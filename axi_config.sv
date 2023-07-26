
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////



class axi_agent_config extends uvm_object;
    `uvm_object_utils(axi_agent_config)
    
       //virtual axi_intf#(.D_WIDTH(D_WIDTH), .A_WIDTH(A_WIDTH)) intf;

    // Master and Slave are active or passive
    uvm_active_passive_enum active = UVM_ACTIVE;

    function new(string name = "env_config");
        super.new(name);
    endfunction


endclass 




