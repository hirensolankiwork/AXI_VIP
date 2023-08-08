
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////


class axi_slave_monitor extends uvm_monitor;

`uvm_component_utils(axi_slave_monitor);
uvm_analysis_port #(axi_slave_seq_item) mon2sb;
uvm_analysis_port #(axi_slave_seq_item) mon2seqr;
axi_slave_seq_item wr_addr_h,rd_addr_h,wr_data_h,wr_addr_que[$];
int wr_addr[$];
slave_sequencer  seqr_h;
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
  
 `uvm_info(get_full_name()," ENTER INSIDE THE BUILD PHASE ",UVM_DEBUG)
  super.build_phase(phase);
 `uvm_info(get_type_name(), " ENTERING THE Slave monitor Build Phase", UVM_DEBUG)
  mon2sb = new("mon2sb",this);
  mon2seqr = new("mon2seqr",this);
  seqr_h = new();
  wr_data_h = new();
  if (!uvm_config_db #(virtual axi_interface)::get(this,"","vif",axi_inf))
	`uvm_fatal(get_full_name(), "Not able to get the virtual interface!")
  `uvm_info(get_full_name()," EXIT INSIDE THE BUILD PHASE ",UVM_DEBUG)

endfunction


////////////////////////////////////////////////////////////////////////
//Method name : run_phase
//Arguments   :  phase
//Description :  this task will sample the interface and acording protocall it will send the scoreboard and sbscriber
//////////////////////////////////////////////////////////////////////
task  run_phase(uvm_phase phase);
 
 `uvm_info(get_full_name()," ENTER INSIDE THE RUN PHASE ",UVM_DEBUG)
  super.run_phase(phase); 
 `uvm_info(get_type_name(), " monitor Run Phase", UVM_DEBUG);
  forever begin 
  monitor();
  end
 `uvm_info(get_full_name()," EXIT INSIDE THE RUN PHASE ",UVM_DEBUG)

endtask


////////////////////////////////////////////////////////////////////////
//Method name : monitor
//Arguments   :  
//Description : this task parallaly monitor write read address and data channel
//////////////////////////////////////////////////////////////////////
task monitor();

`uvm_info(get_full_name()," ENTER INSIDE THE monitor TASK ",UVM_DEBUG)
 fork
   write_addr_monitor();
   write_data_monitor();
   read_addr_monitor();
 join
`uvm_info(get_full_name()," EXIT INSIDE THE monitor TASK ",UVM_DEBUG)

endtask

////////////////////////////////////////////////////////////////////////
//Method name : write-addr-monitor
//Arguments   :  
//Description : this task will sample when AWVALID AND AWREADY high the write address data and control signals and store into que
//////////////////////////////////////////////////////////////////////
task write_addr_monitor();

`uvm_info(get_full_name()," ENTER INSIDE THE write_addr_monitor TASK ",UVM_DEBUG)
    forever begin
      @(posedge axi_inf.mon_cb);
      if(axi_inf.AWVALID && axi_inf.AWREADY)begin
         wr_addr_h = new();
         wr_addr_h.AWADDR  =  axi_inf.AWADDR;
         wr_addr_h.AWLEN   =  axi_inf.AWLEN;
         wr_addr_h.AWBURST =  axi_inf.AWBURST;
         wr_addr_h.AWID    =  axi_inf.AWID;
         wr_addr_h.AWVALID =  axi_inf.AWVALID;
         wr_addr_h.AWSIZE  =   2** axi_inf.AWSIZE;
         wr_addr_que.push_front(wr_addr_h);
      end
    end
`uvm_info(get_full_name()," EXIT INSIDE THE write_addr_monitor TASK ",UVM_DEBUG)

endtask

////////////////////////////////////////////////////////////////////////
//Method name : write_data_monitor
//Arguments   :  
//Description : this task monitor the write data channel and sample @ when WVALID AND WREADY signal high and sample the write data,id,wlast,etc..
//////////////////////////////////////////////////////////////////////
task write_data_monitor();

//`uvm_info(get_full_name()," ENTER INSIDE THE write_data_monitor TASK ",UVM_DEBUG)
 int i;
 forever begin
    if(axi_inf.WVALID && axi_inf.WREADY)begin
      `uvm_info(get_name()," WVALID AND WREADY  ASSERTED ASSERTED IN MONITOR ",UVM_DEBUG)
       if(wr_addr_que.size() > 0)begin
            wr_addr = wr_addr_que.find_index with (item.AWID == axi_inf.WID);  
           //`uvm_info(get_full_name(),$sformatf(" wr_addr AWID is %0d and handle id is %0d then AWLEN is %0d",wr_addr[0].AWID,wr_addr[0],wr_addr[0].AWLEN),UVM_DEBUG)
            wr_addr_h = wr_addr_que[wr_addr[0]];
            wr_addr_que.delete(wr_addr[0]);
            wr_addr.delete();
          // `uvm_info(get_full_name(),$sformatf(" wr_addr AWID is %0d and handle id is %0d then AWLEN is %0d",wr_addr_h.AWID,wr_addr_h,wr_addr_h.AWLEN),UVM_DEBUG)
            wr_data_h.wdata = new[wr_addr_h.AWLEN + 1];
            wr_data_h.WID   = axi_inf.WID;
            wr_data_h.WVALID =  axi_inf.WVALID;
            foreach(wr_data_h.wdata[i])begin
                 wr_data_h.wstrobe[i]  = axi_inf.WSTRB;
                 wr_data_h.wdata[i]  = axi_inf.WDATA;
                 wr_data_h.WLAST = axi_inf.WLAST;
                 if(axi_inf.WLAST)begin
                    `uvm_info(get_full_name(),$sformatf("WLAST ASSERTED and awvalid"),UVM_DEBUG)
                     mon2seqr.write(wr_data_h);
                     wr_data_h = new();
                 end 
             @(posedge axi_inf.mon_cb);
             wait( axi_inf.WVALID && axi_inf.WREADY);
             `uvm_info(get_full_name(),$sformatf("WLAST  NOT ASSERTED"),UVM_DEBUG)
            end   
       end
    end
    @(posedge axi_inf.mon_cb);
 end
 `uvm_info(get_full_name()," EXIT INSIDE THE write_data_monitor TASK ",UVM_DEBUG)

endtask

////////////////////////////////////////////////////////////////////////
//Method name : read-addr_monitor
//Arguments   :  
//Description : this task sample @ when ARVALID AND ARREADY signal hign and sample the READ ADDRESS AND CONTROL SIGNALS
//////////////////////////////////////////////////////////////////////
task read_addr_monitor();

`uvm_info(get_full_name()," ENTER INSIDE THE read_addr_monitor TASK ",UVM_DEBUG)
    forever @(axi_inf.mon_cb) begin
       if(axi_inf.ARVALID &&  axi_inf.ARREADY )begin
         rd_addr_h = new();
         rd_addr_h.ARADDR  =    axi_inf.ARADDR;                      
         rd_addr_h.ARLEN   =    axi_inf.ARLEN;
         rd_addr_h.ARBURST =    axi_inf.ARBURST;
         rd_addr_h.ARID    =    axi_inf.ARID;
         rd_addr_h.ARVALID =    axi_inf.ARVALID;
         rd_addr_h.ARSIZE  =    2** axi_inf.ARSIZE;
         `uvm_info(get_name(),$sformatf("inside monitor arid=%0d,arlen=%0d,arsize=%0d arvalid is %0d",rd_addr_h.ARID,rd_addr_h.ARLEN,rd_addr_h.ARSIZE,rd_addr_h.ARVALID),UVM_DEBUG)
         mon2seqr.write(rd_addr_h);
       end
   end

`uvm_info(get_full_name()," EXIT INSIDE THE read_addr_monitor TASK ",UVM_DEBUG)

endtask
endclass







    








