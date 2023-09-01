/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 01-09-2023 10:46:28
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

  virtual axi_inf    m_vif;      //Tacking interface to convey my packet level info to pin level.
  axi_mas_agent_cfg  m_agnt_cfg;
  bit get_item_flag;          //
  REQ trans_h;
  REQ write_addr_req_q[$];
  REQ write_data_req_q[$];
  REQ read_addr_req_q[$];
  REQ write_addr_req;
  REQ write_data_req;
  REQ read_addr_req;
  RSP write_rsp;
  RSP read_rsp;
//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Build Phase",UVM_HIGH)
    super.build_phase(phase);
    if(!uvm_config_db #(axi_mas_agent_cfg)::get(this,
                                                "",
                                                "axi_master_agent_config",
                                                m_agnt_cfg))
      `uvm_fatal("[MASTER_CONFIG]","m_agnt_cfg can not get in master driver class");
    `uvm_info(get_full_name(),"Ending of Build Phase",UVM_HIGH)
  endfunction
//--------------------------------------------------------------------------
// Task : clear
//--------------------------------------------------------------------------
  task clear();
    `uvm_info(get_full_name(),"Start of clear task",UVM_DEBUG)
    if(!m_vif.arstn)begin
      `uvm_info(get_full_name(),"[clear task]: reset aserted",UVM_HIGH)
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

     //Wait for reset deassert.
      if(get_item_flag)begin
        `uvm_info(get_full_name(),"[clear task]: After Get Next Item Inside reset",UVM_HIGH)
       //TODO: use array size.
       $display("wr_addr array size %d",write_addr_req_q.size());
       $display("wr_data array size %d",write_data_req_q.size());
       $display("read_addr array size %d",read_addr_req_q.size());
        repeat(write_addr_req_q.size() + 2)begin
          seq_item_port.put(write_rsp);
        end
        repeat(write_data_req_q.size() + 1)begin
          seq_item_port.put(write_rsp);
        end
        repeat(read_addr_req_q.size() + 2)begin
          seq_item_port.put(read_rsp);
        end
        seq_item_port.put(write_rsp);
        seq_item_port.put(read_rsp);
        `uvm_info(get_full_name(),"[clear task]: After Item done",UVM_HIGH)
      end
      write_addr_req_q.delete();
      write_data_req_q.delete();
      read_addr_req_q.delete();
      @(posedge m_vif.arstn);
      `uvm_info(get_full_name(),"[clear task]: reset deasserted",UVM_HIGH)
    end
    `uvm_info(get_full_name(),"Start of clear task",UVM_DEBUG)
  endtask 
//--------------------------------------------------------------------------
// Task  : Run Phase  
//--------------------------------------------------------------------------
/*methode 1:
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_HIGH)
   // `uvm_info(get_name(),"Before Forever loop start",UVM_HIGH)
   @(negedge m_vif.arstn);
   clear(); 
   forever begin 
     `uvm_info(get_full_name(),"Starting of Forever loop",UVM_HIGH)
     fork
       begin
         `uvm_info(get_full_name(),"Before Get Call ",UVM_HIGH)
         seq_item_port.get_next_item(req);
         get_item_flag = 1;
         `uvm_info(get_full_name(),"After Get() Call and Before driver() call ",UVM_HIGH)
         driver(req);
         `uvm_info(get_full_name(),"After driver()",UVM_HIGH)
         seq_item_port.item_done();
         get_item_flag = 0;
       end
       begin
         @(negedge m_vif.arstn);
       end
     join_any
     disable fork;
     clear();
   end
   `uvm_info(get_full_name(),"End of Forever loop",UVM_HIGH) 
  endtask 
*/

//Method 2:
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Starting of Run Phase",UVM_HIGH)
   // `uvm_info(get_name(),"Before Forever loop start",UVM_HIGH)
   clear(); 
   forever begin 
     `uvm_info(get_full_name(),"Starting of Forever loop",UVM_HIGH)
     fork
       driver();
       write_addr_trns();
       write_data_trns();
       write_rsp_trns();
       read_trns();
       read_rsp_trns();
       begin
         @(negedge m_vif.arstn);
       end
     join_any
     disable fork;
     clear();
   end
   `uvm_info(get_full_name(),"End of Forever loop",UVM_HIGH) 
  endtask 

  task driver();
    forever begin
      `uvm_info(get_full_name(),"Before Get Call ",UVM_DEBUG)
      seq_item_port.get(req);
      $cast(trans_h,req.clone());
      trans_h.set_id_info(req);
      `uvm_info(get_full_name(),"After Get Call ",UVM_DEBUG)
      get_item_flag = 1;
      if(trans_h.req_e==WRITE_REQ)begin
        wait(write_addr_req_q.size() < m_agnt_cfg.no_seq_xtn &&
             write_data_req_q.size() < m_agnt_cfg.no_seq_xtn);
        `uvm_info(get_full_name(),"[driver] : WRITE_REQ ",UVM_DEBUG)
        write_addr_req_q.push_back(trans_h);
        write_data_req_q.push_back(trans_h);
        $cast(write_rsp,trans_h.clone());
        write_rsp.set_id_info(trans_h);
      //  write_rsp.set_sequence_id(1);
      end
      else if(trans_h.req_e==READ_REQ)begin
        wait(read_addr_req_q.size() < m_agnt_cfg.no_seq_xtn);
        `uvm_info(get_full_name(),"[driver] : READ_REQ ",UVM_DEBUG)
        read_addr_req_q.push_back(trans_h);
        $cast(read_rsp,trans_h.clone());
        read_rsp.set_id_info(trans_h);
       // read_rsp.set_sequence_id(1);
      end
      else
        `uvm_error(get_full_name(),"[DRIVER] Not walid request")
      get_item_flag = 0;
      m_agnt_cfg.axi_drv_count_h++;
    //TODO: send only five pkt at a tme then get.   
    end
  endtask : driver

  task write_addr_trns(); 
    `uvm_info(get_full_name(), "Inside write_addr_trns()", UVM_DEBUG)
    //Wrire Addres chennal transfer
    forever begin
      `uvm_info(get_full_name(),"[write_addr_trns] : Before wait ",UVM_DEBUG)
      wait(write_addr_req_q.size() != 0);
      `uvm_info(get_full_name(),"[write_addr_trns] : After  wait ",UVM_DEBUG)
      write_addr_req = write_addr_req_q.pop_front();
      `DRV.awid     <= write_addr_req.awr_id;
      `DRV.awaddr   <= write_addr_req.wr_addr;
      `DRV.awsize   <= write_addr_req.wr_size;
      `DRV.awlen    <= write_addr_req.wr_len;
      `DRV.awbrust  <= write_addr_req.wr_brust_e;
      repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
      `DRV.awvalid  <= 1'b1;
      @(posedge m_vif.aclk);
      wait(`DRV.awready == 1'b1);
      `DRV.awvalid  <= 1'b0;
      if(m_agnt_cfg.m_write_interleave)begin
        `DRV.awid     <= write_addr_req.awr_id+2;
        `DRV.awaddr   <= write_addr_req.wr_addr+4;
        `DRV.awsize   <= write_addr_req.wr_size;
        `DRV.awlen    <= write_addr_req.wr_len;
        `DRV.awbrust  <= write_addr_req.wr_brust_e;
        repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
        `DRV.awvalid  <= 1'b1;
        @(posedge m_vif.aclk);
        wait(`DRV.awready == 1'b1);
        `DRV.awvalid  <= 1'b0;
      end
      `uvm_info(get_full_name(),"[write_addr_trns] : EOF ",UVM_DEBUG)
    end
  endtask : write_addr_trns

  task write_data_trns();
    `uvm_info(get_full_name(), "Inside write_data_trns()", UVM_DEBUG)
  //Write data chennal transfer.
  forever begin
    `uvm_info(get_full_name(),"[write_data_trns] : Before wait ",UVM_DEBUG)
    wait(write_data_req_q.size() != 0);
    `uvm_info(get_full_name(),"[write_data_trns] : After  wait ",UVM_DEBUG)
    write_data_req = write_data_req_q.pop_front();
    foreach(write_data_req.wr_data[i]) begin
      `uvm_info(get_full_name(),"[write_addr_trns] : Inside Foreach ",UVM_DEBUG)
      `DRV.wid    <= write_data_req.wr_id;
      `DRV.wdata  <= write_data_req.wr_data[i];
      `DRV.wstrob <= write_data_req.wr_strob[i];
      `DRV.wlast <= (i == write_data_req.wr_len) ? 1'b1 : 1'b0;
      repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
      `DRV.wvalid <= 1'b1;
      @(posedge m_vif.aclk);
      wait(`DRV.wready == 1'b1);
      `DRV.wvalid <= 1'b0;
      `DRV.wlast  <= 1'b0;
      if(m_agnt_cfg.m_write_interleave)begin
        @(posedge m_vif.aclk);
        `DRV.wid    <= write_data_req.wr_id+2;
        `DRV.wdata  <= write_data_req.wr_data[i]+4;
        `DRV.wstrob <= write_data_req.wr_strob[i];
        `DRV.wlast <= (i == write_data_req.wr_len) ? 1'b1 : 1'b0;
        repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
        `DRV.wvalid <= 1'b1;
        @(posedge m_vif.aclk);
        wait(`DRV.wready == 1'b1);
        `DRV.wvalid <= 1'b0;
        `DRV.wlast  <= 1'b0;
      end
    end
    `uvm_info(get_full_name(),"[write_addr_trns] : EOF ",UVM_DEBUG)
  end//wr_data_smp.put(1);
  endtask : write_data_trns

  task write_rsp_trns();  
    `uvm_info(get_full_name(), "Inside write_rsp_trns()", UVM_DEBUG)
  //Write Response chennal transfer.
    forever begin
      `uvm_info(get_full_name(),"[write_rsp_trns] : Before Fork ",UVM_DEBUG)
      repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
      if(!m_agnt_cfg.delay_cycle)
        @(posedge m_vif.aclk);
      `DRV.bready <= 1'b1;
      if(`ASYC_MP.bvalid )begin
        write_rsp.b_resp_e   = resp_kind_e'(`DRV.bresp);
        write_rsp.r_id       = `DRV.rid;
        seq_item_port.put(write_rsp);
      end
      `uvm_info(get_full_name(),"[write_data_trns] : EOF ",UVM_DEBUG)
    end
  endtask : write_rsp_trns
  
  task read_trns();
    `uvm_info(get_full_name(),"Inside read_trns()",UVM_DEBUG)
    forever begin
    `uvm_info(get_full_name(),"[raed_trns] : Before wait ",UVM_DEBUG)
      wait(read_addr_req_q.size() != 0);
    `uvm_info(get_full_name(),"[read_trns] : After  wait",UVM_DEBUG)
      read_addr_req = read_addr_req_q.pop_front();
    //Read address chennal transfer.
      `DRV.arid     <= read_addr_req.ard_id;
      `DRV.araddr   <= read_addr_req.rd_addr;
      `DRV.arsize   <= read_addr_req.rd_size;
      `DRV.arlen    <= read_addr_req.rd_len;
      `DRV.arbrust  <= read_addr_req.rd_brust_e;
      repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
      `DRV.arvalid  <= 1'b1;
      @(posedge m_vif.aclk);
      wait(`DRV.arready == 1'b1);
      `DRV.arvalid  <= 1'b0;
      if(m_agnt_cfg.m_write_interleave)begin
        `DRV.arid     <= read_addr_req.ard_id + 2;
        `DRV.araddr   <= read_addr_req.rd_addr + 4;
        `DRV.arsize   <= read_addr_req.rd_size;
        `DRV.arlen    <= read_addr_req.rd_len;
        `DRV.arbrust  <= read_addr_req.rd_brust_e;
        repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
        `DRV.arvalid  <= 1'b1;
        @(posedge m_vif.aclk);
        wait(`DRV.arready == 1'b1);
        `DRV.arvalid  <= 1'b0;
      end
      `uvm_info(get_full_name(),"[read_trns] : EOF", UVM_DEBUG)
    end
  endtask : read_trns 

  task read_rsp_trns();  
    `uvm_info(get_full_name(), "Inside read_rsp_trns()", UVM_DEBUG)
  //Read data and Respose Chennal
    forever begin 
      `uvm_info(get_full_name(),"[read_trns] : Before Fork", UVM_DEBUG)
      repeat(m_agnt_cfg.delay_cycle)@(posedge m_vif.aclk);
      if(!m_agnt_cfg.delay_cycle)
        @(posedge m_vif.aclk);
     `DRV.rready <= 1'b1;
      if(`ASYC_MP.rvalid && `ASYC_MP.rlast)begin
        read_rsp.r_resp_e   = resp_kind_e'(`DRV.rresp);
        read_rsp.r_id       = `DRV.rid;
        seq_item_port.put(read_rsp);
      end
      `uvm_info(get_full_name(),"[read_trns] : EOF ", UVM_DEBUG)
    end
  endtask : read_rsp_trns

endclass  : axi_mas_drv 

`endif 
