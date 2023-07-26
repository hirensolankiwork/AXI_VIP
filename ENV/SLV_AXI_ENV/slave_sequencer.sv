
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////


class slave_sequencer extends uvm_sequencer#(axi_trans);

`uvm_component_utils(slave_sequencer)
uvm_tlm_analysis_fifo #(axi_trans) item_collected;





function new(string str = "slave_sequencer",uvm_component parent = null);

super.new(str,parent);

item_collected = new("item_collected",this);

endfunction

endclass
