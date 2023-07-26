
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth
//date   :  24/07/23
//Description : 
//////////////////////////////////////////////////////////////////////


class axi_slave_driver extends uvm_driver#(axi_trans);

`uvm_component_utils(axi_slave_driver)
axi_trans tr_h;
virtual axi_interface axi_inf;
////////////////////////////////////////////////////////////////////////
//Method name : Constructor new
//Arguments   :  str,parent
//Description : when agent call the create method of slv_drv then this function will be called
//////////////////////////////////////////////////////////////////////
function new(string str = "axi_slave_driver" , uvm_component parent);

super.new(str,parent);

endfunction





////////////////////////////////////////////////////////////////////////
//Method name : build phase
//Arguments   :  phase
//Description : for the build the transaction class.
//////////////////////////////////////////////////////////////////////
function void build_phase(uvm_phase phase);
super.build_phase(phase);
 if (!uvm_config_db #(virtual axi_interface)::get(this,"","vif",axi_inf))
		   `uvm_fatal(get_full_name(), "Not able to get the virtual interface!")

tr_h = new();
`uvm_info("", " Driver Build Phase", UVM_DEBUG);
endfunction




////////////////////////////////////////////////////////////////////////
//Method name : run task
//Arguments   :  phase
//Description : here write a logic for driving stimulus to interface
//////////////////////////////////////////////////////////////////////
task  run_phase(uvm_phase phase);

super.run_phase(phase); 
    `uvm_info("", " DRIVER Run Phase...", UVM_DEBUG);
    forever begin
        
        seq_item_port.get_next_item(req);
            drive(req);
        seq_item_port.item_done();
end
endtask

task  drive(axi_trans tr_h);
          @(posedge axi_inf.slv_drv_cb)
          axi_inf.slv_drv_cb.BRESP <= tr_h.BRESP;
          axi_inf.slv_drv_cb.BVALID <= tr_h.BVALID;
          wait(axi_inf.BREADY == 1'b1)
          axi_inf.slv_drv_cb.BVALID <= 1'b0;
          axi_inf.slv_drv_cb.BRESP <= 1'bx;
endtask    




endclass

