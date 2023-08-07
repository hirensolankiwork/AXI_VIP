/////////////////////////////////////////////////////////////////////////
// Company		    : SCALEDGE 
// Engineer		    : ADITYA MISHRA 
// Create Date    : 24-07-2023
// Last Modifiey  : 06-08-2023 19:21:45
// File Name   	  : axi_define.sv
// Class Name 	  : axi_define
// Project Name	  : AXI_3 VIP
// Description	  : 
//////////////////////////////////////////////////////////////////////////

`ifndef AXI_DEF_SV
`define AXI_DEF_SV

`define WR_ID_WIDTH           4                   //Write id Width is recomended 4 bit 
`define WR_ADDR_WIDTH        32                   //Write Address Width can be 8,16,32,64,128,256,512 or 1024 bits.
`define WR_ADDR_LEN           4                   //Write Address widths lenth is fix 4 bit
`define WR_ADDR_SIZE          3                   //Write Address width size is fix 3 bit 
`define WR_DATA_WIDTH        32                   //Write Data width is started from 2 to 1024 bits.
`define WR_STROBE            `WR_ADDR_WIDTH/8     //Write strobe length is depend on address width
`define RD_ID_WIDTH           4                   //Read id Width is recomended 4 bit 
`define RD_ADDR_WIDTH        32                   //Read Address Width can be 8,16,32,64,128,256,5
`define RD_ADDR_LEN           4                   //Read Address widths lenth is fix 4 bit
`define RD_ADDR_SIZE          3                   //Read Address width size is fix 3 bit 
`define RD_DATA_WIDTH        32                   //Read Data width is started from 2 to 1024 bits
                                                 

//Macro
`define DRV m_vif.mas_drv_cb
`define MON m_vif.mas_mon_cb
`define ASYC_MP m_vif.async_reset


`endif 
