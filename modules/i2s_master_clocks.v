//
//  UHSDR - Universal Ham Software Defined Radio
//
//  Author DF8OE, modified by DB4PLE
//
//  Implements the I2S clock generation to drive I2S slaves 
//
//  FPGA code.
//
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

// We assume 24.576  Mhz clock input here.

/**
 * A runtime configurable I2S clock generator for bit clock and word select / left right clock. It needs the SAICLK to be twice the maximum bitclock
 * s_rate provides the ability to switch the generated bitclock to be /8 /4 /2 of the input clock
 * For now the word length is fixed to 32bits, i.e. 64 bits per frame
 */
 
 module i2s_master_clocks
 #(parameter WORD=32)
 (
   input reset,
   input [1:0] s_rate,
   input SAICLK,
   output reg BCLK,
   output reg LRCLK
);

// generation of BCLK from SAICLK
reg [1:0] div_cnt;
reg [1:0] div_rate;

always @(posedge SAICLK) 
begin
	if (~reset)
	begin
		BCLK <= 1'd0;
		div_cnt <= 1'd0;
	end	
	else
		if (div_cnt == 0)
		   begin
			  BCLK <= ~BCLK;
			  div_cnt <= div_rate;
		   end
		else
			div_cnt <= div_cnt -1'd1;
end

always begin @(posedge SAICLK)
    case (s_rate)
    0: div_rate <= 2;  // 48k
	 1: div_rate <= 1;  // 96k
	 2: div_rate <= 0;  // 192k	
	 3: div_rate <= 0;  // 192k	 
    endcase
end


reg [6:0] bit_cnt;

// generation of LRCLK from BCLK
always @(posedge BCLK or negedge reset) 
begin
	if (~reset)
	begin
		LRCLK <= 1'd0;
		bit_cnt <= 1'd0;
	end	
	else
		if (bit_cnt == 0)
		   begin
			  LRCLK <= ~LRCLK;
			  bit_cnt <= (WORD)-1;
		   end
		else
			bit_cnt <= bit_cnt -1'd1;
end

endmodule


/**
 * A simple testbench for I2S master operation
 * The code tests both the clock generation as well as the I2S module. It reads its output and compares it with the expected result 
 */
 
`timescale 1 ns/1 ps

module i2s_master_clocks_tb();

	parameter WORD = 26;
	reg saiclk;
	reg [1:0] s_rate;
	reg reset;
	wire bclk, lrclk;
	reg din;
	reg [23:0] rx_real;
	reg [23:0] rx_imag;
	wire [15:0] tx_real;	
	wire [15:0] tx_imag;
	wire i2s_ok;
	wire DOUT;

	i2s_master_clocks #(.WORD(WORD)) dut(.reset(reset), .s_rate(s_rate), .SAICLK(saiclk), .BCLK(bclk), .LRCLK(lrclk));
	
	i2s #(.WORD(WORD))dut_i2s_master ( 
	                  ._reset(reset), 
                     .BCLK(bclk), 
							.LRCLK(lrclk), 
							.DIN(DOUT), 
							.DOUT(DOUT), 
							._rx_real(rx_real), 
							._rx_imag(rx_imag), 
							.tx_real(tx_real), 
							.tx_imag(tx_imag), 
							.i2s_ok(i2s_ok));

	
	initial
	begin
		reset = 1'd0;
		s_rate = 2'd2;
		din = 1'd1;
		
		rx_real = 24'h123456;
		rx_imag = 24'habcdef;

		#20 reset = 1'd1;
		

		#2000;
		if (tx_real !== 16'habcd && tx_imag !== 16'h1234) 
			$display("FAIL: Reading own transmission failed");
		else
			$display("PASS: Reading own transmission successful");
		 $finish;	

	end
	
	always 
	begin
    saiclk = 1'b1; 
    #1; 
    saiclk = 1'b0;
    #1; 
	end

endmodule