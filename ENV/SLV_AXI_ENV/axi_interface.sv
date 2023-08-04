
////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24 - 07 - 2023
//Description : axi interface
//////////////////////////////////////////////////////////////////////


interface axi_interface (input bit clk,rst);

//write address channel signals
logic [`WR_ID_WIDTH-1:0]  AWID;
logic [`WR_ADDR_WIDTH-1:0] AWADDR;
logic [`WR_ADDR_LEN-1:0]  AWLEN;
logic [`WR_ADDR_SIZE-1:0]  AWSIZE;
logic [1:0]  AWBURST;
logic AWVALID;
logic AWREADY;

//write Data channel signal
logic [`WR_ID_WIDTH-1:0] WID;
logic [`WR_DATA_WIDTH-1:0] WDATA;
logic [`WR_STROBE-1:0] WSTRB;
logic WLAST;
logic WREADY;
logic WVALID;

//Write Response Channel Signals
logic [`WR_ID_WIDTH-1:0] BID;
logic BREADY;
logic BVALID;
logic [1:0] BRESP;

//Read address channel signals
logic [`RD_ID_WIDTH-1:0] ARID;
logic [`RD_ADDR_WIDTH-1:0] ARADDR;
logic [`RD_ADDR_LEN:0] ARLEN;
logic [`RD_ADDR_SIZE:0] ARSIZE;
logic [3:0] ARBURST;
logic ARVALID;
logic ARREADY;

//Read Data channel signal;
logic [`RD_ID_WIDTH-1:0] RID;
logic [`RD_DATA_WIDTH-1:0] RDATA;
logic [1:0] RRESP;
logic RLAST;
logic RVALID;
logic RREADY;

   /* Clocking Blocks: 
   1. CBs are defined as follows
   2. s_drv_cb - Clocking block for slave driver
   3. mon_cb   - Clocking block for monitors of both master and slave */

    ////////////////////////////////////////////////////////////////////////
    //Clocking Block name : Monitor for Master and Slave 
    //Description : 
    //////////////////////////////////////////////////////////////////////
 clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input AWID;
    input AWADDR;
    input AWLEN;
    input AWSIZE;
    input AWBURST;
    input AWVALID;
    input WID;
    input WDATA;
    input WSTRB;
    input WLAST;
    input WVALID; 
    input BREADY;
    input ARID;
    input ARADDR;
    input ARLEN;
    input ARSIZE;
    input ARBURST;
    input ARVALID;
    input RREADY;
    input AWREADY;
    input WREADY;
    input BID;
    input BRESP;
    input BVALID;
    input ARREADY;
    input RID;
    input RDATA;
    input RRESP;
    input RLAST;
    input RVALID;
 endclocking

 ////////////////////////////////////////////////////////////////////////
 //Clocking Block Name : Slave driver 
 //Description : 
 //////////////////////////////////////////////////////////////////////
 clocking slv_drv_cb @(posedge clk);
     default input #1 output #1;
     input AWID;
     input AWADDR;
     input AWLEN;
     input AWSIZE;
     input AWBURST;
     input AWVALID;
     input WID;
     input WDATA;
     input WSTRB;
     input WLAST;
     input WVALID; 
     input BREADY;
     input ARID;
     input ARADDR;
     input ARLEN;
     input ARSIZE;
     input ARBURST;
     input ARVALID;
     input RREADY;
     output AWREADY;
     output WREADY;
     output BID;
     output BRESP;
     output BVALID;
     output ARREADY;
     output RID;
     output RDATA;
     output RRESP;
     output RLAST;
     output RVALID;
 endclocking

 modport SDRV(clocking slv_drv_cb, input rst,input clk);
 modport SMON(clocking mon_cb,   input rst,input clk);

 modport async_reset(input AWID,
                      input AWADDR,
                      input AWBURST,
                      input AWSIZE,
                      input AWLEN,
                      input AWVALID,
                      output  AWREADY,
                      //Write data
                      input WID,
                      input WDATA,
                      input WSTRB,
                      input WLAST,
                      input WVALID,
                      output  WREADY,
                      //Write response
                      output  BID,
                      output  BRESP,
                      output  BVALID,
                      input   BREADY,
                      //Read addr.
                      input ARID,
                      input ARADDR,
                      input ARBURST,
                      input ARSIZE,
                      input ARLEN,
                      input ARVALID,
                      output  ARREADY,
                      //Read data and response.
                      output  RID,
                      output  RRESP,
                      output  RVALID,
                      output  RDATA,
                         output  RLAST,
                         input   RREADY);
endinterface


