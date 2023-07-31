

////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :        24/07/2023 
//Description : Slave sequance class this will create sequance for driver
//////////////////////////////////////////////////////////////////////



class axi_slave_base_seq  extends uvm_sequence #(axi_trans);

`uvm_object_utils(axi_slave_base_seq)
axi_trans tr_h,temp;
slave_sequencer p_sequencer;
uvm_sequencer b_seqr;
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
     if(! $cast(p_sequencer,m_sequencer))
           `uvm_fatal(get_type_name(),"sequencer casting faills")
     
     forever begin
            p_sequencer.item_collected.get(tr_h);
                
            if(tr_h.WLAST)begin
                 int awid;
                 if(tr_h.aw_que.size != 0)begin
                      temp = tr_h.aw_que.pop_back();
                      awid = temp.AWID;
                      if(tr_h.WID == awid)begin
                          tr_h.BRESP = 2'b00;
                          tr_h.BVALID = 1'b1;
                          tr_h.BID   = tr_h.WID;
                          `uvm_info(get_name(),$sformatf("INSIDE THE SLAVE SEQUANCE THE BID AND WID IS  %0d %0d",tr_h.BID,tr_h.WID),UVM_DEBUG) 
                          tr_h.WLAST = 1'b1;
                          `uvm_send(tr_h);
                     end
                 end  
           end  
           if(tr_h.RVALID)begin
               `uvm_info(get_name(),$sformatf("Inside RVALID  %0d",tr_h.ARID),UVM_DEBUG) 
                if(tr_h.ar_que.size !=0)begin   
                      tr_h.RLAST = 1'b0;
                      tr_h.RRESP = 2'b00;
                      tr_h.rvalid = 1'b1;
                      tr_h.RVALID = 1'b0;
                     `uvm_send(tr_h);
               end
          end        
end

endtask

endclass












