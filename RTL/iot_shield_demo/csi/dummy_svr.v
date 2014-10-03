// dummy svr
// allow testing of the video output and register r/w 
//  
// 28-july-2014  
//  
//  COPYRIGHT VLSI PLUS, LTD. 2014
/////////////////////////////////////////////////////////////
// THE IP IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL VLSI 
// PLUS, LTD. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH 
// THE IP OR THE USE OR OTHER DEALINGS IN THE IP.
//
// THIS FILE IS PRELIMINARY AND  SUBJECT TO CHANGE WITHOUT 
// NOTICE
/////////////////////////////////////////////////////////////
//  9/26: Removed SPI (MR)  

`timescale 1ns/1ps

module dummy_svr(
svr_pixel          ,
svr_pixel_valid    ,
svr_channel_id     ,
svr_fs             ,
svr_fe             ,
svr_ls             ,
svr_le             ,
svr_data_type      ,
svr_cpu_int        ,
readdata           ,
fclk               ,
pclk               ,
reset_n            ,
address            ,
writedata          ,
write              ,
read               ,
lpck_p   	   ,
lpck_n             ,
lpd1_p             ,
lpd1_n             ,
hs_clk             ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
hs_d1              ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
hs_d2              ,   // note - those are outputs from the lvds buffers. In the data sheet we have inputs
lpd2_p             ,
lpd2_n            
);

                                
output   [ 9:0] svr_pixel          ; // pixel output. RAW10 - all bits are used. RAW8 - bits 7:0 are used. Sample with fclk   
output          svr_pixel_valid    ; // pixel valid qualifier. Sample with fclk    
output   [ 1:0] svr_channel_id     ; // MIPI CSI2 Channel indicator. I don't think that the camera is using it, so it will probably be 00. Sample with fclk    
output          svr_fs             ; // Frame-Start. One fclk wide pulse    
output          svr_fe             ; // Frame-End. One fclk wide pulse     
output          svr_ls             ; // Line-Start. One fclk wide pulse    
output          svr_le             ; // Line-End. One fclk wide pulse      
output   [ 5:0] svr_data_type      ; // will indicate the data-type of the received packet, per CSI2. RAW8 is 0x28 and RAW10 is 0x2B. Sample with fclk    
output          svr_cpu_int        ; // Interrupt output, upon error or other predefined cases. Sample with pclk    
output   [31:0] readdata           ; // avalon read bus; used to read reg    
input           fclk               ; // main clock input. min 100MHz
input           pclk               ; // r/w clock; used to read/write registers.    
input           reset_n            ; // a-synchronous  
input   [ 5:0]  address            ; // word-address. all registers are 32 bit wide. sampled with pclk.  
input   [31:0]  writedata          ; // write-data; sampled with pclk. 
input           write              ; // write; sampled with pclk. 
input           read               ; // read; sampled with pclk. 
input           lpck_p   	   ; // CMOS level of clock lane Dp wire. Asynchronous.
input           lpck_n   	   ; // CMOS level of clock lane Dn wire. Asynchronous.
input           lpd1_p             ; // CMOS level of data-1 lane Dp wire. Asynchronous.  
input           lpd1_n             ; // CMOS level of data-1 lane Dn wire. Asynchronous.  
input           hs_clk             ; // clock  lane HS level. source-synchronous.
input           hs_d1              ; // data-1 lane HS level. source-synchronous.
input           hs_d2              ; // data-2 lane HS level. source-synchronous.
input           lpd2_p             ; // CMOS level of data-2 lane Dp wire. Asynchronous.   
input           lpd2_n             ; // CMOS level of data-2 lane Dn wire. Asynchronous.   

//
// registers
// address  name     contents
// =======  ======   ========
// 0x00     enable   single bit enable register. No video will be generated if it is not set
// 0x04     rows     number of rows in the image. default = 1080
// 0x08     columns  number of columns in the image. default = 1920
//
reg        enable   ;
reg [15:0] rows     ;
reg [15:0] columns  ;
wire [7:0] paddr_e = {address, 2'b00};
// read/write registers. 
always @(posedge pclk or negedge reset_n) if (~reset_n) enable  <=  1'd0    ; else if ((write == 1'b1)&&(paddr_e==8'h00)) enable  <= writedata[   0];
always @(posedge pclk or negedge reset_n) if (~reset_n) rows    <= 16'd1080 ; else if ((write == 1'b1)&&(paddr_e==8'h04)) rows    <= writedata[15:0];
always @(posedge pclk or negedge reset_n) if (~reset_n) columns <= 16'd1920 ; else if ((write == 1'b1)&&(paddr_e==8'h08)) columns <= writedata[15:0];
//
//
// reading the registers
//
assign readdata = (read == 1'b0 )? 16'd0:
				  (paddr_e == 8'h00)? {31'd0, enable }:
				  (paddr_e == 8'h04)? {16'd0, rows   }:
				  (paddr_e == 8'h00)? {16'd0, columns}: 32'd0;
				
reg [11:0] row_counter, col_counter;
reg [4:0] frame_counter;

always @(posedge fclk or negedge reset_n) 
if (~reset_n) col_counter <= 12'd0;
else if (enable) col_counter <= (col_counter == 12'd2980)? 12'd0: col_counter + 12'd1;

always @(posedge fclk or negedge reset_n) 
if (~reset_n) row_counter <= 12'd0;
else if ((enable)&&(col_counter == 12'd2980)) 
             row_counter <= (row_counter == 12'd2235)? 12'd0: row_counter + 12'd1;

always @(posedge fclk or negedge reset_n) 
if (~reset_n) frame_counter <= 5'd0;
else if ((enable)&&(col_counter == 12'd2980)&&(row_counter == 12'd2235))
              frame_counter <= (frame_counter == 5'd29)? 5'd0: frame_counter + 5'd1; 
				

assign svr_pixel_valid = (col_counter[3:0] == 4'b1111)                  ? 1'b0:
                         ((col_counter - col_counter[11:4]) >= columns) ? 1'b0:
						 (row_counter == 11'd0)                         ? 1'b0:
						 (row_counter > rows)                           ? 1'b0:
                                                                          1'b1;

wire [3:0] horizotal_select = (columns[11] == 1'b1)? col_counter[10:7]:
                              (columns[10] == 1'b1)? col_counter[ 9:6]:
                              (columns[ 9] == 1'b1)? col_counter[ 8:5]: col_counter[ 7:4];

wire [3:0] vertical_select =  (rows[10] == 1'b1)? row_counter[9:6]:
                              (rows[ 9] == 1'b1)? row_counter[8:5]:
                              (rows[ 8] == 1'b1)? row_counter[7:4]: row_counter[6:3];
					    					   
wire [4:0] color_select = horizotal_select + vertical_select ;                                             

wire color = (frame_counter[4] ^ color_select[0]);

assign svr_pixel = (color==1'b1)? 10'd1023: 9'd0;

assign svr_fs = ((row_counter == 12'd0) && (col_counter == 12'd0) && (enable == 1'b1))? 1'b1: 1'b0;

assign svr_fe = ((row_counter == rows) && (col_counter == 12'd2980))? 1'b1: 1'b0;

assign svr_ls = ((col_counter == 12'd0) && (row_counter > 12'd0) &&(row_counter <= rows))? 1'b1: 1'b0;

assign svr_le = ((col_counter == 12'd2800) && (row_counter > 12'd0) &&(row_counter <= rows))? 1'b1: 1'b0;

////////////////////////////////////
assign svr_channel     = 2'b00  ;
assign svr_data_type   = 6'h2b  ;
assign svr_cpu_int     = 1'b0   ;
assign enable_2        = 1'b0   ;
assign enable_hs_clk   = 1'b0   ;
assign enable_hs_lane1 = 1'b0   ;
assign enable_hs_lane2 = 1'b0   ;
assign svr_enable      = enable ;

             
endmodule

