
 ////////////////////////////////////////////////////////////////////////
 //devloper name : siddharth
 //date   :  24/07/23
 //Description : 
 //////////////////////////////////////////////////////////////////////

 class axi_slave_driver extends uvm_driver#(axi_slave_seq_item);
 `uvm_component_utils(axi_slave_driver)
  virtual axi_interface axi_inf;
  axi_slave_seq_item tr_h,temp,ar_temp,req_h;
  axi_slave_seq_item aw_que[$],ar_que[$],req_que[$];
  bit item_done_flag;
  slave_sequencer  seqr_h;

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
   `uvm_info(get_full_name()," ENTER INSIDE DRIVER BUILD PHASE ",UVM_DEBUG)
    super.build_phase(phase);
    if (!uvm_config_db #(virtual axi_interface)::get(this,"","vif",axi_inf))
       `uvm_fatal(get_full_name(), "Not able to get the virtual interface!")
    temp = new();
    tr_h = new();
   `uvm_info(get_full_name()," EXIT DRIVER BUILD PHASE ",UVM_DEBUG)
  endfunction
 
 ////////////////////////////////////////////////////////////////////////
 //Method name : run task
 //Arguments   :  phase
 //Description : here write a logic for driving stimulus to interface
 //////////////////////////////////////////////////////////////////////
  task  run_phase(uvm_phase phase);
   `uvm_info(get_full_name()," ENTER INSIDE DRIVER RUN PHASE ",UVM_DEBUG)
    super.run_phase(phase); 
    reset();
    forever begin
      fork
        begin
          @(negedge axi_inf.rst);
        end
        resp_drive();
        read_data();
        begin
           forever @(axi_inf.slv_drv_cb) begin
             if(axi_inf.rst) begin
                 Ready_drive();
                 seq_item_port.get_next_item(req);
                 req_h  = req;
                `uvm_info(get_name(),$sformatf("after get requet and req arvalid is 0d",req.ARVALID),UVM_DEBUG)
                 item_done_flag = 1'b1;
                 if(req_h.WVALID)begin
                   `uvm_info(get_name(),$sformatf("WVALID ASSERTED IN DRIVER"),UVM_DEBUG) 
                    aw_que.push_front(req_h);
                   `uvm_info(get_name(),$sformatf("AW_QUE SIZE IS %0d",aw_que.size()),UVM_DEBUG) 
                 end
                 if(req_h.ARVALID)begin
                   `uvm_info(get_name(),$sformatf("ARVALID ASSERTED IN DRIVER"),UVM_DEBUG) 
                    ar_que.push_front(req_h);
                   `uvm_info(get_name(),$sformatf("SIZE OF AR_QUE IS %0d ar_que is %p",ar_que.size(),tr_h.RDATA),UVM_DEBUG)
                 end
                 seq_item_port.item_done();
                 item_done_flag = 1'b0;
           end  
          end
       end   
    join_any
    disable fork;
        reset();
   `uvm_info(get_full_name()," EXIT DRIVER RUN PHASE ",UVM_DEBUG)
 end
 endtask



 ////////////////////////////////////////////////////////////////////////
 //Method name :  respon-drive 
 //Arguments   :  axi_slave_seq_item 
 //Description :  this task drives the respons signals to master whenever wlast asserted 
 //////////////////////////////////////////////////////////////////////
 task  resp_drive();
 forever @(axi_inf.slv_drv_cb) begin
`uvm_info(get_full_name(),$sformatf("ENTER INSIDE DRIVER resp_drive task and size of aw-que is %0d ",aw_que.size()),UVM_DEBUG)
    while(aw_que.size !==0)begin
       temp = aw_que.pop_back(); 
      `uvm_info(get_name(),$sformatf("wlast is asserted sucessfully"),UVM_DEBUG)
       axi_inf.slv_drv_cb.BRESP <= temp.BRESP;
       axi_inf.slv_drv_cb.BID   <= temp.WID;
       axi_inf.slv_drv_cb.BVALID <= 1'b1;
       @(axi_inf.slv_drv_cb);
       if(aw_que.size()==0)
            axi_inf.slv_drv_cb.BVALID <= 1'b0;
    end         
       `uvm_info(get_full_name()," EXIT  DRIVER resp_drive task ",UVM_DEBUG)
 end
endtask   

 ////////////////////////////////////////////////////////////////////////
 //Method name :  read-data
 //Arguments   :  axi-trans
 //Description :  this task drives the read data response as soon as read address recieve 
 //////////////////////////////////////////////////////////////////////
 task read_data();
     forever @(axi_inf.slv_drv_cb) begin
        int len;
        while(ar_que.size !== 0)begin
           `uvm_info(get_full_name(),$sformatf("ENTER INSIDE DRIVER read_data task and size of ar_que is %0d and ",ar_que.size()),UVM_DEBUG)
            ar_temp = ar_que.pop_back();
           `uvm_info(get_name(),$sformatf("RID is asserted sucessfully and size of ar_que is %0d rdata is %p len is %0d and arid is %0d",ar_que.size(),ar_temp.RDATA,ar_temp.ARLEN,ar_temp.ARID),UVM_DEBUG)
            axi_inf.slv_drv_cb.RID    <= ar_temp.ARID;
            axi_inf.slv_drv_cb.RLAST  <= 1'b0;
            axi_inf.slv_drv_cb.RRESP  <= ar_temp.RRESP;  
            axi_inf.slv_drv_cb.RVALID <= 1'b1;
            for(int i = 0; i<= ar_temp.ARLEN; i++)begin 
               axi_inf.slv_drv_cb.RDATA <= ar_temp.RDATA[i];
               `uvm_info(get_name(),$sformatf("RDATA's ith = %0d VALUE IS %0d and ar id is %0d",i,ar_temp.RDATA[i],ar_temp.ARID),UVM_DEBUG)
               if(i == ar_temp.ARLEN)begin
                 `uvm_info(get_name(),$sformatf("RLAST ASSERT"),UVM_DEBUG)
                  axi_inf.slv_drv_cb.RLAST <= 1'b1;
                  axi_inf.slv_drv_cb.RVALID <= 1'b1;
                  @(axi_inf.slv_drv_cb)
                  axi_inf.slv_drv_cb.RLAST <= 1'b0;
                  if(!ar_que.size() != 0) begin
                     axi_inf.slv_drv_cb.RVALID <= 1'b0;
                  end  
               end
               @(axi_inf.slv_drv_cb);
            end   
        end
     end
    `uvm_info(get_full_name()," EXIT  DRIVER read_data task ",UVM_DEBUG)
endtask
 
 ////////////////////////////////////////////////////////////////////////
 //Method name : ready-drive
 //Arguments   : axi-trans
 //Description : this task drives the slave ready signal to the master
 //////////////////////////////////////////////////////////////////////
 task Ready_drive();
  `uvm_info(get_full_name()," ENTER INSIDE DRIVER ready-drive TASK ",UVM_DEBUG)
   axi_inf.slv_drv_cb.AWREADY <= 1'b1;
   axi_inf.slv_drv_cb.WREADY <= 1'b1;
   axi_inf.slv_drv_cb.ARREADY <= 1'b1;
  `uvm_info(get_full_name()," EXIT DRIVER Ready_drive TASK ",UVM_DEBUG)
endtask

////////////////////////////////////////////////////////////////////////
//Method name : 
//Arguments   :  
//Description : 
//////////////////////////////////////////////////////////////////////
  task reset();
   `uvm_info(get_full_name()," ENTER INSIDE DRIVER RESET TASK ",UVM_DEBUG)
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
    axi_inf.async_reset.RLAST   <=  1'b0;
    ar_que.delete();
    `uvm_info(get_name(),$sformatf("RESET  asserted sucessfully and size of ar_que is %0d ",ar_que.size()),UVM_DEBUG)
    aw_que.delete();
    while(req != null)begin
       seq_item_port.get_next_item(req);
       seq_item_port.item_done();
      `uvm_info(get_name(),$sformatf("seq_item_port is clearing"),UVM_DEBUG)
    end   

    if(item_done_flag) begin
        seq_item_port.item_done();
        item_done_flag = 1'b0;
    end   
    @(posedge axi_inf.rst);
   `uvm_info(get_full_name()," EXIT  DRIVER RESET TASK ",UVM_DEBUG)
endtask
endclass


