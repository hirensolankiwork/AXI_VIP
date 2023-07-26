vlib work
vdel -all
vlib work
vlog ../ENV/axi_env_pkg.sv ../TEST/axi_test_pkg.sv ../TOP/axi_tb_top.sv  -l axi_comp_log.log +incdir+../ENV +incdir+../ENV/MAS_AXI_ENV +incdir+../ENV/SLV_AXI_ENV +incdir+../TEST
vsim -novopt axi_tb_top -l axi_run_log.log +UVM_VERBOSITY=UVM_DEBUG
add wave -r sim:/axi_tb_top/*
run -all

