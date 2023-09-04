
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


   //Assertions:

    RESET_ASSERT                   : assert property(@(negedge rst)rstn_asert )
    $info("Reset asserted sucessfully");
     else $error("!!!!!!!!!!!!!!!!!!reset not asserted properly");
    
    RESET_DEASSERT                 : assert property(rstn_dasert)begin
    $info("Reset Deasserted sucessfully");
    end
     else $error("!!!!!!!!!!!!!!!!!!!Reset not deassertion properly");
    
    WRITE_ADDR_CHANNEL_HANDSHAKE   : assert property (awvalid)
    $info("write address channel handshaking sucessfully");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Write channel not handshking properly");
    
    READ_ADDRESS_CHANNEL_HANDSHAKE : assert property (arvalid)
    $info("read address chanel handshaking sucessfully");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Read_address channel handsaking error");

    WRITE_CHANNEL_HANDSHAKING      : assert property (wvalid)
    $info("Write channel handshaking sucessfully");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Write_channel handshhaking error");
    
    AWLEN_STABILITY                : assert property (awlen)
     $info("AWLEN IS STABLE");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1awlen is not stable ");
    

    READ_RSP_CHANNEL_HANDSHAKING   : assert property (rvalid)
    $info("Read rsponse channel handshaking done properly");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Read_rsp channel handsaking not working ");

    WRITE_RSP_CHANNEL_HANDSHAKING  : assert property (bvalid)
    $info("Write Rsp channel have done handshaking properly");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1write_response channel handshaking not working properly");

    AWVALID_DATA                   : assert property (awvalid_data)
    $info("Awvalid data asserted");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1After Write valid assert still data is unknown");

    ARVALID_DATA                   : assert property (arvalid_data)
    $info("Arvalid data asserted");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1In read_data channel have not valid data");

    WVALID_DATA                    : assert property (wvalid_data)
    $info("Wvalid data asserted");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1write data channel doesn't have valid data ");

    RVALID_DATA                    : assert property (rvalid_data)
    $info("Rvalid data asserted");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Read_rsp channel have don't valid data");
    
    BVALID_DATA                    : assert property (bvalid_data)
    $info("Bvalid data asserted");
     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Write response channel have not valid data");
     
    BVALID_DEPENDACY               : assert property (bvalid_dependancy)
     $info("BVALID CORRECTLY ASSERTED");

     else $error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1Bvalid asserted  @that time wready and wvalid and wlast not asserted ");


    property rstn_asert;
         !rst |->  !(BVALID) && !(RVALID) && !(AWREADY) &&!(ARREADY) &&!(WREADY);
    endproperty

    property rstn_dasert;
        @(posedge clk) disable iff(rst == 1'b1) ((AWREADY) && (ARREADY) &&(WREADY)) |-> rst;
    endproperty

    property awvalid;
       @(posedge clk) disable iff(!rst) $rose(AWVALID) |-> AWVALID[*1:$] ##0 (AWREADY);
    endproperty

    property arvalid;
       @(posedge clk) disable iff(!rst) $rose(ARVALID) |-> ARVALID[*1:$] ##0 (ARREADY);
    endproperty; 

    property wvalid;
       @( posedge clk) disable iff(!rst) $rose(WVALID) |-> WVALID[*1:$] ##0 (WREADY);
    endproperty; 

    property bvalid;
       @( posedge clk ) disable iff(!rst) $rose(BVALID) |-> BVALID[*1:$] ##0 (BREADY);
    endproperty; 

    property rvalid;
       @( posedge clk) disable iff(!rst) $rose(RVALID) |-> RVALID[*1:$] ##0 (RREADY); 
    endproperty; 


    property awlen;
       //@( posedge clk ) disable iff(!rst) $rose(AWVALID) |-> $stable(AWLEN)[*1:$] ##0 (AWREADY);
       @( posedge clk ) disable iff(!rst) (AWVALID) & (!AWREADY) |-> $stable(AWLEN) & $stable(AWSIZE) & $stable(AWADDR) & $stable(AWBURST);
    endproperty; 
      

    property awvalid_data;
        @(posedge clk) disable iff(!rst) $rose(AWVALID) |=> !$isunknown(AWADDR) && 
                                                               !$isunknown(AWBURST) && 
                                                               !$isunknown(AWSIZE) &&
                                                               !$isunknown(AWLEN) &&
                                                               !$isunknown(AWID) ;
    endproperty
    property wvalid_data;
        @(posedge clk) disable iff(!rst) $rose(WVALID) |=> !$isunknown(WDATA) && 
                                                               !$isunknown(WSTRB) && 
                                                               !$isunknown(WLAST) &&
                                                               !$isunknown(WID) ;
    endproperty
    property arvalid_data;
        @(posedge clk) disable iff(!rst) $rose(ARVALID) |=> !$isunknown(ARADDR) && 
                                                               !$isunknown(ARBURST) && 
                                                               !$isunknown(ARSIZE) &&
                                                               !$isunknown(ARLEN) &&
                                                               !$isunknown(ARID) ;
    endproperty
    
    property bvalid_data;
       @(posedge clk) disable iff(!rst) $rose(BVALID) |=>   !$isunknown(BID) && 
                                                             !$isunknown(BRESP) &&
                                                             !$isunknown(BREADY) ;
    endproperty                                                         

   property rvalid_data;
       @(posedge clk) disable iff(!rst) $rose(RVALID) |=>   !$isunknown(RID) && 
                                                             !$isunknown(RRESP) &&
                                                             !$isunknown(RREADY) ;
   endproperty


  property bvalid_dependancy;
     @(posedge clk) disable iff(!rst) $rose(BVALID) |-> seq1 and seq2 and seq3;
  endproperty   

  sequence seq1;
     (($past(WLAST,3) == 1) |($past(WLAST,2) == 1)|($past(WLAST,1) == 1));
  endsequence   
    
  sequence seq2;
    ($past(WVALID,1) ==1) | ($past(WVALID,2)==1) | ($past(WVALID,3)==1); 
  endsequence
  
  sequence seq3;
    ($past(WREADY,1) ==1) | ($past(WREADY,2)==1) | ($past(WREADY,3)==1); 
  endsequence



endinterface
                         


