 module xillydemo
  (
  //signals that were advised to drive to ground but caused problems
  /*// A/D Converter
	input [3:0] adc_gpio,
	input adc_sdo,	
	output adc_cs_n,
	output adc_sclk,
	output adc_sdi,
	
	// Codec
	inout codec_scl,
	inout codec_sda,
	input codec_bclk,
	input codec_dout,
	input codec_gpio1,
	input codec_wclk,
	output codec_din,
	output codec_reset_n,
	
	//CSI-2
	input csi_hs_clk_dbg,
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
	output mpcie_dbg_perst_n,
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
	output usb_full,*/
	
   input  clk_50,
   input  pcie_perstn,
   input  pcie_refclk,
   input  pcie_rx,
	input [1:0] user_buttons,
	input [7:0] user_sw,
   output  pcie_tx,
   output [3:0] user_led,
	output reg [3:0] our_led,
	output svr_cpu_int,
	inout  i2c_scl,
	inout i2c_sda,
	//used CSI
	input           lpck_p,   	   	   // CMOS level of clock lane Dp wire. Asynchronous.
	input           lpck_n  , 	   	   // CMOS level of clock lane Dn wire. Asynchronous.
	input           lpd1_p    ,          // CMOS level of data-1 lane Dp wire. Asynchronous.  
	input           lpd1_n ,             // CMOS level of data-1 lane Dn wire. Asynchronous.  
	input           hs_clk ,             // clock  lane HS level. source-synchronous.
	input           hs_d1  ,             // data-1 lane HS level. source-synchronous.
	input           hs_d2 ,            // data-2 lane HS level. source-synchronous.
	input           lpd2_p ,             // CMOS level of data-2 lane Dp wire. Asynchronous.   
	input           lpd2_n              // CMOS level of data-2 lane Dn wire. Asynchronous.   

   );
	assign adc_cs_n = 0;assign adc_sclk = 0;assign adc_sdi = 0;assign codec_din = 0;assign codec_scl = 0;assign codec_sda = 0;assign codec_reset_n = 0;
	assign csi_clk = 0;assign csi_gpio = 0;assign fpga_cpld_clk = 0;assign galileo_scl = 0;assign galileo_sda = 0;assign galileo_5v_oe_n = 0;assign galileo_rst_n = 0;
	assign hshdr_5v_oe_n = 0;assign hshdr_clk2 = 0;assign lshdr_5v_oe_n = 0;assign mpcie_dbg_perst_n = 0;assign sw_dbg_perst_n = 0;assign sw_smbclk = 0;assign sw_smbdata = 0;
	
	//csi svr states
	localparam [4:0] WRITE_ROWS=1, WRITE_COLUMNS=2, WRITE_ENABLE=3, READ_ROWS=4, READ_COLUMNS=5, READ_ENABLE=6, DATA_TRANSFER=7, WAIT_FOR_FS=8,WRITE_FULL=9,WAIT=10, READ_CONFIG=11,WRITE_CONFIG=12,WRITE_ENABLE_FROM_FULL=13,WRITE_ENABLE_FROM_EMPTY=14,WRITE_ENABLE_FROM_FE=15,WRITE_CONFIG_ALL=16,READ_ADDRESS_2=17,WRITE_ADDRESS_2=18,WAIT_UNSLEEP = 19,S_0=0;
	reg [4:0] current_state,next_state;
	//i2c states and params
	localparam [7:0] WAIT_I2C = 1,ENABLE_CORE_I2C=2,WRITE_SLAVE_ADDRESS_I2C=3,WRITE_START_AND_WRITE_I2C=4,WAIT_FOR_TIP_FROM_STEP_2_I2C=5,SET_DATA_TO_DEVICE_I2C=6,SEND_WRITE_TO_DEVICE_I2C=7,WAIT_TRANSFER_DONE_I2C=8,SET_LAST_DATA_I2C=9,SEND_WRITE_STOP_I2C=10,WAIT_FOR_STOP_I2C=11;
	localparam [2:0] PRERlo = 0, PRERhi = 1, CTR = 2, TXR = 3, RXR = 3, CR = 4, SR = 4;
	reg [7:0] current_state_i2c, next_state_i2c;

   // Clock and quiesce
   wire 	bus_clk;
   wire 	quiesce;

	wire [1:0] buttons_pressed;
	wire [1:0] buttons_held;
	//wire reset_global;
      // Memory array
   reg [7:0] 	demoarray[0:31];
	reg [31:0]  output_fifo;
	reg reset_n_but;
	
	wire [7:0] address_slave_cam_write = 8'h6c;
	wire [7:0] address_slave_cam_read = 8'h6d;
	wire [6:0] number_of_registers = 7'h59; //n regs - 1
	reg [7:0] high_address [0:90] ;
	reg [7:0] low_address [0:90] ;
	reg [7:0] values [0:90] ;
	
	reg [2:0] address_i2c;
	reg [7:0] writedata_i2c;
	wire [7:0] readdata_i2c;
	reg write_i2c = 0;
	reg enable_i2c = 1;
	wire waitrequest_n;
	wire bus_enable;// = 0;

	wire scl_padoen_o;
	wire scl_pad_o;
	wire sda_padoen_o;
	wire sda_pad_o;
	wire scl_pad_i;
	wire sda_pad_i;

	//i2c signals, recommended from i2c open cores
	assign i2c_scl = scl_padoen_o ? 1'bz : scl_pad_o;
	assign i2c_sda = sda_padoen_o ? 1'bz: sda_pad_o;
	assign scl_pad_i = i2c_scl;
	assign sda_pad_i = i2c_sda;

	
	//CSI
	wire   [ 9:0] svr_pixel          ; // pixel output. RAW10 - all bits are used. RAW8 - bits 7:0 are used. Sample with fclk   
	wire          svr_pixel_valid    ; // pixel valid qualifier. Sample with fclk    
	wire   [ 1:0] svr_channel_id     ; // MIPI CSI2 Channel indicator. I don't think that the camera is using it, so it will probably be 00. Sample with fclk    
	wire          svr_fs             ; // Frame-Start. One fclk wide pulse    
	wire          svr_fe             ; // Frame-End. One fclk wide pulse     
	wire          svr_ls             ; // Line-Start. One fclk wide pulse    
	wire          svr_le             ; // Line-End. One fclk wide pulse      
	wire   [ 5:0] svr_data_type      ; // will indicate the data-type of the received packet, per CSI2. RAW8 is 0x28 and RAW10 is 0x2B. Sample with fclk    
	//wire          svr_cpu_int        ; // Interrupt output, upon error or other predefined cases. Sample with pclk    
	wire   [31:0] readdata           ; // avalon read bus; used to read reg    
	//input           fclk               ; // main clock input. min 100MHz
	//input           pclk               ; // r/w clock; used to read/write registers.    
	reg           reset_n            ; // a-synchronous  
	reg   [ 5:0]  address            ; // word-address. all registers are 32 bit wide. sampled with pclk.  
	reg   [31:0]  writedata          ; // write-data; sampled with pclk. 
	reg           write              ; // write; sampled with pclk. 
	reg           read               ; // read; sampled with pclk.
	
   
   // Wires related to /dev/xillybus_mem_8
   wire 	user_r_mem_8_rden;
   wire 	user_r_mem_8_empty;
   reg [7:0] 	user_r_mem_8_data;
   wire 	user_r_mem_8_eof;
   wire 	user_r_mem_8_open;
   wire 	user_w_mem_8_wren;
   wire 	user_w_mem_8_full;
   wire [7:0] 	user_w_mem_8_data;
   wire 	user_w_mem_8_open;
   wire [4:0] 	user_mem_8_addr;
   wire 	user_mem_8_addr_update;

   // Wires related to /dev/xillybus_read_32
   wire 	user_r_read_32_rden;
   wire 	user_r_read_32_empty;
   wire [31:0] 	user_r_read_32_data;
   wire 	user_r_read_32_eof;
   wire 	user_r_read_32_open;

   // Wires related to /dev/xillybus_read_8
   wire 	user_r_read_8_rden;
   wire 	user_r_read_8_empty;
   wire [7:0] 	user_r_read_8_data;
   wire 	user_r_read_8_eof;
   wire 	user_r_read_8_open;

   // Wires related to /dev/xillybus_write_32
   wire 	user_w_write_32_wren;
   wire 	user_w_write_32_full;
	wire  user_w_write_32_almost_full;
   wire [31:0] 	user_w_write_32_data;
   wire 	user_w_write_32_open;

   // Wires related to /dev/xillybus_write_8
   wire 	user_w_write_8_wren;
   wire 	user_w_write_8_full;
   wire [7:0] 	user_w_write_8_data;
   wire 	user_w_write_8_open;

	
	wire 	clk_125;
   wire 	reconfig_clk_locked;
   wire [8:0] 	unused;
	
	// Generate 125 MHz clock from existing 50 MHz clock
   altpll clkpll 
     (
      .areset (1'b0),
      .inclk ( { 1'b0, clk_50 }),
      .locked (reconfig_clk_locked),
      .clk ( { unused, clk_125 } ),
      .activeclock (),
      .clkbad (),
      .clkena ({6{1'b1}}),
      .clkloss (),
      .clkswitch (1'b0),
      .configupdate (1'b0),
      .enable0 (),
      .enable1 (),
      .extclk (),
      .extclkena ({4{1'b1}}),
      .fbin (1'b1),
      .fbmimicbidir (),
      .fbout (),
      .fref (),
      .icdrclk (),
      .pfdena (1'b1),
      .phasecounterselect ({4{1'b1}}),
      .phasedone (),
      .phasestep (1'b1),
      .phaseupdown (1'b1),
      .pllena (1'b1),
      .scanaclr (1'b0),
      .scanclk (1'b0),
      .scanclkena (1'b1),
      .scandata (1'b0),
      .scandataout (),
      .scandone (),
      .scanread (1'b0),
      .scanwrite (1'b0),
      .sclkout0 (),
      .sclkout1 (),
      .vcooverrange (),
      .vcounderrange ());
   defparam 	
		clkpll.bandwidth_type = "AUTO",
		clkpll.clk0_divide_by = 2,
		clkpll.clk0_duty_cycle = 50,
		clkpll.clk0_multiply_by = 5,
		clkpll.clk0_phase_shift = "0",
		clkpll.inclk0_input_frequency = 20000,
		clkpll.intended_device_family = "Cyclone IV",
		clkpll.lpm_hint = "CBX_MODULE_PREFIX=pll",
		clkpll.lpm_type = "altpll",
		clkpll.operation_mode = "NO_COMPENSATION",
		clkpll.pll_type = "AUTO",
		clkpll.port_activeclock = "PORT_UNUSED",
		clkpll.port_areset = "PORT_USED",
		clkpll.port_clkbad0 = "PORT_UNUSED",
		clkpll.port_clkbad1 = "PORT_UNUSED",
		clkpll.port_clkloss = "PORT_UNUSED",
		clkpll.port_clkswitch = "PORT_UNUSED",
		clkpll.port_configupdate = "PORT_UNUSED",
		clkpll.port_fbin = "PORT_UNUSED",
		clkpll.port_fbout = "PORT_UNUSED",
		clkpll.port_inclk0 = "PORT_USED",
		clkpll.port_inclk1 = "PORT_UNUSED",
		clkpll.port_locked = "PORT_USED",
		clkpll.port_pfdena = "PORT_UNUSED",
		clkpll.port_phasecounterselect = "PORT_UNUSED",
		clkpll.port_phasedone = "PORT_UNUSED",
		clkpll.port_phasestep = "PORT_UNUSED",
		clkpll.port_phaseupdown = "PORT_UNUSED",
		clkpll.port_pllena = "PORT_UNUSED",
		clkpll.port_scanaclr = "PORT_UNUSED",
		clkpll.port_scanclk = "PORT_UNUSED",
		clkpll.port_scanclkena = "PORT_UNUSED",
		clkpll.port_scandata = "PORT_UNUSED",
		clkpll.port_scandataout = "PORT_UNUSED",
		clkpll.port_scandone = "PORT_UNUSED",
		clkpll.port_scanread = "PORT_UNUSED",
		clkpll.port_scanwrite = "PORT_UNUSED",
		clkpll.port_clk0 = "PORT_USED",
		clkpll.port_clk1 = "PORT_UNUSED",
		clkpll.port_clk2 = "PORT_UNUSED",
		clkpll.port_clk3 = "PORT_UNUSED",
		clkpll.port_clk4 = "PORT_UNUSED",
		clkpll.port_clk5 = "PORT_UNUSED",
		clkpll.port_clk6 = "PORT_UNUSED",
		clkpll.port_clk7 = "PORT_UNUSED",
		clkpll.port_clk8 = "PORT_UNUSED",
		clkpll.port_clk9 = "PORT_UNUSED",
		clkpll.port_clkena0 = "PORT_UNUSED",
		clkpll.port_clkena1 = "PORT_UNUSED",
		clkpll.port_clkena2 = "PORT_UNUSED",
		clkpll.port_clkena3 = "PORT_UNUSED",
		clkpll.port_clkena4 = "PORT_UNUSED",
		clkpll.port_clkena5 = "PORT_UNUSED",
		clkpll.self_reset_on_loss_lock = "OFF",
		clkpll.using_fbmimicbidir_port = "OFF",
		clkpll.width_clock = 10;
	
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

			  // Ports related to /dev/xillybus_write_32
			  // CPU to FPGA signals:
			  .user_w_write_32_wren(user_w_write_32_wren),
			  .user_w_write_32_full(user_w_write_32_full),
			  .user_w_write_32_data(user_w_write_32_data),
			  .user_w_write_32_open(user_w_write_32_open),

			  // Ports related to /dev/xillybus_read_8
			  // FPGA to CPU signals:
			  .user_r_read_8_rden(user_r_read_8_rden),
			  .user_r_read_8_empty(user_r_read_8_empty),
			  .user_r_read_8_data(user_r_read_8_data),
			  .user_r_read_8_eof(user_r_read_8_eof),
			  .user_r_read_8_open(user_r_read_8_open),

			  // Ports related to /dev/xillybus_write_8
			  // CPU to FPGA signals:
			  .user_w_write_8_wren(user_w_write_8_wren),
			  .user_w_write_8_full(user_w_write_8_full),
			  .user_w_write_8_data(user_w_write_8_data),
			  .user_w_write_8_open(user_w_write_8_open),


			  // Signals to top level
			  .clk_125(clk_125),
			  .clk_50(clk_50),
			  .pcie_perstn(pcie_perstn),
			  .pcie_refclk(pcie_refclk),
			  .pcie_rx(pcie_rx),
			  .bus_clk(bus_clk),
			  .pcie_tx(pcie_tx),
			  .quiesce(quiesce),
			  .user_led(user_led)
			  );

	debouncer d1(.button(~user_buttons[0]), .clk(clk_125), .reset(reset_n_but), .pressed(buttons_pressed[0]), .held(buttons_held[0]));
	debouncer d2(.button(~user_buttons[1]), .clk(clk_125), .reset(reset_n_but), .pressed(buttons_pressed[1]), .held(buttons_held[1]));
	
	i2c_master_top i2c_master(
	// wishbone signals
	.wb_clk_i(clk_125),      			// master clock input
	.wb_rst_i(buttons_held[1]),      // synchronous active high reset
	.arst_i(!buttons_held[1]),       		// asynchronous reset 
	.wb_adr_i(address_i2c),      // lower address bits 
	.wb_dat_i(writedata_i2c),      // databus input 
	.wb_dat_o(readdata_i2c),      // databus output
	.wb_we_i(write_i2c),       // write enable input 
	.wb_stb_i(enable_i2c),      // stobe/core select signal 
	.wb_cyc_i(enable_i2c),      // valid bus cycle input 
	.wb_ack_o(bus_enable),      // bus cycle acknowledge output 
	.wb_inta_o(),     // interrupt request signal output
	// I2C signals
	// i2c clock line
	.scl_pad_i(scl_pad_i),     // SCL-line input
	.scl_pad_o(scl_pad_o),     // SCL-line output (always 1'b0)
	.scl_padoen_o(scl_padoen_o),  // SCL-line output enable (active low)
	// i2c data line
	.sda_pad_i(sda_pad_i),     // SDA-line input
	.sda_pad_o(sda_pad_o),     // SDA-line output (always 1'b0)
	.sda_padoen_o(sda_padoen_o)   // SDA-line output enable (active low) 
	);
			  
	svr_lt2 CSI(
		.svr_pixel(svr_pixel)          ,
		.svr_pixel_valid(svr_pixel_valid)    ,
		.svr_channel_id(svr_channel_id)     ,
		.svr_fs(svr_fs)             ,
		.svr_fe(svr_fe)             ,
		.svr_ls(svr_ls)             ,
		.svr_le(svr_le)             ,
		.svr_data_type(svr_data_type)      ,
		.svr_cpu_int(svr_cpu_int)        ,
		.readdata(readdata)           ,
		.fclk(bus_clk)               ,
		.pclk(bus_clk)               ,
		.reset_n(reset_n)            ,
		.address(address)            ,
		.writedata(writedata)          ,
		.write(write)              ,
		.read (read)              ,
		.lpck_p(lpck_p)   	   ,
		.lpck_n(lpck_n)             ,
		.lpd1_p(lpd1_p)             ,
		.lpd1_n(lpd1_n)             ,
		.hs_clk(hs_clk)            ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
		.hs_d1(hs_d1)              ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
		.hs_d2(hs_d2)              ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
		.lpd2_p (lpd2_p)         ,
		.lpd2_n(lpd2_n) 

	);
			  
	reg write_request = 1'b0;	
	reg [1:0] read_flag;
	reg [1:0] write_flag;
	reg [15:0] counter_clk;
	reg [15:0] lsCounter, leCounter;
	reg [15:0] feCounter;
	reg [15:0]noCounter;
	reg  wrongBytesFlag;
	reg comes_from_csi;
	reg start_write;
	reg [31:0] from_readdata;
	
	reg [1:0] read_flag_i2c;
	reg [1:0] write_flag_i2c;
	reg [6:0] register_index;
	reg [15:0] temp_user_sw;
	
	reg [31:0] status_interrupt;
	
	always @(posedge bus_clk)
	begin
		
		
		if(buttons_held[1])
		begin
			current_state <= WAIT;
			read_flag <= 0;
			write_flag <= 0;
			counter_clk <= 0;
			lsCounter <= 0;
			leCounter <= 0;
			noCounter <= 0;
			feCounter <= 0;
			comes_from_csi <= 0;
		end
		else 
		begin
			current_state <= next_state;
			//if any of the current states, set the read and write flags to increment
			if(current_state == WRITE_ROWS || current_state == WRITE_COLUMNS || current_state == WRITE_CONFIG_ALL || current_state == WRITE_ENABLE || current_state == WRITE_CONFIG
				|| current_state == WRITE_ENABLE_FROM_FULL || current_state == WRITE_ENABLE_FROM_EMPTY || current_state == WRITE_ENABLE_FROM_FE || current_state == WRITE_ADDRESS_2)
			begin
				//if the current register value has been read, change to the desired value for writing it back
				if(read_flag == 2)
				begin
					read_flag <= 0;
					//if its write config, only write the fifth bit, this set up the 
					//recover error in the svr
					if(current_state == WRITE_CONFIG)
					begin
						from_readdata <= readdata | 32'h0010;
					end
					//if its write config all, set the last 2 bits to 1
					else if(current_state == WRITE_CONFIG_ALL )
					begin
						from_readdata <= readdata | 32'h0003;
					end
					//this is to enable the svr
					else if(current_state == WRITE_ENABLE || current_state == WRITE_ENABLE_FROM_EMPTY)
					begin
						from_readdata <= readdata | 32'h0001;
					end
					//this writes the values of the dip switch as delay
					else if(current_state == WRITE_ADDRESS_2)
					begin
						from_readdata <= readdata | temp_user_sw;
					end
					//this disables the svr
					else if(current_state == WRITE_ENABLE_FROM_FULL || current_state == WRITE_ENABLE_FROM_FE)
					begin
						from_readdata <= readdata & 32'hFFFE;
					end
					//signals that the register has been read and changed and its ready to be written back
					start_write <= 1;
				end
				else if(start_write == 0)
				begin
					//increment the read flag and set the delay values
					read_flag <= read_flag + 1;
					temp_user_sw <= (~user_sw << 8);
				end
				//set the write mechanism
				if(write_flag == 3)
				begin
					write_flag <= 0;
					start_write <= 0;
				end
				else if(start_write)
				begin
					write_flag <= write_flag + 1;
				end
			end
			//if it needs a read, increment the read flag 
			if(current_state == READ_ROWS || current_state == READ_COLUMNS || current_state == READ_ENABLE || current_state == READ_CONFIG || current_state == READ_ADDRESS_2 || svr_cpu_int)
			begin
			
				if(read_flag == 3)
				begin
					read_flag <= 0;
					from_readdata <= readdata;
				end
				else
				begin
					read_flag <= read_flag + 1;
				end
			end
			//if its wait reset the variables
			if(current_state == WAIT)
			begin
				feCounter <= 0;
				read_flag <= 0;
				write_flag <= 0;
				start_write <= 0;
			end
			//count the number of frame ends
			if(current_state == WAIT_FOR_FS)
			begin
				if(svr_fe)
				begin
					feCounter <= feCounter + 1;
				end
			end
			//count the number of fs and fe
			if(current_state == DATA_TRANSFER)
			begin
				
				if(svr_ls)
				begin
					if(lsCounter != leCounter)
					begin
						noCounter <= noCounter + 1;
					end
					lsCounter <= lsCounter + 1;
				end
				if(svr_le)
				begin
					leCounter <= leCounter + 1;
					
				end
			end
		end	
		
	end
	
	always @(*)
	begin
	
		reset_n = ~buttons_held[1];
		our_led = noCounter;
		
		write = 0;
		read = 0;
		address = 0;
		writedata = 0;
		write_request = 0;
		output_fifo = 0;
		next_state = current_state;
		status_interrupt = 0;
		//reads the interrupt register in case of a 
		//interrupt
		if(svr_cpu_int)
		begin
			if(read_flag == 3)
			begin
				status_interrupt = readdata;
			end
			else
			begin
				read = 1'b1;
				address = 6'h0c;
				status_interrupt = 0;
			end
		end
			case(current_state)
				//wait for the appropiate command
				WAIT:
				begin
				  if (user_r_read_8_data == 8'b01100011) //c - write enable
				  begin
						next_state = WRITE_ENABLE;
				  end
				  else if (user_r_read_8_data == 8'b01100110) //f - read and output enable at 32
				  begin
						next_state = READ_ENABLE;
				  end
				  else if (user_r_read_8_data == 8'b01100111) //g - read and output config at 32
				  begin
						next_state = READ_CONFIG;
				  end
				  else if (user_r_read_8_data == 8'b01101000) //h - write config 2'b01
				  begin
						next_state = WRITE_CONFIG;
				  end
				  else if (user_r_read_8_data == 8'b01101001) //i - write config 2'b11
				  begin
						next_state = WRITE_CONFIG_ALL;
				  end
				  else if (user_r_read_8_data == 8'b01101010) //j - read address 0x02
				  begin
						next_state = READ_ADDRESS_2;
				  end
				   else if (user_r_read_8_data == 8'b01101011) //k - write address 0x02 
				  begin
						next_state = WRITE_ADDRESS_2;
				  end
				  else if(user_r_read_8_data == 8'b01101100)
				  begin
					our_led = wrongBytesFlag;
				  end
				end
				//if its write enable, first read the register,
				//write it back and wait for frame start
				WRITE_ENABLE:
				begin
					if(write_flag == 3)
					begin
						next_state = WAIT_FOR_FS;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 0;
						write = 1'b1;
						writedata = from_readdata;
					end
				   if(read_flag <= 2 && start_write == 0)
					begin
						read = 1'b1;
						address = 0;
					end
				end
				//if its read enable, first read the register,
				//and output it to fifo 32
				READ_ENABLE:
				begin
					if(read_flag == 3)
					begin
						
						
						next_state = WAIT;
					end
					else if(read_flag == 2)
					begin
						output_fifo = readdata;
						write_request = 1'b1;
						read = 1'b1;
						address = 0;
					end
					else
					begin
						read = 1'b1;
						address = 0;
					end
				end
				//if its read address 2, read register 2 and output it
				//to fifo 32
				READ_ADDRESS_2:
				begin
					if(read_flag == 3)
					begin		
						next_state = WAIT;
					end
					else if(read_flag == 2)
					begin
						output_fifo = readdata;
						write_request = 1'b1;
						read = 1'b1;
						address = 2;
					end
					else
					begin
						read = 1'b1;
						address = 2;
					end
				end
				READ_CONFIG:
				begin
					if(read_flag == 3)
					begin				
						next_state = WAIT;
					end
					else if(read_flag == 2)
					begin
						output_fifo = readdata;
						write_request = 1'b1;
						read = 1'b1;
						address = 1;
					end
					else
					begin
						read = 1'b1;
						address = 1;
					end
				end
				WRITE_CONFIG:
				begin
					if(write_flag == 3)
					begin
						next_state = WAIT;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 1;
						write = 1'b1;
						writedata = from_readdata;
					end
					
				   if(read_flag <= 2 && start_write == 0)
					begin
						//writedata = readdata;
						read = 1'b1;
						address = 1;
					end
				end
				//first reads the contents of register 2,
				//enables bits 15-8 with the value of the
				//dip switch, and writes it back 
				WRITE_ADDRESS_2:
				begin
					if(write_flag == 3)
					begin
						next_state = WAIT;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 2;
						write = 1'b1;
						writedata = from_readdata;
					end
				   if(read_flag <= 2 && start_write == 0)
					begin
						read = 1'b1;
						address = 2;
					end
				end
				//first reads the contents of register 1,
				//enables bits 1-0, and writes it back 
				WRITE_CONFIG_ALL:
				begin
					if(write_flag == 3)
					begin
						next_state = WAIT;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 1;
						write = 1'b1;
						writedata = from_readdata;
					end
				   if(read_flag <= 2 && start_write == 0)
					begin
						read = 1'b1;
						address = 1;
					end
				end
				//when trasnfering data, output pixel to fifo 32 when 
				//pixel is valid, if its almost full disable the svr and wait
				//until its empty. else if frame end disable the svr and wait
				DATA_TRANSFER:						 //DATA TRANFSER
				begin
						write_request = svr_pixel_valid;
						output_fifo = svr_pixel;
					if(user_w_write_32_almost_full == 1'b1)
					begin
						write_request = svr_pixel_valid;
						output_fifo = svr_pixel;
						next_state = WRITE_ENABLE_FROM_FULL;
					end
					else
					begin
					end
					if(svr_fe == 1)
					begin
						write_request = 1'b0;
						next_state = WRITE_ENABLE_FROM_FE;
					end
					else
					begin
					
					end
				end
				WAIT_FOR_FS:
				begin
					//if its a frame start and x frames have passed
					//initiate the data transfer
					if(svr_fs == 1'b1 && feCounter > 0)
					begin
						next_state = DATA_TRANSFER;
					end
					else
					begin
					
					end
				end
				//when the fifo is empy enables the svr
				WRITE_FULL:
				begin
					if(user_r_read_32_empty == 1'b1)
					begin
						next_state = WRITE_ENABLE_FROM_EMPTY;
					end
					else
					begin
					end
				end
				//disables the svr
				WRITE_ENABLE_FROM_FULL:
				begin
					if(write_flag == 3)
					begin
						next_state = WRITE_FULL;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 0;
						write = 1'b1;
						writedata = from_readdata;
						write_request = svr_pixel_valid;
						output_fifo = svr_pixel;
					end
				   if(read_flag <= 2 && start_write == 0)
					begin
						read = 1'b1;
						address = 0;
						write_request = svr_pixel_valid;
						output_fifo = svr_pixel;
            
					end
				end
				//enables the svr
				WRITE_ENABLE_FROM_EMPTY:
				begin
					if(write_flag == 3)
					begin
						next_state = DATA_TRANSFER;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 0;
						write = 1'b1;
						writedata = from_readdata;
					end
				   if(read_flag <= 2 && start_write == 0)
					begin
						read = 1'b1;
						address = 0;
            
					end
				end
				//disables the svr and waits
				WRITE_ENABLE_FROM_FE:
				begin
					if(write_flag == 3)
					begin
						next_state = WAIT;
					end
					if (write_flag <= 3 && start_write)
					begin
						address = 0;
						write = 1'b1;
						writedata = from_readdata;
					end
				   if(read_flag <= 2 && start_write == 0)
					begin
						read = 1'b1;
						address = 0;
            
					end
				end
				
				
				default:
				begin
					next_state = WAIT;
				end	
			endcase
		
		
   end
	
	//i2c logic
	always @(posedge clk_125)
	begin
		//reset i2c variables
		if(buttons_held[1])
		begin
			current_state_i2c <= WAIT_I2C;
			read_flag_i2c <= 0;
			write_flag_i2c <= 0;
			write_upper_address_flag <= 0;
			write_lower_address_flag <= 0;
			register_index <= 0;
			last_transmission_flag <= 0;
		end
		else 
		begin
			current_state_i2c <= next_state_i2c;
			//if its a frame end, set the reg index to the last value (sleep command)
			if(current_state == WRITE_ENABLE_FROM_FE)
			begin
				register_index <= 7'h5A;
				last_transmission_flag <= 1;
			end
			//if its waiting, reset the variables, if a write enable command is sent from 
			//fifo 8 (c) set the reg indext to the last value - 1 (unsleep command) 
			if(current_state_i2c == WAIT_I2C)
			begin
				last_transmission_flag <= 0;
				register_index <= 0;
				if (user_r_read_8_data == 8'b01100011) //write enable to csi module, unsleep camera
				begin
					register_index <= 7'h59;
					last_transmission_flag <= 1;
				end
			end
			//any of these states needs the write flag
			if(current_state_i2c == ENABLE_CORE_I2C || current_state_i2c == WRITE_SLAVE_ADDRESS_I2C || current_state_i2c == WRITE_START_AND_WRITE_I2C 
				||current_state_i2c ==  SET_DATA_TO_DEVICE_I2C ||current_state_i2c == SEND_WRITE_TO_DEVICE_I2C|| current_state_i2c == SET_LAST_DATA_I2C 
				||current_state_i2c == SEND_WRITE_STOP_I2C )
			begin
				if(write_flag_i2c == 3)
				begin
					write_flag_i2c <= 0;
				end
				else
				begin
					write_flag_i2c <= write_flag_i2c + 1;
				end
			end
			//any of these states needs the read flag
			if(current_state_i2c == WAIT_FOR_TIP_FROM_STEP_2_I2C || current_state_i2c == WAIT_TRANSFER_DONE_I2C || current_state_i2c == WAIT_FOR_STOP_I2C)
			begin
				if(read_flag_i2c == 2)
				begin
					read_flag_i2c <= 0;
				end
				else
				begin
					read_flag_i2c <= read_flag_i2c + 1;
				end
			end
			//when data commands its done in this state, upped reg value is needed
			if(current_state_i2c == WAIT_FOR_TIP_FROM_STEP_2_I2C)
			begin
				if(read_flag_i2c == 2)
				begin
					if(readdata_i2c[1] == 0)
					begin
						write_upper_address_flag <= 1;
					end
				end
			end
			//while waiting for the data transfer to be done
			else if(current_state_i2c == WAIT_TRANSFER_DONE_I2C)
			begin
				if(read_flag_i2c == 2)
				begin
					if(readdata_i2c[1] == 0)
					begin
						//if the upper address has been written, set the 
						//flag to write the lower reg address
						if(write_upper_address_flag)
						begin
							write_upper_address_flag <= 0;
							write_lower_address_flag <= 1;
						end
						//if lower reg address has been written, deassert the flag
						else if(write_lower_address_flag)
						begin
							write_lower_address_flag <= 0;
						end
					end
				end
			end
			//this states are when the reg value is sent, increments the reg index and check if it should 
			//stop
			else if (current_state_i2c == SEND_WRITE_STOP_I2C)
			begin
				if(write_flag_i2c == 3)
				begin
					register_index <= register_index + 1;
					if(register_index >= (number_of_registers -1))
					begin
						last_transmission_flag <= 1;
					end //if
				end //if
			end //else if
		end
		
	end
	
	always @(*)
	begin
		next_state_i2c = current_state_i2c;
		address_i2c = 0;
		writedata_i2c = 0;
		write_i2c = 0;
		
		if(buttons_held[1])
		begin
			next_state_i2c = WAIT_I2C;
		end
		else 
		begin
			case(current_state_i2c)
			WAIT_I2C:
			begin
				//if any of these conditions, enable the core and prepare for transfer
				if(buttons_pressed[0] || user_r_read_8_data == 8'b01100011 || current_state == WRITE_ENABLE_FROM_FE)
				begin
					enable_i2c = 1;
					next_state_i2c = ENABLE_CORE_I2C;
				end
			end
			//sends the enable core command
			ENABLE_CORE_I2C: // step 0
			begin
				if(write_flag_i2c == 3)
				begin
					next_state_i2c = WRITE_SLAVE_ADDRESS_I2C;
				end
				else
				begin
					write_i2c = 1;
					address_i2c = CTR;
					writedata_i2c = 8'h80;
				end
			end
			//writes the slave addres to i2c
			WRITE_SLAVE_ADDRESS_I2C: // step 1
			begin
				if(write_flag_i2c == 3)
				begin
					next_state_i2c = WRITE_START_AND_WRITE_I2C;
				end
				else
				begin
					write_i2c = 1;
					address_i2c = TXR;
					writedata_i2c = address_slave_cam_write;
				end 
			end
			//send the start and write i2c command
			WRITE_START_AND_WRITE_I2C: //step 2
			begin
				if(write_flag_i2c == 3)
				begin
					next_state_i2c = WAIT_FOR_TIP_FROM_STEP_2_I2C;		
				end
				else
				begin
					write_i2c = 1;
					address_i2c = CR;
					writedata_i2c = 8'h90;
				end 
			end
			//wait for the data transmission to be done
			//then change state
			WAIT_FOR_TIP_FROM_STEP_2_I2C: //step 3
			begin
				if(read_flag_i2c == 2)
				begin
					address_i2c = SR;
					if(readdata_i2c[1] == 0)
					begin
						next_state_i2c = SET_DATA_TO_DEVICE_I2C;		
					end
				end
				else
				begin
					address_i2c = SR;
				end			
			end
			//sets the corresponding data to be written
			SET_DATA_TO_DEVICE_I2C:
			begin
				if(write_flag_i2c == 3)
				begin
					next_state_i2c = SEND_WRITE_TO_DEVICE_I2C; //need flags
				end
				else
				begin
					write_i2c = 1;
					address_i2c = TXR;
					if(write_upper_address_flag)
					begin
						writedata_i2c = high_address[register_index]; // to bevariable
					end
					else if(write_lower_address_flag)
					begin
						writedata_i2c = low_address[register_index]; // to bevariable
					end
					
				end 
			end
			//sends the write i2c command 
			SEND_WRITE_TO_DEVICE_I2C:
			begin
				if(write_flag_i2c == 3)
				begin
				
					next_state_i2c = WAIT_TRANSFER_DONE_I2C; //needs flags
				end
				else
				begin
					write_i2c = 1;
					address_i2c = CR;
					writedata_i2c = 8'h10;
				end 
			end
			//wait for the data transmission to be done
			//then change state
			WAIT_TRANSFER_DONE_I2C:
			begin
				if(read_flag_i2c == 2)
				begin
					address_i2c = SR;
					if(readdata_i2c[1] == 0)
					begin
						if(write_upper_address_flag)
						begin
							next_state_i2c = SET_DATA_TO_DEVICE_I2C; //needs flags
						end
						else if(write_lower_address_flag)
						begin
							next_state_i2c = SET_LAST_DATA_I2C; //needs flags
						end
					end
				end
				else
				begin
					address_i2c = SR;
				end		
			end
			//set the last byte of data 
			SET_LAST_DATA_I2C:
			begin
				//write_values_flag = 0;
				if(write_flag_i2c == 3)
				begin
					next_state_i2c = SEND_WRITE_STOP_I2C; 
				end
				else
				begin
					write_i2c = 1;
					address_i2c = TXR;
					writedata_i2c = values[register_index]; 			
				end 
			end
			//send write and stop i2c command
			SEND_WRITE_STOP_I2C:
			begin
				if(write_flag_i2c == 3)
				begin
					next_state_i2c = WAIT_FOR_STOP_I2C; 
				end
				else
				begin
					write_i2c = 1;
					address_i2c = CR;
					writedata_i2c = 8'h50;
				end 
			end
			//wait for the wait command to be sent to change state
			WAIT_FOR_STOP_I2C:
			begin
				if(read_flag_i2c == 2)
				begin
					address_i2c = SR;
					if(readdata_i2c[1] == 0)
					begin
						if(last_transmission_flag)
						begin
							next_state_i2c = WAIT_I2C;
						end
						else
						begin
							next_state_i2c = WRITE_SLAVE_ADDRESS_I2C;
						end
					end
				end
				else
				begin
					address_i2c = SR;
				end
			end
			default: next_state_i2c = WAIT_I2C;
			endcase
		end
	end

	reg write_upper_address_flag ;
	reg write_lower_address_flag ;
	reg last_transmission_flag;

   assign  user_r_mem_8_empty = 0;
   assign  user_r_mem_8_eof = 0;
   assign  user_w_mem_8_full = 0;

   // 32-bit loopback
   scfifo fifo_32 ( // 32x512 words
		    .clock (bus_clk),
		    .data (output_fifo), //output_fifo //user_w_write_32_data
		    .rdreq (user_r_read_32_rden),
		    .sclr (!user_w_write_32_open && !user_r_read_32_open),
		    .wrreq (write_request), //write_request //user_w_write_32_wren
		    .empty (user_r_read_32_empty),
		    .full (user_w_write_32_full),
		    .q (user_r_read_32_data),
		    .aclr (),
		    .almost_empty (),
		    .almost_full (user_w_write_32_almost_full),
		    .usedw ());
   defparam
	   fifo_32.add_ram_output_register = "ON",
	   fifo_32.lpm_numwords = 1024,
	   fifo_32.lpm_showahead = "OFF",
	   fifo_32.lpm_type = "scfifo",
	   fifo_32.lpm_width = 32,
	   fifo_32.lpm_widthu = 10,
	   fifo_32.overflow_checking = "ON",
	   fifo_32.underflow_checking = "ON",
	   fifo_32.use_eab = "ON",
		//value for almost full flag
		fifo_32.ALMOST_FULL_VALUE = 900;
   
   assign  user_r_read_32_eof = 0;

   // 8-bit loopback
   scfifo fifo_8 ( // 8x2048 words
		   .clock (bus_clk),
		   .data (user_w_write_8_data),
		   .rdreq (user_r_read_8_rden),
		   .sclr (!user_w_write_8_open && !user_r_read_8_open),
		   .wrreq (user_w_write_8_wren),
		   .empty (user_r_read_8_empty),
		   .full (user_w_write_8_full),
		   .q (user_r_read_8_data),
		   .aclr (),
		   .almost_empty (),
		   .almost_full (),
		   .usedw ());
   defparam
	   fifo_8.add_ram_output_register = "ON",
	   fifo_8.lpm_numwords = 2048,
	   fifo_8.lpm_showahead = "OFF",
	   fifo_8.lpm_type = "scfifo",
	   fifo_8.lpm_width = 8,
	   fifo_8.lpm_widthu = 11,
	   fifo_8.overflow_checking = "ON",
	   fifo_8.underflow_checking = "ON",
	   fifo_8.use_eab = "ON";
   
   assign  user_r_read_8_eof = 0;
	
	
	initial 
	begin
		high_address[0] = 8'h01; //1
		high_address[1] = 8'h01; //2
		high_address[2] = 8'h30; //3
		high_address[3] = 8'h30; //4
		high_address[4] = 8'h30; //5
		high_address[5] = 8'h30; //6
		high_address[6] = 8'h31; //7
		high_address[7] = 8'h38; //8
		high_address[8] = 8'h38; //9
		high_address[9] = 8'h38; //10
		high_address[10] = 8'h37; //11
		high_address[11] = 8'h36; //12
		high_address[12] = 8'h36; //13
		high_address[13] = 8'h50; //14
		high_address[14] = 8'h50; //15
		high_address[15] = 8'h50; //16
		high_address[16] = 8'h50; //17
		high_address[17] = 8'h5a; //18
		high_address[18] = 8'h30; //19
		high_address[19] = 8'h30; //20
		high_address[20] = 8'h30; //21
		high_address[21] = 8'h30; //22
		high_address[22] = 8'h30; //23
		high_address[23] = 8'h30; //24
		high_address[24] = 8'h30; //25
		high_address[25] = 8'h30; //26
		high_address[26] = 8'h3a; //27
		high_address[27] = 8'h3a; //28
		high_address[28] = 8'h3c; //29
		high_address[29] = 8'h3b; //30
		high_address[30] = 8'h38; //31
		high_address[31] = 8'h38; //32
		high_address[32] = 8'h38; //33
		high_address[33] = 8'h38; //34
		high_address[34] = 8'h38; //35
		high_address[35] = 8'h38; //36
		high_address[36] = 8'h37; //37
		high_address[37] = 8'h37; //38
		high_address[38] = 8'h38; //39
		high_address[39] = 8'h38; //40
		high_address[40] = 8'h38; //41
		high_address[41] = 8'h38; //42
		high_address[42] = 8'h38; //43
		high_address[43] = 8'h38; //44
		high_address[44] = 8'h38; //45
		high_address[45] = 8'h38; //46
		high_address[46] = 8'h38; //47
		high_address[47] = 8'h38; //48
		high_address[48] = 8'h38; //49
		high_address[49] = 8'h38; //50
		high_address[50] = 8'h38; //51
		high_address[51] = 8'h38; //52
		high_address[52] = 8'h36; //53
		high_address[53] = 8'h36; //54
		high_address[54] = 8'h36; //55
		high_address[55] = 8'h36; //56
		high_address[56] = 8'h36; //57
		high_address[57] = 8'h36; //58
		high_address[58] = 8'h36; //59
		high_address[59] = 8'h36; //60
		high_address[60] = 8'h37; //61
		high_address[61] = 8'h37; //62
		high_address[62] = 8'h37; //63
		high_address[63] = 8'h37; //64
		high_address[64] = 8'h37; //65
		high_address[65] = 8'h37; //66
		high_address[66] = 8'h37; //67
		high_address[67] = 8'h3f; //68
		high_address[68] = 8'h3f; //69
		high_address[69] = 8'h3f; //70
		high_address[70] = 8'h3a; //71
		high_address[71] = 8'h3a; //72
		high_address[72] = 8'h3a; //73
		high_address[73] = 8'h3a; //74
		high_address[74] = 8'h3a; //75
		high_address[75] = 8'h3a; //76
		high_address[76] = 8'h3a; //77
		high_address[77] = 8'h3a; //78
		high_address[78] = 8'h3a; //79
		high_address[79] = 8'h3a; //80
		high_address[80] = 8'h3a; //81
		high_address[81] = 8'h3a; //82
		high_address[82] = 8'h40; //83
		high_address[83] = 8'h40; //84
		high_address[84] = 8'h40; //85
		high_address[85] = 8'h48; //86
		high_address[86] = 8'h40; //87
		high_address[87] = 8'h40; //88
		high_address[88] = 8'h50; //89
		high_address[89] = 8'h01; //90
		high_address[90] = 8'h01; //91

		low_address[0] = 8'h00; //1
		low_address[1] = 8'h03; //2
		low_address[2] = 8'h34; //3
		low_address[3] = 8'h35; //4
		low_address[4] = 8'h36; //5
		low_address[5] = 8'h3c; //6
		low_address[6] = 8'h06; //7
		low_address[7] = 8'h21; //8
		low_address[8] = 8'h20; //9
		low_address[9] = 8'h27; //10
		low_address[10] = 8'h0c; //11
		low_address[11] = 8'h12; //12
		low_address[12] = 8'h18; //13
		low_address[13] = 8'h00; //14
		low_address[14] = 8'h01; //15
		low_address[15] = 8'h02; //16
		low_address[16] = 8'h03; //17
		low_address[17] = 8'h00; //18
		low_address[18] = 8'h00; //19
		low_address[19] = 8'h01; //20
		low_address[20] = 8'h02; //21
		low_address[21] = 8'h16; //22
		low_address[22] = 8'h17; //23
		low_address[23] = 8'h18; //24
		low_address[24] = 8'h1c; //25
		low_address[25] = 8'h1d; //26
		low_address[26] = 8'h18; //27
		low_address[27] = 8'h19; //28
		low_address[28] = 8'h01; //29
		low_address[29] = 8'h07; //30
		low_address[30] = 8'h0c; //31
		low_address[31] = 8'h0d; //32
		low_address[32] = 8'h0e; //33
		low_address[33] = 8'h0f; //34
		low_address[34] = 8'h14; //35
		low_address[35] = 8'h15; //36
		low_address[36] = 8'h08; //37
		low_address[37] = 8'h09; //38
		low_address[38] = 8'h08; //39
		low_address[39] = 8'h09; //40
		low_address[40] = 8'h0a; //41
		low_address[41] = 8'h0b; //42
		low_address[42] = 8'h00; //43
		low_address[43] = 8'h01; //44
		low_address[44] = 8'h02; //45
		low_address[45] = 8'h03; //46
		low_address[46] = 8'h04; //47
		low_address[47] = 8'h05; //48
		low_address[48] = 8'h06; //49
		low_address[49] = 8'h07; //50
		low_address[50] = 8'h11; //51
		low_address[51] = 8'h13; //52
		low_address[52] = 8'h30; //53
		low_address[53] = 8'h32; //54
		low_address[54] = 8'h33; //55
		low_address[55] = 8'h34; //56
		low_address[56] = 8'h36; //57
		low_address[57] = 8'h20; //58
		low_address[58] = 8'h21; //59
		low_address[59] = 8'h00; //60
		low_address[60] = 8'h04; //61
		low_address[61] = 8'h03; //62
		low_address[62] = 8'h15; //63
		low_address[63] = 8'h17; //64
		low_address[64] = 8'h31; //65
		low_address[65] = 8'h0b; //66
		low_address[66] = 8'h05; //67
		low_address[67] = 8'h05; //68
		low_address[68] = 8'h06; //69
		low_address[69] = 8'h01; //70
		low_address[70] = 8'h08; //71
		low_address[71] = 8'h09; //72
		low_address[72] = 8'h0a; //73
		low_address[73] = 8'h0b; //74
		low_address[74] = 8'h0d; //75
		low_address[75] = 8'h0e; //76
		low_address[76] = 8'h0f; //77
		low_address[77] = 8'h10; //78
		low_address[78] = 8'h1b; //79
		low_address[79] = 8'h1e; //80
		low_address[80] = 8'h11; //81
		low_address[81] = 8'h1f; //82
		low_address[82] = 8'h01; //83
		low_address[83] = 8'h04; //84
		low_address[84] = 8'h00; //85
		low_address[85] = 8'h37; //86
		low_address[86] = 8'h50; //87
		low_address[87] = 8'h51; //88
		low_address[88] = 8'h3d; //89
		low_address[89] = 8'h00; //90
		low_address[90] = 8'h00; //91

		values[0] = 8'h00; //1
		values[1] = 8'h01; //2
		values[2] = 8'h1a; //3
		values[3] = 8'h41; //4
		values[4] = 8'h7d; //5
		values[5] = 8'h11; //6
		values[6] = 8'hf5; //7
		values[7] = 8'h06; //8
		values[8] = 8'h00; //9
		values[9] = 8'hec; //10
		values[10] = 8'h03; //11
		values[11] = 8'h5b; //12
		values[12] = 8'h04; //13
		values[13] = 8'h06; //14
		values[14] = 8'h00; //15
		values[15] = 8'h40; //16
		values[16] = 8'h08; //17
		values[17] = 8'h08; //18
		values[18] = 8'h00; //19
		values[19] = 8'h00; //20
		values[20] = 8'h00; //21
		values[21] = 8'h08; //22
		values[22] = 8'he0; //23
		values[23] = 8'h44; //24
		values[24] = 8'hf8; //25
		values[25] = 8'hf0; //26
		values[26] = 8'h00; //27
		values[27] = 8'hf8; //28
		values[28] = 8'h80; //29
		values[29] = 8'h0c; //30
		values[30] = 8'h0a; //31
		values[31] = 8'h8c; //32
		values[32] = 8'h07; //33
		values[33] = 8'hb6; //34
		values[34] = 8'h11; //35
		values[35] = 8'h11; //36
		values[36] = 8'h64; //37
		values[37] = 8'h12; //38
		values[38] = 8'h0a; //39
		values[39] = 8'h20; //40
		values[40] = 8'h07; //41
		values[41] = 8'h98; //42
		values[42] = 8'h00; //43
		values[43] = 8'h00; //44
		values[44] = 8'h00; //45
		values[45] = 8'h00; //46
		values[46] = 8'h0a; //47
		values[47] = 8'h3f; //48
		values[48] = 8'h07; //49
		values[49] = 8'ha3; //50
		values[50] = 8'h10; //51
		values[51] = 8'h06; //52
		values[52] = 8'h2e; //53
		values[53] = 8'he2; //54
		values[54] = 8'h23; //55
		values[55] = 8'h44; //56
		values[56] = 8'h06; //57
		values[57] = 8'h64; //58
		values[58] = 8'he0; //59
		values[59] = 8'h37; //60
		values[60] = 8'ha0; //61
		values[61] = 8'h5a; //62
		values[62] = 8'h78; //63
		values[63] = 8'h01; //64
		values[64] = 8'h02; //65
		values[65] = 8'h60; //66
		values[66] = 8'h1a; //67
		values[67] = 8'h02; //68
		values[68] = 8'h10; //69
		values[69] = 8'h0a; //70
		values[70] = 8'h01; //71
		values[71] = 8'h28; //72
		values[72] = 8'h00; //73
		values[73] = 8'hf6; //74
		values[74] = 8'h08; //75
		values[75] = 8'h06; //76
		values[76] = 8'h58; //77
		values[77] = 8'h50; //78
		values[78] = 8'h58; //79
		values[79] = 8'h50; //80
		values[80] = 8'h60; //81
		values[81] = 8'h28; //82
		values[82] = 8'h02; //83
		values[83] = 8'h04; //84
		values[84] = 8'h09; //85
		values[85] = 8'h28; //86
		values[86] = 8'h6e; //87
		values[87] = 8'h8f; //88
		values[88] = 8'h80; //89
		values[89] = 8'h01; //90
		values[90] = 8'h00; //91

		
		//PCLK is internal MIPI pixel clock, it is related to SCLK and MIPI divider. At current 2lane setting, 4837 = 2000/(mipi_speed/5).  If MIPI clock is 125MHz (mipi_speed/lane is 250Mbps), then 4837 = 0x28. If mipi_speed = 200Mbps, then 4837 = 0x32


	end
endmodule
