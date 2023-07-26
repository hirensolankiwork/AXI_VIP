
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth
//date   :  24/07/23
//Description : 
//////////////////////////////////////////////////////////////////////


class axi_slave_driver extends uvm_driver#(axi_trans);

`uvm_component_utils(axi_slave_driver)
virtual axi_interface axi_inf;
axi_trans tr_h;

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
        Ready_drive();
        seq_item_port.get_next_item(req);
        `uvm_info(get_name(),"After get next",UVM_DEBUG)
          if(req.WLAST)
            resp_drive(req);
          if(req.RVALID)
            read_data(req); 
        seq_item_port.item_done();
end
endtask

task  resp_drive(axi_trans tr_h);
          axi_inf.slv_drv_cb.BRESP <= tr_h.BRESP;
          axi_inf.slv_drv_cb.BVALID <= tr_h.BVALID;
          axi_inf.slv_drv_cb.BID    <= tr_h.BID;
          @(axi_inf.slv_drv_cb);
          wait(axi_inf.slv_drv_cb.BREADY == 1'b1);
          axi_inf.slv_drv_cb.BVALID <= 1'b0;
endtask    

task read_data(axi_trans tr_h);
    int len;
       int size;
       len = tr_h.rlen_que.pop_back();
       size = tr_h.rsize_que.pop_back();
       axi_inf.SDRV.slv_drv_cb.RID <= tr_h.raid.pop_back();
       axi_inf.SDRV.slv_drv_cb.RLAST <= 1'b0;
       axi_inf.SDRV.slv_drv_cb.RRESP <= 2'b00;
       axi_inf.SDRV.slv_drv_cb.RID   <= tr_h.RID; 
         for(int i = len*size; i>0 ; i--)
           begin
                 axi_inf.SDRV.slv_drv_cb.RDATA = $urandom_range(50,100);
                 if(i==1)begin
                        axi_inf.SDRV.slv_drv_cb.RLAST = 1'b1;
                 end
                 @(axi_inf.slv_drv_cb);
           end
endtask


task Ready_drive();
          axi_inf.slv_drv_cb.AWREADY <= 1'b1;
          axi_inf.slv_drv_cb.WREADY <= 1'b1;
          axi_inf.slv_drv_cb.ARREADY <= 1'b1;
          axi_inf.slv_drv_cb.RVALID <= 1'b1;
endtask

endclass

