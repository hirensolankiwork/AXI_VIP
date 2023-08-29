/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 25-08-2023 14:33:50
// File Name   	  : axi_mas_seq_item.sv
// Class Name 	  : axi_mas_seq_item
// Project Name	  : AXI_3 VIP
// Description	  : This is the transection class where the requered signals
// which driver want to send to DUT or Monitor want to semple it and send to
// scoreboard are mention here.
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_SEQ_ITEM_SV
`define AXI_MAS_SEQ_ITEM_SV

//--------------------------------------------------------------------------
// class  : axi_mas_seq_item 
//--------------------------------------------------------------------------
typedef enum bit[1:0]{FIX,INCR,WRAP,RESERVE} brust_kind_e;
typedef enum bit[1:0]{OKAY,EXOKAY,SLVERR,DECERR} resp_kind_e;
typedef enum bit {WRITE_REQ,READ_REQ} req_kind_e;
class axi_mas_seq_item extends uvm_sequence_item;

  rand  req_kind_e                  req_e;
  randc bit [(`WR_ID_WIDTH-1):0]    awr_id;
  randc bit [(`WR_ID_WIDTH-1):0]    wr_id;
  rand  brust_kind_e                wr_brust_e;
  rand  bit [(`WR_ADDR_WIDTH-1):0]  wr_addr;
  rand  bit [(`WR_ADDR_SIZE-1):0]   wr_size;
  rand  bit [(`WR_ADDR_LEN-1):0]    wr_len;
  rand  bit [(`WR_DATA_WIDTH-1):0]  wr_data[];
  rand  bit [(`WR_STROBE-1):0]      wr_strob[];
        bit                         b_valid;
        bit [(`WR_ID_WIDTH-1):0]    b_id;
        resp_kind_e                 b_resp_e;
  randc bit [(`RD_ID_WIDTH-1):0]    ard_id;
  rand  brust_kind_e                rd_brust_e;
  rand  bit [(`RD_ADDR_WIDTH-1):0]  rd_addr;
  rand  bit [(`RD_ADDR_SIZE-1):0]   rd_size;
  rand  bit [(`RD_ADDR_LEN-1):0]    rd_len;
        bit [(`RD_DATA_WIDTH-1):0]  rd_data[$];
        bit                         r_last;
        bit                         r_valid;
        bit [(`RD_ID_WIDTH-1):0]    r_id;
        resp_kind_e                 r_resp_e;

//UVM Fectory registretion.
//uvm_sequence_item is object that's why we are using `uvm_object_utils macro.
  `uvm_object_utils_begin(axi_mas_seq_item)
    `uvm_field_enum(req_kind_e,req_e,UVM_ALL_ON)
    `uvm_field_int(awr_id,UVM_ALL_ON|UVM_HEX)
    `uvm_field_enum(brust_kind_e,wr_brust_e,UVM_ALL_ON)
    `uvm_field_int(wr_len,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(wr_size,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(wr_addr,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(wr_id,UVM_ALL_ON|UVM_HEX)
    `uvm_field_array_int(wr_data,UVM_ALL_ON|UVM_HEX)
    `uvm_field_array_int(wr_strob,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(b_id,UVM_ALL_ON|UVM_HEX)
    `uvm_field_enum(resp_kind_e,b_resp_e,UVM_ALL_ON)
    `uvm_field_int(ard_id,UVM_ALL_ON|UVM_HEX)
    `uvm_field_enum(brust_kind_e,rd_brust_e,UVM_ALL_ON)
    `uvm_field_int(rd_len,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(rd_size,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(rd_addr,UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(r_id,UVM_ALL_ON|UVM_HEX)
    `uvm_field_queue_int(rd_data,UVM_ALL_ON|UVM_HEX)
    `uvm_field_enum(resp_kind_e,r_resp_e,UVM_ALL_ON)
  `uvm_object_utils_end

//new counstructore declaration.
  function new(string name="axi_mas_seq_item");
    super.new(name);
  endfunction

// to get the Bytes per transfer.


  constraint WR_ID_1 {
    soft awr_id == wr_id;
  }
  constraint WR_BRUST {
    soft wr_brust_e == INCR;
    soft rd_brust_e == INCR;
  }
//TODO: Slove Before uses.
  constraint WR_DATA_SIZE { 
    solve wr_len before wr_data;
    solve wr_len before wr_strob;
    wr_data.size() == wr_len+1;
    wr_strob.size()== wr_len+1;
  }

  constraint BRUST_SIZE { 
    8*(2**wr_size) <= `WR_DATA_WIDTH;
    8*(2**rd_size) <= `RD_DATA_WIDTH;
  }
//TODO: Constraint for alingned addr.
  constraint ADDR_VAL {
    /*  solve order constraints  */
    solve wr_brust_e before wr_addr;
    solve wr_size before wr_addr;

    /*  rand variable constraints  */
    if(wr_brust_e == WRAP)
        wr_addr == int'(wr_addr/2**wr_size) * (2**wr_size);

  }
  constraint WRITE_STRB   { foreach(wr_strob[i])
                            {
                              wr_strob[i] == '1;
                            }
                          }
 int wcontainer_size;
 int rcontainer_size;
//This will calculate the boundry for one transfer  
  function int w_wrap_boundry ();
    wcontainer_size = (1<<wr_size) * (wr_len+1);
    return int'(wr_addr/wcontainer_size) * wcontainer_size;
  endfunction

  function int r_wrap_boundry ();
    rcontainer_size = (1<<rd_size) * (rd_len+1);
    return int'(rd_addr/rcontainer_size) * rcontainer_size;
  endfunction

endclass  : axi_mas_seq_item 

`endif 
