
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth
//date   :  24/07/23
//Description : 
//////////////////////////////////////////////////////////////////////


class axi_slave_driver extends uvm_driver#(axi_trans);

`uvm_component_utils(axi_slave_driver)
virtual axi_interface axi_inf;
axi_trans tr_h;
bit item_done_flag;

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
        fork
          begin
               @(negedge axi_inf.rst);
          end
        
          begin
               
               if(axi_inf.rst) begin
                        Ready_drive();
                        seq_item_port.get_next_item(req);
                        item_done_flag = 1'b1;
                        `uvm_info(get_name(),$sformatf("After get next wlast and rvalid is %0d %0d",req.WLAST,req.rvalid),UVM_DEBUG)
                         if(req.WLAST)begin
                             `uvm_info(get_type_name(),$sformatf("  enter the resp_task"),UVM_MEDIUM);
                             @(axi_inf.mon_cb)
                             resp_drive(req);
                         end
                         if(req.rvalid)begin
                            read_data(req); 
                         end
                          seq_item_port.item_done();
                          item_done_flag = 1'b0;
               end  
           end
     join_any
     disable fork;
            if(!axi_inf.rst)
            begin
                 `uvm_info(get_name(),$sformatf("RESET TASK "),UVM_DEBUG) 
                 axi_inf.async_reset.WREADY  <=  1'b0;
                 axi_inf.async_reset.ARREADY <=  1'b0;
                 axi_inf.async_reset.AWREADY <=  1'b0;
                 axi_inf.async_reset.BID     <=  1'b0;
                 axi_inf.async_reset.BRESP   <=  1'b0;
                 axi_inf.async_reset.BVALID  <=  1'b0;
                 axi_inf.async_reset.RID     <=  1'b0;
                 axi_inf.async_reset.RRESP   <=  1'b0;
                 axi_inf.async_reset.RVALID  <=  1'b0;
                 axi_inf.async_reset.RDATA   <=  1'b0;
                 axi_inf.async_reset.RLAST   <=   1'b0;
                 tr_h.rvalid                 =   1'b0;
                 tr_h.ar_que.delete();
                 tr_h.aw_que.delete();
                 tr_h.wstrobe.delete();
                 tr_h.wdata.delete();
                 tr_h.RVALID = 1'b0;
                 tr_h.WLAST = 1'b0;
                 tr_h.ARVALID = 1'b0;
                 tr_h.AWVALID = 1'b0;
                 tr_h.ARID    = 1'b0;
                `uvm_info(get_name(),$sformatf("Inside slave Driver @ reset ARID %0d and size of ar que and aw que is %0d %0d ",tr_h.ARID,tr_h.ar_que.size(),tr_h.aw_que.size()),UVM_DEBUG) 
            if(item_done_flag) begin
               seq_item_port.item_done();
               item_done_flag = 1'b0;
            end   
            @(posedge axi_inf.rst);

     end
     
end
endtask



////////////////////////////////////////////////////////////////////////
//Method name :  respon-drive 
//Arguments   :  axi_trans 
//Description :  this task drives the respons signals to master whenever wlast asserted 
//////////////////////////////////////////////////////////////////////
task  resp_drive(axi_trans tr_h);
          axi_inf.slv_drv_cb.BRESP <= 2'b00;
          axi_inf.slv_drv_cb.BID   <= tr_h.WID;
          axi_inf.slv_drv_cb.BVALID <= 1'b1;
          @(axi_inf.slv_drv_cb);
          axi_inf.slv_drv_cb.BVALID <= 1'b0;
          tr_h.WLAST = 1'b0;
endtask   




////////////////////////////////////////////////////////////////////////
//Method name :  read-data
//Arguments   :  axi-trans
//Description :  this task drives the read data response as soon as read address recieve 
//////////////////////////////////////////////////////////////////////
task read_data(axi_trans tr_h);
     int len;
     int size;
     `uvm_info(get_name(),$sformatf("Inside slave driver before que delete size  %0d and size of que is %0d",tr_h.ar_que[0].ARID,tr_h.ar_que.size),UVM_DEBUG) 
     while(tr_h.ar_que.size !=0)begin
           len = tr_h.ar_que[0].ARLEN;
           axi_inf.slv_drv_cb.RID <= tr_h.ar_que[0].ARID;
           `uvm_info(get_name(),$sformatf("Inside slave driver read data ARID %0d",tr_h.ar_que[0].ARID),UVM_DEBUG) 
           tr_h.ar_que.delete(0);
           `uvm_info(get_name(),$sformatf("Inside slave driver after que delete size  %0d and size of que is %0d",tr_h.ar_que[0].ARID,tr_h.ar_que.size),UVM_DEBUG) 
           `uvm_info(get_type_name(),$sformatf(" read id getting driver is %0d que array is  %p",axi_inf.slv_drv_cb.RID,tr_h.ar_que),UVM_MEDIUM);
            axi_inf.slv_drv_cb.RLAST <= 1'b0;
            axi_inf.slv_drv_cb.RRESP <= 2'b00;
            axi_inf.slv_drv_cb.RVALID <= 1'b1;
            for(int i = len; i>=0 ; i--)
            begin
                 tr_h.randomize();
                 axi_inf.slv_drv_cb.RDATA <= tr_h.RDATA;
                 `uvm_info(get_type_name(),$sformatf(" data burst is %0d and value of i is %0d and size of ar_que is %0d",len,i,tr_h.ar_que.size),UVM_MEDIUM);
                 if(i==0)begin
                      if(req.WLAST)begin
                           @(axi_inf.slv_drv_cb);
                           `uvm_info(get_type_name(),$sformatf(" @ from read task to enter the resp_task"),UVM_MEDIUM);
                           resp_drive(req);
                      end
                      `uvm_info(get_type_name(),$sformatf(" value of i is %0d size of que %0d and data of que %0d ",i,tr_h.ar_que[0],tr_h.ar_que.size),UVM_MEDIUM);
                      axi_inf.slv_drv_cb.RLAST <= 1'b1;
                      axi_inf.slv_drv_cb.RVALID <= 1'b1;
                      @(axi_inf.slv_drv_cb)
                      axi_inf.slv_drv_cb.RLAST <= 1'b0;
                      axi_inf.slv_drv_cb.RVALID <= 1'b0;
                      tr_h.rvalid = 1'b0;
                 end
                 if(req.WLAST)begin
                 @(axi_inf.slv_drv_cb);
                 `uvm_info(get_type_name(),$sformatf(" @ from read task to enter the resp_task"),UVM_MEDIUM);
                 resp_drive(req);
             end
            @(axi_inf.slv_drv_cb);
            end
            @(axi_inf.slv_drv_cb);
        end 
endtask

////////////////////////////////////////////////////////////////////////
//Method name : ready-drive
//Arguments   : axi-trans
//Description : this task drives the slave ready signal to the master
//////////////////////////////////////////////////////////////////////
task Ready_drive();
         if(axi_inf.rst)begin
               axi_inf.slv_drv_cb.AWREADY <= 1'b1;
               axi_inf.slv_drv_cb.WREADY <= 1'b1;
               axi_inf.slv_drv_cb.ARREADY <= 1'b1;
          end
endtask

endclass


