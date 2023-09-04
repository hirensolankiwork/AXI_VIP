

////////////////////////////////////////////////////////////////////////
//devloper name : Siddharth 
//date   :  24 - 07 - 2023
//Description : transaction 
//////////////////////////////////////////////////////////////////////

 typedef enum bit [1:0] {FIXED,INCREMENT,WRAP_AROUND,RESERVED} aw_burst_kind;
 class axi_slave_seq_item extends  uvm_sequence_item;
  
   `uvm_object_utils(axi_slave_seq_item)
    ////////////////////////////////////////////////////////////////////////
    //Method name : 
    //Arguments   :  
    //Description : 
    //////////////////////////////////////////////////////////////////////
    function new(string name = "axi_slave_seq_item");
      super.new(name);
    endfunction: new

        bit[3:0]                        wstrobe [];
    bit[`WR_DATA_WIDTH-1:0]         wdata[];
    // write address FLAG
    bit [`WR_ADDR_WIDTH-1:0]        AWADDR;                     
    bit [`WR_ADDR_LEN-1:0]          AWLEN;
    bit [`WR_ADDR_SIZE-1:0]         AWSIZE;
    bit [1:0]                       AWBURST;
    aw_burst_kind                    AWBURST_E;
    bit [`WR_ID_WIDTH-1:0]          AWID;   
    bit                             AWVALID;
    //write data channel Flag
    bit [`WR_ID_WIDTH-1:0]          WID;
    bit                             WLAST;
    bit                             WVALID;
    bit [`WR_STROBE-1:0]            WSTRB;
   //read address channel Flag
    bit [`WR_ADDR_WIDTH-1:0]        ARADDR ;                      
    bit [`WR_ADDR_LEN-1:0]          ARLEN;  
    bit [`WR_ADDR_SIZE-1:0]         ARSIZE ;
    bit [1:0]                       ARBURST;
    bit [`WR_ID_WIDTH-1:0]          ARID;   
    bit                             ARVALID;
    bit                             ARREADY;
    //read data channel signals
    bit                             RVALID;
    rand bit [31:0]                 RDATA[];
    rand bit [1:0]                  RRESP;
    //response channel
    static bit                      VALID;
    rand bit [1:0]                  BRESP;
endclass








