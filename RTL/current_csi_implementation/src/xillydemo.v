module xillydemo
  (
   input  clk_50,
   input  pcie_perstn,
   input  pcie_refclk,
   input  pcie_rx,
	input [1:0] user_buttons,
	input [7:0] user_sw,
   output  pcie_tx,
   output [3:0] user_led,
	output reg [3:0] our_led,
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
	
	localparam [4:0] WRITE_ROWS=1, WRITE_COLUMNS=2, WRITE_ENABLE=3, READ_ROWS=4, READ_COLUMNS=5, READ_ENABLE=6, DATA_TRANSFER=7, WAIT_FOR_FS=8,WRITE_FULL=9,WAIT=10, READ_CONFIG=11,WRITE_CONFIG=12,WRITE_ENABLE_FROM_FULL=13,WRITE_ENABLE_FROM_EMPTY=14,WRITE_ENABLE_FROM_FE=15,WRITE_CONFIG_ALL=16,READ_ADDRESS_2=17,WRITE_ADDRESS_2=18,S_0=0;
	reg [4:0] current_state,next_state;
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
	
	//CSI
	wire   [ 9:0] svr_pixel          ; // pixel output. RAW10 - all bits are used. RAW8 - bits 7:0 are used. Sample with fclk   
	wire          svr_pixel_valid    ; // pixel valid qualifier. Sample with fclk    
	wire   [ 1:0] svr_channel_id     ; // MIPI CSI2 Channel indicator. I don't think that the camera is using it, so it will probably be 00. Sample with fclk    
	wire          svr_fs             ; // Frame-Start. One fclk wide pulse    
	wire          svr_fe             ; // Frame-End. One fclk wide pulse     
	wire          svr_ls             ; // Line-Start. One fclk wide pulse    
	wire          svr_le             ; // Line-End. One fclk wide pulse      
	wire   [ 5:0] svr_data_type      ; // will indicate the data-type of the received packet, per CSI2. RAW8 is 0x28 and RAW10 is 0x2B. Sample with fclk    
	wire          svr_cpu_int        ; // Interrupt output, upon error or other predefined cases. Sample with pclk    
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
		.fclk(clk_125)               ,
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
		.hs_clk (hs_clk)            ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
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
		end
		else 
		begin
			current_state <= next_state;
			if(svr_cpu_int)
			begin
				if(read_flag >= 2)
				begin
					if(readdata[31:16] != 16'h0CA8 && readdata[31:16] != 16'h0000)
					begin
						wrongBytesFlag <= wrongBytesFlag + 1;
					end
				end
			end
			if(current_state == WRITE_ROWS || current_state == WRITE_COLUMNS || current_state == WRITE_CONFIG_ALL || current_state == WRITE_ENABLE || current_state == WRITE_CONFIG 
				|| current_state == WRITE_ENABLE_FROM_FULL || current_state == WRITE_ENABLE_FROM_EMPTY || current_state == WRITE_ENABLE_FROM_FE || current_state == WRITE_ADDRESS_2)
			begin
				if(write_flag == 2)
				begin
					write_flag <= 0;
				end
				else
				begin
					write_flag <= write_flag + 1;
				end
			end
			if(current_state == READ_ROWS || current_state == READ_COLUMNS || current_state == READ_ENABLE || current_state == READ_CONFIG || current_state == READ_ADDRESS_2 || svr_cpu_int)
			begin
			
				if(read_flag == 3)
				begin
					read_flag <= 0;
				end
				else
				begin
					read_flag <= read_flag + 1;
				end
			end
			if(current_state == WAIT)
			begin
				feCounter <= 0;
			end
			if(current_state == WAIT_FOR_FS)
			begin
				if(svr_fe)
				begin
					feCounter <= feCounter + 1;
				end
			end
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
		if(svr_cpu_int)
		begin
			if(read_flag == 2)
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
				WAIT:
				begin
					
				  if (user_r_read_8_data == 8'b01100011) //c - write enable
				  begin
						our_led = status_interrupt[7:4];
						next_state = WRITE_ENABLE;
				  end
				  else if (user_r_read_8_data == 8'b01100110) //f - read and output enable at 32
				  begin
					our_led = status_interrupt[11:8];
						next_state = READ_ENABLE;
				  end
				  else if (user_r_read_8_data == 8'b01100111) //g - read and output config at 32
				  begin
					our_led = status_interrupt[15:12];
						next_state = READ_CONFIG;
				  end
				  else if (user_r_read_8_data == 8'b01101000) //h - write config 2'b01
				  begin
					our_led = status_interrupt[19:16];
						next_state = WRITE_CONFIG;
				  end
				  else if (user_r_read_8_data == 8'b01101001) //i - write config 2'b11
				  begin
					our_led = status_interrupt[23:20];
						next_state = WRITE_CONFIG_ALL;
				  end
				   else if (user_r_read_8_data == 8'b01101010) //j - read address 0x02
				  begin
					our_led = status_interrupt[27:24];
						next_state = READ_ADDRESS_2;
				  end
				   else if (user_r_read_8_data == 8'b01101011) //k - write address 0x02 
				  begin
					our_led = status_interrupt[3:0];
						next_state = WRITE_ADDRESS_2;
				  end
				  else if(user_r_read_8_data == 8'b01101100) //h
				  begin
					our_led = wrongBytesFlag;
				  end
				  else
				  begin
					our_led = status_interrupt[31:28];
				  end
				end
				WRITE_ENABLE:
				begin
					
					if(write_flag == 2)
					begin
						next_state = WAIT_FOR_FS;
					end
					else
					begin
						address = 0;
						write = 1'b1;
						writedata = 1;
					
					end
				end
				READ_ENABLE:
				begin
					if(read_flag == 2)
					begin
						
						
						next_state = WAIT;
					end
					else if(read_flag == 1)
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
				READ_ADDRESS_2:
				begin
					if(read_flag == 2)
					begin		
						next_state = WAIT;
					end
					else if(read_flag == 1)
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
					if(read_flag == 2)
					begin
						
						
						next_state = WAIT;
					end
					else if(read_flag == 1)
					begin
						output_fifo = readdata;
						write_request = 1'b1;
						read = 1'b1;
						address = 6'h1;
					end
					else
					begin
						read = 1'b1;
						address = 6'h1;
					end
				end
				WRITE_CONFIG:
				begin
					if(write_flag == 2)
					begin
						next_state = WAIT;
					end
					else
					begin
						address = 1;
						write = 1'b1;
						writedata = 2;
					end
				end
				WRITE_ADDRESS_2:
				begin
					if(write_flag == 2)
					begin
						next_state = WAIT;
					end
					else
					begin
						address = 2;
						write = 1'b1;
						writedata[23:16] = ~user_sw;
						writedata[7:0] = ~user_sw;
					end
				end
				WRITE_CONFIG_ALL:
				begin
					if(write_flag == 2)
					begin
						next_state = WAIT;
					end
					else
					begin
						address = 1;
						write = 1'b1;
						writedata = 3;
					end
				end
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
					if(svr_fs == 1'b1 && feCounter > 1)
					begin
						next_state = DATA_TRANSFER;
					end
					else
					begin
					
					end
				end
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
				WRITE_ENABLE_FROM_FULL:
				begin
					if(write_flag == 2)
					begin
						write = 1'b1;
						next_state = WRITE_FULL;
						write_request = 0;
					end
					else
					begin
						address = 0;
						write = 1'b1;
						writedata = 0;
						write_request = svr_pixel_valid;
						output_fifo = svr_pixel;
					
					end
				end
				WRITE_ENABLE_FROM_EMPTY:
				begin
					if(write_flag == 2)
					begin
						write = 1'b1;
						next_state = DATA_TRANSFER;
					end
					else
					begin
						address = 0;
						write = 1'b1;
						writedata = 1;
					
					end
				end
				WRITE_ENABLE_FROM_FE:
				begin
					if(write_flag == 2)
					begin
						next_state = WAIT;
					end
					else
					begin
						address = 0;
						write = 1'b1;
						writedata = 0;
					
					end
				end
				
				
				default:
				begin
					next_state = WAIT;
				end	
			endcase
		
		
   end

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
	   fifo_32.add_ram_output_register = "OFF",
	   fifo_32.lpm_numwords = 1024,
	   fifo_32.lpm_showahead = "OFF",
	   fifo_32.lpm_type = "scfifo",
	   fifo_32.lpm_width = 32,
	   fifo_32.lpm_widthu = 10,
	   fifo_32.overflow_checking = "ON",
	   fifo_32.underflow_checking = "ON",
	   fifo_32.use_eab = "ON",
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
	   fifo_8.add_ram_output_register = "OFF",
	   fifo_8.lpm_numwords = 2048,
	   fifo_8.lpm_showahead = "OFF",
	   fifo_8.lpm_type = "scfifo",
	   fifo_8.lpm_width = 8,
	   fifo_8.lpm_widthu = 11,
	   fifo_8.overflow_checking = "ON",
	   fifo_8.underflow_checking = "ON",
	   fifo_8.use_eab = "ON";
   
   assign  user_r_read_8_eof = 0;
endmodule
