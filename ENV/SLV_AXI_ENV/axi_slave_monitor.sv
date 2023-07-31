
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////


class axi_slave_monitor extends uvm_monitor;

`uvm_component_utils(axi_slave_monitor);
uvm_analysis_port #(axi_trans) mon2sb;
uvm_analysis_port #(axi_trans) mon2seqr;
axi_trans tr_h; 
virtual axi_interface axi_inf;

////////////////////////////////////////////////////////////////////////
//Method name : constructor
//Arguments   :  str,parent
//Description : when agent call the create method of slave_monitor this new constructor will call
//////////////////////////////////////////////////////////////////////
function new(string str = "axi_slave_monitor", uvm_component parent);
        super.new(str,parent);
 endfunction       

////////////////////////////////////////////////////////////////////////
//Method name : build phase
//Arguments   :  phase
//Description : create the uvm_analysis_port 
//////////////////////////////////////////////////////////////////////
function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info(get_type_name(), " ENTERING THE Slave monitor Build Phase", UVM_DEBUG)
   mon2sb = new("mon2sb",this);
   mon2seqr = new("mon2seqr",this);
   if (!uvm_config_db #(virtual axi_interface)::get(this,"","vif",axi_inf))
		   `uvm_fatal(get_full_name(), "Not able to get the virtual interface!")
endfunction


////////////////////////////////////////////////////////////////////////
//Method name : run_phase
//Arguments   :  phase
//Description :  this task will sample the interface and acording protocall it will send the scoreboard and sbscriber
//////////////////////////////////////////////////////////////////////
task  run_phase(uvm_phase phase);
    super.run_phase(phase); 
    `uvm_info(get_type_name(), " monitor Run Phase", UVM_DEBUG);
    forever begin 
    monitor();
    end
endtask


////////////////////////////////////////////////////////////////////////
//Method name : monitor
//Arguments   :  
//Description : this task parallaly monitor write read address and data channel
//////////////////////////////////////////////////////////////////////
task monitor();
    fork
        write_addr_monitor();
        write_data_monitor();
        read_addr_monitor();
    join

endtask

////////////////////////////////////////////////////////////////////////
//Method name : write-addr-monitor
//Arguments   :  
//Description : this task will sample when AWVALID AND AWREADY high the write address data and control signals and store into que
//////////////////////////////////////////////////////////////////////
task write_addr_monitor();
    forever begin
    @(posedge axi_inf.mon_cb);
    if(axi_inf.AWVALID && axi_inf.AWREADY)begin
          tr_h = new();
          tr_h.AWADDR  = $urandom_range(1,10);   // //axi_inf.AWADDR;
          tr_h.AWLEN   =  axi_inf.AWLEN;
          tr_h.AWBURST =  axi_inf.AWBURST;
          tr_h.AWID    =  axi_inf.AWID;
          tr_h.AWVALID = axi_inf.AWVALID;
          tr_h.AWSIZE = 2** axi_inf.AWSIZE;
          tr_h.aw_que.push_front(tr_h);
         `uvm_info(get_name(),$sformatf(" INSIDE THE AWCONDITON and size of AWQUE is %0d ",tr_h.aw_que.size()),UVM_DEBUG)
          mon2seqr.write(tr_h);
  end
end
endtask

////////////////////////////////////////////////////////////////////////
//Method name : write_data_monitor
//Arguments   :  
//Description : this task monitor the write data channel and sample @ when WVALID AND WREADY signal high and sample the write data,id,wlast,etc..
//////////////////////////////////////////////////////////////////////
task write_data_monitor();
     int i;
     forever begin
           if(axi_inf.WVALID && axi_inf.WREADY)
           begin
                `uvm_info(get_name(),$sformatf(" WVALID AND WREADY  ASSERTED ASSERTED IN MONITOR "),UVM_DEBUG)
                 if(!axi_inf.WLAST)
                      begin
                          tr_h.WVALID =  axi_inf.WVALID;
                          tr_h.WID    =  axi_inf.WID;
                          tr_h.wstrobe[i]  = axi_inf.WSTRB;
                          tr_h.wdata[i]  = axi_inf.WDATA;
                         `uvm_info(get_name(),$sformatf(" WLAST NOT ASSERTED ASSERTED IN MONITOR and ID IS %0d",tr_h.WID),UVM_DEBUG)
                      end
                 if(axi_inf.WLAST)
                      begin
                          wait(axi_inf.BREADY == 1)
                          `uvm_info(get_name(),$sformatf(" WLAST ASSERTED IN MONITOR and ID IS %0d",tr_h.WID),UVM_DEBUG)
                          tr_h.WLAST = 1'b1;
                          `uvm_info(get_type_name(),$sformatf(" ENTER FROM MONITOR TO RSP_TASK"),UVM_MEDIUM);
                           mon2seqr.write(tr_h);
                           i = 0;
                           tr_h = new();
                      end 
             end
           @(posedge axi_inf.mon_cb);
     end
endtask


////////////////////////////////////////////////////////////////////////
//Method name : read-addr_monitor
//Arguments   :  
//Description : this task sample @ when ARVALID AND ARREADY signal hign and sample the READ ADDRESS AND CONTROL SIGNALS
//////////////////////////////////////////////////////////////////////
task read_addr_monitor();
    forever begin
        if(axi_inf.ARVALID &&  axi_inf.ARREADY)begin
             tr_h = new();
             tr_h.ARADDR  =    axi_inf.ARADDR;                      
             tr_h.ARLEN   =    axi_inf.ARLEN;
             tr_h.ARBURST =    axi_inf.ARBURST;
             tr_h.ARID    =    axi_inf.ARID;
             tr_h.RVALID  =    1'b1;
             tr_h.ARVALID =    axi_inf.ARVALID;
             tr_h.ARSIZE  =    2** axi_inf.ARSIZE;
             tr_h.ar_que.push_back(tr_h);
             `uvm_info(get_name(),$sformatf("Inside slave Monitor ARID IS %0d que size is %0d and que stored @ last  is %0d and data stored @ first index %0d",axi_inf.ARID,tr_h.ar_que.size(),tr_h.ar_que[$].ARID,tr_h.ar_que[$-1].ARID),UVM_DEBUG) 
             mon2seqr.write(tr_h);
        end
        @(axi_inf.mon_cb);
    end
endtask
endclass







    








