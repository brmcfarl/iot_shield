// 
// IoT Shield Demo RTL
//
// Author: Matt Staniszewski
// E-mail: matt.staniszewski@intel.com
//
// Copyright (c) 2014, Intel Corporation
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Intel Corporation nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

module iot_shield_demo
  (	
	// A/D Converter
	input [3:0] adc_gpio,
	input adc_sdo,	
	output adc_cs_n,
	output adc_sclk,
	output adc_sdi,
	
	// Clock
	input [1:0] fpga_clk,
	
	// Codec
	inout codec_scl,
	inout codec_sda,
	input codec_bclk,
	input codec_dout,
	input codec_gpio1,
	input codec_wclk,
	output codec_din,
	output codec_reset_n,
	
	// CSI-2
	inout csi_scl,
	inout csi_sda,
	input csi_hs_clk,
	input csi_hs_clk_dbg,
	input [1:0]csi_hs_d,
	input csi_lp_clkp,
	input csi_lp_clkn,
	input [1:0]csi_lp_p,
	input [1:0]csi_lp_n,
	output csi_clk,
	output csi_gpio,
	
	// FPGA <-> CPLD IOs
	input [5:0] fpga_cpld_io,	
	output [1:0] fpga_cpld_clk,
	
	// Galileo Headers
	inout galileo_scl,
	inout galileo_sda,
	input [13:0] galileo_io,
	output [2:1] galileo_5v_oe_n,
	output galileo_rst_n,
	
	// High-Speed Header
	input hshdr_clk1,
	input [2:1] hshdr_diff,
	input [39:0] hshdr_io,
	output [4:1] hshdr_5v_oe_n,
	output hshdr_clk2,
	
	// Low-Speed Headers
	input [7:0] lshdr2_io,
	input [7:0] lshdr1_io,
	input [7:0] lshdr0_io,
	output [2:1] lshdr_5v_oe_n,
	
	// PCI Express (PCIe)
	input [2:1] fpga_coex,
	input fpga_dbg_perst_n,
	input fpga_perst_n,
	input pcie_refclk,
	input pcie_rx,
	output mpcie_dbg_perst_n,
	output pcie_tx,
	output sw_dbg_perst_n,
	
	// PCIe Switch
	inout sw_smbclk,
	inout sw_smbdata,
	input [7:0] sw_gpio,
	
	// USB Controller (USB Blaster II)
	inout [1:0] usb_addr,
	inout [7:0] usb_data,
	inout usb_scl,
	inout usb_sda,
	input usb_clk,
	input usb_oe_n,
	input usb_rd_n,
	input usb_reset_n,
	input usb_wr_n,
	output usb_empty,
	output usb_full,
	
	// User I/O (Buttons, LEDs, Switches)
	input [1:0] user_button,
	input [7:0] user_sw,
	output [7:0] user_led
	
 );
	
   // Clock and quiesce
   wire  clk_125;
   wire  clk_50;
	wire  bus_clk;
	wire  quiesce;

	// Wires related to /dev/xillybus_mem_8
	wire  user_r_mem_8_rden;
	wire  user_r_mem_8_empty;
	wire [7:0] user_r_mem_8_data;
	wire  user_r_mem_8_eof;
	wire  user_r_mem_8_open;
	wire  user_w_mem_8_wren;
	wire  user_w_mem_8_full;
	wire [7:0] user_w_mem_8_data;
	wire  user_w_mem_8_open;
	wire [4:0] user_mem_8_addr;
	wire  user_mem_8_addr_update;

	// Wires related to /dev/xillybus_read_32
	wire  user_r_read_32_rden;
	wire  user_r_read_32_empty;
	wire [31:0] user_r_read_32_data;
	wire  user_r_read_32_eof;
	wire  user_r_read_32_open;

	// Wires related to /dev/xillybus_read_8
	wire  user_r_read_8_rden;
	wire  user_r_read_8_empty;
	wire [7:0] user_r_read_8_data;
	wire  user_r_read_8_eof;
	wire  user_r_read_8_open;

	// Wires related to /dev/xillybus_write_32
	wire  user_w_write_32_wren;
	wire  user_w_write_32_full;
	wire [31:0] user_w_write_32_data;
	wire  user_w_write_32_open;

	// Wires related to /dev/xillybus_write_8
	wire  user_w_write_8_wren;
	wire  user_w_write_8_full;
	wire [7:0] user_w_write_8_data;
	wire  user_w_write_8_open;
	
	// Dummy wires
	wire something, stuff;
	
	// Dummy outputs to be replaced
	assign adc_cs_n = 1'b1;
	assign adc_sclk = 1'b0;
	assign adc_sdi = 1'b0;
	assign codec_din = 1'b0;
	assign codec_reset_n = 1'b0;
	assign csi_clk = 1'b0;
	assign csi_gpio = 1'b0;
	assign fpga_cpld_clk = 2'b00;
	assign galileo_5v_oe_n = 2'b11;
	assign galileo_rst_n = 1'b0;
	assign hshdr_5v_oe_n = 4'hF;
	assign hshdr_clk2 = 1'b0;
	assign lshdr_5v_oe_n = 2'b11;
	assign mpcie_dbg_perst_n = 1'b0;
	assign sw_dbg_perst_n = 1'b0;
	assign usb_empty = 1'b0;
	assign usb_full = 1'b0;
	assign user_led = 8'd0;	
	
	//
	// Additional Cores
	//
	// Below are some other IP cores that may be useful:
	//   
	// I2S - http://opencores.org/project,spdif_interface
	// PWM - http://opencores.org/project,pwm
	// SPI - http://opencores.org/project,spi
	//
	
	
	// PLL to generate clocks needed by the DMA
	pll_100_to_125_50 free_to_pcie_clks (
				.inclk0(fpga_clk[0]),
				.c0(clk_125),
				.c1(clk_50),
				.locked());	// PLL Lock signal not hooked up!

				
	//
	// Xillybus PCIe DMA IP
   //
	xillybus xillybus_ins (

		// Ports related to /dev/xillybus_mem_8
		// FPGA to CPU signals:
		.user_r_mem_8_rden(user_r_mem_8_rden),
		.user_r_mem_8_empty(user_r_mem_8_empty),
		.user_r_mem_8_data(user_r_mem_8_data),
		.user_r_mem_8_eof(user_r_mem_8_eof),
		.user_r_mem_8_open(user_r_mem_8_open),

		// CPU to FPGA signals:
		.user_w_mem_8_wren(user_w_mem_8_wren),
		.user_w_mem_8_full(user_w_mem_8_full),
		.user_w_mem_8_data(user_w_mem_8_data),
		.user_w_mem_8_open(user_w_mem_8_open),

		// Address signals:
		.user_mem_8_addr(user_mem_8_addr),
		.user_mem_8_addr_update(user_mem_8_addr_update),

		// Ports related to /dev/xillybus_read_32
		// FPGA to CPU signals:
		.user_r_read_32_rden(user_r_read_32_rden),
		.user_r_read_32_empty(user_r_read_32_empty),
		.user_r_read_32_data(user_r_read_32_data),
		.user_r_read_32_eof(user_r_read_32_eof),
		.user_r_read_32_open(user_r_read_32_open),

		// Ports related to /dev/xillybus_read_8
		// FPGA to CPU signals:
		.user_r_read_8_rden(user_r_read_8_rden),
		.user_r_read_8_empty(user_r_read_8_empty),
		.user_r_read_8_data(user_r_read_8_data),
		.user_r_read_8_eof(user_r_read_8_eof),
		.user_r_read_8_open(user_r_read_8_open),

		// Ports related to /dev/xillybus_write_32
		// CPU to FPGA signals:
		.user_w_write_32_wren(user_w_write_32_wren),
		.user_w_write_32_full(user_w_write_32_full),
		.user_w_write_32_data(user_w_write_32_data),
		.user_w_write_32_open(user_w_write_32_open),

		// Ports related to /dev/xillybus_write_8
		// CPU to FPGA signals:
		.user_w_write_8_wren(user_w_write_8_wren),
		.user_w_write_8_full(user_w_write_8_full),
		.user_w_write_8_data(user_w_write_8_data),
		.user_w_write_8_open(user_w_write_8_open),

		// General signals
		.clk_125(clk_125),
		.clk_50(clk_50),
		.pcie_perstn(fpga_perst_n),
		.pcie_refclk(pcie_refclk),
		.pcie_rx(pcie_rx),
		.bus_clk(bus_clk),
		.pcie_tx(pcie_tx),
		.quiesce(quiesce),
		.user_led()	//ms: no leds hooked up
	);
  
  
  //
  // Demo Application Logic (loopback FIFOs)
  //
  
//   // A simple inferred RAM
//   always @(posedge bus_clk)
//     begin
//	if (user_w_mem_8_wren)
//	  demoarray[user_mem_8_addr] <= user_w_mem_8_data;
//	
//	if (user_r_mem_8_rden)
//	  user_r_mem_8_data <= demoarray[user_mem_8_addr];	  
//     end
//
//   assign  user_r_mem_8_empty = 0;
//   assign  user_r_mem_8_eof = 0;
//   assign  user_w_mem_8_full = 0;
//
//   // 32-bit loopback
//   scfifo fifo_32 ( // 32x512 words
//		    .clock (bus_clk),
//		    .data (user_w_write_32_data),
//		    .rdreq (user_r_read_32_rden),
//		    .sclr (!user_w_write_32_open && !user_r_read_32_open),
//		    .wrreq (user_w_write_32_wren),
//		    .empty (user_r_read_32_empty),
//		    .full (user_w_write_32_full),
//		    .q (user_r_read_32_data),
//		    .aclr (),
//		    .almost_empty (),
//		    .almost_full (),
//		    .usedw ());
//   defparam
//	   fifo_32.add_ram_output_register = "OFF",
//	   fifo_32.lpm_numwords = 512,
//	   fifo_32.lpm_showahead = "OFF",
//	   fifo_32.lpm_type = "scfifo",
//	   fifo_32.lpm_width = 32,
//	   fifo_32.lpm_widthu = 9,
//	   fifo_32.overflow_checking = "ON",
//	   fifo_32.underflow_checking = "ON",
//	   fifo_32.use_eab = "ON";
//   
//   assign  user_r_read_32_eof = 0;
//
//   // 8-bit loopback
//   scfifo fifo_8 ( // 8x2048 words
//		   .clock (bus_clk),
//		   .data (user_w_write_8_data),
//		   .rdreq (user_r_read_8_rden),
//		   .sclr (!user_w_write_8_open && !user_r_read_8_open),
//		   .wrreq (user_w_write_8_wren),
//		   .empty (user_r_read_8_empty),
//		   .full (user_w_write_8_full),
//		   .q (user_r_read_8_data),
//		   .aclr (),
//		   .almost_empty (),
//		   .almost_full (),
//		   .usedw ());
//   defparam
//	   fifo_8.add_ram_output_register = "OFF",
//	   fifo_8.lpm_numwords = 2048,
//	   fifo_8.lpm_showahead = "OFF",
//	   fifo_8.lpm_type = "scfifo",
//	   fifo_8.lpm_width = 8,
//	   fifo_8.lpm_widthu = 11,
//	   fifo_8.overflow_checking = "ON",
//	   fifo_8.underflow_checking = "ON",
//	   fifo_8.use_eab = "ON";
//   
//   assign  user_r_read_8_eof = 0;
	
	
	//
	// VLSI Plus CSI-2 Receiver IP (Coming soon!)
	//
	//ms: TBD
	
	//
	// Glue Logic (between CSI and PCIe)
	//
	assign something = stuff;	//ms: feel free to modify, I think this needs more work :-)

	
endmodule
