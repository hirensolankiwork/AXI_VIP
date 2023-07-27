
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
tr_h =  new();
`uvm_info(get_type_name(), " monitor Run Phase", UVM_DEBUG);

forever begin 
monitor();
end
endtask

task monitor();

fork
write_addr_monitor();
write_data_monitor();
write_rsp_monitor();
read_addr_monitor();
read_data_monitor();
join

endtask

task write_addr_monitor();

forever begin
@(posedge axi_inf.mon_cb);
if(axi_inf.AWVALID && axi_inf.AWREADY)begin
tr_h.AWADDR  = $urandom_range(1,10);   // //axi_inf.AWADDR;
tr_h.AWLEN   =  axi_inf.AWLEN;
tr_h.AWSIZE  =  axi_inf.AWSIZE;
tr_h.AWBURST =  axi_inf.AWBURST;
tr_h.AWID    =  axi_inf.AWID;
tr_h.AWVALID = axi_inf.AWVALID;
mon2seqr.write(tr_h);

end
end

endtask



task write_data_monitor();
forever begin
    @(posedge axi_inf.mon_cb);
    if(axi_inf.WVALID && axi_inf.WREADY)begin
    tr_h.WVALID =  axi_inf.WVALID;
    tr_h.WID    =  axi_inf.WID;
    tr_h.WSTRB  = axi_inf.WSTRB;
    tr_h.WLAST  = axi_inf.WLAST;
    tr_h.AWVALID = axi_inf.AWVALID;
    mon2seqr.write(tr_h);

end
end
endtask


task write_rsp_monitor();
forever begin
    @(posedge axi_inf.mon_cb);
    wait(axi_inf.WLAST == 1'b1)begin
  `uvm_info(get_name(),"Inside slave MObitor BVALID",UVM_DEBUG) 
    mon2seqr.write(tr_h);


end
end
endtask


task read_addr_monitor();

forever begin
    @(posedge axi_inf.mon_cb);
    if(axi_inf.ARVALID && axi_inf.ARREADY)begin
   tr_h.ARADDR  =  axi_inf.ARADDR;                      
   tr_h.ARLEN   =  axi_inf.ARLEN;
   tr_h.ARSIZE  =  axi_inf.ARSIZE;
   tr_h.ARBURST = axi_inf.ARBURST;
   tr_h.ARID    =  axi_inf.ARID;
   tr_h.ARVALID = axi_inf.ARVALID;
   mon2seqr.write(tr_h);

end
end
endtask


task read_data_monitor();
forever begin
    @(axi_inf.mon_cb);
    if(axi_inf.ARREADY && axi_inf.ARVALID)begin
    @(axi_inf.mon_cb);
    tr_h.RVALID = 1'b1;
    mon2seqr.write(tr_h);
    end
end
endtask

endclass







    













