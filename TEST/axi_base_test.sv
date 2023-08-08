/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 07-08-2023 10:44:17
// File Name   	  : axi_base_test.sv
// Class Name 	  : axi_base_test 
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_BASE_TEST_SV
`define AXI_BASE_TEST_SV
//--------------------------------------------------------------------------
// class  : axi_base_test 
//--------------------------------------------------------------------------

class axi_base_test extends uvm_test;

  `uvm_component_utils(axi_base_test)

  axi_mas_env           env_h;
  axi_mas_env_cfg       m_env_cfg_h;
  axi_mas_agent_cfg     m_agent_cfg_h[];
  axi_slave_agent_config      s_agent_cfg_h[];
  axi_slave_env_uvc     env_uvc; 
  uvm_report_server     server_h; 

// no of dut 
  int no_dut = 1;
  
//create the agent
  int has_magent = 1;
  int has_sagent = 1;
  
//enable the coverage collector
  bit has_mcollector=0;
 	bit has_scollector=0;
  
// no of sequence u want run
 	int no_seq_xtn=1;
  
//write out of response & write interleav  
  int write_interleave=0;
  int write_out_order_resp=0;
  
//read out of response & read interleav  
  int read_interleave=0;
  int read_out_order_resp=0;
  

  function new (string name = "axi_base_test", uvm_component parent=null);
	  super.new(name,parent);
  endfunction
  
  function void config_axi();
    if(has_magent)begin
      m_agent_cfg_h = new[no_dut];
      foreach(m_agent_cfg_h[i])begin
        m_agent_cfg_h[i]=axi_mas_agent_cfg::type_id::create($sformatf("m_agent_cfg_h[%0d]",i));
			  if(!uvm_config_db #(virtual axi_inf)::get(this,
                                                  "",
                                                  $sformatf("vif_%0d",i),
                                                  m_agent_cfg_h[i].m_cfg_vif))
          `uvm_fatal("[VIF CONFIG]","cannot get()interface axi_cfg_vif from uvm_config_db. Have you set() it?")
        m_agent_cfg_h[i].is_active = UVM_ACTIVE;
        m_agent_cfg_h[i].m_write_interleave = write_interleave ;
        m_agent_cfg_h[i].m_write_out_order_resp = write_out_order_resp;
        m_agent_cfg_h[i].m_read_interleave = read_interleave ;
        m_agent_cfg_h[i].m_read_out_order_resp = read_out_order_resp;
        m_env_cfg_h.m_agent_cfg_h[i] = m_agent_cfg_h[i]; 
      end
    end
    
/*
    if(has_sagent)begin
      s_agent_cfg_h = new[no_dut];
      foreach(s_agent_cfg_h[i])begin
      s_agent_cfg_h[i]=axi_agent_config::type_id::create($sformatf("s_agentt_cfg_h[%0d]", i));
    /*  if(!uvm_config_db #(virtual axi_interface)::get(this,
                                                      "",
                                                      $sformatf("vif_%0d",i),
                                                      s_agent_cfg_h[i].s_cfg_vif))
        `uvm_fatal("[VIF CONFIG]","cannot get()interface axi_cfg_vif from uvm_config_db. Have you set() it?")
    s_agent_cfg_h[i].is_active = UVM_ACTIVE;
      s_agent_cfg_h[i].s_write_interleave = write_interleave ;
      s_agent_cfg_h[i].s_write_out_order_resp = write_out_order_resp;
      s_agent_cfg_h[i].s_read_interleave = read_interleave ;
      s_agent_cfg_h[i].s_read_out_order_resp = read_out_order_resp;*/
     // m_env_cfg_h.s_agent_cfg_h[i] = s_agent_cfg_h[i];
     // end
   // end
		m_env_cfg_h.no_dut = no_dut;
		m_env_cfg_h.has_magent = has_magent;
		//m_env_cfg_h.has_sagent = has_sagent;
  	m_env_cfg_h.has_mcollector= has_mcollector;
  	m_env_cfg_h.has_scollector= has_scollector;
    m_env_cfg_h.has_scoreboard= 0;
  endfunction : config_axi  

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    m_env_cfg_h = axi_mas_env_cfg::type_id::create("axi_mas_env_cfg_h");
    env_uvc     = axi_slave_env_uvc::type_id::create("env_uvc",this);
    if(has_magent)
      m_env_cfg_h.m_agent_cfg_h = new[no_dut];
		
    //if(has_sagent)
      //m_env_cfg_h.s_agent_cfg_h = new[no_dut];

    config_axi();
    uvm_config_db #(axi_mas_env_cfg)::set(this,
                                             "*",
                                             "axi_mas_env_config",
                                             m_env_cfg_h);
	  env_h = axi_mas_env::type_id::create("env_h",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction 

  
  function void report_phase (uvm_phase phase);
    super.report_phase(phase);
    server_h = uvm_report_server::get_server();
    
    if( !server_h.get_severity_count(UVM_FATAL) && 
        !server_h.get_severity_count(UVM_ERROR)) begin

      $display("///////////////////////////////////\n");
      $display("|                ###              |\n",
               "|               #   #             |\n",
               "|               #   #             |\n",
               "|               #    #            |\n",
               "|      ##########     #####       |\n",
               "|     #          #      # #       |\n", 
               "|    #########     #    # #       |\n", 
               "|   #            #      # #       |\n",
               "|    #########  #       # #       |\n",
               "|     #          #      # #       |\n",
               "|      ####################       |\n");
      $display("///////////////////////////////////\n");
    end
    else begin
      $display("///////////////////////////////////\n");
      $display("|      ####################       |\n",
               "|     #          #      # #       |\n",
               "|    #########     #    # #       |\n",
               "|   #            #      # #       |\n",
               "|    #########  #       # #       |\n",
               "|     #          #      # #       |\n",
               "|      ###########     ####       |\n",
               "|                #    #           |\n",
               "|                #   #            |\n",
               "|                #   #            |\n",
               "|                 ###             |\n");
      $display("///////////////////////////////////\n");
    end
  endfunction



endclass 

`endif 
