/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 31-08-2023
// Last Modifiey  : Fri Sep 15 12:21:16 2023
// File Name   	  : axi_interleave_seq.sv
// Class Name 	  : axi_interleave_seq 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_INTERLEAVE_SEQ_SV
`define AXI_INTERLEAVE_SEQ_SV

//-------------------------------------------------------------------------
//class: axi_interleave_seq
//-------------------------------------------------------------------------

class axi_interleave_seq extends axi_mas_base_seqs;  
//UVM Fectory registretion.
//uvm_sequence is object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils(axi_interleave_seq)

//new counstructore declaration.
  function new(string name="axi_interleave_seq");
    super.new(name);
  endfunction 

  task pre_body ();
    super.pre_body();
  endtask

//------------------------------------------------------------------------
//Task : body 
//       This task is by default called by the start methode in test compo
//      -nent the sequence you want to send can be done inside this task.
//------------------------------------------------------------------------
  task body();
    `uvm_info(get_name(),"Start of body task .",UVM_HIGH);
    req = axi_mas_seq_item::type_id::create("req"); //Create the sequence item.
    begin //Simple Sequence item randomize process.
      repeat(count) begin
        start_item(req);              //wait the request grant from the sequencer.
        assert(req.randomize());      //Randomize the sequence item.
        finish_item(req);             //Send the randomize sequence item and wait for
      end                             // item_done call.
    end
    `uvm_info(get_name(),"End of body task .",UVM_HIGH);
  endtask : body

  //task post_body ();
  //  wait(count == (-20));
  //endtask

endclass  : axi_interleave_seq 

`endif 
