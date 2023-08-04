/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 01-08-2023 14:04:34
// File Name   	  : axi_mas_base_seqs.sv
// Class Name 	  : axi_mas_base_seqs 
// Project Name	  : AXI_3 VIP
// Description	  : This is the base sequence class  which is responsible 
// for genrating the sequence item fore the sequener to route to the 
// driver.
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_BASE_SEQS_SV
`define AXI_MAS_BASE_SEQS_SV

//------------------------------------------------------------------------
// class  : axi_mas_base_seqs 
//------------------------------------------------------------------------
class axi_mas_base_seqs extends uvm_sequence #(axi_mas_seq_item);

//UVM Fectory registretion.
//uvm_sequence is object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils(axi_mas_base_seqs)

//new counstructore declaration.
  function new(string name="axi_mas_base_seqs");
    super.new(name);
  endfunction
 
//virtual axi_inf m_vif;
   
//------------------------------------------------------------------------
//Task : pre_body 
//       This task is by default called by the start methode in test compo
//      -nent the sequence you want to send can be done inside this task.
//      before Body task .
//------------------------------------------------------------------------
  task pre_body();
  //if(!(uvm_config_db #(virtual axi_inf)::get(null,"*","m_vif",m_vif)))
  //  `uvm_fatal(get_name(),"[INTERFACE] Connection faild !!!")
  endtask 

//------------------------------------------------------------------------
//Task : body 
//       This task is by default called by the start methode in test compo
//      -nent the sequence you want to send can be done inside this task.
//------------------------------------------------------------------------
  virtual task body();
  
    req = axi_mas_seq_item::type_id::create("req"); //Create the sequence item.
    repeat(100 ) begin
      start_item(req);      //wait the request grant from the sequencer.
      assert(req.randomize());      //Randomize the sequence item.
      finish_item(req);     //Send the randomize sequence item and wait for
    end                     // item_done call.
  endtask
/*
  task reset(int i);
    repeat(i)begin
      repeat($urandom_range(5,15))@(negedge m_vif.aclk);
        m_vif.arstn <= 1'b0;
      @(posedge m_vif.aclk)
      m_vif.arstn <= 1'b1;
    end
  endtask : reset 
*/
endclass  : axi_mas_base_seqs 


`endif 
