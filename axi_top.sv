



////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////

module axi_top;
 import uvm_pkg::*;
  import axi_pkg::*; 
  `include "uvm_macros.svh"


  bit rst;
   bit clk;
   
   always #5 clk = ~clk;

  axi_interface axi_inf(clk,rst);
 // axi_inf  inf(clk,rst);

/*
  always @ (*)  axi_inf.ARID = inf.arid;   
  always @ (*)  axi_inf.ARADDR = inf.araddr;
  always @ (*)  axi_inf.ARLEN = inf.arlen;
  always @ (*)  axi_inf.ARSIZE = inf.arsize;
  always @ (*)  axi_inf.ARBURT = inf.arburst;
  always @ (*)  axi_inf.ARVALID = inf.arvalid;
  always @ (*)  inf.arready  = axi_inf.ARREADY; 
   


  always @ (*)  axi_inf.AWID = inf.awid;   
  always @ (*)  axi_inf.AWADDR = inf.awaddr;
  always @ (*)  axi_inf.AWLEN = inf.awlen;
  always @ (*)  axi_inf.AWSIZE = inf.arsize;
  always @ (*)  axi_inf.AWBURT = inf.arburst;
  always @ (*)  axi_inf.AWVALID = inf.arvalid;
  always @ (*)  inf.arready  = axi_inf.ARREADY; 
 
   
  always @ (*)  axi_inf.WID = inf.wid;   
  always @ (*)  axi_inf.WDATA = inf.wdata;
  always @ (*)  axi_inf.WSTROBE = inf.wstrobe;
  always @ (*)  axi_inf.WLAST = inf.wlast;
  always @ (*)  axi_inf.WVALID = inf.wvalid;
  always @ (*)  inf.wready  = axi_inf.WREADY; 



  always @ (*)  inf.bid      =  axi_inf.WID;    
  always @ (*)  inf.bresp    =  axi_inf.BRESP;  
  always @ (*)  inf.wvalid   =  axi_inf.WVALID; 
  always @ (*)  axi_inf.WREADY   =  inf.wready; 


     
  always @ (*)  axi_inf.RID      = inf.rid;   
  always @ (*)  inf.rdata        = axi_inf.RDATA;
  always @ (*)  inf.rlast        = axi_inf.RLAST;
  always @ (*)  inf.rvalid       = axi_inf.RVALID;
  always @ (*)  axi_inf.ready  = axi_inf.WREADY; 
*/

initial begin

uvm_config_db #(virtual axi_interface)::set(null,"*","vif",axi_inf);
//uvm_config_db #(virtual axi_inf)::set(null,"*","vif",inf);
   
   run_test("axi_test");  
   end

   
endmodule
