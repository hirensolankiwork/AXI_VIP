
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////

typedef bit[`WR_DATA_WIDTH-1:0] dyn[$];
class axi_slave_monitor extends uvm_monitor;
dyn data[int];
`uvm_component_utils(axi_slave_monitor);
uvm_analysis_port #(axi_slave_seq_item) mon2sub;
uvm_analysis_port #(axi_slave_seq_item) mon2sb;
axi_slave_seq_item wr_addr_h,rd_addr_h,wr_data_h,wr_addr_que[$],rd_addr_que[$],wr_data_que[$];
int wr_addr[$];
uvm_blocking_get_imp #(axi_slave_seq_item,axi_slave_monitor) get_imp; 
virtual axi_interface axi_inf;
 int wrcount,count; 
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
  mon2sub = new("mon2sub",this);
  wr_data_h = new();
  wr_addr_h = new();
  get_imp = new("get_imp",this);
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
 forever begin
   fork
      write_addr_monitor();
      write_data_monitor();
      read_addr_monitor();
      @(negedge axi_inf.rst);
   join_any
   disable fork;
   reset();
`uvm_info(get_full_name()," EXIT INSIDE THE monitor TASK ",UVM_DEBUG)
end
endtask

////////////////////////////////////////////////////////////////////////
//Method name : write-addr-monitor
//Arguments   :  
//Description : this task will sample when AWVALID AND AWREADY high the write address data and control signals and store into que
//////////////////////////////////////////////////////////////////////
task write_addr_monitor();

`uvm_info(get_name()," ENTER INSIDE THE write_addr_monitor TASK ",UVM_DEBUG)
    forever @(axi_inf.mon_cb) begin
      if(axi_inf.mon_cb.AWVALID && axi_inf.mon_cb.AWREADY)begin
          wr_addr_h = new();
         wr_addr_h.AWADDR  =  axi_inf.mon_cb.AWADDR;
         wr_addr_h.AWLEN   =  axi_inf.mon_cb.AWLEN;
         wr_addr_h.AWBURST =  axi_inf.mon_cb.AWBURST;
         wr_addr_h.AWBURST_E = aw_burst_kind'(axi_inf.mon_cb.AWBURST); 
         wr_addr_h.AWID    =  axi_inf.mon_cb.AWID;
         wr_addr_h.AWVALID =  axi_inf.mon_cb.AWVALID;
         wr_addr_h.AWSIZE  =   2** axi_inf.mon_cb.AWSIZE;
         wr_addr_que.push_back(wr_addr_h);
        `uvm_info(get_name(), $sformatf("size of write address que is %0d and awid is %0d ",wr_addr_que.size(),wr_addr_h.AWID),UVM_DEBUG)
         mon2sub.write(wr_addr_h);
         wrcount++;
         
      end
    end
`uvm_info(get_name()," EXIT INSIDE THE write_addr_monitor TASK ",UVM_DEBUG)

endtask

////////////////////////////////////////////////////////////////////////
//Method name : write_data_monitor
//Arguments   :  
//Description : this task monitor the write data channel and sample @ when WVALID AND WREADY signal high and sample the write data,id,wlast,etc..
//////////////////////////////////////////////////////////////////////
task write_data_monitor();

//`uvm_info(get_full_name()," ENTER INSIDE THE write_data_monitor TASK ",UVM_DEBUG)
 int i;
 forever@(axi_inf.mon_cb) begin
    if(axi_inf.mon_cb.WVALID && axi_inf.mon_cb.WREADY && wr_addr_que.size !=0)begin
       `uvm_info(get_name(),$sformatf("[inside task ]WVALID && WREADY WLAST !=0 and size of wr_addr_que size  is %0d and wr_count is %0d wid is %0d wlen is %0d,count is %0d ",wr_addr_que.size(),wrcount, axi_inf.mon_cb.WID,wr_data_h.AWLEN,count),UVM_DEBUG)
        wr_addr = wr_addr_que.find_index with (item.AWID == axi_inf.mon_cb.WID);  
        wr_data_h = wr_addr_que[wr_addr[0]];
        wr_addr.delete();
        wr_data_h.WVALID =  axi_inf.mon_cb.WVALID;
        wr_data_h.WLAST = axi_inf.mon_cb.WLAST;
        wr_data_h.BRESP = axi_inf.mon_cb.BRESP;
        wr_data_h.WID   = axi_inf.mon_cb.WID;
        data[wr_data_h.WID].push_front(axi_inf.mon_cb.WDATA);
       `uvm_info(get_name(),$sformatf("WVALID && WREADY awlen  is %0d and i is %0d and inf_wid is %0d and awid is %0d and address is %0d size of wraddr_que is %0d count is %0d",wr_data_h.AWLEN,i,axi_inf.mon_cb.WID,wr_data_h.AWID,wr_data_h,wr_addr_que.size(),count),UVM_DEBUG)
        if(axi_inf.mon_cb.WLAST)begin
           wr_data_h.wdata = new[wr_data_h.AWLEN+1];
           wr_data_h.wdata = data[wr_data_h.WID];
           wr_addr = wr_addr_que.find_index with (item.AWID == axi_inf.mon_cb.WID);
           wr_addr_que.delete(wr_addr[0]);
           wr_addr.delete();
           data[axi_inf.mon_cb.WID].delete();
           `uvm_info(get_full_name(),$sformatf("[@monitor]wlast asserted %0d and wstrobe is %p and wid is %0d and size of wr_data que is %0d",wr_data_h.WLAST,wr_data_h.wstrobe,wr_data_h.WID,wr_data_que.size()),UVM_DEBUG)
           mon2sub.write(wr_data_h);
           wr_data_que.push_front(wr_data_h);

        end
   end
end      
      
 `uvm_info(get_name()," EXIT INSIDE THE write_data_monitor TASK ",UVM_DEBUG)

endtask

////////////////////////////////////////////////////////////////////////
//Method name : read-addr_monitor
//Arguments   :  
//Description : this task sample @ when ARVALID AND ARREADY signal hign and sample the READ ADDRESS AND CONTROL SIGNALS
//////////////////////////////////////////////////////////////////////
 task read_addr_monitor();

 `uvm_info(get_name()," ENTER INSIDE THE read_addr_monitor TASK ",UVM_DEBUG)
    forever @(axi_inf.mon_cb) begin
       if(axi_inf.mon_cb.ARVALID &&  axi_inf.mon_cb.ARREADY )begin
         rd_addr_h = new();
         rd_addr_h.ARADDR  =    axi_inf.mon_cb.ARADDR;                      
         rd_addr_h.ARLEN   =    axi_inf.mon_cb.ARLEN;
         rd_addr_h.ARBURST =    axi_inf.mon_cb.ARBURST;
         rd_addr_h.ARID    =    axi_inf.mon_cb.ARID;
         rd_addr_h.ARVALID =    axi_inf.mon_cb.ARVALID;
         rd_addr_h.ARSIZE  =    2** axi_inf.mon_cb.ARSIZE;
         rd_addr_h.RRESP   = axi_inf.mon_cb.RRESP;
         rd_addr_que.push_front(rd_addr_h);
         mon2sub.write(rd_addr_h);
         //`uvm_info(get_name(),$sformatf(" ARVALID && ARREADYinside monitor arid=%0d,arlen=%0d,arsize=%0d arvalid is %0d",rd_addr_h.ARID,rd_addr_h.ARLEN,rd_addr_h.ARSIZE,rd_addr_h.ARVALID),UVM_DEBUG)
       end
    end
`uvm_info(get_name()," EXIT INSIDE THE read_addr_monitor TASK ",UVM_DEBUG)
 endtask

 task get(output axi_slave_seq_item temp_h);
 wait (rd_addr_que.size >0 | wr_data_que.size() >0)
    if(rd_addr_que.size() >0)begin
     // `uvm_info(get_name(), $sformatf("[INSIDE GET]before pop rd_addr_que size is %0d",rd_addr_que.size()),UVM_DEBUG)
       temp_h = rd_addr_que.pop_back(); 
     // `uvm_info(get_full_name(), $sformatf("[INSIDE GET]after pop rd_addr_que size is %0d and arvalid is %0d",rd_addr_que.size(),temp_h.ARVALID),UVM_DEBUG)
    end   
    else if(wr_data_que.size() >0)begin
     // `uvm_info(get_name(),$sformatf(" [INSIDE GET]wr_data_que size is %0d ",wr_data_que.size()),UVM_DEBUG)
       temp_h = wr_data_que.pop_back();
      //`uvm_info(get_name(),$sformatf(" [INSIDE GET]wr_data_que size is %0d and WLAST is %0d ",wr_data_que.size(),wr_data_h.WLAST),UVM_DEBUG)
    end
 endtask
 
 task reset();
   // `uvm_info(get_name(),$sformatf("BEFORE in monitor reset asserted and rd_addr_que size %0d wr_data_que size %0d and size of wr_addr_que %0d ",rd_addr_que.size(),wr_data_que.size(),wr_addr.size()),UVM_DEBUG)
    rd_addr_que.delete();
    wr_data_que.delete();
    wr_addr_que.delete();
   // `uvm_info(get_name(),$sformatf("AFTER in monitor reset asserted and rd_addr_que size %0d wr_data_que size %0d and size of wr_addr_que %0d ",rd_addr_que.size(),wr_data_que.size(),wr_addr.size()),UVM_DEBUG)
    @(posedge axi_inf.rst);
 endtask
 
 task Extract();
 endtask 

 endclass 







    








