
////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24 - 07 - 2023
//Description : axi interface
//////////////////////////////////////////////////////////////////////


interface axi_interface #(parameter ADDR_WIDTH = 32 , DATA_WIDTH =32) (input bit clk,rst);


//write address channel signals

logic [3:0] AWID;
logic [ADDR_WIDTH-1:0] AWADDR;
logic [3:0] AWLEN;
logic [2:0] AWSIZE;
logic [1:0] AWBURST;
logic AWVALID;
logic AWREADY;


//write Data channel signal
logic [3:0] WID;
logic [DATA_WIDTH-1:0] WDATA;
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
logic [ADDR_WIDTH-1:0] ARADDR;
logic [3:0] ARLEN;
logic [2:0] ARSIZE;
logic [3:0] ARBURST;
logic ARVALID;
logic ARREADY;


//Read Data channel signal;
logic [3:0] RID;
logic [DATA_WIDTH-1:0] RDATA;
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
        input AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID, WID, WDATA, WSTRB,  WLAST, WVALID, 
                BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, RREADY;
        input AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RDATA, RRESP,  RLAST, RVALID;
    endclocking




    
    ////////////////////////////////////////////////////////////////////////
    //Clocking Block Name : Slave driver 
    //Description : 
    //////////////////////////////////////////////////////////////////////
    clocking slv_drv_cb @(posedge clk);
      default input #1 output #1;
        input AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID, WID, WDATA, WSTRB,  WLAST, WVALID, 
                BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, RREADY;
        output AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RDATA, RRESP, RLAST, RVALID;
    endclocking


    modport SDRV(clocking slv_drv_cb, input rst);
    modport SMON(clocking mon_cb,   input rst);





endinterface


