onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_tb_top/m_inf/aclk
add wave -noupdate /axi_tb_top/m_inf/arstn
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awid
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awaddr
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awlen
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awsize
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awbrust
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awready
add wave -noupdate -height 24 -expand -group {Write Address Channel} /axi_tb_top/m_inf/awvalid
add wave -noupdate -height 24 -expand -group {Write Data Chennal} /axi_tb_top/m_inf/wid
add wave -noupdate -height 24 -expand -group {Write Data Chennal} /axi_tb_top/m_inf/wdata
add wave -noupdate -height 24 -expand -group {Write Data Chennal} /axi_tb_top/m_inf/wstrob
add wave -noupdate -height 24 -expand -group {Write Data Chennal} /axi_tb_top/m_inf/wlast
add wave -noupdate -height 24 -expand -group {Write Data Chennal} /axi_tb_top/m_inf/wready
add wave -noupdate -height 24 -expand -group {Write Data Chennal} /axi_tb_top/m_inf/wvalid
add wave -noupdate -height 24 -expand -group {Write Response Chennal} /axi_tb_top/m_inf/bid
add wave -noupdate -height 24 -expand -group {Write Response Chennal} /axi_tb_top/m_inf/bresp
add wave -noupdate -height 24 -expand -group {Write Response Chennal} /axi_tb_top/m_inf/bready
add wave -noupdate -height 24 -expand -group {Write Response Chennal} /axi_tb_top/m_inf/bvalid
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/arid
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/araddr
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/arlen
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/arsize
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/arbrust
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/arready
add wave -noupdate -height 24 -expand -group {Read Address Chennal} /axi_tb_top/m_inf/arvalid
add wave -noupdate -height 24 -expand -group {Read Data & Response Chennal} /axi_tb_top/m_inf/rid
add wave -noupdate -height 24 -expand -group {Read Data & Response Chennal} /axi_tb_top/m_inf/rdata
add wave -noupdate -height 24 -expand -group {Read Data & Response Chennal} /axi_tb_top/m_inf/rresp
add wave -noupdate -height 24 -expand -group {Read Data & Response Chennal} /axi_tb_top/m_inf/rlast
add wave -noupdate -height 24 -expand -group {Read Data & Response Chennal} /axi_tb_top/m_inf/rready
add wave -noupdate -height 24 -expand -group {Read Data & Response Chennal} /axi_tb_top/m_inf/rvalid
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/clk
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/rst
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWADDR
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWLEN
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWSIZE
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWBURST
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWVALID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/AWREADY
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/WID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/WDATA
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/WSTRB
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/WLAST
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/WREADY
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/WVALID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/BID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/BREADY
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/BVALID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/BRESP
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARADDR
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARLEN
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARSIZE
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARBURST
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARVALID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/ARREADY
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/RID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/RDATA
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/RLAST
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/RVALID
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/RREADY
add wave -noupdate -height 24 -expand -group {Slave Interface} /axi_tb_top/s_inf/RRESP
add wave -noupdate -expand /axi_tb_top/m_inf/AXI_RESET_ASSERT
add wave -noupdate -expand /axi_tb_top/m_inf/AXI_AWVALID_DEASSERT
add wave -noupdate -expand /axi_tb_top/m_inf/AXI_WVALID_DEASSERT
add wave -noupdate -expand /axi_tb_top/m_inf/AXI_ARVALID_DEASSERT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
configure wave -valuecolwidth 76
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
WaveRestoreZoom {0 ns} {104 ns}
