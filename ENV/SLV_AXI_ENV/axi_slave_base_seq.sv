

 ////////////////////////////////////////////////////////////////////////
 //devloper name : siddharth 
 //date   :        24/07/2023 
 //Description : Slave sequance class this will create sequance for driver
 //////////////////////////////////////////////////////////////////////
 class axi_slave_base_seq  extends uvm_sequence #(axi_slave_seq_item);
`uvm_object_utils(axi_slave_base_seq)
 axi_slave_seq_item temp,rd_addr_h,wr_data_h;
`uvm_declare_p_sequencer(slave_sequencer)
 int slv_mem [int];
 struct {axi_slave_seq_item rd_addr_h,wr_data_h;}s_h;
 axi_slave_seq_item tr_h;
 int count;
 
 ////////////////////////////////////////////////////////////////////////
 //Method name : constructor new
 //Arguments   :  string
 //Description : build the axi_slave_base-seq class
 //////////////////////////////////////////////////////////////////////
 function new(string str = "axi_slave_base_seq");
    super.new(str);
 endfunction

////////////////////////////////////////////////////////////////////////
//Method name : body
//Arguments   :  
//Description : when ever the base test call start method of this class this task body call. this task generate sequance for driver for driving Response signals.
//////////////////////////////////////////////////////////////////////
task body();
   int i;
     forever begin
        p_sequencer.get_port.get(tr_h);
       `uvm_info(get_name(),$sformatf("@ SEQUANCE GET AFTER POINTERS OF WLAST AND ARVALID is %0d and %0d ",tr_h.WLAST,tr_h.ARVALID),UVM_DEBUG) 
        if( tr_h.WLAST)begin
       `uvm_info(get_name(),$sformatf("@ BURST TYPE IS %s and actual burst is %0d AWLEN IS %0d AWSIZE IS %0d and id is %0d ",tr_h.AWBURST_E,tr_h.AWBURST,tr_h.AWLEN,tr_h.AWSIZE,tr_h.AWID),UVM_DEBUG) 
           if(tr_h.AWBURST_E == FIXED)begin
             for(int i =0; i<(tr_h.AWLEN+1) ; i++)begin
              `uvm_info(get_name(),$sformatf(" [FIXED] itteration of i is %0d and awlen is %0d and size is %0d ",i,tr_h.AWLEN,tr_h.AWSIZE),UVM_DEBUG) 
               for(int j=0; j<tr_h.AWSIZE;j++)begin
                 `uvm_info(get_name(),$sformatf("[FIXED] j is %0d count is %0d addr is %0d  ",j,count,tr_h.AWADDR),UVM_DEBUG) 
                 slv_mem[tr_h.AWADDR] = tr_h.wdata[count];
                 tr_h.AWADDR++;
                 count++;
                if(j == (tr_h.AWSIZE-1))begin
                   tr_h.AWADDR = tr_h.AWADDR - tr_h.AWSIZE;
                  `uvm_info(get_name(),$sformatf(" [FIXES]awaddr is %0d ",tr_h.AWADDR),UVM_DEBUG) 
                end
              end  
           end
       end   
           if(tr_h.AWBURST_E == INCREMENT)begin
            for(int i =0; i<(tr_h.AWLEN+1) ; i++)begin
             `uvm_info(get_name(),$sformatf(" [INCR]itteration of i is %0d and awlen is %0d and size is %0d",i,tr_h.AWLEN,tr_h.AWSIZE),UVM_DEBUG) 
              for(int j=0; j<tr_h.AWSIZE;j++)begin
                `uvm_info(get_name(),$sformatf("[INCR] j is %0d count is %0d addr is %0d  ",j,count,tr_h.AWADDR),UVM_DEBUG) 
                slv_mem[tr_h.AWADDR] = tr_h.wdata[count];
                tr_h.AWADDR++;
                count++;
                end     
              end
           end   
          

          
          void'(tr_h.randomize with { BRESP == 0;});
          `uvm_send(tr_h);
        end  
        if( tr_h.ARVALID)
        begin
           tr_h.RDATA = new[tr_h.ARLEN + 1];
           void'(tr_h.randomize with { unique {RDATA}; });
           void'(tr_h.randomize with { RRESP == 0; });
           `uvm_info(get_full_name,$sformatf("rvalid assert in base seqs and randomize value  arvalid is %0d",tr_h.ARVALID),UVM_DEBUG)
           `uvm_send(tr_h);
        end
     end
  `uvm_info(get_full_name()," EXIT SLAVE BASE SEQS FUNCTION NEW ",UVM_DEBUG)

endtask
endclass












