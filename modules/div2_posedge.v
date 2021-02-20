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


/**
 * A clock by two divider which acts on positive clock and has a clocked ~reset
 *
 */

module div2_posedge(
	input reset,
	input clk,
	output reg div_clk);

always @(posedge clk or negedge reset) 
begin 
	if (~reset)
		div_clk <= 1'd1;
	else
		div_clk <= ~div_clk;
end
	
	
endmodule