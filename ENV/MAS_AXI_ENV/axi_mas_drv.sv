/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 26-07-2023 12:40:41
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
//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_DEBUG)
  endfunction

//--------------------------------------------------------------------------
// Task  : Run Phase  
//--------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_DEBUG)
   // `uvm_info(get_full_name(),"Before Forever loop start",UVM_DEBUG)
   forever begin 
    `uvm_info(get_full_name(),"Starting of Forever loop",UVM_DEBUG)
      fork
        begin
          `uvm_info(get_full_name(),"Before Get Next Item ",UVM_DEBUG)
          seq_item_port.get_next_item(req);
          `uvm_info(get_full_name(),"After Get Next Item and Before Send to DUT ",UVM_DEBUG)
          send_to_dut(req);
          `uvm_info(get_full_name(),"After Send to DUT and Before Finish Item",UVM_DEBUG)
          seq_item_port.item_done();
          `uvm_info(get_full_name(),"After Finish Item",UVM_DEBUG)
        end
        begin
          @(negedge m_vif.arstn);
        end
      join_any
      disable fork;
      if(!m_vif.arstn)begin
        `DRV.awvalid <= 1'b0;
        `DRV.wvalid  <= 1'b0;
        `DRV.bready  <= 1'b0;
        `DRV.arvalid <= 1'b0;
        `DRV.rready  <= 1'b0;
      //Wait for reset deassert.
       @(posedge m_vif.arstn);
     end
   end
   `uvm_info(get_full_name(),"End of Forever loop",UVM_DEBUG) 
  endtask 
  task send_to_dut(axi_mas_seq_item req); 
    @(posedge m_vif.aclk);
    fork
      //Wrire Addres chennal transfer
      begin
        `DRV.awvalid  <= 1'b1;
        `DRV.awid     <= req.awr_id;
        `DRV.awaddr   <= req.wr_addr;
        `DRV.awsize   <= req.wr_size;
        `DRV.awlen    <= req.wr_len;
        `DRV.awbrust  <= req.wr_brust_e;
        wait(`DRV.awready == 1'b1);
        @(posedge m_vif.aclk);
        `DRV.awvalid  <= 1'b0;
      end
      //Write data chennal transfer.
      begin
        `DRV.wid    <= req.wr_id;
        foreach(req.wr_data[i]) begin
          `DRV.wvalid <= 1'b1;
          `DRV.wdata  <= req.wr_data[i];
          `DRV.wstrob <= req.wr_strob;
           if(i==req.wr_len)
            `DRV.wlast <= 1'b1;
           else
            `DRV.wlast <= 1'b0;
          wait(`DRV.wready == 1'b1);
          @(posedge m_vif.aclk);
          `DRV.wvalid <= 1'b0;
         end
      end
      //Write Response chennal transfer.
      begin
        `DRV.bready <= 1'b1;  
        wait(`DRV.bvalid== 1'b1);
        @(posedge m_vif.aclk);
        `DRV.bready <= 1'b0;
      end
      //Read address chennal transfer.
      begin
        `DRV.arvalid  <= 1'b1;
        `DRV.arid     <= req.ard_id;
        `DRV.araddr   <= req.rd_addr;
        `DRV.arsize   <= req.rd_size;
        `DRV.arlen    <= req.rd_len;
        `DRV.arbrust  <= req.rd_brust_e;
        wait(`DRV.arready == 1'b1);
        @(posedge m_vif.aclk);
        `DRV.arvalid  <= 1'b0;
      end
      //Read data and Respose Chennal
      begin
        `DRV.rready <= 1'b1;  
        wait(`DRV.rvalid== 1'b1 || `DRV.rlast == 1'b1);
        @(posedge m_vif.aclk);
        `DRV.rready <= 1'b0;
      end
    join
  endtask 
endclass  : axi_mas_drv 

`endif 
