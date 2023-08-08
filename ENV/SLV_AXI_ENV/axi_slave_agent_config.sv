
 ////////////////////////////////////////////////////////////////////////
 //devloper name : 
 //date   :  
 //Description : 
 //////////////////////////////////////////////////////////////////////

  class axi_slave_agent_config extends uvm_object;
  
  virtual axi_interface axi_inf;

 //active passive agent config
 uvm_active_passive_enum active = UVM_ACTIVE;
 
 int ready_delay,resp_delay;
  
 function new(string str = "axi_slave_agent_config"); 
    super.new(str);
 endfunction : new

endclass


