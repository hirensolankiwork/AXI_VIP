class axi_slave_subscriber  extends uvm_subscriber #(axi_slave_seq_item);
 `uvm_component_utils(axi_slave_subscriber)
  
 axi_slave_seq_item  trans_h;

 covergroup axi_slave_unpack_data with function sample( bit[3:0] wstrobe );
   
    WSTROBE : coverpoint wstrobe
    {
       bins wstrb[] = {0};
    }
   
 endgroup   
 covergroup axi_slave_collector;
   
   option.per_instance = 1;
  
 AWLEN  : coverpoint trans_h.AWLEN
   {
        bins b1[] = { [0:15] };
   }
 
 ARLEN  : coverpoint  trans_h.ARLEN
   {
        bins b2[] = {[0:15]};  
   }
 
 AWBURST: coverpoint trans_h.AWBURST
   {
        bins legal[] = { [0:2] };
        illegal_bins illegal = { 3};
   }
 
 ARBURST: coverpoint trans_h.ARBURST
   {
        bins legal[] = { [0:2] };
        illegal_bins illegal = { 3};
 
   }
 AWSIZE : coverpoint trans_h.AWSIZE;
 ARSIZE : coverpoint trans_h.ARSIZE;
 
 AWID   : coverpoint trans_h.AWID 
   {
      bins b1[] = {[0:15]};
   }
 
 ARID   : coverpoint trans_h.ARID
   {
      bins b1[] = {[0:15]};
   }
 
 
 BRRESP  : coverpoint trans_h.BRESP
   {
     bins bresp[] = {[3:0]};
     illegal_bins bresp_illegal[] = {2,3};
     ignore_bins bresp_ignore = {1};
   }
 
 RRESP  : coverpoint trans_h.RRESP
   {
     bins rresp[] = {[3:0]};
     illegal_bins rresp_illegal[] = {2,3};
     ignore_bins  ignore_bin = {1};
   }
 
 
 
 
 AWLENXAWBURST: cross AWLEN,AWBURST
   {
      illegal_bins illegal = binsof(AWLEN) intersect {1,3,7,15} && binsof(AWBURST) intersect { 2}; 
   }
 
 ARLENXARBURST: cross ARLEN,ARBURST
   {
      illegal_bins illegal = binsof(ARLEN) intersect {1,3,7,15} && binsof(ARBURST) intersect { 2}; 
   }
 
 
 endgroup
 function new(string str = "axi_slave_subscriber",uvm_component parent);
    super.new(str,parent);
      axi_slave_collector = new();
      axi_slave_unpack_data = new();
 endfunction
 
 
  function void write(axi_slave_seq_item t);
    trans_h = t;
    if(trans_h.WLAST)begin
        foreach(trans_h.wstrobe[i])
             axi_slave_unpack_data.sample(trans_h.wstrobe[i]);
             `uvm_info(get_full_name(),$sformatf("[@subs]wlast asserted %0d and wstrobe is %p",trans_h.WLAST,trans_h.wstrobe),UVM_DEBUG)
    end         
    axi_slave_collector.sample();
 endfunction
  endclass




