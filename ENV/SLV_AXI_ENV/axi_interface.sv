
////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24 - 07 - 2023
//Description : axi interface
//////////////////////////////////////////////////////////////////////


interface axi_interface (input bit clk,rst);


//write address channel signals

logic [3:0] AWID;
logic [31:0] AWADDR;
logic [3:0] AWLEN;
logic [2:0] AWSIZE;
logic [1:0] AWBURST;
logic AWVALID;
logic AWREADY;


//write Data channel signal
logic [3:0] WID;
logic [31:0] WDATA;
logic [3:0] WSTRB;
logic WLAST;
logic WREADY;
logic WVALID;


//Write Response Channel Signals
logic [3:0] BID;
logic BREADY;
logic BVALID;
logic [1:0] BRESP;


//Read address channel signals
logic [3:0] ARID;
logic [31:0] ARADDR;
logic [3:0] ARLEN;
logic [2:0] ARSIZE;
logic [3:0] ARBURST;
logic ARVALID;
logic ARREADY;


//Read Data channel signal;
logic [3:0] RID;
logic [31:0] RDATA;
logic [1:0] RRESP;
logic RLAST;
logic RVALID;
logic RREADY;



/* Clocking Blocks: 2 CBs are defined as follows
   2. s_drv_cb - Clocking block for slave driver
   3. mon_cb   - Clocking block for monitors of both master and slave */





    ////////////////////////////////////////////////////////////////////////
    //Clocking Block name : Monitor for Master and Slave 
    //Description : 
    //////////////////////////////////////////////////////////////////////
    clocking mon_cb @(posedge clk);
        input AWID,
              AWADDR,
              AWLEN,
              AWSIZE,
              AWBURST,
              AWVALID,
              WID,
              WDATA,
              WSTRB,
              WLAST,
              WVALID, 
              BREADY,
              ARID,
              ARADDR,
              ARLEN,
              ARSIZE,
              ARBURST,
              ARVALID,
              RREADY;
        input AWREADY,
              WREADY,
              BID,
              BRESP,
              BVALID,
              ARREADY,
              RID,
              RDATA,
              RRESP,
              RLAST,
              RVALID;
    endclocking




    
    ////////////////////////////////////////////////////////////////////////
    //Clocking Block Name : Slave driver 
    //Description : 
    //////////////////////////////////////////////////////////////////////
    clocking slv_drv_cb @(posedge clk);
      default input #1 output #1;
        input AWID,
              AWADDR,
              AWLEN,
              AWSIZE,
              AWBURST,
              AWVALID,
              WID,
              WDATA,
              WSTRB,
              WLAST,
              WVALID, 
              BREADY,
              ARID,
              ARADDR,
              ARLEN,
              ARSIZE,
              ARBURST,
              ARVALID,
              RREADY;
        output AWREADY,
               WREADY,
               BID,
               BRESP,
               BVALID,
               ARREADY,
               RID,
               RDATA,
               RRESP,
               RLAST,
               RVALID;
    endclocking


    modport SDRV(clocking slv_drv_cb, input rst);
    modport SMON(clocking mon_cb,   input rst);

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


