//Legal Notice: (C)2015 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

///** PCIe wrapper + 
//*/
module pcie_c4_1x_plus (
                         // inputs:
                          app_int_sts,
                          app_msi_num,
                          app_msi_req,
                          app_msi_tc,
                          cpl_err,
                          cpl_pending,
                          fixedclk_serdes,
                          lmi_addr,
                          lmi_din,
                          lmi_rden,
                          lmi_wren,
                          local_rstn,
                          pcie_rstn,
                          pclk_in,
                          pex_msi_num,
                          phystatus_ext,
                          pipe_mode,
                          pld_clk,
                          pm_auxpwr,
                          pm_data,
                          pm_event,
                          pme_to_cr,
                          reconfig_clk,
                          reconfig_clk_locked,
                          refclk,
                          rx_in0,
                          rx_st_mask0,
                          rx_st_ready0,
                          rxdata0_ext,
                          rxdatak0_ext,
                          rxelecidle0_ext,
                          rxstatus0_ext,
                          rxvalid0_ext,
                          test_in,
                          tx_st_data0,
                          tx_st_eop0,
                          tx_st_err0,
                          tx_st_sop0,
                          tx_st_valid0,

                         // outputs:
                          app_clk,
                          app_int_ack,
                          app_msi_ack,
                          clk250_out,
                          clk500_out,
                          core_clk_out,
                          lane_act,
                          lmi_ack,
                          lmi_dout,
                          ltssm,
                          pme_to_sr,
                          powerdown_ext,
                          rate_ext,
                          rc_pll_locked,
                          rx_st_bardec0,
                          rx_st_be0,
                          rx_st_data0,
                          rx_st_eop0,
                          rx_st_err0,
                          rx_st_sop0,
                          rx_st_valid0,
                          rxpolarity0_ext,
                          srstn,
                          tl_cfg_add,
                          tl_cfg_ctl,
                          tl_cfg_ctl_wr,
                          tl_cfg_sts,
                          tl_cfg_sts_wr,
                          tx_cred0,
                          tx_fifo_empty0,
                          tx_out0,
                          tx_st_ready0,
                          txcompl0_ext,
                          txdata0_ext,
                          txdatak0_ext,
                          txdetectrx_ext,
                          txelecidle0_ext
                       )
;

  output           app_clk;
  output           app_int_ack;
  output           app_msi_ack;
  output           clk250_out;
  output           clk500_out;
  output           core_clk_out;
  output  [  3: 0] lane_act;
  output           lmi_ack;
  output  [ 31: 0] lmi_dout;
  output  [  4: 0] ltssm;
  output           pme_to_sr;
  output  [  1: 0] powerdown_ext;
  output           rate_ext;
  output           rc_pll_locked;
  output  [  7: 0] rx_st_bardec0;
  output  [  7: 0] rx_st_be0;
  output  [ 63: 0] rx_st_data0;
  output           rx_st_eop0;
  output           rx_st_err0;
  output           rx_st_sop0;
  output           rx_st_valid0;
  output           rxpolarity0_ext;
  output           srstn;
  output  [  3: 0] tl_cfg_add;
  output  [ 31: 0] tl_cfg_ctl;
  output           tl_cfg_ctl_wr;
  output  [ 52: 0] tl_cfg_sts;
  output           tl_cfg_sts_wr;
  output  [ 35: 0] tx_cred0;
  output           tx_fifo_empty0;
  output           tx_out0;
  output           tx_st_ready0;
  output           txcompl0_ext;
  output  [  7: 0] txdata0_ext;
  output           txdatak0_ext;
  output           txdetectrx_ext;
  output           txelecidle0_ext;
  input            app_int_sts;
  input   [  4: 0] app_msi_num;
  input            app_msi_req;
  input   [  2: 0] app_msi_tc;
  input   [  6: 0] cpl_err;
  input            cpl_pending;
  input            fixedclk_serdes;
  input   [ 11: 0] lmi_addr;
  input   [ 31: 0] lmi_din;
  input            lmi_rden;
  input            lmi_wren;
  input            local_rstn;
  input            pcie_rstn;
  input            pclk_in;
  input   [  4: 0] pex_msi_num;
  input            phystatus_ext;
  input            pipe_mode;
  input            pld_clk;
  input            pm_auxpwr;
  input   [  9: 0] pm_data;
  input            pm_event;
  input            pme_to_cr;
  input            reconfig_clk;
  input            reconfig_clk_locked;
  input            refclk;
  input            rx_in0;
  input            rx_st_mask0;
  input            rx_st_ready0;
  input   [  7: 0] rxdata0_ext;
  input            rxdatak0_ext;
  input            rxelecidle0_ext;
  input   [  2: 0] rxstatus0_ext;
  input            rxvalid0_ext;
  input   [ 39: 0] test_in;
  input   [ 63: 0] tx_st_data0;
  input            tx_st_eop0;
  input            tx_st_err0;
  input            tx_st_sop0;
  input            tx_st_valid0;

  wire             app_clk;
  wire             app_int_ack;
  wire             app_msi_ack;
  wire             busy_altgxb_reconfig;
  wire             busy_altgxb_reconfig_altr;
  wire             clk250_out;
  wire             clk500_out;
  wire             core_clk_out;
  wire             crst;
  wire             dlup_exit;
  wire    [  4: 0] gnd_hpg_ctrler;
  wire             gxb_powerdown;
  wire             hotrst_exit;
  wire             hotrst_exit_altr;
  wire             l2_exit;
  wire    [  3: 0] lane_act;
  wire             lmi_ack;
  wire    [ 31: 0] lmi_dout;
  wire    [  4: 0] ltssm;
  wire             npor;
  wire             npor_serdes_pll_locked;
  wire             offset_cancellation_reset;
  wire             open_rx_fifo_empty0;
  wire             open_rx_fifo_full0;
  wire             open_tx_fifo_full0;
  wire    [  3: 0] open_tx_fifo_rdptr0;
  wire    [  3: 0] open_tx_fifo_wrptr0;
  wire             otb0;
  wire             otb1;
  wire             pll_powerdown;
  wire             pme_to_sr;
  wire    [  1: 0] powerdown_ext;
  wire             rate_ext;
  wire             rc_pll_locked;
  wire    [ 33: 0] reconfig_fromgxb;
  wire    [  3: 0] reconfig_togxb;
  wire    [  7: 0] rx_st_bardec0;
  wire    [  7: 0] rx_st_be0;
  wire    [ 63: 0] rx_st_data0;
  wire             rx_st_eop0;
  wire             rx_st_err0;
  wire             rx_st_sop0;
  wire             rx_st_valid0;
  wire             rxpolarity0_ext;
  wire             srst;
  wire             srstn;
  wire    [  3: 0] tl_cfg_add;
  wire    [ 31: 0] tl_cfg_ctl;
  wire             tl_cfg_ctl_wr;
  wire    [ 52: 0] tl_cfg_sts;
  wire             tl_cfg_sts_wr;
  wire    [ 35: 0] tx_cred0;
  wire             tx_fifo_empty0;
  wire             tx_out0;
  wire             tx_st_ready0;
  wire             txcompl0_ext;
  wire    [  7: 0] txdata0_ext;
  wire             txdatak0_ext;
  wire             txdetectrx_ext;
  wire             txelecidle0_ext;
  assign otb0 = 1'b0;
  assign otb1 = 1'b1;
  assign offset_cancellation_reset = ~reconfig_clk_locked;
  assign reconfig_fromgxb[33 : 5] = 0;
  assign gnd_hpg_ctrler = 0;
  assign busy_altgxb_reconfig_altr = (pipe_mode==otb1)?otb0:busy_altgxb_reconfig;
  assign gxb_powerdown = ~npor;
  assign hotrst_exit_altr = hotrst_exit;
  assign pll_powerdown = ~npor;
  assign npor_serdes_pll_locked = pcie_rstn & local_rstn & rc_pll_locked;
  assign npor = pcie_rstn & local_rstn;
  pcie_c4_1x epmap
    (
      .app_clk (app_clk),
      .app_int_ack (app_int_ack),
      .app_int_sts (app_int_sts),
      .app_msi_ack (app_msi_ack),
      .app_msi_num (app_msi_num),
      .app_msi_req (app_msi_req),
      .app_msi_tc (app_msi_tc),
      .busy_altgxb_reconfig (busy_altgxb_reconfig_altr),
      .cal_blk_clk (reconfig_clk),
      .clk250_out (clk250_out),
      .clk500_out (clk500_out),
      .core_clk_out (core_clk_out),
      .cpl_err (cpl_err),
      .cpl_pending (cpl_pending),
      .crst (crst),
      .dlup_exit (dlup_exit),
      .fixedclk_serdes (fixedclk_serdes),
      .gxb_powerdown (gxb_powerdown),
      .hotrst_exit (hotrst_exit),
      .hpg_ctrler (gnd_hpg_ctrler),
      .l2_exit (l2_exit),
      .lane_act (lane_act),
      .lmi_ack (lmi_ack),
      .lmi_addr (lmi_addr),
      .lmi_din (lmi_din),
      .lmi_dout (lmi_dout),
      .lmi_rden (lmi_rden),
      .lmi_wren (lmi_wren),
      .ltssm (ltssm),
      .npor (npor),
      .pclk_in (pclk_in),
      .pex_msi_num (pex_msi_num),
      .phystatus_ext (phystatus_ext),
      .pipe_mode (pipe_mode),
      .pld_clk (pld_clk),
      .pll_powerdown (pll_powerdown),
      .pm_auxpwr (pm_auxpwr),
      .pm_data (pm_data),
      .pm_event (pm_event),
      .pme_to_cr (pme_to_cr),
      .pme_to_sr (pme_to_sr),
      .powerdown_ext (powerdown_ext),
      .rate_ext (rate_ext),
      .rc_pll_locked (rc_pll_locked),
      .reconfig_clk (reconfig_clk),
      .reconfig_fromgxb (reconfig_fromgxb[4 : 0]),
      .reconfig_togxb (reconfig_togxb),
      .refclk (refclk),
      .rx_fifo_empty0 (open_rx_fifo_empty0),
      .rx_fifo_full0 (open_rx_fifo_full0),
      .rx_in0 (rx_in0),
      .rx_st_bardec0 (rx_st_bardec0),
      .rx_st_be0 (rx_st_be0[7 : 0]),
      .rx_st_data0 (rx_st_data0[63 : 0]),
      .rx_st_eop0 (rx_st_eop0),
      .rx_st_err0 (rx_st_err0),
      .rx_st_mask0 (rx_st_mask0),
      .rx_st_ready0 (rx_st_ready0),
      .rx_st_sop0 (rx_st_sop0),
      .rx_st_valid0 (rx_st_valid0),
      .rxdata0_ext (rxdata0_ext),
      .rxdatak0_ext (rxdatak0_ext),
      .rxelecidle0_ext (rxelecidle0_ext),
      .rxpolarity0_ext (rxpolarity0_ext),
      .rxstatus0_ext (rxstatus0_ext),
      .rxvalid0_ext (rxvalid0_ext),
      .srst (srst),
      .test_in (test_in),
      .tl_cfg_add (tl_cfg_add),
      .tl_cfg_ctl (tl_cfg_ctl),
      .tl_cfg_ctl_wr (tl_cfg_ctl_wr),
      .tl_cfg_sts (tl_cfg_sts),
      .tl_cfg_sts_wr (tl_cfg_sts_wr),
      .tx_cred0 (tx_cred0),
      .tx_fifo_empty0 (tx_fifo_empty0),
      .tx_fifo_full0 (open_tx_fifo_full0),
      .tx_fifo_rdptr0 (open_tx_fifo_rdptr0),
      .tx_fifo_wrptr0 (open_tx_fifo_wrptr0),
      .tx_out0 (tx_out0),
      .tx_st_data0 (tx_st_data0[63 : 0]),
      .tx_st_eop0 (tx_st_eop0),
      .tx_st_err0 (tx_st_err0),
      .tx_st_ready0 (tx_st_ready0),
      .tx_st_sop0 (tx_st_sop0),
      .tx_st_valid0 (tx_st_valid0),
      .txcompl0_ext (txcompl0_ext),
      .txdata0_ext (txdata0_ext),
      .txdatak0_ext (txdatak0_ext),
      .txdetectrx_ext (txdetectrx_ext),
      .txelecidle0_ext (txelecidle0_ext)
    );


  altpcie_reconfig_3cgx reconfig
    (
      .busy (busy_altgxb_reconfig),
      .offset_cancellation_reset (offset_cancellation_reset),
      .reconfig_clk (reconfig_clk),
      .reconfig_fromgxb (reconfig_fromgxb[4 : 0]),
      .reconfig_togxb (reconfig_togxb)
    );


  pcie_c4_1x_rs_hip rs_hip
    (
      .app_rstn (srstn),
      .crst (crst),
      .dlup_exit (dlup_exit),
      .hotrst_exit (hotrst_exit_altr),
      .l2_exit (l2_exit),
      .ltssm (ltssm),
      .npor (npor_serdes_pll_locked),
      .pld_clk (pld_clk),
      .srst (srst),
      .test_sim (test_in[0])
    );



endmodule

