/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 07-08-2023
// Last Modifiey  : 08-08-2023 10:05:10
// File Name   	  : axi_mas_collector.sv
// Class Name 	  : axi_mas_collector
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_COLLECTOR_SV
`define AXI_MAS_COLLECTOR_SV


covergroup axi_mas_data_cg with function sample(bit val);

  option.per_instance = 1;

  BIT_TOGGLE_CP : coverpoint val
    {
      bins txn_cb_01 = (0=>1);
      bins txn_cb_10 = (1=>0);
    }
endgroup


class axi_mas_collector extends uvm_subscriber #(axi_mas_seq_item);
//UVM Fectory registretion.
//uvm_subscriber is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_collector)

  axi_mas_seq_item   m_tx_h;
  axi_mas_data_cg    wr_data_cg[];
  axi_mas_data_cg    rd_data_cg[];

  covergroup axi_mas_cg (string name="axi_mas_cg");
    option.comment=$sformatf("This is the Master Coverage collector : [%s]",name);
    option.per_instance = 1;
    ADDR_WRITE_CP : coverpoint m_tx_h.wr_addr
      {
        bins low_wr_addr_cb = {[0:99]};
        bins mid_wr_addr_cb = {[100:199]};
        bins max_wr_addr_cb = {[200:$]};
      }

    ADDR_READ_CP  : coverpoint m_tx_h.rd_addr
      {
        bins low_rd_addr_cb = {[0:99]};
        bins mid_rd_addr_cb = {[100:199]};
        bins max_rd_addr_cb = {[200:$]};
      }
    AWID_CP : coverpoint m_tx_h.awr_id
      {
        bins awid_cb[10] = {[0:$]};
      }

    WID_CP  : coverpoint m_tx_h.wr_id
      {
        bins wid_cb[10] = {[0:$]};
      }

    BID_CP  : coverpoint m_tx_h.b_id
      {
        bins bid_cb[10] = {[0:$]};
      }
 
    ARID_CP  : coverpoint m_tx_h.ard_id
      {
        bins bid_cb[10] = {[0:$]};
      }
   
    RID_CP  : coverpoint m_tx_h.r_id
      {
        bins bid_cb[10] = {[0:$]};
      }
    
    AWSIZE_CP : coverpoint m_tx_h.wr_size
      {
        bins awsize_cb[3]   = {[0:$]};
      }
    ARSIZE_CP : coverpoint m_tx_h.rd_size
      {
        bins arsize_cb[3]   = {[0:$]};
      }

    AWLEN_CP  : coverpoint m_tx_h.wr_len ;

    ARLEN_CP  : coverpoint m_tx_h.rd_len ;
    
    AWBRUST_CB  : coverpoint m_tx_h.wr_brust_e
      {
        bins wr_brust_cb = {[0:2]};
        illegal_bins wr_brust_illegal = {3};
      }

    ARBRUST_CB  : coverpoint m_tx_h.rd_brust_e
      {
        bins rd_brust_cb = {[0:2]};
        illegal_bins rd_brust_illegal = {3};
      }

//    WSTROBE_CB  : coverpoint m_tx_h.wr_strob
//      {
//        bins wr_strob_cb[3] = {[0:$]};
//      }
  endgroup  : axi_mas_cg

/*  covergroup axi_mas_data_cvg with function void semple(bit val);
    BIT_TOGGLE_CP : coverpoint val
      {
        bins txn_cb_01 = (0=>1);
        bins txn_cb_10 = (1=>0);
      }
  endgroup
*/

//new counstructore declaration.
  function new(string name="axi_mas_collector",uvm_component parent=null);
    super.new(name,parent);
    axi_mas_cg = new("axi_mas_cg");
      wr_data_cg = new[`WR_DATA_WIDTH];
    rd_data_cg = new[`RD_DATA_WIDTH];
    foreach(wr_data_cg[i])
      wr_data_cg[i] = new();
    foreach(rd_data_cg[i])
      rd_data_cg[i] = new();
  endfunction

  virtual function void write(axi_mas_seq_item t);
    m_tx_h = t;
    axi_mas_cg.sample();
    foreach(m_tx_h.wr_data[i,j])
      wr_data_cg[j].sample(m_tx_h.wr_data[i][j]);
   
    foreach(m_tx_h.rd_data[i,j])
      rd_data_cg[j].sample(m_tx_h.rd_data[i][j]);
   
  endfunction
  
endclass  : axi_mas_collector



`endif 
