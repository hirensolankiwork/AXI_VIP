

////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////



class axi_slave_agent extends uvm_agent;

`uvm_component_utils(axi_slave_agent)

axi_slave_driver  slv_drv;
axi_slave_monitor slv_mon;
slave_sequencer   slv_seqr;
uvm_analysis_port #(axi_trans) mon2sb;
axi_agent_config slv_cfg;


////////////////////////////////////////////////////////////////////////
//Method name : new constructor 
//Arguments   :  str,phase
//Description : when environment call create method of agent this function will be called
//////////////////////////////////////////////////////////////////////
function new(string str = "axi_slave_agent",uvm_component parent);
    super.new(str,parent);
endfunction





////////////////////////////////////////////////////////////////////////
//Method name : build phase 
//Arguments   :  phase
//Description : this will create the slave driver,slave monitor,slave sequencer and create analysis port 
//////////////////////////////////////////////////////////////////////
function void build_phase(uvm_phase phase);
      super.build_phase(phase); 
      `uvm_info(get_name(), " Entering AGENT Build Phase", UVM_DEBUG);
       mon2sb = new("mon2sb",this);
       if (!uvm_config_db #(axi_agent_config)::get(this,"","slv_cfg",slv_cfg))
      		     `uvm_fatal(get_full_name(), "Not able to get spi master config!")
                  slv_mon = axi_slave_monitor::type_id::create("slv_mon",this);
            if (slv_cfg.active == UVM_ACTIVE) begin
                  slv_drv = axi_slave_driver::type_id::create("slv_drv",this);
                  slv_seqr = slave_sequencer::type_id::create("slv_seqr",this);
		end
endfunction





////////////////////////////////////////////////////////////////////////
//Method name : connect phase  
//Arguments   :  phase
//Description : connect the driver and sequencer using inbuilt pull port and pull export 
//////////////////////////////////////////////////////////////////////
function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), " AGENT Connect Phase", UVM_DEBUG);
        mon2sb.connect(slv_mon.mon2sb);
         if (slv_cfg.active == UVM_ACTIVE) begin
        slv_drv.seq_item_port.connect(slv_seqr.seq_item_export);
        slv_mon.mon2seqr.connect(slv_seqr.item_collected.analysis_export);
        end
endfunction

endclass
