/////////////////////////////////////////////////////////////////////////
// Company        : SCALEDGE 
// Engineer       : ADITYA MISHRA 
// Create Date    : 10-08-2023
// Last Modifiey  : 28-08-2023 17:27:01
// File Name   	  : axi_mas_checker.sv
// Class Name 	  : axi_mas_checker 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_CHECKER_SV
`define AXI_MAS_CHECKER_SV

class axi_mas_checker  extends uvm_subscriber #(axi_mas_seq_item);
//UVM Fectory registretion.
//uvm_subscriber is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_checker)

  function new(string name="axi_mas_checker",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  axi_mas_seq_item  m_tx_q[$];
  axi_mas_seq_item  m_tx_h;
 // int mem_awid [$];
 // int mem_arid [$];
 // int temp_q   [$];
 // int size=0;
 // bit valid_flag ;
//--------------------------------------------------------------------------
//Function : Build Phase 
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Start of Build Phase.",UVM_HIGH)
    super.build_phase(phase);
    `uvm_info(get_name(),"End of Build Phase.",UVM_HIGH)
  endfunction

//----------------------------------------------------------------------------
//Function : write
//  In which we are goin to implement our checker.
//----------------------------------------------------------------------------

  function void write(axi_mas_seq_item t);
    `uvm_info(get_name(),"Inside the checker.",UVM_HIGH)
    if(t != null)begin
      t.print();
      m_tx_q.push_back(t);
     // mem_awid.push_back(t.awr_id);
     // mem_arid.push_back(t.ard_id);
    end
    `uvm_info(get_name(),"End of task .",UVM_HIGH)
  endfunction

//----------------------------------------------------------------------------
//Task : Run Phase
//----------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    forever begin
      wait(m_tx_q.size() != 0);
      m_tx_h = m_tx_q.pop_front();
      //----------------------------------------------------------------------------
      //WID Checker in which we are going to check wather the request is send
      //to slave is there or not.
      //----------------------------------------------------------------------------
    //  if(m_tx_h.b_valid) begin
    //    $display(mem_awid);
    //    temp_q = mem_awid.find_index() with (item == m_tx_h.b_id);
    //    if(temp_q.size() != 0)begin
    //      $display(temp_q);
    //      `uvm_info("BID_CHECKER","The Checker for BID got PASS.",UVM_HIGH)
    //      foreach(temp_q[i])
    //        mem_awid.delete(temp_q[i]-i);
    //    end
    //    else
    //      `uvm_error("BID_CHECKER","The Checker for BID got Fail.")
    //  end
    //  //---------------------------------------------------------------------------
    //  //RID Checker in which we are going to check wather the request is send
    //  //to slave is there or not.
    //  //---------------------------------------------------------------------------
    //  if(m_tx_h.r_valid & m_tx_h.r_last) begin
    //    $display(mem_arid);
    //    temp_q = mem_arid.find_index() with (item == m_tx_h.r_id);
    //    //temp_q = m_tx_q.find_first_index() with (item.ard_id == m_tx_h.r_id);
    //    if(temp_q.size() != 0)begin
    //      $display(temp_q);
    //      `uvm_info("RID_CHECKER","The Checker for RID got PASS.",UVM_HIGH)
    //      foreach(temp_q[i])
    //        mem_arid.delete(temp_q[i]-i);
    //     // m_tx_q.delete(temp_q.pop_front());
    //     // i--;
    //    end
    //    else
    //      `uvm_error("RID_CHECKER","The Checker for RID got Fail.")
    //  end
      //----------------------------------------------------------------------------
      //AWADDR Width Checker.
      //----------------------------------------------------------------------------
      if($size(m_tx_h.wr_addr) == `WR_ADDR_WIDTH)
        `uvm_info("AWADDR_CHECKER","The Checker for AWADDR Size got PASS.",UVM_HIGH)
      else 
        `uvm_error("AWADDR_CHECKER","The Checker For AWADDR Size got Fail..!!!")
      //------------------------------------------------------------------------------
      //ARADDR width Checker.
      //------------------------------------------------------------------------------
      if($size(m_tx_h.rd_addr) == `RD_ADDR_WIDTH)
        `uvm_info("ARADDR_CHECKER","The Checker for ARADDR Size got PASS.",UVM_HIGH)
      else 
        `uvm_error("ARADDR_CHECKER","The Checker For ARADDR Size got Fail..!!!")
      //----------------------------------------------------------------------------
      //AWDATA Width Checker. 
      //----------------------------------------------------------------------------
      if($size(m_tx_h.wr_data,2) == `WR_DATA_WIDTH )
        `uvm_info("AWADDR_CHECKER","The Checker for AWADDR Size got PASS.",UVM_HIGH)
      else 
        `uvm_error("AWADDR_CHECKER","The Checker For AWADDR Size got Fail..!!!")
      //----------------------------------------------------------------------------
      //AWDATA Width Checker. 
      //----------------------------------------------------------------------------
      if($size(m_tx_h.rd_data,2) == `WR_DATA_WIDTH )
        `uvm_info("ARADDR_CHECKER","The Checker for ARADDR Size got PASS.",UVM_HIGH)
      else 
        `uvm_error("ARADDR_CHECKER","The Checker For ARADDR Size got Fail..!!!")

     // i++;
    end
  endtask  

endclass

`endif 
