

////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :        24/07/2023 
//Description : Slave sequance class this will create sequance for driver
//////////////////////////////////////////////////////////////////////
class axi_slave_base_seq  extends uvm_sequence #(axi_slave_seq_item);
`uvm_object_utils(axi_slave_base_seq)
axi_slave_seq_item temp,rd_addr_h,wr_data_h;
`uvm_declare_p_sequencer(slave_sequencer)
int mem [int];
 struct {axi_slave_seq_item rd_addr_h,wr_data_h;}s_h;
axi_slave_seq_item tr_h;
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
       `uvm_info(get_name(),$sformatf("@ SEQUANCE GET AFTER POINTERS OF WLAST AND ARVALID is %0d and %0d",tr_h.WLAST,tr_h.ARVALID),UVM_DEBUG) 
        if( tr_h.WLAST)
        begin
          `uvm_info(get_name(),$sformatf(" IN SEQUS WLAST ASSERT" ),UVM_DEBUG) 
           tr_h.randomize with { BRESP == 0;};
          `uvm_send(tr_h);
        end  
        if( tr_h.ARVALID)
        begin
           tr_h.RDATA = new[tr_h.ARLEN + 1];
           tr_h.randomize with { unique {RDATA}; };
           tr_h.randomize with { RRESP == 0; };
           `uvm_info(get_full_name,$sformatf("rvalid assert in base seqs and randomize value  arvalid is %0d",tr_h.ARVALID),UVM_DEBUG)
           `uvm_send(tr_h);
        end
     end
  `uvm_info(get_full_name()," EXIT SLAVE BASE SEQS FUNCTION NEW ",UVM_DEBUG)

endtask
endclass












