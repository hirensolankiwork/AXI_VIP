/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 27-07-2023 15:32:29
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

  bit clk;
  bit rstn;

  axi_inf m_inf(clk,rstn);
  axi_interface s_inf(clk,rstn); 

  always @(*) s_inf.ARID     = m_inf.arid;
  always @(*) s_inf.ARADDR   = m_inf.araddr;
  always @(*) s_inf.ARLEN    = m_inf.arlen;
  always @(*) s_inf.ARSIZE   = m_inf.arsize;
  always @(*) s_inf.ARBURST  = m_inf.arbrust;
  always @(*) s_inf.ARVALID  = m_inf.arvalid;
  always @(*) m_inf.arready  = s_inf.ARREADY;

  always @(*) m_inf.rid      = s_inf.RID;  
  always @(*) m_inf.rdata    = s_inf.RDATA;  
  always @(*) m_inf.rresp    = s_inf.RRESP;  
  always @(*) m_inf.rlast    = s_inf.RLAST;  
  always @(*) m_inf.rvalid   = s_inf.RVALID;  
  always @(*) s_inf.RREADY   = m_inf.rready;  
   
  always @(*) m_inf.bid      = s_inf.BID;  
  always @(*) m_inf.bresp    = s_inf.BRESP;  
  always @(*) m_inf.bvalid   = s_inf.BVALID;  
  always @(*) s_inf.BREADY   = m_inf.bready;  
   
  always @(*) s_inf.AWID     = m_inf.awid;  
  always @(*) s_inf.AWADDR   = m_inf.awaddr;  
  always @(*) s_inf.AWLEN    = m_inf.awlen;  
  always @(*) s_inf.AWSIZE   = m_inf.awsize;  
  always @(*) s_inf.AWBURST  = m_inf.awbrust; 
  always @(*) s_inf.AWVALID  = m_inf.awvalid; 
  always @(*) m_inf.awready  = s_inf.AWREADY; 
   
  always @(*) s_inf.WID      = m_inf.wid;  
  always @(*) s_inf.WDATA    = m_inf.wdata;  
  always @(*) s_inf.WSTRB    = m_inf.wstrob;  
  always @(*) s_inf.WVALID   = m_inf.wvalid;  
  always @(*) s_inf.WLAST    = m_inf.wlast;  
  always @(*) m_inf.wready   = s_inf.WREADY;  


//--------------------------------------------------------------------------------------------
//           DUT instantiation
//--------------------------------------------------------------------------------------------
  task reset();
    repeat(2)@(negedge clk)
    rstn = 1'b0;
    @(posedge clk)
    rstn = 1'b1;
  endtask : reset 

  initial forever #2 clk = ~clk;
//--------------------------------------------------------------------------------------------
//           set config_db
//--------------------------------------------------------------------------------------------
   initial begin
    uvm_config_db #(virtual axi_inf)::set(uvm_root::get(),"*","m_vif",m_inf);   //uvm_root::get()
	   uvm_config_db #(virtual axi_interface)::set(uvm_root::get(),"*","vif",s_inf);   //uvm_root::get()
   end
//--------------------------------------------------------------------------------------------
//           Aplying initial reset
//--------------------------------------------------------------------------------------------

   initial begin
     rstn = 1'b1;
     reset();
     repeat(10)@(negedge clk);
     reset();
   end
//--------------------------------------------------------------------------------------------
//           Calling test
//--------------------------------------------------------------------------------------------

   initial begin
      run_test("axi_base_test");
   end

endmodule
