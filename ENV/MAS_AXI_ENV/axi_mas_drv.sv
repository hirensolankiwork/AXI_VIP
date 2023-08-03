/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 03-08-2023 12:09:00
// File Name   	  : axi_mas_drv.sv
// Class Name 	  : axi_mas_drv 
// Project Name	  : AXI_3 VIP
// Description	  : This is the Driver components which is responceble to
// take the sequence item from the sequencer and convert it into the pin level
// and route it to the interfac and acknoleg the sequencer.
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_DRV_SV
`define AXI_MAS_DRV_SV

//--------------------------------------------------------------------------
// class  : axi_mas_drv 
//--------------------------------------------------------------------------
class axi_mas_drv extends uvm_driver #(axi_mas_seq_item);

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_drv)

//new counstructore declaration.
  function new(string name="axi_mas_drv",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  virtual axi_inf m_vif;      //Tacking interface to convey my packet level info to pin level.
  bit get_item_flag;          //
  REQ write_req[$];
  REQ read_req[$];
  RSP write_rsp;
  RSP read_rsp;
//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_DEBUG)
  endfunction
//--------------------------------------------------------------------------
// Task : clear
//--------------------------------------------------------------------------
  task clear();
    `uvm_info(get_full_name(),"Start of clear task",UVM_DEBUG)
    if(!m_vif.arstn)begin
      `uvm_info(get_full_name(),"[clear task]: reset aserted",UVM_DEBUG)
      `ASYC_MP.awid   <= 'b0;
      `ASYC_MP.awaddr <= 'b0;
      `ASYC_MP.awbrust<= 'b0;
      `ASYC_MP.awsize <= 'b0;
      `ASYC_MP.awlen  <= 'b0;
      `ASYC_MP.awlock <= 'b0;
      `ASYC_MP.awprot <= 'b0;
      `ASYC_MP.awcache<= 'b0;
      `ASYC_MP.awvalid<= 'b0;
      `ASYC_MP.wid    <= 'b0;
      `ASYC_MP.wdata  <= 'b0;
      `ASYC_MP.wstrob <= 'b0;
      `ASYC_MP.wlast  <= 'b0;
      `ASYC_MP.wvalid <= 'b0;
      `ASYC_MP.bready <= 'b0;
      `ASYC_MP.arid   <= 'b0;
      `ASYC_MP.araddr <= 'b0;
      `ASYC_MP.arbrust<= 'b0;
      `ASYC_MP.arsize <= 'b0;
      `ASYC_MP.arlen  <= 'b0;
      `ASYC_MP.arlock <= 'b0;
      `ASYC_MP.arprot <= 'b0;
      `ASYC_MP.arcache<= 'b0;
      `ASYC_MP.arvalid<= 'b0;
      `ASYC_MP.rready <= 'b0;
      write_req.delete();
      read_req.delete();
      //Wait for reset deassert.
      if(get_item_flag)begin
        `uvm_info(get_full_name(),"[clear task]: After Get Next Item Inside reset",UVM_DEBUG)
        seq_item_port.item_done();
        `uvm_info(get_full_name(),"[clear task]: After Item done",UVM_DEBUG)
      end
      @(posedge m_vif.arstn);
      `uvm_info(get_full_name(),"[clear task]: reset deasserted",UVM_DEBUG)
    end
    `uvm_info(get_full_name(),"Start of clear task",UVM_DEBUG)
  endtask 
//--------------------------------------------------------------------------
// Task  : Run Phase  
//--------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_DEBUG)
   // `uvm_info(get_name(),"Before Forever loop start",UVM_DEBUG)
   @(negedge m_vif.arstn);
   clear(); 
   forever begin 
     `uvm_info(get_full_name(),"Starting of Forever loop",UVM_DEBUG)
     fork
       begin
         `uvm_info(get_full_name(),"Before Get Call ",UVM_DEBUG)
         seq_item_port.get(req);
         get_item_flag = 1;
         `uvm_info(get_full_name(),"After Get() Call and Before driver() call ",UVM_DEBUG)
         driver(req);
         `uvm_info(get_full_name(),"After driver()",UVM_DEBUG)
         get_item_flag = 0;
       end
       begin
         @(negedge m_vif.arstn);
       end
     join_any
     disable fork;
     clear();
   end
   `uvm_info(get_full_name(),"End of Forever loop",UVM_DEBUG) 
  endtask 
  task driver(REQ req);
    fork
    //Write Response chennal transfer.
      forever begin
        fork : BREADY_RSP
          begin
            @(posedge m_vif.aclk)
            `DRV.bready <= 1'b1;
          end
          begin
            @(negedge `DRV.bvalid)
            `DRV.bready <= 1'b0;
          end
        join_any
        disable BREADY_RSP;
      end
    //Read data and Respose Chennal
      forever begin
        fork : RREADY_RSP
          begin
            @(posedge m_vif.aclk)
            `DRV.rready <= 1'b1;
          end
          begin
            @(negedge `DRV.rvalid)
            `DRV.rready <= 1'b0;
          end
        join_any
        disable RREADY_RSP;
      end
    join_none

      @(posedge m_vif.aclk);
      fork
        if(req.req_e==WRITE_REQ)begin
          write_req.push_back(req);
          write_trns();
        end
        if(req.req_e==READ_REQ)begin
          read_req.push_back(req);
          read_trns();
        end
      join
  endtask 

  task write_trns(); 
    wait(write_req.size() != 0);
    req = write_req.pop_front();
    fork
    `uvm_info(get_full_name(), "Inside write trns()", UVM_DEBUG)
    //Wrire Addres chennal transfer
      begin
        `DRV.awid     <= req.awr_id;
        `DRV.awaddr   <= req.wr_addr;
        `DRV.awsize   <= req.wr_size;
        `DRV.awlen    <= req.wr_len;
        `DRV.awbrust  <= req.wr_brust_e;
        `DRV.awvalid  <= 1'b1;
        wait(`DRV.awready == 1'b1);
        @(posedge m_vif.aclk);
        `DRV.awvalid  <= 1'b0;
      end
    //Write data chennal transfer.
      begin
        foreach(req.wr_data[i]) begin
          `DRV.wid    <= req.wr_id;
          `DRV.wvalid <= 1'b1;
          `DRV.wdata  <= req.wr_data[i];
          `DRV.wstrob <= req.wr_strob[i];
          `DRV.wlast <= (i == req.wr_len) ? 1'b1 : 1'b0;
          wait(`DRV.wready == 1'b1);
          @(posedge m_vif.aclk);
          `DRV.wvalid <= 1'b0;
          `DRV.wlast  <= 1'b0;
        end
      end
      wait(`DRV.bvalid);
    join
  endtask

  task read_trns();
    wait(read_req.size() != 0);
    req = read_req.pop_front();
    `uvm_info(get_full_name(), "Inside read_trns()", UVM_DEBUG)
    fork
    //Read address chennal transfer.
      begin
        `DRV.arid     <= req.ard_id;
        `DRV.araddr   <= req.rd_addr;
        `DRV.arsize   <= req.rd_size;
        `DRV.arlen    <= req.rd_len;
        `DRV.arbrust  <= req.rd_brust_e;
        `DRV.arvalid  <= 1'b1;
        wait(`DRV.arready == 1'b1);
        @(posedge m_vif.aclk);
        `DRV.arvalid  <= 1'b0;
      end
      wait(`DRV.rvalid && `DRV.rlast);
    join
  endtask 
endclass  : axi_mas_drv 

`endif 
