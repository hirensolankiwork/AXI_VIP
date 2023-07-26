/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 26-07-2023 12:57:34
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

  axi_mas_base_seqs     mseqs_h;
  axi_slave_base_seq    sseqs_h;
  axi_env               env_h;
  uvm_report_server     server_h; 


  function new (string name = "axi_base_test", uvm_component parent=null);
	  super.new(name,parent);
  endfunction
   
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
	  env_h = axi_env::type_id::create("env_h",this);
  endfunction
  
  task run_phase (uvm_phase phase);
    phase.raise_objection(this);
      fork
        begin
		      mseqs_h = axi_mas_base_seqs::type_id::create("mseqs_h");
		      void'(mseqs_h.randomize());
		      mseqs_h.start(env_h.magent_h.mseqr_h);
		    end
		    begin
		      sseqs_h = axi_slave_base_seq::type_id::create("sseqs_h");
          sseqs_h.start(env_h.sagent_h.slv_seqr);
		    end 
      join
   // phase.phase_done.set_drain_time(this, 50) ;
	  phase.drop_objection(this);
  endtask

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
