onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_tb_top/inf/aclk
add wave -noupdate /axi_tb_top/inf/arstn
add wave -noupdate /axi_tb_top/inf/awid
add wave -noupdate /axi_tb_top/inf/awaddr
add wave -noupdate /axi_tb_top/inf/awlen
add wave -noupdate /axi_tb_top/inf/awsize
add wave -noupdate /axi_tb_top/inf/awbrust
add wave -noupdate /axi_tb_top/inf/awready
add wave -noupdate /axi_tb_top/inf/awvalid
add wave -noupdate /axi_tb_top/inf/wid
add wave -noupdate /axi_tb_top/inf/wdata
add wave -noupdate /axi_tb_top/inf/wstrob
add wave -noupdate /axi_tb_top/inf/wlast
add wave -noupdate /axi_tb_top/inf/wready
add wave -noupdate /axi_tb_top/inf/wvalid
add wave -noupdate /axi_tb_top/inf/bid
add wave -noupdate /axi_tb_top/inf/bresp
add wave -noupdate /axi_tb_top/inf/bready
add wave -noupdate /axi_tb_top/inf/bvalid
add wave -noupdate /axi_tb_top/inf/arid
add wave -noupdate /axi_tb_top/inf/araddr
add wave -noupdate /axi_tb_top/inf/arlen
add wave -noupdate /axi_tb_top/inf/arsize
add wave -noupdate /axi_tb_top/inf/arbrust
add wave -noupdate /axi_tb_top/inf/arready
add wave -noupdate /axi_tb_top/inf/arvalid
add wave -noupdate /axi_tb_top/inf/rid
add wave -noupdate /axi_tb_top/inf/rdata
add wave -noupdate /axi_tb_top/inf/rresp
add wave -noupdate /axi_tb_top/inf/rlast
add wave -noupdate /axi_tb_top/inf/rready
add wave -noupdate /axi_tb_top/inf/rvalid
add wave -noupdate /axi_tb_top/inf/mas_drv_cb/mas_drv_cb_event
add wave -noupdate /axi_tb_top/inf/mas_mon_cb/mas_mon_cb_event
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {54 ns}
