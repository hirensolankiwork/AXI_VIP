/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 13-08-2023 12:38:00
// File Name   	  : axi_mas_sb.sv
// Class Name 	  : axi_mas_sb 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_SB_SV
`define AXI_MAS_SB_SV

//--------------------------------------------------------------------------
// class  : axi_mas_sb 
//--------------------------------------------------------------------------
class axi_mas_sb extends uvm_scoreboard;
//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_sb)

  `uvm_analysis_imp_decl(_mas)
  `uvm_analysis_imp_decl(_slv)

  axi_mas_seq_item mact_q[$];
  axi_mas_seq_item mact_h;
  axi_slave_seq_item sact_q[$];
  axi_slave_seq_item sact_h;

  int pass,fail;

// Add necessary TLM exports to receive transactions from other
// components and instantiat them in build_phase
  uvm_analysis_imp_mas #(axi_mas_seq_item,axi_mas_sb) m_sb_imp; 
  uvm_analysis_imp_slv #(axi_slave_seq_item,axi_mas_sb) s_ap_imp;

//new counstructore declaration.
  function new(string name="axi_mas_sb",uvm_component parent=null);
    super.new(name,parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_sb_imp = new("m_sb_imp",this);
    s_ap_imp = new("slv_ap_imp",this);
  endfunction 

//--------------------------------------------------------------------------
// Function  : write_mas
//--------------------------------------------------------------------------
  function void write_mas(axi_mas_seq_item trans_h);
    trans_h.print();
    mact_q.push_back(trans_h);
  endfunction 
//--------------------------------------------------------------------------
// Function  : write_slv
//--------------------------------------------------------------------------
  function void write_slv(axi_slave_seq_item trans_h);
    trans_h.print();
    sact_q.push_back(trans_h);
  endfunction 

//--------------------------------------------------------------------------
// Task : run phase
//--------------------------------------------------------------------------

  task run_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Run Phase",UVM_DEBUG)
    `uvm_info(get_name(),"Before Forever loop start",UVM_DEBUG)
    forever begin
    `uvm_info(get_name(),"Starting of Forever loop",UVM_DEBUG)
      wait( sact_q.size != 0 && mact_q.size !=0);
      mact_h = mact_q.pop_front();
      sact_h = sact_q.pop_front();
      check_data(mact_h,sact_h);
    end
    `uvm_info(get_name(),"End of Forever loop",UVM_DEBUG)
  endtask
//--------------------------------------------------------------------------
// Task : check_data
//--------------------------------------------------------------------------

  task check_data(axi_mas_seq_item mact_h,axi_slave_seq_item sact_h); 
    `uvm_info("Scoreboard","Start of Check Data",UVM_HIGH);
    if(mact_h.awr_id == sact_h.AWID) begin
      $display("| Master AW_ID : %d | Slave AW_ID : %d ",mact_h.awr_id,sact_h.AWID);
      `uvm_info("SCOREBOARD","Comparision of AW_ID is Successful.",UVM_LOW)
      pass++;
    end
    else begin
      `uvm_error("SCOREBOARD","Comparision of AW_ID is Faild.")
      fail++;
    end
    if(mact_h.wr_len == sact_h.AWLEN) begin
      $display("| Master AW_LEN : %d | Slave AW_LEN : %d ",mact_h.wr_len,sact_h.AWLEN);
      `uvm_info("SCOREBOARD","Comparision of AW_LEN is Successful.",UVM_LOW)
      pass++;
    end
    else begin
      `uvm_error("SCOREBOARD","Comparision of AW_LEN is Faild.")
      fail++;
    end
    if(mact_h.wr_size == sact_h.AWSIZE) begin
      $display("| Master AW_SIZE : %d | Slave AW_SIZE : %d ",mact_h.wr_size,sact_h.AWSIZE);
      `uvm_info("SCOREBOARD","Comparision of AW_SIZE is Successful.",UVM_LOW)
      pass++;
    end
    else begin
      `uvm_error("SCOREBOARD","Comparision of AW_SIZE is Faild.")
      fail++;
    end

    `uvm_info("Scoreboard","End of Check Data",UVM_HIGH)
  endtask 
endclass 

`endif 
