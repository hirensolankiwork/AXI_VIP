

////////////////////////////////////////////////////////////////////////
//devloper name : 
//date   :  
//Description : 
//////////////////////////////////////////////////////////////////////



class axi_slave_base_seq  extends uvm_sequence #(axi_trans);


`uvm_object_utils(axi_slave_base_seq)
//`uvm_declare_p_sequencer(slave_sequencer)
axi_trans tr_h,temp;

slave_sequencer p_sequencer;
uvm_sequencer b_seqr;

int mem [int];

function new(string str = "axi_slave_base_seq");

super.new(str);

endfunction


task body();


  `uvm_info(get_name(),"Inside slave seq body",UVM_DEBUG) 

   if(! $cast(p_sequencer,m_sequencer))
      `uvm_fatal(get_type_name(),"sequencer casting faills")
 
  
  forever begin
    p_sequencer.item_collected.get(tr_h);
   
  

  if(tr_h.AWVALID)begin
       tr_h.AWSIZE = 2** tr_h.AWSIZE;
      tr_h.aw_que.push_front(tr_h);
      

   end


   if(tr_h.ARVALID)begin
           tr_h.ARSIZE = 2** tr_h.ARSIZE;
           `uvm_info(get_name(),$sformatf("Inside slave base sequance ARID  %0d",tr_h.ARID),UVM_DEBUG) 
          tr_h.ar_que.push_back(tr_h);
           `uvm_info(get_name(),$sformatf("@time tr_h.ARVALID is zero"),UVM_DEBUG) 
   end


if(tr_h.WLAST)begin
   int awid;
     if(tr_h.aw_que.size != 0)begin
     temp = tr_h.aw_que.pop_back();
     awid = temp.AWID;
      if(tr_h.WID == awid)begin
        tr_h.BRESP = 2'b00;
        tr_h.BVALID = 1'b1;
        tr_h.BID   = tr_h.WID;
       `uvm_send(tr_h);
      end
    end  
    end  

    if(tr_h.RVALID)begin

      `uvm_info(get_name(),$sformatf("Inside RVALID  %0d",tr_h.ARID),UVM_DEBUG) 
        tr_h.RLAST = 1'b0;
        tr_h.RRESP = 2'b00;
       `uvm_send(tr_h);
     end        
end

endtask

endclass







/*
 if(tr_h.AWVALID)begin
     int temp_size;
     waddr_que.push_front(tr_h.AWADDR);
     len_que.push_front(tr_h.AWLEN);
     temp_size = tr_h.AWSIZE;
     size_que.push_front(2**temp_size);
     `uvm_info(get_type_name(),$sformatf("transaction sucessfully get addr is %p len is %p size is %p ",waddr_que,len_que,size_que),UVM_MEDIUM);
      tr_h.AWREADY = 1'b1;
      `uvm_send(tr_h);

   end


*/






/*
int waddr_que[$];
int raddr_que[$];
int wlen_que[$];
int rlen_que[$];
int wsize_que[$];
int rsize_que[$];
bit [3:0]wawid[$];
bit [3:0]raid[$];
bit [3:0]wid;
int temp_awid;
int temp_arid;

*/
