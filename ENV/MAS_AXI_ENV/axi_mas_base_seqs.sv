/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 10-08-2023 16:01:59
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
 
  int count=50;
   
//------------------------------------------------------------------------
//Task : pre_body 
//       This task is by default called by the start methode in test compo
//      -nent the sequence you want to send can be done inside this task.
//      before Body task .
//------------------------------------------------------------------------
  task pre_body();
    `uvm_info(get_name(),"Start of body task .",UVM_HIGH);
    use_response_handler(1);
    `uvm_info(get_name(),"Start of body task .",UVM_HIGH);
  endtask 

//------------------------------------------------------------------------
//Task : body 
//       This task is by default called by the start methode in test compo
//      -nent the sequence you want to send can be done inside this task.
//------------------------------------------------------------------------
  virtual task body();
    `uvm_info(get_name(),"Start of body task .",UVM_HIGH);
    req = axi_mas_seq_item::type_id::create("req"); //Create the sequence item.
    repeat(count) begin
      start_item(req);      //wait the request grant from the sequencer.
      assert(req.randomize());      //Randomize the sequence item.
      finish_item(req);     //Send the randomize sequence item and wait for
    end                     // item_done call.
    `uvm_info(get_name(),"End of body task .",UVM_HIGH);
  endtask
  
  task post_body ();
    `uvm_info(get_name(),"Start of body task .",UVM_HIGH);
    wait(count == 0);
  endtask
  
  function void response_handler (uvm_sequence_item response);
    count--;
    `uvm_info(get_type_name(),$sformatf("count : %0d Response : %p",count,response),UVM_HIGH)
  endfunction

endclass  : axi_mas_base_seqs 


`endif 
