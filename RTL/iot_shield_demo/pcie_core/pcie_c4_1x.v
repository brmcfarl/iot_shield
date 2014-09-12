// megafunction wizard: %IP Compiler for PCI Express v12.1%
// GENERATION: XML
// ============================================================
// Megafunction Name(s):
// ============================================================

//Legal Notice: (C)2014 Altera Corporation. All rights reserved.  Your
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

//$Revision: #1 
//Phy type: Cyclone IV GX Hard IP 
//Number of Lanes: 1
//Ref Clk Freq: 100Mhz
//Number of VCs: 1
//Transaction Layer runs at 62.5Mhz
module pcie_c4_1x (
                    // inputs:
                     app_int_sts,
                     app_msi_num,
                     app_msi_req,
                     app_msi_tc,
                     busy_altgxb_reconfig,
                     cal_blk_clk,
                     cpl_err,
                     cpl_pending,
                     crst,
                     fixedclk_serdes,
                     gxb_powerdown,
                     hpg_ctrler,
                     lmi_addr,
                     lmi_din,
                     lmi_rden,
                     lmi_wren,
                     npor,
                     pclk_in,
                     pex_msi_num,
                     phystatus_ext,
                     pipe_mode,
                     pld_clk,
                     pll_powerdown,
                     pm_auxpwr,
                     pm_data,
                     pm_event,
                     pme_to_cr,
                     reconfig_clk,
                     reconfig_togxb,
                     refclk,
                     rx_in0,
                     rx_st_mask0,
                     rx_st_ready0,
                     rxdata0_ext,
                     rxdatak0_ext,
                     rxelecidle0_ext,
                     rxstatus0_ext,
                     rxvalid0_ext,
                     srst,
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
                     derr_cor_ext_rcv0,
                     derr_cor_ext_rpl,
                     derr_rpl,
                     dlup_exit,
                     hotrst_exit,
                     ko_cpl_spc_vc0,
                     l2_exit,
                     lane_act,
                     lmi_ack,
                     lmi_dout,
                     ltssm,
                     pme_to_sr,
                     powerdown_ext,
                     r2c_err0,
                     rate_ext,
                     rc_pll_locked,
                     rc_rx_digitalreset,
                     reconfig_fromgxb,
                     reset_status,
                     rx_fifo_empty0,
                     rx_fifo_full0,
                     rx_st_bardec0,
                     rx_st_be0,
                     rx_st_data0,
                     rx_st_eop0,
                     rx_st_err0,
                     rx_st_sop0,
                     rx_st_valid0,
                     rxpolarity0_ext,
                     suc_spd_neg,
                     tl_cfg_add,
                     tl_cfg_ctl,
                     tl_cfg_ctl_wr,
                     tl_cfg_sts,
                     tl_cfg_sts_wr,
                     tx_cred0,
                     tx_fifo_empty0,
                     tx_fifo_full0,
                     tx_fifo_rdptr0,
                     tx_fifo_wrptr0,
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
  output           derr_cor_ext_rcv0;
  output           derr_cor_ext_rpl;
  output           derr_rpl;
  output           dlup_exit;
  output           hotrst_exit;
  output  [ 19: 0] ko_cpl_spc_vc0;
  output           l2_exit;
  output  [  3: 0] lane_act;
  output           lmi_ack;
  output  [ 31: 0] lmi_dout;
  output  [  4: 0] ltssm;
  output           pme_to_sr;
  output  [  1: 0] powerdown_ext;
  output           r2c_err0;
  output           rate_ext;
  output           rc_pll_locked;
  output           rc_rx_digitalreset;
  output  [  4: 0] reconfig_fromgxb;
  output           reset_status;
  output           rx_fifo_empty0;
  output           rx_fifo_full0;
  output  [  7: 0] rx_st_bardec0;
  output  [  7: 0] rx_st_be0;
  output  [ 63: 0] rx_st_data0;
  output           rx_st_eop0;
  output           rx_st_err0;
  output           rx_st_sop0;
  output           rx_st_valid0;
  output           rxpolarity0_ext;
  output           suc_spd_neg;
  output  [  3: 0] tl_cfg_add;
  output  [ 31: 0] tl_cfg_ctl;
  output           tl_cfg_ctl_wr;
  output  [ 52: 0] tl_cfg_sts;
  output           tl_cfg_sts_wr;
  output  [ 35: 0] tx_cred0;
  output           tx_fifo_empty0;
  output           tx_fifo_full0;
  output  [  3: 0] tx_fifo_rdptr0;
  output  [  3: 0] tx_fifo_wrptr0;
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
  input            busy_altgxb_reconfig;
  input            cal_blk_clk;
  input   [  6: 0] cpl_err;
  input            cpl_pending;
  input            crst;
  input            fixedclk_serdes;
  input            gxb_powerdown;
  input   [  4: 0] hpg_ctrler;
  input   [ 11: 0] lmi_addr;
  input   [ 31: 0] lmi_din;
  input            lmi_rden;
  input            lmi_wren;
  input            npor;
  input            pclk_in;
  input   [  4: 0] pex_msi_num;
  input            phystatus_ext;
  input            pipe_mode;
  input            pld_clk;
  input            pll_powerdown;
  input            pm_auxpwr;
  input   [  9: 0] pm_data;
  input            pm_event;
  input            pme_to_cr;
  input            reconfig_clk;
  input   [  3: 0] reconfig_togxb;
  input            refclk;
  input            rx_in0;
  input            rx_st_mask0;
  input            rx_st_ready0;
  input   [  7: 0] rxdata0_ext;
  input            rxdatak0_ext;
  input            rxelecidle0_ext;
  input   [  2: 0] rxstatus0_ext;
  input            rxvalid0_ext;
  input            srst;
  input   [ 39: 0] test_in;
  input   [ 63: 0] tx_st_data0;
  input            tx_st_eop0;
  input            tx_st_err0;
  input            tx_st_sop0;
  input            tx_st_valid0;

  wire             app_clk;
  wire             app_int_ack;
  wire             app_msi_ack;
  wire             clk250_out;
  wire             clk500_out;
  wire             core_clk_in;
  wire             core_clk_out;
  wire             derr_cor_ext_rcv0;
  wire             derr_cor_ext_rpl;
  wire             derr_rpl;
  wire             detect_mask_rxdrst;
  wire             dlup_exit;
  wire    [ 23: 0] eidle_infer_sel;
  wire             fifo_err;
  wire             gnd_AvlClk_i;
  wire    [ 11: 0] gnd_CraAddress_i;
  wire    [  3: 0] gnd_CraByteEnable_i;
  wire             gnd_CraChipSelect_i;
  wire             gnd_CraRead;
  wire             gnd_CraWrite;
  wire    [ 31: 0] gnd_CraWriteData_i;
  wire             gnd_Rstn_i;
  wire    [  5: 0] gnd_RxmIrqNum_i;
  wire             gnd_RxmIrq_i;
  wire             gnd_RxmReadDataValid_i;
  wire    [ 63: 0] gnd_RxmReadData_i;
  wire             gnd_RxmWaitRequest_i;
  wire    [ 16: 0] gnd_TxsAddress_i;
  wire    [  9: 0] gnd_TxsBurstCount_i;
  wire    [  7: 0] gnd_TxsByteEnable_i;
  wire             gnd_TxsChipSelect_i;
  wire             gnd_TxsRead_i;
  wire    [ 63: 0] gnd_TxsWriteData_i;
  wire             gnd_TxsWrite_i;
  wire             gxb_powerdown_int;
  wire    [  1: 0] hip_extraclkout;
  wire             hotrst_exit;
  wire    [ 19: 0] ko_cpl_spc_vc0;
  wire             l2_exit;
  wire    [  3: 0] lane_act;
  wire             lmi_ack;
  wire    [ 31: 0] lmi_dout;
  wire    [  4: 0] ltssm;
  wire             open_CraIrq_o;
  wire    [ 31: 0] open_CraReadData_o;
  wire             open_CraWaitRequest_o;
  wire    [ 31: 0] open_RxmAddress_o;
  wire    [  9: 0] open_RxmBurstCount_o;
  wire    [  7: 0] open_RxmByteEnable_o;
  wire             open_RxmRead_o;
  wire    [ 63: 0] open_RxmWriteData_o;
  wire             open_RxmWrite_o;
  wire             open_TxsReadDataValid_o;
  wire    [ 63: 0] open_TxsReadData_o;
  wire             open_TxsWaitRequest_o;
  wire             open_gxb_powerdown;
  wire             open_rc_rx_analogreset;
  wire             open_rc_tx_digitalreset;
  wire    [  7: 0] open_rx_st_be0_p1;
  wire    [ 63: 0] open_rx_st_data0_p1;
  wire             open_rx_st_eop0_p1;
  wire             open_rx_st_sop0_p1;
  wire             pclk_central;
  wire             pclk_central_serdes;
  wire             pclk_ch0;
  wire             pclk_ch0_serdes;
  wire             phystatus;
  wire             phystatus_pcs;
  wire             pipe_mode_int;
  wire             pll_fixed_clk;
  wire             pll_fixed_clk_serdes;
  wire             pll_locked;
  wire             pll_powerdown_int;
  wire             pme_to_sr;
  wire    [  1: 0] powerdown;
  wire    [  1: 0] powerdown0_ext;
  wire    [  1: 0] powerdown0_int;
  wire    [  1: 0] powerdown_ext;
  wire             r2c_err0;
  wire             rate_ext;
  wire             rate_int;
  wire             rateswitch;
  wire             rateswitchbaseclock;
  wire             rc_areset;
  wire             rc_inclk_eq_125mhz;
  wire             rc_pll_locked;
  wire             rc_rx_analogreset;
  wire             rc_rx_digitalreset;
  wire             rc_rx_pll_locked_one;
  wire             rc_tx_digitalreset;
  wire    [  4: 0] reconfig_fromgxb;
  wire             reset_status;
  wire             rx_cruclk;
  wire             rx_digitalreset_serdes;
  wire             rx_fifo_empty0;
  wire             rx_fifo_full0;
  wire             rx_freqlocked;
  wire    [  7: 0] rx_freqlocked_byte;
  wire             rx_in;
  wire             rx_pll_locked;
  wire    [  7: 0] rx_pll_locked_byte;
  wire    [  7: 0] rx_signaldetect_byte;
  wire    [  7: 0] rx_st_bardec0;
  wire    [  7: 0] rx_st_be0;
  wire    [ 63: 0] rx_st_data0;
  wire             rx_st_eop0;
  wire             rx_st_err0;
  wire             rx_st_sop0;
  wire             rx_st_valid0;
  wire    [  7: 0] rxdata;
  wire    [  7: 0] rxdata_pcs;
  wire             rxdatak;
  wire             rxdatak_pcs;
  wire             rxelecidle;
  wire             rxelecidle_pcs;
  wire             rxpolarity;
  wire             rxpolarity0_ext;
  wire             rxpolarity0_int;
  wire    [  2: 0] rxstatus;
  wire    [  2: 0] rxstatus_pcs;
  wire             rxvalid;
  wire             rxvalid_pcs;
  wire             suc_spd_neg;
  wire    [ 63: 0] test_out_int;
  wire    [  3: 0] tl_cfg_add;
  wire    [ 31: 0] tl_cfg_ctl;
  wire             tl_cfg_ctl_wr;
  wire    [ 52: 0] tl_cfg_sts;
  wire             tl_cfg_sts_wr;
  wire    [ 35: 0] tx_cred0;
  wire    [  7: 0] tx_deemph;
  wire             tx_fifo_empty0;
  wire             tx_fifo_full0;
  wire    [  3: 0] tx_fifo_rdptr0;
  wire    [  3: 0] tx_fifo_wrptr0;
  wire    [ 23: 0] tx_margin;
  wire             tx_out;
  wire             tx_out0;
  wire             tx_st_ready0;
  wire             txcompl;
  wire             txcompl0_ext;
  wire             txcompl0_int;
  wire    [  7: 0] txdata;
  wire    [  7: 0] txdata0_ext;
  wire    [  7: 0] txdata0_int;
  wire             txdatak;
  wire             txdatak0_ext;
  wire             txdatak0_int;
  wire             txdetectrx;
  wire             txdetectrx0_ext;
  wire             txdetectrx0_int;
  wire             txdetectrx_ext;
  wire             txelecidle;
  wire             txelecidle0_ext;
  wire             txelecidle0_int;
  wire             use_c4gx_serdes;
  assign app_clk = pld_clk;
  assign txdetectrx_ext = txdetectrx0_ext;
  assign powerdown_ext = powerdown0_ext;
  assign rxdata[7 : 0] = pipe_mode_int ? rxdata0_ext : rxdata_pcs[7 : 0];
  assign phystatus = pipe_mode_int ? phystatus_ext : phystatus_pcs;
  assign rxelecidle = pipe_mode_int ? rxelecidle0_ext : rxelecidle_pcs;
  assign rxvalid = pipe_mode_int ? rxvalid0_ext : rxvalid_pcs;
  assign txdata[7 : 0] = txdata0_int;
  assign rxdatak = pipe_mode_int ? rxdatak0_ext : rxdatak_pcs;
  assign rxstatus[2 : 0] = pipe_mode_int ? rxstatus0_ext : rxstatus_pcs[2 : 0];
  assign powerdown[1 : 0] = powerdown0_int;
  assign rxpolarity = rxpolarity0_int;
  assign txcompl = txcompl0_int;
  assign txdatak = txdatak0_int;
  assign txdetectrx = txdetectrx0_int;
  assign txelecidle = txelecidle0_int;
  assign txdata0_ext = pipe_mode_int ? txdata0_int : 0;
  assign txdatak0_ext = pipe_mode_int ? txdatak0_int : 0;
  assign txdetectrx0_ext = pipe_mode_int ? txdetectrx0_int : 0;
  assign txelecidle0_ext = pipe_mode_int ? txelecidle0_int : 0;
  assign txcompl0_ext = pipe_mode_int ? txcompl0_int : 0;
  assign rxpolarity0_ext = pipe_mode_int ? rxpolarity0_int : 0;
  assign powerdown0_ext = pipe_mode_int ? powerdown0_int : 0;
  assign ko_cpl_spc_vc0 = 20'h701c;
  assign rx_in = rx_in0;
  assign tx_out0 = tx_out;
  assign rc_inclk_eq_125mhz = 1;
  assign pclk_central_serdes = 0;
  assign pll_fixed_clk_serdes = rateswitchbaseclock;
  assign rateswitchbaseclock = pclk_ch0_serdes;
  assign rc_pll_locked = (pipe_mode_int == 1'b1) ? 1'b1 : &pll_locked;
  assign gxb_powerdown_int = (pipe_mode_int == 1'b1) ? 1'b1 : gxb_powerdown;
  assign pll_powerdown_int = (pipe_mode_int == 1'b1) ? 1'b1 : pll_powerdown;
  assign rx_pll_locked = {1{1'b1}};
  assign rx_cruclk = {1{refclk}};
  assign rc_areset = pipe_mode_int | ~npor | busy_altgxb_reconfig;
  assign pclk_central = (pipe_mode_int == 1'b1) ? pclk_in : pclk_central_serdes;
  assign pclk_ch0 = (pipe_mode_int == 1'b1) ? pclk_in : pclk_ch0_serdes;
  assign rateswitch = {1{rate_int}};
  assign rate_ext = pipe_mode_int ? rate_int : 0;
  assign pll_fixed_clk = (pipe_mode_int == 1'b1) ? clk250_out : pll_fixed_clk_serdes;
  assign rc_rx_pll_locked_one = &(rx_pll_locked | rx_freqlocked);
  assign use_c4gx_serdes = 1'b1;
  assign fifo_err = 1'b0;
  assign rx_freqlocked_byte[0] = rx_freqlocked;
  assign rx_freqlocked_byte[7 : 1] = 7'h7F;
  assign rx_pll_locked_byte[0] = rx_pll_locked;
  assign rx_pll_locked_byte[7 : 1] = 7'h7F;
  assign rx_signaldetect_byte[7 : 0] = 8'hFF;
  assign detect_mask_rxdrst = 1'b0;
  assign core_clk_in = 1'b0;
  assign gnd_AvlClk_i = 1'b0;
  assign gnd_Rstn_i = 1'b0;
  assign gnd_TxsChipSelect_i = 1'b0;
  assign gnd_TxsRead_i = 1'b0;
  assign gnd_TxsWrite_i = 1'b0;
  assign gnd_TxsWriteData_i = 1'b0;
  assign gnd_TxsBurstCount_i = 1'b0;
  assign gnd_TxsAddress_i = 1'b0;
  assign gnd_TxsByteEnable_i = 1'b0;
  assign gnd_RxmWaitRequest_i = 1'b0;
  assign gnd_RxmReadData_i = 1'b0;
  assign gnd_RxmReadDataValid_i = 1'b0;
  assign gnd_RxmIrq_i = 1'b0;
  assign gnd_RxmIrqNum_i = 1'b0;
  assign gnd_CraChipSelect_i = 1'b0;
  assign gnd_CraRead = 1'b0;
  assign gnd_CraWrite = 1'b0;
  assign gnd_CraWriteData_i = 1'b0;
  assign gnd_CraAddress_i = 1'b0;
  assign gnd_CraByteEnable_i = 1'b0;
  pcie_c4_1x_serdes serdes
    (
      .cal_blk_clk (cal_blk_clk),
      .fixedclk (fixedclk_serdes),
      .gxb_powerdown (gxb_powerdown_int),
      .hip_tx_clkout (pclk_ch0_serdes),
      .pipe8b10binvpolarity (rxpolarity),
      .pipedatavalid (rxvalid_pcs),
      .pipeelecidle (rxelecidle_pcs),
      .pipephydonestatus (phystatus_pcs),
      .pipestatus (rxstatus_pcs),
      .pll_areset (pll_powerdown_int),
      .pll_inclk (refclk),
      .pll_locked (pll_locked),
      .powerdn (powerdown),
      .reconfig_clk (reconfig_clk),
      .reconfig_fromgxb (reconfig_fromgxb),
      .reconfig_togxb (reconfig_togxb),
      .rx_analogreset (rc_rx_analogreset),
      .rx_ctrldetect (rxdatak_pcs),
      .rx_datain (rx_in),
      .rx_dataout (rxdata_pcs),
      .rx_digitalreset (rx_digitalreset_serdes),
      .rx_elecidleinfersel (eidle_infer_sel[2 : 0]),
      .rx_freqlocked (rx_freqlocked),
      .tx_ctrlenable (txdatak),
      .tx_datain (txdata),
      .tx_dataout (tx_out),
      .tx_detectrxloop (txdetectrx),
      .tx_digitalreset (rc_tx_digitalreset),
      .tx_forcedispcompliance (txcompl),
      .tx_forceelecidle (txelecidle)
    );


  altpcie_rs_serdes rs_serdes
    (
      .busy_altgxb_reconfig (busy_altgxb_reconfig),
      .detect_mask_rxdrst (detect_mask_rxdrst),
      .fifo_err (fifo_err),
      .ltssm (ltssm),
      .npor (npor),
      .pld_clk (pld_clk),
      .pll_locked (rc_pll_locked),
      .rc_inclk_eq_125mhz (rc_inclk_eq_125mhz),
      .rx_freqlocked (rx_freqlocked_byte),
      .rx_pll_locked (rx_pll_locked_byte),
      .rx_signaldetect (rx_signaldetect_byte),
      .rxanalogreset (rc_rx_analogreset),
      .rxdigitalreset (rx_digitalreset_serdes),
      .test_in (test_in),
      .txdigitalreset (rc_tx_digitalreset),
      .use_c4gx_serdes (use_c4gx_serdes)
    );


  pcie_c4_1x_core wrapper
    (
      .AvlClk_i (gnd_AvlClk_i),
      .CraAddress_i (gnd_CraAddress_i),
      .CraByteEnable_i (gnd_CraByteEnable_i),
      .CraChipSelect_i (gnd_CraChipSelect_i),
      .CraIrq_o (open_CraIrq_o),
      .CraRead (gnd_CraRead),
      .CraReadData_o (open_CraReadData_o),
      .CraWaitRequest_o (open_CraWaitRequest_o),
      .CraWrite (gnd_CraWrite),
      .CraWriteData_i (gnd_CraWriteData_i),
      .Rstn_i (gnd_Rstn_i),
      .RxmAddress_o (open_RxmAddress_o),
      .RxmBurstCount_o (open_RxmBurstCount_o),
      .RxmByteEnable_o (open_RxmByteEnable_o),
      .RxmIrqNum_i (gnd_RxmIrqNum_i),
      .RxmIrq_i (gnd_RxmIrq_i),
      .RxmReadDataValid_i (gnd_RxmReadDataValid_i),
      .RxmReadData_i (gnd_RxmReadData_i),
      .RxmRead_o (open_RxmRead_o),
      .RxmWaitRequest_i (gnd_RxmWaitRequest_i),
      .RxmWriteData_o (open_RxmWriteData_o),
      .RxmWrite_o (open_RxmWrite_o),
      .TxsAddress_i (gnd_TxsAddress_i),
      .TxsBurstCount_i (gnd_TxsBurstCount_i),
      .TxsByteEnable_i (gnd_TxsByteEnable_i),
      .TxsChipSelect_i (gnd_TxsChipSelect_i),
      .TxsReadDataValid_o (open_TxsReadDataValid_o),
      .TxsReadData_o (open_TxsReadData_o),
      .TxsRead_i (gnd_TxsRead_i),
      .TxsWaitRequest_o (open_TxsWaitRequest_o),
      .TxsWriteData_i (gnd_TxsWriteData_i),
      .TxsWrite_i (gnd_TxsWrite_i),
      .aer_msi_num (5'b00000),
      .app_int_ack (app_int_ack),
      .app_int_sts (app_int_sts),
      .app_msi_ack (app_msi_ack),
      .app_msi_num (app_msi_num),
      .app_msi_req (app_msi_req),
      .app_msi_tc (app_msi_tc),
      .core_clk_in (core_clk_in),
      .core_clk_out (core_clk_out),
      .cpl_err (cpl_err),
      .cpl_pending (cpl_pending),
      .crst (crst),
      .derr_cor_ext_rcv0 (derr_cor_ext_rcv0),
      .derr_cor_ext_rpl (derr_cor_ext_rpl),
      .derr_rpl (derr_rpl),
      .dl_ltssm (ltssm),
      .dlup_exit (dlup_exit),
      .eidle_infer_sel (eidle_infer_sel),
      .hip_extraclkout (hip_extraclkout),
      .hotrst_exit (hotrst_exit),
      .hpg_ctrler (hpg_ctrler),
      .l2_exit (l2_exit),
      .lane_act (lane_act),
      .lmi_ack (lmi_ack),
      .lmi_addr (lmi_addr),
      .lmi_din (lmi_din),
      .lmi_dout (lmi_dout),
      .lmi_rden (lmi_rden),
      .lmi_wren (lmi_wren),
      .npor (npor),
      .pclk_central (pclk_central),
      .pclk_ch0 (pclk_ch0),
      .pex_msi_num (pex_msi_num),
      .phystatus0_ext (phystatus),
      .pld_clk (pld_clk),
      .pll_fixed_clk (pll_fixed_clk),
      .pm_auxpwr (pm_auxpwr),
      .pm_data (pm_data),
      .pm_event (pm_event),
      .pme_to_cr (pme_to_cr),
      .pme_to_sr (pme_to_sr),
      .powerdown0_ext (powerdown0_int),
      .r2c_err0 (r2c_err0),
      .rate_ext (rate_int),
      .rc_areset (rc_areset),
      .rc_gxb_powerdown (open_gxb_powerdown),
      .rc_inclk_eq_125mhz (rc_inclk_eq_125mhz),
      .rc_pll_locked (rc_pll_locked),
      .rc_rx_analogreset (open_rc_rx_analogreset),
      .rc_rx_digitalreset (rc_rx_digitalreset),
      .rc_rx_pll_locked_one (rc_rx_pll_locked_one),
      .rc_tx_digitalreset (open_rc_tx_digitalreset),
      .reset_status (reset_status),
      .rx_fifo_empty0 (rx_fifo_empty0),
      .rx_fifo_full0 (rx_fifo_full0),
      .rx_st_bardec0 (rx_st_bardec0),
      .rx_st_be0 (rx_st_be0),
      .rx_st_be0_p1 (open_rx_st_be0_p1),
      .rx_st_data0 (rx_st_data0),
      .rx_st_data0_p1 (open_rx_st_data0_p1),
      .rx_st_eop0 (rx_st_eop0),
      .rx_st_eop0_p1 (open_rx_st_eop0_p1),
      .rx_st_err0 (rx_st_err0),
      .rx_st_mask0 (rx_st_mask0),
      .rx_st_ready0 (rx_st_ready0),
      .rx_st_sop0 (rx_st_sop0),
      .rx_st_sop0_p1 (open_rx_st_sop0_p1),
      .rx_st_valid0 (rx_st_valid0),
      .rxdata0_ext (rxdata[7 : 0]),
      .rxdatak0_ext (rxdatak),
      .rxelecidle0_ext (rxelecidle),
      .rxpolarity0_ext (rxpolarity0_int),
      .rxstatus0_ext (rxstatus[2 : 0]),
      .rxvalid0_ext (rxvalid),
      .srst (srst),
      .suc_spd_neg (suc_spd_neg),
      .test_in (test_in),
      .test_out (test_out_int),
      .tl_cfg_add (tl_cfg_add),
      .tl_cfg_ctl (tl_cfg_ctl),
      .tl_cfg_ctl_wr (tl_cfg_ctl_wr),
      .tl_cfg_sts (tl_cfg_sts),
      .tl_cfg_sts_wr (tl_cfg_sts_wr),
      .tx_cred0 (tx_cred0),
      .tx_deemph (tx_deemph),
      .tx_fifo_empty0 (tx_fifo_empty0),
      .tx_fifo_full0 (tx_fifo_full0),
      .tx_fifo_rdptr0 (tx_fifo_rdptr0),
      .tx_fifo_wrptr0 (tx_fifo_wrptr0),
      .tx_margin (tx_margin),
      .tx_st_data0 (tx_st_data0),
      .tx_st_data0_p1 (64'h0),
      .tx_st_eop0 (tx_st_eop0),
      .tx_st_eop0_p1 (1'b0),
      .tx_st_err0 (tx_st_err0),
      .tx_st_ready0 (tx_st_ready0),
      .tx_st_sop0 (tx_st_sop0),
      .tx_st_sop0_p1 (1'b0),
      .tx_st_valid0 (tx_st_valid0),
      .txcompl0_ext (txcompl0_int),
      .txdata0_ext (txdata0_int),
      .txdatak0_ext (txdatak0_int),
      .txdetectrx0_ext (txdetectrx0_int),
      .txelecidle0_ext (txelecidle0_int)
    );



//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign pipe_mode_int = pipe_mode;
  altpcie_pll_100_250 refclk_to_250mhz
    (
      .areset (1'b0),
      .c0 (clk250_out),
      .inclk0 (refclk)
    );


  altpcie_pll_125_250 pll_250mhz_to_500mhz
    (
      .areset (1'b0),
      .c0 (clk500_out),
      .inclk0 (clk250_out)
    );



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  assign pipe_mode_int = 0;
//synthesis read_comments_as_HDL off

endmodule


// =========================================================
// IP Compiler for PCI Express Wizard Data
// ===============================
// DO NOT EDIT FOLLOWING DATA
// @Altera, IP Toolbench@
// Warning: If you modify this section, IP Compiler for PCI Express Wizard may not be able to reproduce your chosen configuration.
// 
// Retrieval info: <?xml version="1.0"?>
// Retrieval info: <MEGACORE title="IP Compiler for PCI Express"  version="12.1"  build="243"  iptb_version="1.3.0 Build 243"  format_version="120" >
// Retrieval info:  <NETLIST_SECTION class="altera.ipbu.flowbase.netlist.model.MVCModel"  active_core="altpcie_hip_pipen1b" >
// Retrieval info:   <STATIC_SECTION>
// Retrieval info:    <PRIVATES>
// Retrieval info:     <NAMESPACE name = "parameterization">
// Retrieval info:      <PRIVATE name = "p_pcie_phy" value="Cyclone IV GX"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_port_type" value="Native Endpoint"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_tag_supported" value="32"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msi_message_requested" value="1"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_low_priority_virtual_channels" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_retry_fifo_depth" value="64"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nfts_common_clock" value="255"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nfts_separate_clock" value="255"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_exp_rom_bar_used" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_link_common_clock" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_advanced_error_reporting" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_ecrc_check" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_ecrc_generation" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_power_indicator" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_attention_indicator" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_attention_button" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msi_message_64bits_address_capable" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_auto_configure_retry_buffer" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_implement_data_register" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_device_init_required" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_L1_aspm" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rate_match_fifo" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_fast_recovery" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "SOPCSystemName" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR0AvalonAddress" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR0Size" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR1AvalonAddress" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR1Size" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR2AvalonAddress" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR2Size" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR3AvalonAddress" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR3Size" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR4AvalonAddress" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR4Size" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR5AvalonAddress" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "actualBAR5Size" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "allowedDeviceFamilies" value="[Cyclone IV GX]"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "altgx_generated" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "clockSource" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "contextState" value="NativeContext"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "deviceFamily" value="Cyclone IV GX"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "ordering_code" value="IP-PCIE/4"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hardwired_address_map" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_00" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_00_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_01" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_01_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_02" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_02_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_03" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_03_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_04" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_04_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_05" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_05_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_06" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_06_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_07" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_07_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_08" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_08_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_09" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_09_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_10" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_10_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_11" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_11_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_12" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_12_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_13" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_13_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_14" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_14_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_15" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_hw_pci_address_15_type" value="Memory32Bit"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_pane_count" value="1"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_avalon_pane_size" value="20"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_enable_pcie_hip_dprio" value="Disable"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_64bit_bar" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_64bit_bus" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_66mhz" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_allow_param_readback" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_altera_arbiter" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_arbited_devices" value="2"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_arbiter" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_0_auto_avalon_address" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_0_auto_sized" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_0_avalon_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_0_hardwired" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_0_pci_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_0_prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_1_auto_avalon_address" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_1_auto_sized" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_1_avalon_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_1_hardwired" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_1_pci_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_1_prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_2_auto_avalon_address" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_2_auto_sized" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_2_avalon_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_2_hardwired" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_2_pci_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_2_prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_3_auto_avalon_address" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_3_auto_sized" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_3_avalon_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_3_hardwired" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_3_pci_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_3_prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_4_auto_avalon_address" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_4_auto_sized" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_4_avalon_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_4_hardwired" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_4_pci_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_4_prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_5_auto_avalon_address" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_5_auto_sized" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_5_avalon_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_5_hardwired" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_5_pci_address" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bar_5_prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_bus_access_address_width" value="18"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_global_reset" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_host_bridge" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_impl_cra_av_slave_port" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_master" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_master_bursts" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_master_concurrent_reads" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_master_data_width" value="64"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_maximum_burst_size" value="128"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_maximum_burst_size_a2p" value="128"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_maximum_pending_read_transactions_a2p" value="8"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_non_pref_av_master_port" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_not_target_only_port" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_pref_av_master_port" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_reqn_gntn_pins" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_single_clock" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_target_bursts" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_target_concurrent_reads" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pci_user_specified_bars" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_L1_exit_latency_common_clock" value="&gt;64 us"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_L1_exit_latency_separate_clock" value="&gt;64 us"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_advanced_error_int_num" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_alt2gxb" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_altgx_keyParameters_used" value="{p_pcie_enable_hip=1, p_pcie_number_of_lanes=x1, p_pcie_phy=Cyclone IV GX, p_pcie_rate=Gen1 (2.5 Gbps), p_pcie_txrx_clock=100 MHz}"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_app_signal_interface" value="AvalonST"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_avalon_mm_lite" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_size_bar_0" value="128 Bytes - 7 bits"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_size_bar_1" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_size_bar_2" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_size_bar_3" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_size_bar_4" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_size_bar_5" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_type_bar_0" value="64-bit Prefetchable Memory"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_type_bar_1" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_type_bar_2" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_type_bar_3" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_type_bar_4" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_type_bar_5" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_used_bar_0" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_used_bar_1" value="1"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_used_bar_2" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_used_bar_3" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_used_bar_4" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_bar_used_bar_5" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_channel_number" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_chk_io" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_class_code" value="0xFF0000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_credit_vc0" value="112"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_used_space_vc0" value="1792"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_used_space_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_used_space_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_data_used_space_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_credit_vc0" value="28"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_used_space_vc0" value="448"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_used_space_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_used_space_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_header_used_space_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_completion_timeout" value="NONE"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_custom_phy_x8" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_custom_rx_buffer_xml" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_device_id" value="0xEBEB"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_disable_L0s" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_dll_active_report_support" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_eie_b4_nfts_count" value="4"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_completion_timeout_disable" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_function_msix_support" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_hip" value="1"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_hip_core_clk" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_pcie_gen2_x8_es" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_pcie_gen2_x8_s5gx" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_root_port_endpoint_mode" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_simple_dma" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_slot_capability" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_enable_tl_bypass_mode" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_endpoint_L0s_acceptable_latency" value="&lt;64 ns"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_endpoint_L1_acceptable_latency" value="&lt;1 us"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_exp_rom_bar_size" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_gen2_nfts_diff_clock" value="255"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_gen2_nfts_same_clock" value="255"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_initiator_performance_preset" value="High"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_internal_clock" value="62.5 MHz"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_io_base_and_limit_register" value="IODisable"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_lanerev" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_link_port_number" value="0x01"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_max_payload_size" value="128 Bytes"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_mem_base_and_limit_register" value="MemDisable"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msix_pba_bir" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msix_pba_offset" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msix_table_bir" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msix_table_offset" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_msix_table_size" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_credit_vc0" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_used_space_vc0" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_used_space_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_used_space_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_data_used_space_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_credit_vc0" value="20"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_used_space_vc0" value="320"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_used_space_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_used_space_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_nonposted_header_used_space_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_number_of_lanes" value="x1"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_phy_interface" value="Serial"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_pme_pending" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_pme_reg_id" value="0x0000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_credit_vc0" value="80"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_used_space_vc0" value="1280"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_used_space_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_used_space_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_data_used_space_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_credit_vc0" value="16"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_used_space_vc0" value="256"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_used_space_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_used_space_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_posted_header_used_space_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rate" value="Gen1 (2.5 Gbps)"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_retry_buffer_size" value="16 KBytes"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_revision_id" value="0x01"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_preset" value="Default"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_string_vc0" value="4 KBytes"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_string_vc1" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_string_vc2" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_string_vc3" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_vc0" value="4096"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_rx_buffer_size_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_slot_capabilities" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_special_phy_gl" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_special_phy_px" value="1"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_subsystem_device_id" value="0xEBEB"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_subsystem_vendor_id" value="0x1172"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_surprise_down_error_support" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_target_performance_preset" value="High"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_test_out_width" value="None"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_threshold_for_L0s_entry" value="8192 ns"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_total_header_credit_vc0" value="64"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_total_header_credit_vc1" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_total_header_credit_vc2" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_total_header_credit_vc3" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_txrx_clock" value="100 MHz"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_underSOPCBuilder" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_use_crc_forwarding" value="0"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_use_parity" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_variation_name" value="pcie_c4_1x_core"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_vendor_id" value="0x1172"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_version" value="1.1"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_pcie_virutal_channels" value="1"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "pref_nonp_independent" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "translationTableSizeInfo" value="The bridge reserves a contiguous Avalon address range to access
// Retrieval info: PCIe devices. This Avalon address range is segmented into one or
// Retrieval info: more equal-sized pages that are individually mapped to PCIe
// Retrieval info: addresses. Select the number and size of the address pages."  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress0" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress1" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress10" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress11" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress12" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress13" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress14" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress15" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress2" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress3" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress4" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress5" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress6" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress7" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress8" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWAddress9" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress0" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress1" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress10" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress11" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress12" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress13" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress14" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress15" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress2" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress3" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress4" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress5" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress6" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress7" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress8" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonHWPCIAddress9" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiAvalonTranslationTable" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar0PCIAddress" value="0x0000000000000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar0Prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar1PCIAddress" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar1Prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar2PCIAddress" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar2Prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar3PCIAddress" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar3Prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar4PCIAddress" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar4Prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar5PCIAddress" value="0x00000000"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiBar5Prefetchable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiCRAInfoPanel" value="other"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiExpROMType" value="Select to Enable"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiFixedTable" value="true"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBar0Type" value="64-bit Prefetchable Memory"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBar1Type" value="N/A"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBar2Type" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBar3Type" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBar4Type" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBar5Type" value="Disable this and all higher BARs"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBarTable" value="false"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIBusArbiter" value="external"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIDeviceMode" value="masterTarget"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCIMasterPerformance" value="burstSinglePending"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPCITargetPerformance" value="burstSinglePending"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPaneCount" value="1"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "uiPaneSize" value="20"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "ui_pcie_msix_pba_bir" value="1:0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "ui_pcie_msix_table_bir" value="1:0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "p_tx_cdc_full_value" value="12"  type="INTEGER"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "simgen_enable">
// Retrieval info:      <PRIVATE name = "language" value="VERILOG"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "enabled" value="0"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "greybox">
// Retrieval info:      <PRIVATE name = "gb_enabled" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "filename" value="pcie_c4_1x_syn.v"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "testbench">
// Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "simgen">
// Retrieval info:      <PRIVATE name = "filename" value="pcie_c4_1x_core.v"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "serializer"/>
// Retrieval info:    </PRIVATES>
// Retrieval info:    <FILES/>
// Retrieval info:    <PORTS/>
// Retrieval info:    <LIBRARIES/>
// Retrieval info:   </STATIC_SECTION>
// Retrieval info:  </NETLIST_SECTION>
// Retrieval info: </MEGACORE>
// =========================================================
