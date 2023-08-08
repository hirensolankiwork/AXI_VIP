
 ////////////////////////////////////////////////////////////////////////
 //devloper name : 
 //date   :  
 //Description : 
 //////////////////////////////////////////////////////////////////////

  class axi_slave_agent_config extends uvm_object;
 
    `uvm_object_utils(axi_slave_agent_config)
  virtual axi_interface axi_inf;

 //active passive agent config
 uvm_active_passive_enum active = UVM_ACTIVE;
 
 int ready_delay,resp_delay;
  //to set the noumber of monitore or dirver in agent.
  static int axi_mon_count_h;
	static int axi_drv_count_h;

	bit driver_mode=0;
//base on delay_cycle we can delay ready or valid signal do driver.  
  bit [4:0]delay_cycle=1;

//This is just the sequencer counter.  
  int no_seq_xtn;
  
  int m_write_interleave;
 	int m_write_out_order_resp;
  
 	int m_read_interleave;
 	int m_read_out_order_resp;

 function new(string str = "axi_slave_agent_config"); 
    super.new(str);
 endfunction : new

endclass


