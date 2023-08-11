/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 31-07-2023
// Last Modifiey  : 10-08-2023 16:03:51
// File Name   	  : axi_mas_reset_seq.sv
// Class Name 	  : axi_mas_reset_seq 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_RESET_SEQ_SV
`define AXI_RESET_SEQ_SV

class axi_mas_reset_seq extends axi_mas_base_seqs;
//UVM Fectory registretion.
//uvm_sequence is object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils(axi_mas_reset_seq)

//new counstructore declaration.
  function new(string name="AXI_MAS_RESET_SEQS");
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
    fork
    /*begin //Reset Process 
        m_vif.reset(3);
      end*/
      begin //Simple Sequence item randomize process.
        repeat(count) begin
          start_item(req);              //wait the request grant from the sequencer.
          assert(req.randomize());      //Randomize the sequence item.
          finish_item(req);             //Send the randomize sequence item and wait for
        end                             // item_done call.
     end
    join
    `uvm_info(get_name(),"End of body task .",UVM_HIGH);
  endtask : body

  task post_body ();
    super.post_body();
  endtask

endclass  : axi_mas_reset_seq

`endif 
