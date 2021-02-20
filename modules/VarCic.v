//
// cic - A Cascaded Integrator-Comb filter
//
// Copyright (c) 2008 Alex Shovkoplyas, VE3NEA
// Copyright (c) 2013 Phil Harman, VK6PH
// Copyright (c) 2015 Jeremy McDermond, NH6Z
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Library General Public License for more details.
// You should have received a copy of the GNU Library General Public
// License along with this library; if not, write to the
// Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
// Boston, MA  02110-1301, USA.

// 2020 - Modified to correct work with decimation rate 2,3,4,5,10,20,40. David Fainitski, N7DDC

module VarCic (decimation, clock, in_strobe,  out_strobe, in_data, out_data );

  //design parameters
  parameter STAGES = 3; //  Sections of both Comb and Integrate
  parameter IN_WIDTH = 22;
  parameter OUT_WIDTH = 18;

  // calculated parameters
  // ACC_WIDTH = IN_WIDTH + Ceil(STAGES * log2(MAX_DECIMATION));
  parameter ACC_WIDTH = 38;

  input [7:0] decimation;

  input clock;
  input in_strobe;
  output reg out_strobe;

  input signed [IN_WIDTH-1:0] in_data;
  output reg signed [OUT_WIDTH-1:0] out_data;


//------------------------------------------------------------------------------
//                               control
//------------------------------------------------------------------------------
reg [7:0] sample_no = 0;

generate
    always @(posedge clock)
        if (in_strobe)
            if (sample_no == (decimation - 1'd1)) begin
                sample_no <= 0;
                out_strobe <= 1;
            end else begin
                sample_no <= sample_no + 1'd1;
                    out_strobe <= 0;
            end
        else
            out_strobe <= 0;
endgenerate

//------------------------------------------------------------------------------
//                                stages
//------------------------------------------------------------------------------
reg signed [ACC_WIDTH-1:0] integrator_data [1:STAGES];
reg signed [ACC_WIDTH-1:0] comb_data [1:STAGES];
reg signed [ACC_WIDTH-1:0] comb_last [0:STAGES];

always @(posedge clock) begin
    integer index;

    //  Integrators
    if(in_strobe) begin
        integrator_data[1] <= integrator_data[1] + in_data;
        for(index = 1; index < STAGES; index = index + 1) begin
            integrator_data[index + 1] <= integrator_data[index] + integrator_data[index+1];
        end
    end

    // Combs
    if(out_strobe) begin
        comb_data[1] <= integrator_data[STAGES] - comb_last[0];
        comb_last[0] <= integrator_data[STAGES];
        for(index = 1; index < STAGES; index = index + 1) begin
            comb_data[index + 1] <= comb_data[index] - comb_last[index];
            comb_last[index] <= comb_data[index];
        end
    end
end

//------------------------------------------------------------------------------
//                            output rounding
//------------------------------------------------------------------------------

localparam msb40 =  ACC_WIDTH - 1;
localparam msb20 =  msb40 - STAGES;
localparam msb10 =  msb20 - STAGES;
localparam msb8  =  msb10 - (STAGES >> 1);
localparam msb5  =  msb10 - STAGES;
localparam msb4  =  msb8  - STAGES;
localparam msb3  =  msb4  - (STAGES >> 1);
localparam msb2  =  msb4  - STAGES;


always @(posedge clock)
  case (decimation)
    40: out_data <= comb_data[STAGES][msb40 -: OUT_WIDTH] + comb_data[STAGES][msb40 - OUT_WIDTH - 1];
    20: out_data <= comb_data[STAGES][msb20 -: OUT_WIDTH] + comb_data[STAGES][msb20 - OUT_WIDTH - 1];
    10: out_data <= comb_data[STAGES][msb10 -: OUT_WIDTH] + comb_data[STAGES][msb10 - OUT_WIDTH - 1];
     8: out_data <= comb_data[STAGES][msb8  -: OUT_WIDTH] + comb_data[STAGES][msb8  - OUT_WIDTH - 1];
     5: out_data <= comb_data[STAGES][msb5  -: OUT_WIDTH] + comb_data[STAGES][msb5  - OUT_WIDTH - 1];
     4: out_data <= comb_data[STAGES][msb4  -: OUT_WIDTH] + comb_data[STAGES][msb4  - OUT_WIDTH - 1];
     3: out_data <= comb_data[STAGES][msb3  -: OUT_WIDTH] + comb_data[STAGES][msb3  - OUT_WIDTH - 1];
     2: out_data <= comb_data[STAGES][msb2  -: OUT_WIDTH] + comb_data[STAGES][msb2  - OUT_WIDTH - 1];
  endcase

endmodule
