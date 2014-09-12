// altera message_off 10230 10335
`timescale 1ns / 10ps

module xillybus(clk_125, clk_50, pcie_perstn, pcie_refclk, pcie_rx, pcie_tx,
  bus_clk, quiesce, user_led, user_r_read_32_rden, user_r_read_32_data,
  user_r_read_32_empty, user_r_read_32_eof, user_r_read_32_open,
  user_w_write_32_wren, user_w_write_32_data, user_w_write_32_full,
  user_w_write_32_open, user_r_read_8_rden, user_r_read_8_data,
  user_r_read_8_empty, user_r_read_8_eof, user_r_read_8_open,
  user_w_write_8_wren, user_w_write_8_data, user_w_write_8_full,
  user_w_write_8_open, user_r_mem_8_rden, user_r_mem_8_data,
  user_r_mem_8_empty, user_r_mem_8_eof, user_r_mem_8_open, user_w_mem_8_wren,
  user_w_mem_8_data, user_w_mem_8_full, user_w_mem_8_open, user_mem_8_addr,
  user_mem_8_addr_update);

  input  clk_125;
  input  clk_50;
  input  pcie_perstn;
  input  pcie_refclk;
  input  pcie_rx;
  input [31:0] user_r_read_32_data;
  input  user_r_read_32_empty;
  input  user_r_read_32_eof;
  input  user_w_write_32_full;
  input [7:0] user_r_read_8_data;
  input  user_r_read_8_empty;
  input  user_r_read_8_eof;
  input  user_w_write_8_full;
  input [7:0] user_r_mem_8_data;
  input  user_r_mem_8_empty;
  input  user_r_mem_8_eof;
  input  user_w_mem_8_full;
  output  pcie_tx;
  output  bus_clk;
  output  quiesce;
  output [3:0] user_led;
  output  user_r_read_32_rden;
  output  user_r_read_32_open;
  output  user_w_write_32_wren;
  output [31:0] user_w_write_32_data;
  output  user_w_write_32_open;
  output  user_r_read_8_rden;
  output  user_r_read_8_open;
  output  user_w_write_8_wren;
  output [7:0] user_w_write_8_data;
  output  user_w_write_8_open;
  output  user_r_mem_8_rden;
  output  user_r_mem_8_open;
  output  user_w_mem_8_wren;
  output [7:0] user_w_mem_8_data;
  output  user_w_mem_8_open;
  output [4:0] user_mem_8_addr;
  output  user_mem_8_addr_update;
  wire [35:0] tx_cred0;
  wire  tx_fifo_empty0;
  wire  tx_st_ready0;
  wire [63:0] tx_st_data0;
  wire  tx_st_eop0;
  wire  tx_st_err0;
  wire  tx_st_sop0;
  wire  tx_st_valid0;
  wire  rx_fifo_empty0;
  wire [7:0] rx_st_bardec0;
  wire [7:0] rx_st_be0;
  wire [63:0] rx_st_data0;
  wire  rx_st_eop0;
  wire  rx_st_err0;
  wire  rx_st_sop0;
  wire  rx_st_valid0;
  wire  rx_st_ready0;
  wire  rx_st_mask0;
  wire [3:0] tx_fifo_rdptr0;
  wire [3:0] tx_fifo_wrptr0;
  wire  trn_terr_drop_n;
  wire  app_msi_ack;
  wire  app_msi_req;
  wire [3:0] tl_cfg_add;
  wire [31:0] tl_cfg_ctl;
  wire  tl_cfg_ctl_wr;
  wire [52:0] tl_cfg_sts;
  wire  tl_cfg_sts_wr;
  wire  recv_dma_idle;
  wire  core_clk_out;
  wire  pme_to_sr;
  wire  fixedclk_serdes;
  wire  pclk_in;
  wire  pipe_mode;
  wire  pld_clk;
  wire  reconfig_clk;
  wire  reconfig_clk_locked;
  wire  cpl_pending;
  wire  busy_altgxb_reconfig;
  wire  crst;
  wire  dlup_exit;
  wire  hotrst_exit;
  wire  l2_exit;
  wire  npor_serdes_pll_locked;
  wire  rc_pll_locked;
  wire [4:0] reconfig_fromgxb;
  wire [3:0] reconfig_togxb;
  wire  srst;
  wire [4:0] ltssm;

   assign 	       bus_clk = core_clk_out;
   assign 	       trn_terr_drop_n = 1; // Compatible with Xilinx

   assign 	       pld_clk = core_clk_out;
   assign 	       pclk_in = 0; // Used only on simulation
   assign 	       pipe_mode = 0; // Requirement for hardware compilation
   assign 	       reconfig_clk = clk_50;
   assign 	       fixedclk_serdes = clk_125;
   assign 	       reconfig_clk_locked = 1; // No PLL, so always locked
   assign 	       cpl_pending = !recv_dma_idle;
   assign 	       npor_serdes_pll_locked = pcie_perstn && rc_pll_locked;

   // This perl snippet turns the input/output ports to wires, so only
   // those that really connect something become real ports (input/output
   // keywords are used to create global variables)

  pcie_c4_1x pcie
    (
     .app_clk (),
     .app_int_ack (),
     .app_int_sts (1'b0), // No legacy interrupts
     .app_msi_ack (app_msi_ack),
     .app_msi_num (5'd0),
     .app_msi_req (app_msi_req),
     .app_msi_tc (3'd0),
     .busy_altgxb_reconfig (busy_altgxb_reconfig),
     .cal_blk_clk (reconfig_clk),
     .clk250_out (),
     .clk500_out (),
     .core_clk_out (core_clk_out),
     .cpl_err (6'd0), // No errors reported at all
     .cpl_pending (cpl_pending),
     .crst (crst),
     .dlup_exit (dlup_exit),
     .fixedclk_serdes (fixedclk_serdes),
     .gxb_powerdown (!pcie_perstn),
     .hotrst_exit (hotrst_exit),
     .hpg_ctrler (5'd0),
     .l2_exit (l2_exit),
     .lane_act (),
     .lmi_ack (),
     .lmi_addr (12'd0),
     .lmi_din (32'd0),
     .lmi_dout (),
     .lmi_rden (1'b0),
     .lmi_wren (1'b0),
     .ltssm (ltssm),
     .npor (pcie_perstn),
     .pclk_in (pclk_in),
     .pex_msi_num (5'd0),
     .pipe_mode (pipe_mode),
     .pld_clk (pld_clk),
     .pll_powerdown (!pcie_perstn),
     .pm_auxpwr (1'b0),
     .pm_data (10'd0), // No power consumption data
     .pm_event (1'b0),
     .pme_to_cr (pme_to_sr), // Shortcircuit req->ack as in example code
     .pme_to_sr (pme_to_sr),
     .rc_pll_locked (rc_pll_locked),
     .reconfig_clk (reconfig_clk),
     .reconfig_fromgxb (reconfig_fromgxb),
     .reconfig_togxb (reconfig_togxb),
     .refclk (pcie_refclk),
     .rx_in0 (pcie_rx),
     .rx_st_bardec0 (),
     .rx_st_be0 (),
     .rx_st_data0 (rx_st_data0),
     .rx_st_eop0 (rx_st_eop0),
     .rx_st_err0 (rx_st_err0),
     .rx_st_ready0 (rx_st_ready0),
     .rx_st_sop0 (rx_st_sop0),
     .rx_st_valid0 (rx_st_valid0),
     .srst (srst),
     .test_in (40'd0),
     .tl_cfg_add (tl_cfg_add),
     .tl_cfg_ctl (tl_cfg_ctl),
     .tl_cfg_ctl_wr (tl_cfg_ctl_wr),
     .tl_cfg_sts (tl_cfg_sts),
     .tl_cfg_sts_wr (tl_cfg_sts_wr),
     .tx_cred0 (tx_cred0),
     .tx_fifo_empty0 (tx_fifo_empty0),
     .tx_out0 (pcie_tx),
     .tx_st_data0 (tx_st_data0),
     .tx_st_eop0 (tx_st_eop0),
     .tx_st_err0 (tx_st_err0),
     .tx_st_ready0 (tx_st_ready0),
     .tx_st_sop0 (tx_st_sop0),
     .tx_st_valid0 (tx_st_valid0),
     .tx_fifo_rdptr0(tx_fifo_rdptr0),
     .tx_fifo_wrptr0(tx_fifo_wrptr0)
     );

   altpcie_reconfig_3cgx reconfig
     (
      .busy (busy_altgxb_reconfig),
      .offset_cancellation_reset (!reconfig_clk_locked),
      .reconfig_clk (reconfig_clk),
      .reconfig_fromgxb (reconfig_fromgxb),
      .reconfig_togxb (reconfig_togxb)
      );

   pcie_c4_1x_rs_hip rs_hip
     (
      .app_rstn (),
      .crst (crst),
      .dlup_exit (dlup_exit),
      .hotrst_exit (hotrst_exit),
      .l2_exit (l2_exit),
      .ltssm (ltssm),
      .npor (npor_serdes_pll_locked),
      .pld_clk (pld_clk),
      .srst (srst),
      .test_sim (1'b0)
      );

  xillybus_core  xillybus_core_ins(.user_led_w(user_led),
    .user_mem_8_addr_w(user_mem_8_addr), .user_mem_8_addr_update_w(user_mem_8_addr_update),
    .tx_cred0_w(tx_cred0), .tx_fifo_empty0_w(tx_fifo_empty0),
    .tx_st_ready0_w(tx_st_ready0), .tx_st_data0_w(tx_st_data0),
    .tx_st_eop0_w(tx_st_eop0), .tx_st_err0_w(tx_st_err0),
    .tx_st_sop0_w(tx_st_sop0), .tx_st_valid0_w(tx_st_valid0),
    .rx_fifo_empty0_w(rx_fifo_empty0), .rx_st_bardec0_w(rx_st_bardec0),
    .rx_st_be0_w(rx_st_be0), .rx_st_data0_w(rx_st_data0),
    .rx_st_eop0_w(rx_st_eop0), .rx_st_err0_w(rx_st_err0),
    .rx_st_sop0_w(rx_st_sop0), .rx_st_valid0_w(rx_st_valid0),
    .rx_st_ready0_w(rx_st_ready0), .rx_st_mask0_w(rx_st_mask0),
    .tx_fifo_rdptr0_w(tx_fifo_rdptr0), .tx_fifo_wrptr0_w(tx_fifo_wrptr0),
    .trn_terr_drop_n_w(trn_terr_drop_n), .app_msi_ack_w(app_msi_ack),
    .app_msi_req_w(app_msi_req), .tl_cfg_add_w(tl_cfg_add),
    .tl_cfg_ctl_w(tl_cfg_ctl), .tl_cfg_ctl_wr_w(tl_cfg_ctl_wr),
    .tl_cfg_sts_w(tl_cfg_sts), .tl_cfg_sts_wr_w(tl_cfg_sts_wr),
    .recv_dma_idle_w(recv_dma_idle), .pcie_perstn_w(pcie_perstn),
    .user_r_read_32_rden_w(user_r_read_32_rden), .user_r_read_32_data_w(user_r_read_32_data),
    .user_r_read_32_empty_w(user_r_read_32_empty),
    .user_r_read_32_eof_w(user_r_read_32_eof), .user_r_read_32_open_w(user_r_read_32_open),
    .user_w_write_32_wren_w(user_w_write_32_wren),
    .user_w_write_32_data_w(user_w_write_32_data),
    .user_w_write_32_full_w(user_w_write_32_full),
    .user_w_write_32_open_w(user_w_write_32_open),
    .user_r_read_8_rden_w(user_r_read_8_rden), .user_r_read_8_data_w(user_r_read_8_data),
    .user_r_read_8_empty_w(user_r_read_8_empty), .user_r_read_8_eof_w(user_r_read_8_eof),
    .user_r_read_8_open_w(user_r_read_8_open), .bus_clk_w(bus_clk),
    .user_w_write_8_wren_w(user_w_write_8_wren), .user_w_write_8_data_w(user_w_write_8_data),
    .user_w_write_8_full_w(user_w_write_8_full), .user_w_write_8_open_w(user_w_write_8_open),
    .user_r_mem_8_rden_w(user_r_mem_8_rden), .quiesce_w(quiesce),
    .user_r_mem_8_data_w(user_r_mem_8_data), .user_r_mem_8_empty_w(user_r_mem_8_empty),
    .user_r_mem_8_eof_w(user_r_mem_8_eof), .user_r_mem_8_open_w(user_r_mem_8_open),
    .user_w_mem_8_wren_w(user_w_mem_8_wren), .user_w_mem_8_data_w(user_w_mem_8_data),
    .user_w_mem_8_full_w(user_w_mem_8_full), .user_w_mem_8_open_w(user_w_mem_8_open));

endmodule
