/*
*	Still in progress. can send a write command succesfully for now
*
*/
module I2COpenCore
(
	input clk_50,
	input [1:0] user_buttons,
	output reg [7:0] user_leds,
	inout i2c_sda,
	inout i2c_scl
);

wire [1:0] buttons_pressed;
wire [1:0] buttons_held;
reg reset_debs;
localparam [7:0] WAIT = 1,SET_SLAVE_ADDR = 2,INIT_I2C=3, WAIT_TRANSFER_TIP_COMES_FROM_INIT_I2C=4, SEND_WRITE_I2C=5, STOP_I2C=6,WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_NEEDS_LOWER_ADDRESS=7,WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_SEND_DATA=8,SEND_WRITE_I2C_NEEDS_LOWER_ADDRESS=9,WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_NEEDS_UPPER_ADDRESS=10,WAIT_TRANSFER_TIP_SENDING_DATA=11,SEND_WRITE_I2C_NEEDS_UPPER_ADDRESS=12;
localparam [2:0] PRERlo = 0, PRERhi = 1, CTR = 2, TXR = 3, RXR = 3, CR = 4, SR = 4;
reg [7:0] current_state, next_state;

debouncer d1(.button(~user_buttons[0]), .clk(clk_50), .reset(reset_debs), .pressed(buttons_pressed[0]), .held(buttons_held[0]));
debouncer d2(.button(~user_buttons[1]), .clk(clk_50), .reset(reset_debs), .pressed(buttons_pressed[1]), .held(buttons_held[1]));

wire [7:0] address_slave_cam_write = 8'h6c;
wire [7:0] address_slave_cam_read = 8'h6d;



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

	

always @(posedge clk_50)
begin
	if(buttons_held[1])
	begin
		current_state <= WAIT;
	end
	else 
	begin
		current_state <= next_state;	
	end
	
end

always @(*)
begin
	next_state = current_state;
	if(buttons_held[1])
	begin
		//address = PRERlo;
		//writedata = 8'h63;
		next_state = WAIT;
		//write = 1;
		enable = 1;
	end
	else 
	begin
		case(current_state)
		WAIT:
		begin
			//address = PRERhi;
			//writedata = 8'h0;
			//write = 1;
			if(buttons_pressed[0])
			begin
				write = 1;
				enable = 1;
				address = CTR;
				writedata = 8'h80;
				next_state = INIT_I2C;
			end
			else
			begin
			end
		end
		SET_SLAVE_ADDR:
		begin
			//write = 0;
			address = TXR;
			write = 1;
			writedata = address_slave_cam_write;
			next_state = WAIT_TRANSFER_TIP_COMES_FROM_INIT_I2C;
		end
		INIT_I2C:
		begin
			address = CR;
			write = 1;
			writedata = 8'h90;
			next_state = SET_SLAVE_ADDR;
			
		end
		WAIT_TRANSFER_TIP_COMES_FROM_INIT_I2C:
		begin
			address = SR;
			write = 0;
			if(address == SR)
			begin
				if(readdata[1] == 0)
				begin
					address = TXR;
					write = 1;
					writedata = address_slave_cam_write;
					next_state = SEND_WRITE_I2C_NEEDS_UPPER_ADDRESS;
				end
			end
			
		end
		WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_NEEDS_UPPER_ADDRESS:
		begin
			address = SR;
			write = 0;
			if(address == SR)
			begin
				if(readdata[1] == 0)
				begin
					if(readdata[7]== 0)
					begin
						address = TXR;
						write = 1;
						writedata = 8'h01;
						next_state = SEND_WRITE_I2C_NEEDS_LOWER_ADDRESS;	
					end
					else
					begin
						next_state = STOP_I2C;
					end
				end
			end
		end
		WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_NEEDS_LOWER_ADDRESS:
		begin
			address = SR;
			write = 0;
			if(address == SR)
			begin
				if(readdata[1] == 0)
				begin
					if(readdata[7]== 0)
					begin
						address = TXR;
						write = 1;
						writedata = 8'h0;
						next_state = SEND_WRITE_I2C;	
					end
					else
					begin
						next_state = STOP_I2C;
					end
				end
			end
		end
		WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_SEND_DATA:
		begin
			address = SR;
			write = 0;
			if(address == SR)
			begin
				if(readdata[1] == 0)
				begin
					if(readdata[7]== 0)
					begin
						address = TXR;
						write = 1;
						writedata = 8'h01;
						next_state = STOP_I2C;	
					end
				end
			end
		end
		WAIT_TRANSFER_TIP_SENDING_DATA:
		begin
			address = SR;
			write = 0;
			if(address == SR)
			begin
				if(readdata[1] == 0)
				begin
					if(readdata[7]== 0)
					begin
						write = 1;
						next_state = WAIT;	
					end
				end
			end
		end
		SEND_WRITE_I2C_NEEDS_UPPER_ADDRESS: 
		begin 
			address = CR;
			write = 1;
			writedata = 8'h10;
			next_state = WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_NEEDS_UPPER_ADDRESS;
		end
		SEND_WRITE_I2C_NEEDS_LOWER_ADDRESS: 
		begin 
			address = CR;
			write = 1;
			writedata = 8'h10;
			next_state = WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_NEEDS_LOWER_ADDRESS;
		end
		SEND_WRITE_I2C: 
		begin 
			address = CR;
			write = 1;
			writedata = 8'h10;
			next_state = WAIT_TRANSFER_TIP_COMES_FROM_SEND_WRITE_I2C_SEND_DATA;
		end
		STOP_I2C:
		begin
			address = CR;
			write = 1;
			writedata = 8'h50;
			next_state = WAIT_TRANSFER_TIP_SENDING_DATA;
		end
		default: next_state = WAIT;
		endcase
	end
end
endmodule