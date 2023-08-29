/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 28-08-2023 17:44:11
// File Name   	  : axi_mas_inf.sv
// Interface Name : axi_mas_inf
// Project Name	  : AXI_3 VIP
// Description	  : This is the interface.
//////////////////////////////////////////////////////////////////////////

`ifndef AIX_MAS_INF_SV
`define AXI_MAS_INF_SV

`include "axi_define.sv"
interface axi_inf(input logic aclk,
                  input logic arstn);
//-------------------------------------------------------------------------
// Write Address Chennal
//-------------------------------------------------------------------------
  logic [(`WR_ID_WIDTH-1)  :0]   awid;
  logic [(`WR_ADDR_WIDTH-1):0]   awaddr;
  logic [(`WR_ADDR_LEN-1)  :0]   awlen;
  logic [(`WR_ADDR_SIZE-1) :0]   awsize;
  logic [1:0]                    awbrust;
  logic [1:0]                    awlock;
  logic [3:0]                    awcache;
  logic [2:0]                    awprot;
  logic                          awready;
  logic                          awvalid;
//-------------------------------------------------------------------------
// Write Data Chennal
//-------------------------------------------------------------------------
  logic [(`WR_ID_WIDTH-1)  :0]   wid;
  logic [(`WR_DATA_WIDTH-1):0]   wdata;
  logic [(`WR_STROBE-1):0]       wstrob;
  logic                          wlast;
  logic                          wready;
  logic                          wvalid;
//-------------------------------------------------------------------------
// Write Responce Chennal
//-------------------------------------------------------------------------
  logic [(`WR_ID_WIDTH-1) :0]    bid;
  logic [1:0]                    bresp;
  logic                          bready;
  logic                          bvalid;
//-------------------------------------------------------------------------
// Read Address Chennal
//-------------------------------------------------------------------------
  logic [(`RD_ID_WIDTH-1)  :0]   arid;
  logic [(`RD_ADDR_WIDTH-1):0]   araddr;
  logic [(`RD_ADDR_LEN-1)  :0]   arlen;
  logic [(`RD_ADDR_SIZE-1) :0]   arsize;
  logic [1:0]                    arbrust;
  logic [1:0]                    arlock;
  logic [3:0]                    arcache;
  logic [2:0]                    arprot;
  logic                          arready;
  logic                          arvalid;
//-------------------------------------------------------------------------
// Read Data and Responce Chennal
//-------------------------------------------------------------------------
  logic [(`RD_ID_WIDTH-1)  :0]   rid;
  logic [(`RD_DATA_WIDTH-1):0]   rdata;
  logic [1:0]                    rresp;
  logic                          rlast;
  logic                          rready;
  logic                          rvalid;

  


  clocking mas_drv_cb@(posedge aclk);
    default input #1 output #1;
    //Write Addr
    output awid;
    output awaddr;
    output awbrust;
    output awsize;
    output awlen;
    output awlock;
    output awprot;
    output awcache;
    output awvalid;
    input  awready;
    //Write data
    output wid;
    output wdata;
    output wstrob;
    output wlast;
    output wvalid;
    input  wready;
    //Write response
    input  bid;
    input  bresp;
    input  bvalid;
    output bready;
    //Read addr.
    output arid;
    output araddr;
    output arbrust;
    output arsize;
    output arlen;
    output arlock;
    output arprot;
    output arcache;
    output arvalid;
    input  arready;
    //Read data and response.
    input  rid;
    input  rresp;
    input  rvalid;
    input  rdata;
    input  rlast;
    output rready;
  endclocking

  clocking mas_mon_cb@(posedge aclk);
    default input #1 output #1;
    //Write Addr
    input  awid;
    input  awaddr;
    input  awbrust;
    input  awsize;
    input  awlen;
    input  awlock;
    input  awprot;
    input  awcache;
    input  awvalid;
    input awready;
    //Write data
    input  wid;
    input  wdata;
    input  wstrob;
    input  wlast;
    input  wvalid;
    input wready;
    //Write response
    input bid;
    input bresp;
    input bvalid;
    input  bready;
    //Read addr.
    input  arid,araddr,arbrust;
    input  arsize,arlen,arlock;
    input  arprot,arcache,arvalid;
    input arready;
    //Read data and response.
    input rid,rresp,rvalid;
    input rdata,rlast;
    input  rready;
  endclocking

  modport async_reset( output awid,
                       output awaddr,
                       output awbrust,
                       output awsize,
                       output awlen,
                       output awlock,
                       output awprot,
                       output awcache,
                       output awvalid,
                       input  awready,
                       //Write data
                       output wid,
                       output wdata,
                       output wstrob,
                       output wlast,
                       output wvalid,
                       input  wready,
                       //Write response
                       input  bid,
                       input  bresp,
                       input  bvalid,
                       output bready,
                       //Read addr.
                       output arid,
                       output araddr,
                       output arbrust,
                       output arsize,
                       output arlen,
                       output arlock,
                       output arprot,
                       output arcache,
                       output arvalid,
                       input  arready,
                       //Read data and response.
                       input  rid,
                       input  rresp,
                       input  rvalid,
                       input  rdata,
                       input  rlast,
                       output rready);

  property axi_reset;
    @(negedge arstn)1'b1 |-> @(posedge arstn) (!awvalid) && (!wvalid) && (!arvalid);
  endproperty

  AXI_RESET_ASSERT : assert property (axi_reset)begin
                       $info("[RESET_ASSERT]:Assertion PASS");
                     end
                     else
                       $error("[RESET_ASSERT]:Assertion fail...");

  property axi_awvalid_dasser;
    @(posedge aclk) disable iff(!arstn) $fell(awvalid) |-> $past(awready,1);
  endproperty
    
  AXI_AWVALID_DEASSERT  : assert property (axi_awvalid_dasser)begin
                            $info("[AWVALID_DEASSERT]:Assertion PASS");
                          end
                          else
                            $error("[AWVALID_DEASSERT]:Assertion fail...");
  property axi_wvalid_dasser;
    @(posedge aclk) disable iff(!arstn) $fell(wvalid) |-> $past(wready,1);
  endproperty
    
  AXI_WVALID_DEASSERT  : assert property (axi_wvalid_dasser)begin
                            $info("[WVALID_DEASSERT]:Assertion PASS");
                         end
                         else
                            $error("[WVALID_DEASSERT]:Assertion fail...");
  property axi_arvalid_dasser;
    @(posedge aclk) disable iff(!arstn) $fell(arvalid) |-> $past(arready,1);
  endproperty
    
  AXI_ARVALID_DEASSERT  : assert property (axi_arvalid_dasser)begin
                            $info("[AWVALID_DEASSERT]:Assertion PASS");
                          end
                          else
                            $error("[AWVALID_DEASSERT]:Assertion fail...");

  property axi_awvalid_asser;
    @(posedge aclk) disable iff(!arstn) $rose(awvalid) |=> !$isunknown(awaddr) && 
                                                           !$isunknown(awbrust) && 
                                                           !$isunknown(awsize) &&
                                                           !$isunknown(awlen) &&
                                                           !$isunknown(awid) ;
  endproperty
  property axi_wvalid_asser;
    @(posedge aclk) disable iff(!arstn) $rose(wvalid) |=>  !$isunknown(wdata) && 
                                                           !$isunknown(wstrob) && 
                                                           !$isunknown(wlast) &&
                                                           !$isunknown(wid) ;
  endproperty
  property axi_arvalid_asser;
    @(posedge aclk) disable iff(!arstn) $rose(arvalid) |=> !$isunknown(araddr) && 
                                                           !$isunknown(arbrust) && 
                                                           !$isunknown(arsize) &&
                                                           !$isunknown(arlen) &&
                                                           !$isunknown(arid) ;
  endproperty

  AXI_AWVALID_ASSERT  : assert property (axi_awvalid_asser)begin
                            $info("[AWVALID_ASSERT]:Assertion PASS");
                          end
                          else
                            $error("[AWVALID_ASSERT]:Assertion fail...");
  AXI_WVALID_ASSERT  : assert property (axi_wvalid_asser)begin
                            $info("[WVALID_ASSERT]:Assertion PASS");
                          end
                          else
                            $error("[WVALID_ASSERT]:Assertion fail...");
  AXI_ARVALID_ASSERT  : assert property (axi_arvalid_asser)begin
                            $info("[ARVALID_ASSERT]:Assertion PASS");
                          end
                          else
                            $error("[ARVALID_ASSERT]:Assertion fail...");
 
  property axi_awch_stable;
    @(posedge aclk) disable iff(!arstn) awvalid && !awready |-> $stable(awaddr) && 
                                                               $stable(awbrust) && 
                                                               $stable(awsize) &&
                                                               $stable(awlen) &&
                                                               $stable(awid) ;
  endproperty
  property axi_wch_stable;
    @(posedge aclk) disable iff(!arstn) wvalid && !wready |-> $stable(wdata) && 
                                                              $stable(wstrob) && 
                                                              $stable(wlast) &&
                                                              $stable(wid) ;
  endproperty
  property axi_arch_stable;
    @(posedge aclk) disable iff(!arstn) arvalid && !arready|-> $stable(araddr) && 
                                                               $stable(arbrust) && 
                                                               $stable(arsize) &&
                                                               $stable(arlen) &&
                                                               $stable(arid) ;
  endproperty

  AXI_AWCH_STABLE  : assert property (axi_awch_stable)begin
                            $info("[AWCH_STABLE]:Assertion PASS");
                          end
                          else
                            $error("[AWCH_STABLE]:Assertion fail...");
  AXI_WCH_STABLE  : assert property (axi_wch_stable)begin
                            $info("[WCH_STABLE]:Assertion PASS");
                          end
                          else
                            $error("[WCH_STABLE]:Assertion fail...");
  AXI_ARCH_STABLE  : assert property (axi_arch_stable)begin
                            $info("[ARCH_STABLE]:Assertion PASS");
                          end
                          else
                            $error("[ARCH_STABLE]:Assertion fail...");                         

  property axi_ready_before_valid(logic valid,logic ready);    
    @(posedge aclk) disable iff(!arstn) ($past(valid,1)==0)&& ready |-> ##[1:$] valid ##1 !valid;
  endproperty
  AXI_READY_ASSERTED_BEFOR_VALID_ASSERT : assert property (axi_ready_before_valid(awvalid,awready))begin
                                             $info("[ARVALID_ASSERT]:Assertion PASS");
                                          end
                                          else
                                             $error("[ARVALID_ASSERT]:Assertion fail...");

endinterface

`endif 
