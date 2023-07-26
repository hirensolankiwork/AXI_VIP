
////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24 - 07 - 2023
//Description : axi interface
//////////////////////////////////////////////////////////////////////


interface axi_interface(input bit clk,rst);


//write address channel signals

logic [3:0] AWID;
logic [31:0] AWADDR;
logic [3:0] AWLEN  = 4'b1000;
logic [2:0] AWSIZE = 3'b010;
logic [1:0] AWBURST= 2'b10;
logic AWVALID = 1'b1;
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
logic [1:0] RRSEP;
logic RLAST;
logic RVALID;
logic RREADY;
logic RRESP;



/* Clocking Blocks: 2 CBs are defined as follows
   2. s_drv_cb - Clocking block for slave driver
   3. mon_cb   - Clocking block for monitors of both master and slave */





    ////////////////////////////////////////////////////////////////////////
    //Clocking Block name : Monitor for Master and Slave 
    //Description : 
    //////////////////////////////////////////////////////////////////////
    clocking mon_cb @(posedge clk);
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
              RREADY,
              AWREADY,
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






endinterface


