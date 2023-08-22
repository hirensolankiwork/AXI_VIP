/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 22-08-2023 15:32:41
// File Name   	  : axi_mas_sb.sv
// Class Name 	  : axi_mas_sb 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_MAS_SB_SV
`define AXI_MAS_SB_SV

//--------------------------------------------------------------------------
// class  : axi_mas_sb 
//--------------------------------------------------------------------------
class axi_mas_sb extends uvm_scoreboard;
//UVM Fectory registretion.
//uvm_sequencer is Component that's why we are using `uvm_component_utils macro.
  `uvm_component_utils(axi_mas_sb)

  axi_mas_seq_item mact_q[$];
  axi_mas_seq_item mact_h;
  axi_mas_seq_item mexpt_q[$];
  axi_mas_seq_item mexpt_h;

  int mem [int];

  int pass,fail;

// Add necessary TLM exports to receive transactions from other
// components and instantiat them in build_phase
  uvm_analysis_imp #(axi_mas_seq_item,axi_mas_sb) m_mon_aimp;

//new counstructore declaration.
  function new(string name="axi_mas_sb",uvm_component parent=null);
    super.new(name,parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Build Phase",UVM_DEBUG)
    super.build_phase(phase);
    m_mon_aimp = new("m_mon_aimp",this);
    `uvm_info(get_name(),"End of Build Phase",UVM_DEBUG)
  endfunction 

//--------------------------------------------------------------------------
// Function  : write
//--------------------------------------------------------------------------
  function void write(axi_mas_seq_item trans_h);
    `uvm_info(get_name(),"Starting of write_mon",UVM_DEBUG)
    //trans_h.print();
    mact_q.push_back(trans_h);
    pridict_data(trans_h);
    `uvm_info(get_name(),"End of write_mon",UVM_DEBUG)
  endfunction 

//--------------------------------------------------------------------------
// Task : run phase
//--------------------------------------------------------------------------

  task run_phase(uvm_phase phase);
    `uvm_info(get_name(),"Starting of Run Phase",UVM_DEBUG)
    `uvm_info(get_name(),"Before Forever loop start",UVM_DEBUG)
    forever begin
    `uvm_info(get_name(),"Starting of Forever loop",UVM_DEBUG)
      wait( mexpt_q.size != 0);
      wait( mact_q.size !=0);
      mact_h = mact_q.pop_front();
      mexpt_h = mexpt_q.pop_front();
    `uvm_info(get_name(),"After wait.",UVM_DEBUG)
      check_data(mact_h,mexpt_h);
    end
    `uvm_info(get_name(),"End of Forever loop",UVM_DEBUG)
  endtask
//--------------------------------------------------------------------------
// Task : pridict_data
//--------------------------------------------------------------------------

  function void pridict_data(axi_mas_seq_item trans_h);
    `uvm_info(get_name(),"Start of Pridict data",UVM_DEBUG)
    if(trans_h.req_e==WRITE_REQ)begin
      if(trans_h.wr_brust_e==FIX)begin
        foreach(trans_h.wr_data[i])
          mem[trans_h.wr_addr] = trans_h.wr_data[i];
      end
      else if(trans_h.wr_brust_e==INCR)begin
        foreach(trans_h.wr_data[i])
          mem[trans_h.wr_addr + i*(1<<trans_h.wr_size)] = trans_h.wr_data[i];
      end
      else if(trans_h.wr_brust_e==WRAP)begin
        foreach(trans_h.wr_data[i]) begin
          mem[trans_h.w_wrap_boundry() + i*trans_h.wcontainer_size] = trans_h.wr_data[i];
        end
      end
    end
    else if(trans_h.req_e==READ_REQ)begin
      if(trans_h.rd_brust_e==FIX)begin
        for(int i=0; i <= trans_h.rd_len;i++)begin
          trans_h.rd_data[i] = mem [trans_h.rd_addr];
        end
      end
      else if(trans_h.rd_brust_e==INCR)begin
        for(int i=0; i <= trans_h.rd_len;i++)begin
          trans_h.rd_data[i]=mem[trans_h.rd_addr + i*(1<<trans_h.rd_size)];
        end
      end
      else if(trans_h.rd_brust_e==WRAP)begin
        for(int i=0; i <= trans_h.rd_len;i++)begin
          trans_h.rd_data[i]= mem[trans_h.r_wrap_boundry() + i*trans_h.rcontainer_size]; 
        end
      end
    end
    mexpt_q.push_back(trans_h);
    foreach(mem[i])
      `uvm_info(get_name(),$sformatf("DATA : %h",mem[i]),UVM_DEBUG)
    `uvm_info(get_name(),"End of Pridict data",UVM_DEBUG)
  endfunction

//--------------------------------------------------------------------------
// Task : check_data
//--------------------------------------------------------------------------

  task check_data(axi_mas_seq_item mact_h,axi_mas_seq_item mexpt_h); 
    `uvm_info(get_name(),"Start of Check Data",UVM_HIGH);

    if(mact_h.rd_brust_e==FIX)begin
      for(int i=0; i <= mact_h.rd_len;i++)begin
        if(mexpt_h.rd_data[i] == mem [mact_h.rd_addr]) begin
          `uvm_info(get_name(),"Comparision of R_DATA is Successful.",UVM_LOW)
          `uvm_info(get_name(),
                    $sformatf("| Master R_DATA[%0d] : %0h | Master Expected R_DATA[%0d] : %0h ",i,mem[mact_h.rd_addr],i,mexpt_h.rd_data[i]),
                    UVM_LOW)
          pass++;
        end
        else begin
          `uvm_error(get_name(),$sformatf("Comparision of R_DATA[%d] is Faild.",mexpt_h.rd_data[i]))
          `uvm_info(get_name(),
                    $sformatf("| Master R_DATA[%0d] : %0h | Master Expected R_DATA[%0d] : %0h ",i,mem[mact_h.rd_addr],i,mexpt_h.rd_data[i]),
                    UVM_LOW)
          fail++;
        end
      end
    end
    else if(mact_h.rd_brust_e==INCR)begin
      for(int i=0; i <= mact_h.rd_len;i++)begin
        if(mact_h.rd_data[i]==mem[mact_h.rd_addr + i*(1<<mact_h.rd_size)])begin
          `uvm_info(get_name(),"Comparision of R_DATA is Successful.",UVM_LOW)
          `uvm_info(get_name(),
                    $sformatf("| Master R_DATA[%0d] : %0h | Master Expected R_DATA[%0d] : %0h ",i,mem[mact_h.rd_addr + i*(1<<mact_h.rd_size)],i,mexpt_h.rd_data[i]),
                    UVM_LOW)
          pass++;
        end
        else begin
          `uvm_error(get_name(),$sformatf("Comparision of R_DATA[%d] is Faild.",mexpt_h.rd_data[i]))
          `uvm_info(get_name(),
                    $sformatf("| Master R_DATA[%0d] : %0h | Master Expected R_DATA[%0d] : %0h ",i,mem[mact_h.rd_addr + i*(1<<mact_h.rd_size)],i,mexpt_h.rd_data[i]),
                    UVM_LOW)
          fail++;
        end
      end
    end
    else if(mact_h.rd_brust_e==WRAP)begin
      for(int i=0; i <= mact_h.rd_len;i++)begin
        if(mexpt_h.rd_data[i]== mem[mact_h.r_wrap_boundry() + i*mact_h.rcontainer_size])begin
          `uvm_info(get_name(),"Comparision of R_DATA is Successful.",UVM_LOW)
          `uvm_info(get_name(),
                    $sformatf("| Master R_DATA[%0d] : %0h | Master Expected R_DATA[%0d] : %0h ",i,mem[mact_h.r_wrap_boundry() + i*mact_h.rcontainer_size],i,mexpt_h.rd_data[i]),
                    UVM_LOW)
          pass++;
        end
        else begin
          `uvm_error(get_name(),$sformatf("Comparision of R_DATA[%d] is Faild.",mexpt_h.rd_data[i]))
          `uvm_info(get_name(),
                    $sformatf("| Master R_DATA[%0d] : %0h | Master Expected R_DATA[%0d] : %0h ",i,mem[mact_h.r_wrap_boundry() + i*mact_h.rcontainer_size],i,mexpt_h.rd_data[i]),
                    UVM_LOW)
          fail++;
        end
      end
    end

    `uvm_info(get_name(),"End of Check Data",UVM_HIGH)
  endtask 
endclass 

`endif 
