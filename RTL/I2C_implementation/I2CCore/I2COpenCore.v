module I2COpenCore
(
	input clk_50,
	input [1:0] user_buttons,
	input [7:0] user_sw,
	output reg [7:0] user_leds,
	inout i2c_sda,
	inout i2c_scl
);

wire [1:0] buttons_pressed;
wire [1:0] buttons_held;
wire [1:0] switch_pressed;
wire [1:0] switch_held;
reg reset_debs;
localparam [7:0] WAIT = 1,ENABLE_CORE=2,WRITE_SLAVE_ADDRESS=3,WRITE_START_AND_WRITE=4,WAIT_FOR_TIP_FROM_STEP_2=5,SET_DATA_TO_DEVICE=6,SEND_WRITE_TO_DEVICE=7,WAIT_TRANSFER_DONE=8,SET_LAST_DATA=9,SEND_WRITE_STOP=10,WAIT_FOR_STOP=11, WRITE_READ_FROM_DEVICE=12, READ_FROM_DEVICE=13;
localparam [2:0] PRERlo = 0, PRERhi = 1, CTR = 2, TXR = 3, RXR = 3, CR = 4, SR = 4;
reg [7:0] current_state, next_state;

debouncer d1(.button(~user_buttons[0]), .clk(clk_50), .reset(reset_debs), .pressed(buttons_pressed[0]), .held(buttons_held[0]));
debouncer d2(.button(~user_buttons[1]), .clk(clk_50), .reset(reset_debs), .pressed(buttons_pressed[1]), .held(buttons_held[1]));

debouncer d3(.button(~user_sw[0]), .clk(clk_50), .reset(reset_debs), .pressed(switch_pressed[0]), .held(switch_held[0]));
debouncer d4(.button(~user_sw[1]), .clk(clk_50), .reset(reset_debs), .pressed(switch_pressed[1]), .held(switch_held[1]));


wire [7:0] address_slave_cam_write = 8'h6c;
wire [7:0] address_slave_cam_read = 8'h6d;
wire [6:0] number_of_registers = 7'h58; //n regs - 1
reg [7:0] high_address [0:89] ;
reg [7:0] low_address [0:89] ;
reg [7:0] values [0:89] ;


reg [2:0] address;
reg [7:0] writedata;
wire [7:0] readdata;
reg write = 0;
reg enable = 1;
wire waitrequest_n;
wire bus_enable = 0;

wire scl_padoen_o;
wire scl_pad_o;
wire sda_padoen_o;
wire sda_pad_o;
wire scl_pad_i;
wire sda_pad_i;

assign i2c_scl = scl_padoen_o ? 1'bz : scl_pad_o;
assign i2c_sda = sda_padoen_o ? 1'bz: sda_pad_o;
assign scl_pad_i = i2c_scl;
assign sda_pad_i = i2c_sda;


i2c_master_top i2c_master(
	// wishbone signals
	.wb_clk_i(clk_50),      			// master clock input
	.wb_rst_i(buttons_held[1]),      // synchronous active high reset
	.arst_i(!buttons_held[1]),       		// asynchronous reset 
	.wb_adr_i(address),      // lower address bits 
	.wb_dat_i(writedata),      // databus input 
	.wb_dat_o(readdata),      // databus output
	.wb_we_i(write),       // write enable input 
	.wb_stb_i(enable),      // stobe/core select signal 
	.wb_cyc_i(enable),      // valid bus cycle input 
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

	reg [1:0] read_flag;
	reg [1:0] write_flag;
	reg write_i2c;
	reg [6:0] register_index;

always @(posedge clk_50)
begin
	if(buttons_held[1])
	begin
		current_state <= WAIT;
		read_flag <= 0;
		write_flag <= 0;
		write_upper_address_flag <= 0;
		write_lower_address_flag <= 0;
		register_index <= 0;
		last_transmission_flag <= 0;
		needs_read_flag <= 0;
	end
	else 
	begin
		current_state <= next_state;
		if(current_state == WAIT)
		begin
			last_transmission_flag <= 0;
			register_index <= 0;
			needs_read_flag <=0;
		end
		if(current_state == ENABLE_CORE || current_state == WRITE_SLAVE_ADDRESS || current_state == WRITE_START_AND_WRITE ||current_state ==  SET_DATA_TO_DEVICE ||current_state == SEND_WRITE_TO_DEVICE|| current_state == SET_LAST_DATA ||current_state == SEND_WRITE_STOP || current_state == WRITE_READ_FROM_DEVICE || current_state == READ_FROM_DEVICE)
		begin
			if(write_flag == 3)
			begin
				write_flag <= 0;
			end
			else
			begin
				write_flag <= write_flag + 1;
			end
		end
		if(current_state == WAIT_FOR_TIP_FROM_STEP_2 || current_state == WAIT_TRANSFER_DONE || current_state == WAIT_FOR_STOP)
		begin
			if(read_flag == 2)
			begin
				read_flag <= 0;
			end
			else
			begin
				read_flag <= read_flag + 1;
			end
		end
		if(current_state == WAIT_FOR_TIP_FROM_STEP_2)
		begin
			if(read_flag == 2)
			begin
				if(readdata[1] == 0)
				begin
					write_upper_address_flag <= 1;
				end
			end
		end
		else if(current_state == WAIT_TRANSFER_DONE)
		begin
			if(read_flag == 2)
			begin
				if(readdata[1] == 0)
				begin
					if(write_upper_address_flag)
					begin
						write_upper_address_flag <= 0;
						write_lower_address_flag <= 1;
					end
					else if(write_lower_address_flag)
					begin
						write_lower_address_flag <= 0;
					end
				end
			end
		end
		else if (current_state == SEND_WRITE_STOP || current_state == READ_FROM_DEVICE)
		begin
			needs_read_flag <= 0;
			if(write_flag == 3)
			begin
				register_index <= register_index + 1;
				if(register_index == (number_of_registers -1))
				begin
					last_transmission_flag <= 1;
				end //if
			end //if
		end //else if
		else if(current_state == WRITE_READ_FROM_DEVICE)
		begin
			needs_read_flag <= 1;
		end
	end
	
end

reg write_upper_address_flag ;
reg write_lower_address_flag ;
reg needs_read_flag;
reg last_transmission_flag;

always @(*)
begin
	next_state = current_state;
	address = 0;
	writedata = 0;
	write = 0;
	user_leds = readdata;
	//enable = 1;
	
	if(buttons_held[1])
	begin
		//address = PRERlo;
		//writedata = 8'h63;
		next_state = WAIT;
		//write = 1;
		//enable = 1;
		//write_values_flag = 0;
	end
	else 
	begin
		case(current_state)
		WAIT:
		begin
			//write_values_flag = 0;
			//address = PRERhi;
			//writedata = 8'h0;
			//write = 1;
			if(switch_pressed[0] || switch_pressed[1])
			begin
				//write = 1;
				enable = 1;
				//address = CTR;
				//writedata = 8'h80;
				next_state = ENABLE_CORE;
			end
			else
			begin
			end
		end
		ENABLE_CORE: // step 0
		begin
			if(write_flag == 3)
			begin
				next_state = WRITE_SLAVE_ADDRESS;
			end
			else
			begin
				write = 1;
				address = CTR;
				writedata = 8'h80;
			end
		end
		WRITE_SLAVE_ADDRESS: // step 1
		begin
			if(write_flag == 3)
			begin
				next_state = WRITE_START_AND_WRITE;
			end
			else
			begin
				write = 1;
				address = TXR;
				writedata = address_slave_cam_write;
			end 
		end
		WRITE_START_AND_WRITE: //step 2
		begin
			if(write_flag == 3)
			begin
				next_state = WAIT_FOR_TIP_FROM_STEP_2;		
			end
			else
			begin
				write = 1;
				address = CR;
				writedata = 8'h90;
			end 
		end
		WAIT_FOR_TIP_FROM_STEP_2: //step 3
		begin
			if(read_flag == 2)
			begin
				address = SR;
				if(readdata[1] == 0)
				begin
					if(needs_read_flag == 0)
					begin
						next_state = SET_DATA_TO_DEVICE;		
					end
					else if(needs_read_flag == 1)
					begin
						next_state = READ_FROM_DEVICE;		
					end		
				end
			end
			else
			begin
				address = SR;
			end
			
					
		end
		READ_FROM_DEVICE:
		begin
			if(write_flag == 3)
			begin
				if(last_transmission_flag)
				begin
					next_state = WAIT;
				end
				else
				begin
					next_state = WAIT_FOR_STOP; 
				end
			end
			else
			begin
				write = 1;
				address = CR;
				writedata = 8'h28;
			end 
		end
		SET_DATA_TO_DEVICE:
		begin
			if(write_flag == 3)
			begin
				next_state = SEND_WRITE_TO_DEVICE; //need flags
			end
			else
			begin
				write = 1;
				address = TXR;
				if(write_upper_address_flag)
				begin
					writedata = high_address[register_index]; // to bevariable
				end
				else if(write_lower_address_flag)
				begin
					writedata = low_address[register_index]; // to bevariable
				end
				
			end 
		end
		SEND_WRITE_TO_DEVICE:
		begin
			if(write_flag == 3)
			begin
			
				next_state = WAIT_TRANSFER_DONE; //needs flags
			end
			else
			begin
				write = 1;
				address = CR;
				writedata = 8'h10;
			end 
		end
		WAIT_TRANSFER_DONE:
		begin
		
			if(read_flag == 2)
			begin
				address = SR;
				if(readdata[1] == 0)
				begin
					if(write_upper_address_flag)
					begin
						next_state = SET_DATA_TO_DEVICE; //needs flags
					end
					else if(write_lower_address_flag && switch_held[0])
					begin
						next_state = SET_LAST_DATA; //needs flags
					end
					else if(write_lower_address_flag && switch_held[1])
					begin
						next_state = WRITE_READ_FROM_DEVICE; //needs flags
					end
				end
			end
			else
			begin
				address = SR;
			end		
		end
		WRITE_READ_FROM_DEVICE: 
		begin
			if(write_flag == 3)
			begin
				next_state = WRITE_START_AND_WRITE;
			end
			else
			begin
				write = 1;
				address = TXR;
				writedata = address_slave_cam_read;
			end 
		end
		SET_LAST_DATA:
		begin
			//write_values_flag = 0;
			if(write_flag == 3)
			begin
				next_state = SEND_WRITE_STOP; 
			end
			else
			begin
				write = 1;
				address = TXR;
				writedata = values[register_index]; 			
			end 
		end
		SEND_WRITE_STOP:
		begin
			if(write_flag == 3)
			begin
				if(last_transmission_flag)
				begin
					next_state = WAIT;
				end
				else
				begin
					next_state = WAIT_FOR_STOP; 
				end
			end
			else
			begin
				write = 1;
				address = CR;
				writedata = 8'h50;
			end 
		end
		WAIT_FOR_STOP:
		begin
			if(read_flag == 2)
			begin
				address = SR;
				if(readdata[1] == 0)
				begin
					next_state = WRITE_SLAVE_ADDRESS;
				end
			end
			else
			begin
				address = SR;
			end
		end
		default: next_state = WAIT;
		endcase
	end
end

initial 
begin
	high_address[0] = 8'h01; 
	high_address[1] = 8'h01; 
	high_address[2] = 8'h30; 
	high_address[3] = 8'h30; 
	high_address[4] = 8'h30; 
	high_address[5] = 8'h30; 
	high_address[6] = 8'h31; 
	high_address[7] = 8'h38; 
	high_address[8] = 8'h38; 
	high_address[9] = 8'h38; 
	high_address[10] = 8'h37; 
	high_address[11] = 8'h36; 
	high_address[12] = 8'h36; 
	high_address[13] = 8'h50; 
	high_address[14] = 8'h50; 
	high_address[15] = 8'h50; 
	high_address[16] = 8'h50; 
	high_address[17] = 8'h5a; 
	high_address[18] = 8'h30; 
	high_address[19] = 8'h30; 
	high_address[20] = 8'h30; 
	high_address[21] = 8'h30; 
	high_address[22] = 8'h30; 
	high_address[23] = 8'h30; 
	high_address[24] = 8'h30; 
	high_address[25] = 8'h30; 
	high_address[26] = 8'h3a; 
	high_address[27] = 8'h3a; 
	high_address[28] = 8'h3c; 
	high_address[29] = 8'h3b; 
	high_address[30] = 8'h38; 
	high_address[31] = 8'h38; 
	high_address[32] = 8'h38; 
	high_address[33] = 8'h38; 
	high_address[34] = 8'h38; 
	high_address[35] = 8'h38; 
	high_address[36] = 8'h37; 
	high_address[37] = 8'h37; 
	high_address[38] = 8'h38; 
	high_address[39] = 8'h38; 
	high_address[40] = 8'h38; 
	high_address[41] = 8'h38; 
	high_address[42] = 8'h38; 
	high_address[43] = 8'h38; 
	high_address[44] = 8'h38; 
	high_address[45] = 8'h38; 
	high_address[46] = 8'h38; 
	high_address[47] = 8'h38; 
	high_address[48] = 8'h38; 
	high_address[49] = 8'h38; 
	high_address[50] = 8'h38; 
	high_address[51] = 8'h38; 
	high_address[52] = 8'h36; 
	high_address[53] = 8'h36; 
	high_address[54] = 8'h36; 
	high_address[55] = 8'h36; 
	high_address[56] = 8'h36; 
	high_address[57] = 8'h36; 
	high_address[58] = 8'h36; 
	high_address[59] = 8'h36; 
	high_address[60] = 8'h37; 
	high_address[61] = 8'h37; 
	high_address[62] = 8'h37; 
	high_address[63] = 8'h37; 
	high_address[64] = 8'h37; 
	high_address[65] = 8'h37; 
	high_address[66] = 8'h37; 
	high_address[67] = 8'h3f; 
	high_address[68] = 8'h3f; 
	high_address[69] = 8'h3f; 
	high_address[70] = 8'h3a; 
	high_address[71] = 8'h3a; 
	high_address[72] = 8'h3a; 
	high_address[73] = 8'h3a; 
	high_address[74] = 8'h3a; 
	high_address[75] = 8'h3a; 
	high_address[76] = 8'h3a; 
	high_address[77] = 8'h3a; 
	high_address[78] = 8'h3a; 
	high_address[79] = 8'h3a; 
	high_address[80] = 8'h3a; 
	high_address[81] = 8'h3a; 
	high_address[82] = 8'h40; 
	high_address[83] = 8'h40; 
	high_address[84] = 8'h40; 
	high_address[85] = 8'h48; 
	high_address[86] = 8'h40; 
	high_address[87] = 8'h40; 
	high_address[88] = 8'h50; 
	high_address[89] = 8'h01; 

	low_address[0] = 8'h00; 
	low_address[1] = 8'h03; 
	low_address[2] = 8'h34; 
	low_address[3] = 8'h35; 
	low_address[4] = 8'h36; 
	low_address[5] = 8'h3c; 
	low_address[6] = 8'h06; 
	low_address[7] = 8'h21; 
	low_address[8] = 8'h20; 
	low_address[9] = 8'h27; 
	low_address[10] = 8'h0c; 
	low_address[11] = 8'h12; 
	low_address[12] = 8'h18; 
	low_address[13] = 8'h00; 
	low_address[14] = 8'h01; 
	low_address[15] = 8'h02; 
	low_address[16] = 8'h03; 
	low_address[17] = 8'h00; 
	low_address[18] = 8'h00; 
	low_address[19] = 8'h01; 
	low_address[20] = 8'h02; 
	low_address[21] = 8'h16; 
	low_address[22] = 8'h17; 
	low_address[23] = 8'h18; 
	low_address[24] = 8'h1c; 
	low_address[25] = 8'h1d; 
	low_address[26] = 8'h18; 
	low_address[27] = 8'h19; 
	low_address[28] = 8'h01; 
	low_address[29] = 8'h07; 
	low_address[30] = 8'h0c; 
	low_address[31] = 8'h0d; 
	low_address[32] = 8'h0e; 
	low_address[33] = 8'h0f; 
	low_address[34] = 8'h14; 
	low_address[35] = 8'h15; 
	low_address[36] = 8'h08; 
	low_address[37] = 8'h09; 
	low_address[38] = 8'h08; 
	low_address[39] = 8'h09; 
	low_address[40] = 8'h0a; 
	low_address[41] = 8'h0b; 
	low_address[42] = 8'h00; 
	low_address[43] = 8'h01; 
	low_address[44] = 8'h02; 
	low_address[45] = 8'h03; 
	low_address[46] = 8'h04; 
	low_address[47] = 8'h05; 
	low_address[48] = 8'h06; 
	low_address[49] = 8'h07; 
	low_address[50] = 8'h11; 
	low_address[51] = 8'h13; 
	low_address[52] = 8'h30; 
	low_address[53] = 8'h32; 
	low_address[54] = 8'h33; 
	low_address[55] = 8'h34; 
	low_address[56] = 8'h36; 
	low_address[57] = 8'h20; 
	low_address[58] = 8'h21; 
	low_address[59] = 8'h00; 
	low_address[60] = 8'h04; 
	low_address[61] = 8'h03; 
	low_address[62] = 8'h15; 
	low_address[63] = 8'h17; 
	low_address[64] = 8'h31; 
	low_address[65] = 8'h0b; 
	low_address[66] = 8'h05; 
	low_address[67] = 8'h05; 
	low_address[68] = 8'h06; 
	low_address[69] = 8'h01; 
	low_address[70] = 8'h08; 
	low_address[71] = 8'h09; 
	low_address[72] = 8'h0a; 
	low_address[73] = 8'h0b; 
	low_address[74] = 8'h0d; 
	low_address[75] = 8'h0e; 
	low_address[76] = 8'h0f; 
	low_address[77] = 8'h10; 
	low_address[78] = 8'h1b; 
	low_address[79] = 8'h1e; 
	low_address[80] = 8'h11; 
	low_address[81] = 8'h1f; 
	low_address[82] = 8'h01; 
	low_address[83] = 8'h04; 
	low_address[84] = 8'h00; 
	low_address[85] = 8'h37; 
	low_address[86] = 8'h50; 
	low_address[87] = 8'h51; 
	low_address[88] = 8'h3d; 
	low_address[89] = 8'h00; 

	values[0] = 8'h00; 
	values[1] = 8'h01; 
	values[2] = 8'h1a; 
	values[3] = 8'h41; 
	values[4] = 8'h7d; 
	values[5] = 8'h11; 
	values[6] = 8'hf5; 
	values[7] = 8'h06; 
	values[8] = 8'h00; 
	values[9] = 8'hec; 
	values[10] = 8'h03; 
	values[11] = 8'h5b; 
	values[12] = 8'h04; 
	values[13] = 8'h06; 
	values[14] = 8'h00; 
	values[15] = 8'h40; 
	values[16] = 8'h08; 
	values[17] = 8'h08; 
	values[18] = 8'h00; 
	values[19] = 8'h00; 
	values[20] = 8'h00; 
	values[21] = 8'h08; 
	values[22] = 8'he0; 
	values[23] = 8'h44; 
	values[24] = 8'hf8; 
	values[25] = 8'hf0; 
	values[26] = 8'h00; 
	values[27] = 8'hf8; 
	values[28] = 8'h80; 
	values[29] = 8'h0c; 
	values[30] = 8'h0a; 
	values[31] = 8'h8c; 
	values[32] = 8'h07; 
	values[33] = 8'hb6; 
	values[34] = 8'h11; 
	values[35] = 8'h11; 
	values[36] = 8'h64; 
	values[37] = 8'h12; 
	values[38] = 8'h0a; 
	values[39] = 8'h20; 
	values[40] = 8'h07; 
	values[41] = 8'h98; 
	values[42] = 8'h00; 
	values[43] = 8'h00; 
	values[44] = 8'h00; 
	values[45] = 8'h00; 
	values[46] = 8'h0a; 
	values[47] = 8'h3f; 
	values[48] = 8'h07; 
	values[49] = 8'ha3; 
	values[50] = 8'h10; 
	values[51] = 8'h06; 
	values[52] = 8'h2e; 
	values[53] = 8'he2; 
	values[54] = 8'h23; 
	values[55] = 8'h44; 
	values[56] = 8'h06; 
	values[57] = 8'h64; 
	values[58] = 8'he0; 
	values[59] = 8'h37; 
	values[60] = 8'ha0; 
	values[61] = 8'h5a; 
	values[62] = 8'h78; 
	values[63] = 8'h01; 
	values[64] = 8'h02; 
	values[65] = 8'h60; 
	values[66] = 8'h1a; 
	values[67] = 8'h02; 
	values[68] = 8'h10; 
	values[69] = 8'h0a; 
	values[70] = 8'h01; 
	values[71] = 8'h28; 
	values[72] = 8'h00; 
	values[73] = 8'hf6; 
	values[74] = 8'h08; 
	values[75] = 8'h06; 
	values[76] = 8'h58; 
	values[77] = 8'h50; 
	values[78] = 8'h58; 
	values[79] = 8'h50; 
	values[80] = 8'h60; 
	values[81] = 8'h28; 
	values[82] = 8'h02; 
	values[83] = 8'h04; 
	values[84] = 8'h09; 
	values[85] = 8'h32; 
	values[86] = 8'h6e; 
	values[87] = 8'h8f; 
	values[88] = 8'h80; 
	values[89] = 8'h01; 
	
	//PCLK is internal MIPI pixel clock, it is related to SCLK and MIPI divider. At current 2lane setting, 4837 = 2000/(mipi_speed/5).  If MIPI clock is 125MHz (mipi_speed/lane is 250Mbps), then 4837 = 0x28. If mipi_speed = 200Mbps, then 4837 = 0x32


end
endmodule