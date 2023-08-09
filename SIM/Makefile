#Makefile

#RTL := RTL\mux_rtl.sv

TOP :=..\TOP\axi_tb_top.sv	

PKG :=..\ENV\MAS_AXI_ENV\axi_env_pkg.sv ..\TEST\axi_test_pkg.sv

# Top module name change everytime
TOP_M :=axi_tb_top

#runall : lib comp sim
	
runcov :
	lib comp_cov regression html

lib :
	vlib work

# for compiling and view output on command prompt

comp :
	vlog $(PKG) $(TOP) -l axi_comp_log.log +incdir+../ENV/MAS_AXI_ENV +incdir+../ENV/SLV_AXI_ENV +incdir+../TEST

qsim :
	vsim -novopt -assertdebug $(TOP_M) -l axi_run_log.log +UVM_TESTNAME=$1 +UVM_VERBOSITY=$2

sim :
	vsim -novopt -assertdebug $(TOP_M) -l axi_run_log.log -c -do "run -all; exit" +UVM_TESTNAME=$1 +UVM_VERBOSITY=$2

# for coverage report compilation	

comp_cov :
	vlog -coveropt 3 +acc +cover $(TOP) $(PKG) -l axi_cov_log.log

# regression

regression :
	vsim -vopt -coverage $(TOP_M) -l axi_run_idel_log.log -c -do "coverage save -onexit -directive -cvg -codeAll test_idel_con.ucdb; run -all; exit;" +UVM_TESTNAME=mux_base_test
	vsim -vopt -coverage $(TOP_M) -l axi_reset_test_log.log -c -do "coverage save -onexit -directive -cvg -codeAll test_reset_con.ucdb; run -all; exit;" +UVM_TESTNAME=axi_reset_test
	vcover merge main_cov.ucdb test_idel_con.ucdb test_reset_con.ucdb
	vcover report -html -htmldir Coverage main_cov.ucdb 


# for every single test
TEST_CASE_1 :
	vsim -vopt -coverage -assertdebug $(TOP_M) -l axi_run_idel_log.log -c -do "coverage save -onexit -directive -cvg -codeAll test_idel_con.ucdb; run -all; exit;" +UVM_TESTNAME=axi_rand_test

TEST_CASE_2:
	vsim -vopt -coverage -assertdebug $(TOP_M) -l axi_reset_test_log.log -c -do "coverage save -onexit -directive -cvg -codeAll test_reset_con.ucdb; run -all; exit;" +UVM_TESTNAME=axi_reset_test
	
	