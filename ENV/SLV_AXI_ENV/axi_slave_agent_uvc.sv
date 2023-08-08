class axi_slave_agent_uvc extends uvm_agent; 
 
  `uvm_component_utils(axi_slave_agent_uvc) 
   axi_slave_agent_config slv_cfg;
   axi_slave_agent   slv_agnt;

    function new (string str="axi_slv_agent_uvc", uvm_component parent=null); 
        super.new(str,parent); 
    endfunction: new 
	
	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
        slv_cfg = new;
		uvm_config_db #(axi_slave_agent_config)::set(this,"*","slv_cfg", slv_cfg);
        slv_agnt = axi_slave_agent::type_id::create("slv_agnt", this);
    endfunction

   	
	         
endclass 




