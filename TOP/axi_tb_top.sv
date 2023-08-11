/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 09-08-2023 12:41:03
// File Name   	  : axi_tb_top.sv
// Module Name 	  : axi_tb_top
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

module axi_tb_top();

  import axi_test_pkg::*;
// import the UVM package
  import uvm_pkg::*;
// include the uvm_macros.svh
	`include "uvm_macros.svh"

  bit clk=1;
  bit rstn;

  axi_inf m_inf(clk,rstn);
  axi_interface s_inf(clk,rstn); 

  assign s_inf.ARID     = m_inf.arid;
  assign s_inf.ARADDR   = m_inf.araddr;
  assign s_inf.ARLEN    = m_inf.arlen;
  assign s_inf.ARSIZE   = m_inf.arsize;
  assign s_inf.ARBURST  = m_inf.arbrust;
  assign s_inf.ARVALID  = m_inf.arvalid;
  assign m_inf.arready  = s_inf.ARREADY;

  assign m_inf.rid      = s_inf.RID;  
  assign m_inf.rdata    = s_inf.RDATA;  
  assign m_inf.rresp    = s_inf.RRESP;  
  assign m_inf.rlast    = s_inf.RLAST;  
  assign m_inf.rvalid   = s_inf.RVALID;  
  assign s_inf.RREADY   = m_inf.rready;  
   
  assign m_inf.bid      = s_inf.BID;  
  assign m_inf.bresp    = s_inf.BRESP;  
  assign m_inf.bvalid   = s_inf.BVALID;  
  assign s_inf.BREADY   = m_inf.bready;  
   
  assign s_inf.AWID     = m_inf.awid;  
  assign s_inf.AWADDR   = m_inf.awaddr;  
  assign s_inf.AWLEN    = m_inf.awlen;  
  assign s_inf.AWSIZE   = m_inf.awsize;  
  assign s_inf.AWBURST  = m_inf.awbrust; 
  assign s_inf.AWVALID  = m_inf.awvalid; 
  assign m_inf.awready  = s_inf.AWREADY; 
   
  assign s_inf.WID      = m_inf.wid;  
  assign s_inf.WDATA    = m_inf.wdata;  
  assign s_inf.WSTRB    = m_inf.wstrob;  
  assign s_inf.WVALID   = m_inf.wvalid;  
  assign s_inf.WLAST    = m_inf.wlast;  
  assign m_inf.wready   = s_inf.WREADY;  


//--------------------------------------------------------------------------------------------
//           DUT instantiation
//--------------------------------------------------------------------------------------------
  task reset(int i);
    repeat(i)begin
    //  repeat($urandom_range(2,15))@(negedge clk);
      repeat(8)@(negedge clk);
        rstn = 1'b0;
      @(posedge clk)
      rstn = 1'b1;
    end
  endtask : reset 

  initial forever #2 clk = ~clk;
//--------------------------------------------------------------------------------------------
//           set config_db
//--------------------------------------------------------------------------------------------
   initial begin
    uvm_config_db #(virtual axi_inf)::set(uvm_root::get(),"*","vif_0",m_inf);   //uvm_root::get()
	   uvm_config_db #(virtual axi_interface)::set(uvm_root::get(),"*","vif",s_inf);   //uvm_root::get()
   end
//--------------------------------------------------------------------------------------------
//           Aplying initial reset
//--------------------------------------------------------------------------------------------

   initial begin
     rstn = 1'b0;
     repeat(2)@(posedge clk);
     rstn = 1'b1;
     if($test$plusargs("UVM_TESTNAME=axi_reset_test"))
       reset(1);
   end
//--------------------------------------------------------------------------------------------
//           Calling test
//--------------------------------------------------------------------------------------------

   initial begin
      run_test();
   end

endmodule
