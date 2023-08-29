/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 28-08-2023 17:09:57
// File Name   	  : axi_mas_mon.sv
// Class Name 	  : axi_mas_mon 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_MON_SV
`define AXI_MAS_MON_SV

//--------------------------------------------------------------------------
// class  : axi_mas_mon 
//--------------------------------------------------------------------------
class axi_mas_mon extends uvm_sequencer;

//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_mon)

//new counstructore declaration.
  function new(string name="axi_mas_mon",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  axi_mas_seq_item trans_h;                       //Taking the tarantection packet to send it to the score board.
  virtual axi_inf m_vif;                          //Tacking interface to convey my packet level info to pin level.
  uvm_analysis_port #(axi_mas_seq_item) m_mon_ap; //Taking the analysis port.
  int mem_awid [$];
  int mem_arid [$];
  int temp_q   [$];
  int temp_q1   [$];
//--------------------------------------------------------------------------
// Function  : Build Phase  
//--------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    m_mon_ap = new("m_mon_ap",this);
    `uvm_info(get_name(),"Ending of Build Phase",UVM_DEBUG)
  endfunction

//--------------------------------------------------------------------------
// Task  : Run Phase  
//--------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Run Phase",UVM_DEBUG)
    `uvm_info(get_name(),"Before Forever loop start",UVM_DEBUG)
    forever begin
    `uvm_info(get_name(),"Starting of Forever loop",UVM_DEBUG)
      fork
        begin
          trans_h = axi_mas_seq_item::type_id::create("trans_h");
          monitore(trans_h);
        end
        begin
          @(negedge m_vif.arstn);
        end
      join_any
      disable fork;
      if(!m_vif.arstn)
        @(posedge m_vif.arstn);
    end
    `uvm_info(get_name(),"End of Forever loop",UVM_DEBUG)
  endtask 
//--------------------------------------------------------------------------
// Task  : Monitore 
//--------------------------------------------------------------------------
  task monitore(axi_mas_seq_item trans_h);
    `uvm_info(get_name(),"Starting of Monitore",UVM_DEBUG)
    @(posedge m_vif.aclk);
    fork
      forever begin
        @(posedge m_vif.aclk);
        if (`MON.awvalid && `MON.awready)begin
          `uvm_info(get_name(),"Write Addr Chennal Handshak",UVM_DEBUG)
          trans_h.awr_id     = `MON.awid;
          mem_awid.push_back(`MON.awid);
          trans_h.wr_addr    = `MON.awaddr;
          trans_h.wr_size    = `MON.awsize;
          trans_h.wr_len     = `MON.awlen;
          trans_h.wr_brust_e = brust_kind_e'(`MON.awbrust);
          m_mon_ap.write(trans_h);
        end
        `uvm_info(get_name(),"After Write Addr Chennal Handshak Write call",UVM_DEBUG)
      end
      forever begin
        @(posedge m_vif.aclk);
        if(`MON.wvalid && `MON.wready)begin
          `uvm_info(get_name(),"Wrire Data Channel Handshak",UVM_DEBUG)
          trans_h.wr_id      = `MON.wid;
          trans_h.wr_data    = new[trans_h.wr_len +1];
          trans_h.wr_strob   = new[trans_h.wr_len +1];

          foreach(trans_h.wr_data[i])begin
            trans_h.wr_data[i]= `MON.wdata;
            trans_h.wr_strob[i]  = `MON.wstrob;
            @(posedge m_vif.aclk);
            if(i != trans_h.wr_len)
              wait(`MON.wvalid && `MON.wready);
            else
              m_mon_ap.write(trans_h);
          end
          //trans_h.print();
        end
        `uvm_info(get_name(),"After  Write Data Channel Handshak Write call",UVM_DEBUG)
      end
      forever begin
        @(posedge m_vif.aclk);
        if(`MON.bready && `MON.bvalid)begin
          `uvm_info(get_name(),"Wrire response Channel Handshake",UVM_DEBUG)
          trans_h.b_valid    = `MON.bvalid;
          temp_q = mem_awid.find_first_index() with (item == `MON.bid);
          $display(mem_awid);
          if(temp_q.size() != 0)begin
            $display(temp_q);
            `uvm_info("BID_CHECKER","The Checker for BID got PASS.",UVM_HIGH)
            foreach(temp_q[i])
              mem_awid.delete(temp_q[i]-i);
          end
          else
            `uvm_error("BID_CHECKER","The Checker for BID got Fail.")
          trans_h.b_id       = `MON.bid;
          trans_h.b_resp_e   = resp_kind_e'(`MON.bresp);
          m_mon_ap.write(trans_h);
        end
        `uvm_info(get_name(),"After  Write Response Channel Handshak Write call",UVM_DEBUG)
      end
      forever begin
        @(posedge m_vif.aclk);
        if(`MON.arready && `MON.arvalid)begin
          `uvm_info(get_name(),"Read Addr Channel Handshake",UVM_DEBUG)
          trans_h.ard_id     = `MON.arid;
          mem_arid.push_back(`MON.arid);
              $display(mem_arid);
          trans_h.rd_addr    = `MON.araddr;
          trans_h.rd_size    = `MON.arsize;
          trans_h.rd_len     = `MON.arlen;
          trans_h.rd_brust_e = brust_kind_e'(`MON.arbrust);
          //trans_h.print();
          m_mon_ap.write(trans_h);
        end
        `uvm_info(get_name(),"After Read Addr Channel Handshake Write call",UVM_DEBUG)
      end
      forever begin
        @(posedge m_vif.aclk);
        if(`MON.rready && `MON.rvalid)begin
          `uvm_info(get_name(),"Read data Channel Handshake",UVM_DEBUG)
          trans_h.r_valid    = `MON.rvalid;
          trans_h.r_id       = `MON.rid;
          for(int i=0; i<=trans_h.rd_len ;i++)begin
            trans_h.rd_data.push_back(`MON.rdata);
            @(posedge m_vif.aclk );
            if(i != trans_h.rd_len)
              wait(`MON.rready && `MON.rvalid);
            else begin
              wait(`MON.rlast);
                temp_q1 = mem_arid.find_first_index() with (item == `MON.rid);
                $display(mem_arid);
                if(temp_q1.size() != 0)begin
                  $display(temp_q1);
                  `uvm_info("RID_CHECKER","The Checker for RID got PASS.",UVM_HIGH)
                  foreach(temp_q1[i])
                    mem_arid.delete(temp_q1[i]-i);
                end
                else
                  `uvm_error("RID_CHECKER","The Checker for RID got Fail.")
                trans_h.r_last = `MON.rlast;
            end
           // trans_h.print();
          end
          trans_h.r_resp_e   = resp_kind_e'(`MON.rresp);
                    m_mon_ap.write(trans_h);
        end
        `uvm_info(get_name(),"After Read data & Response Write call",UVM_DEBUG)
      end
    join
    `uvm_info(get_name(),"After Fork Join ",UVM_DEBUG)
  endtask 

endclass  : axi_mas_mon 

`endif 
