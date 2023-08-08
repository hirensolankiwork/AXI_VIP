
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////


class slave_sequencer extends uvm_sequencer#(axi_slave_seq_item);
    `uvm_component_utils(slave_sequencer)
     uvm_tlm_analysis_fifo #(axi_slave_seq_item) item_collected;
     bit[7:0] slv_mem[int];
     int len[];
     axi_slave_seq_item  tr_h;
     virtual axi_interface axi_inf;

     ////////////////////////////////////////////////////////////////////////
     //Method name : 
     //Arguments   :  
     //Description : 
     //////////////////////////////////////////////////////////////////////
     function new(string str = "slave_sequencer",uvm_component parent = null);
       super.new(str,parent);
       item_collected = new("item_collected",this);
       if (!uvm_config_db #(virtual axi_interface)::get(this,"","vif",axi_inf))
       `uvm_fatal(get_full_name(), "Not able to get the virtual interface!")
       tr_h = new();
     endfunction

    ////////////////////////////////////////////////////////////////////////
    //Method name : 
    //Arguments   :  
    //Description : 
    /////////////////////////////////////////////////////////////////////
    task slv_mem_write();
      int k;
      `uvm_info(get_name(),$sformatf("IN SQUANCER ANALYSIS FIFO size is %0d ",item_collected.used()),UVM_DEBUG) 
      if(!item_collected.is_empty())
      begin
         //item_collected.get(tr_h);
         len = new[tr_h.AWLEN + 1];
        `uvm_info(get_name(),$sformatf("INSIDE THE  SEQUANCER TASK len  size is  %0d AND AWSIZE IS %0d",len.size,tr_h.AWLEN),UVM_DEBUG) 
           foreach(len[i])
           begin
              k = 0;
             `uvm_info(get_name(),$sformatf("INSIDE THE INCREMENT FULL WORD MEMORY DATA IS %h",tr_h.wdata[i]),UVM_DEBUG) 
              for(int j = 0; j <tr_h.AWSIZE ; j++)
              begin
                `uvm_info(get_name(),$sformatf("INSIDE THE INCREMENT MEMORY DATA IS %h address is %h itteration is of len %0d and byte is %0d ",slv_mem[tr_h.AWADDR],tr_h.AWADDR,i,j),UVM_DEBUG) 
                 tr_h.AWADDR++;
                 k = k + 8;
               end
             end
           end 
    endtask
   
   
  
endclass
