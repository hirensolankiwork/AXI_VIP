
////////////////////////////////////////////////////////////////////////
//devloper name : siddharth 
//date   :  24/07/2023
//Description : 
//////////////////////////////////////////////////////////////////////



class axi_scoreboard extends uvm_scoreboard;


`uvm_component_utils(axi_scoreboard)


// For 2 write method implement this decl meaco use
   `uvm_analysis_imp_decl(_master)
   `uvm_analysis_imp_decl(_slave)

 //2 analysis port 1 from master and 1 from slave monitor  
 uvm_analysis_imp_master #(axi_trans,axi_scoreboard) mas_mon2sb_imp;
   uvm_analysis_imp_slave #(axi_trans,axi_scoreboard) slv_mon2sb_imp;


////////////////////////////////////////////////////////////////////////
//Method name : constructor new
//Arguments   :  str and parent
//Description : this method will be called when the environment call create method 
//////////////////////////////////////////////////////////////////////
function new(string str = "axi_scoreboard",uvm_component parent);
   super.new(str,parent);

endfunction



////////////////////////////////////////////////////////////////////////
//Method name : build phase
//Arguments   :  phase
//Description : this method will create implemation ports
//////////////////////////////////////////////////////////////////////

function void build_phase(uvm_phase phase);
super.build_phase(phase); 
mas_mon2sb_imp = new("mas_mon2sb_imp",this);
slv_mon2sb_imp = new("slv_mon2sb_imp",this);

`uvm_info("", " Scoreboard Build Phase", UVM_DEBUG)
endfunction





////////////////////////////////////////////////////////////////////////
//Method name : write_master
//Arguments   : axi_trans 
//Description : it will take tr_h transaction from master monitor
//////////////////////////////////////////////////////////////////////
function void write_master(axi_trans tr_h);
`uvm_info(get_type_name(),"Inside the master Write_master task",UVM_DEBUG);

endfunction



////////////////////////////////////////////////////////////////////////
//Method name : write_slave
//Arguments   :  axi_trans 
//Description : it will take tr_h transaction from slave master 
//////////////////////////////////////////////////////////////////////
function void write_slave(axi_trans tr_h);
`uvm_info(get_type_name(),"inside slave write function",UVM_DEBUG);


endfunction

endclass
