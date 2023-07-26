

////////////////////////////////////////////////////////////////////////
//devloper name : 
//date   :  
//Description : 
//////////////////////////////////////////////////////////////////////



class axi_slave_base_seq  extends uvm_sequence #(axi_trans);


`uvm_object_utils(axi_slave_base_seq)
//`uvm_declare_p_sequencer(slave_sequencer)
axi_trans tr_h;

slave_sequencer p_sequencer;
uvm_sequencer b_seqr;
int mem [int];
int waddr_que[$];
int raddr_que[$];
int len_que[$];
int size_que[$];
bit [3:0]awid[$];
bit [3:0]wid;

int rd_addr;
//b_seqr = 

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
     int temp_size;
     waddr_que.push_front(tr_h.AWADDR);
     len_que.push_front(tr_h.AWLEN);
     temp_size = tr_h.AWSIZE;
     size_que.push_front(2**temp_size);
     awid.push_front(tr_h.AWID);
    `uvm_info(get_type_name(),$sformatf("transaction sucessfully get addr is %p len is %p size is %p ",waddr_que,len_que,size_que),UVM_MEDIUM);
     //`uvm_send(tr_h);
   end

   if(tr_h.WVALID)begin
     
      rd_addr = waddr_que.pop_back();
     `uvm_info(get_type_name(),$sformatf(" Address que %d",rd_addr),UVM_MEDIUM);
      mem[rd_addr] = tr_h.WDATA ;
      `uvm_info(get_type_name(),$sformatf(" memory data is %d",mem[rd_addr]),UVM_MEDIUM);
      //`uvm_send(tr_h);
     end
  
   if(tr_h.WLAST)begin
      int temp_awid;
      temp_awid = awid.pop_back();
      if(tr_h.WID == temp_awid)begin
        tr_h.BRESP = 2'b00;
       //TODO:
        //tr_h.BVALID = 1'b1;
        `uvm_send(tr_h);
      end
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








