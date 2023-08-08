quit -sim
vlib work
vdel -all
vlib work
vlog ../ENV/MAS_AXI_ENV/axi_mas_env_pkg.sv ../TEST/axi_test_pkg.sv ../TOP/axi_tb_top.sv  -l axi_comp_log.log +incdir+../ENV/MAS_AXI_ENV +incdir+../ENV/SLV_AXI_ENV +incdir+../TEST
vsim -novopt axi_tb_top -l axi_run_log.log +UVM_VERBOSITY=UVM_DEBUG +UVM_TESTNAME=axi_reset_test
do wave.do
run -all

