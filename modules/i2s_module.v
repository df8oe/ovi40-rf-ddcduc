//**************************
// I2S Slave mode
// David Fainitski, N7DDC
// for DDC Module 2 project
// Seattle, 2020
// modified by DF8OE, DB4PLE
//***************************


// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.



module i2s_module (
   input _reset,
   input BCLK,
   input LRCLK,
   input DIN,
   output DOUT,
   input [23:0] _rx_real,
   input [23:0] _rx_imag,
   output [15:0] tx_real,
   output [15:0] tx_imag,
   output i2s_ok // test signal received passes pattern check, only active if DEBUG_I2S is defined
);


wire [23:0] rx_real;
cdc_sync #(24)
    real_ (.siga(_rx_real), .rstb(1'b0), .clkb(BCLK), .sigb(rx_real));

wire [23:0] rx_imag;
cdc_sync #(24)
    imag_ (.siga(_rx_imag), .rstb(1'b0), .clkb(BCLK), .sigb(rx_imag));

wire reset;
cdc_sync #(1)
    rst_i (.siga(_reset), .rstb(1'b0), .clkb(BCLK), .sigb(reset));

wire sync;
rcv_i2s rcv_i2s (BCLK, reset, LRCLK, DIN, sync, tx_real, tx_imag, i2s_ok);

trm_i2s trm_i2s (BCLK, DOUT, sync, rx_real, rx_imag);

endmodule

//-----------------------------------------------------------------------
//  Receive data from I2S bus
//-----------------------------------------------------------------------
module rcv_i2s (
    input clock,
    input reset,
    input WS,
    input DIN,
    output reg sync,
    output reg [15:0] data_right,
    output reg [15:0] data_left,
`ifndef DEBUG_I2S	 
    output i2s_ok
`else
    output reg i2s_ok
`endif	 
    );


// State maschine for I2S bus
reg [2:0] state;
reg [5:0] bit_cnt;
reg [63:0] buffer;

`ifndef DEBUG_I2S
assign  i2s_ok = 1'dz;
`endif

always @(posedge clock)
   if(!reset)
        begin
            state <= 0;
            sync <= 0;
        end
    else case(state)
    0:
        begin
            sync <= 0;
				bit_cnt <= 0;
            if(WS) state <= 1;
        end
    1:
        if(!WS)
            begin
                sync <= 1;
                state <= 2;
            end
    2:
        begin
            buffer[63-bit_cnt] <= DIN;
            if(bit_cnt==63)
                bit_cnt <= 1'd0;
            else
                bit_cnt <= bit_cnt + 1'd1;
            if(bit_cnt==63 & WS)
                state <= 0; // Auto syncronisation
            if(bit_cnt==31 & !WS)
                state <= 0; // Auto syncronisation
        end
    default:
        state <= 0;
    endcase

always @(negedge clock)
    if(bit_cnt==0)
        begin
            data_left <= buffer[63:48];
            data_right <= buffer[31:16];
`ifdef DEBUG_I2S
            i2s_ok <= (buffer[63:40] == 24'h654321 && buffer[31:8] == 24'hfedcba && buffer[7:0] == buffer[7:0]);
`endif
        end

endmodule

//--------------------------------------------------------------------
// Send data to I2S bus
//--------------------------------------------------------------------
module trm_i2s (
    input clock,
    output reg DOUT,
    input sync,
    input [23:0] data_left,
    input [23:0] data_right
    );

reg [5:0] bit_cnt;
reg [63:0] buffer;

`ifdef DEBUG_I2S
reg [7:0] byte_cnt;
`endif

always @(negedge clock)
    if(!sync)
        begin
            bit_cnt <= 1'd0;
`ifdef DEBUG_I2S
            byte_cnt <= 1'd0;
`endif
        end
    else
        begin
            DOUT <= buffer[63-bit_cnt];
            if(bit_cnt==63)
                begin
`ifndef DEBUG_I2S
                buffer <= {data_left, 8'd0, data_right, 8'd0};
// buffer <= {data_left, byte_cnt, data_right, byte_cnt};
`else
				buffer <= {24'h123456, byte_cnt, 24'habcdef, byte_cnt};
`endif
                bit_cnt <= 1'd0;
`ifdef DEBUG_I2S
                byte_cnt <= byte_cnt + 1'd1;
`endif
                end
            else
                bit_cnt <= bit_cnt + 1'd1;
        end

endmodule
