/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 26-07-2023 10:17:02
// File Name   	  : axi_mas_mon.sv
// Class Name 	  : 
// Project Name	  : 
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_MON_SV
`define AXI_MAS_MON_SV

//--------------------------------------------------------------------------
// class  : axi_mas_mon 
//--------------------------------------------------------------------------
class axi_mas_mon extends uvm_sequencer;

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_mon)

//new counstructore declaration.
  function new(string name="axi_mas_mon",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  axi_mas_seq_item trans_h;                       //Taking the tarantection packet to send it to the score board.
  virtual axi_inf m_vif;                          //Tacking interface to convey my packet level info to pin level.
  uvm_analysis_port #(axi_mas_seq_item) mas_ap;   //Taking the analysis port.

//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    mas_ap = new("mas_ap",this);
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_DEBUG)
  endfunction

//--------------------------------------------------------------------------
// Task  : Run Phase  
//--------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_DEBUG)
    `uvm_info(get_full_name(),"Before Forever loop start",UVM_DEBUG)
    forever begin
    `uvm_info(get_full_name(),"Starting of Forever loop",UVM_DEBUG)
      trans_h = axi_mas_seq_item::type_id::create("trans_h");
      monitore(trans_h);
    end
    `uvm_info(get_full_name(),"End of Forever loop",UVM_DEBUG)
  endtask 
//--------------------------------------------------------------------------
// Task  : Moniter 
//--------------------------------------------------------------------------
  task monitore(axi_mas_seq_item trans_h);
    `uvm_info(get_full_name(),"Starting of Monitore",UVM_DEBUG)
    @(posedge m_vif.aclk);
    trans_h.awr_id     = `MON.awid;
    trans_h.wr_addr    = `MON.awaddr;
    trans_h.wr_size    = `MON.awsize;
    trans_h.wr_len     = `MON.awlen;
    trans_h.wr_brust_e = brust_kind_e'(`MON.awbrust);
    trans_h.wr_id      = `MON.wid;
    foreach(trans_h.wr_data[i])
      trans_h.wr_data[i]    = `MON.wdata;
    trans_h.wr_strob   = `MON.wstrob;
    trans_h.b_id       = `MON.bid;
    trans_h.b_resp_e   = resp_kind_e'(`MON.bresp);
    trans_h.ard_id     = `MON.arid;
    trans_h.rd_addr    = `MON.araddr;
    trans_h.rd_size    = `MON.arsize;
    trans_h.rd_len     = `MON.arlen;
    trans_h.rd_brust_e = brust_kind_e'(`MON.arbrust);
    trans_h.r_id       = `MON.rid;
    trans_h.rd_data.push_back(`MON.rdata);
    trans_h.r_resp_e   = resp_kind_e'(`MON.rresp);
    mas_ap.write(trans_h);
  endtask 

endclass  : axi_mas_mon 

`endif 
