

////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24 - 07 - 2023
//Description : transaction 
//////////////////////////////////////////////////////////////////////

class axi_trans extends  uvm_sequence_item;

`uvm_object_utils(axi_trans)


//  Constructor: new
    function new(string name = "axi_transaction");
        super.new(name);
    endfunction: new


    static axi_trans aw_que[$];
    static axi_trans ar_que[$];
    bit wstrobe [];
    bit wdata[];
    
    // write address channel signal
    bit [31:0] AWADDR;                       //   $urandom_range(1,10);
    bit [3:0]  AWLEN;
    bit [2:0]  AWSIZE;
    bit [1:0]  AWBURST;
    bit [3:0]  AWID;   
    bit        AWVALID;

    //write data channe signal
    bit        [31:0]   WDATA;
    static bit [3:0]    WID;
    bit        [3:0]    WSTRB;
    static  bit         WLAST;
    bit                 WVALID;

    //write response channel
    bit [3:0]   BID;
    bit         BREADY;
    bit [1:0]   BRESP; 
    bit         BVALID;

    //read address channel signal
    bit [31:0]     ARADDR ;                      
    bit [3:0]      ARLEN;  
    bit [2:0]      ARSIZE ;
    bit [1:0]      ARBURST;
    bit [3:0]      ARID;   
    bit            ARVALID;
    bit            ARREADY;

    //read data channel signals
    bit                    RREADY;
    static bit             RVALID;
    static bit             rvalid;
    randc bit [31:0]       RDATA;
    bit [3:0]              RID;
    bit [1:0]              RRESP;
    bit                    RLAST; 


endclass








