

////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :        24/07/2023 
//Description : Slave sequance class this will create sequance for driver
//////////////////////////////////////////////////////////////////////



class axi_slave_base_seq  extends uvm_sequence #(axi_slave_seq_item);
`uvm_object_utils(axi_slave_base_seq)
axi_slave_seq_item tr_h,temp;
`uvm_declare_p_sequencer(slave_sequencer)
int mem [int];

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
        p_sequencer.item_collected.get(tr_h);
       `uvm_info(get_name(),$sformatf("FIFO EMPTY %0d ",p_sequencer.item_collected.is_empty),UVM_DEBUG) 
        if(tr_h.WLAST)
        begin
          `uvm_info(get_name(),$sformatf(" IN SEQUS WLAST ASSERT" ),UVM_DEBUG) 
          `uvm_send(tr_h);
           tr_h.WLAST = 1'b0;
        end  
        if(tr_h.RVALID)
        begin
           tr_h.RDATA = new[tr_h.ARLEN + 1];
           tr_h.randomize with { unique {RDATA}; };
          `uvm_info(get_full_name,$sformatf("rvalid assert in base seqs and randomize value is %p",tr_h.RDATA),UVM_DEBUG)
           tr_h.RVALID = 1'b0;
          `uvm_send(tr_h);
        end
     end
  `uvm_info(get_full_name()," EXIT SLAVE BASE SEQS FUNCTION NEW ",UVM_DEBUG)

endtask
endclass












