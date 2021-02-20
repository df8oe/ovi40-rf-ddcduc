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

//__________________________________________________________________________________________________________

// 2020 - Modified to correct work with decimation rate 5. David Fainitski, N7DDC
// Modified for decimation rate by DF8OE

//__________________________________________________________________________________________________________


module CicDec10 (clock, in_strobe,  out_strobe, in_data, out_data );

  //design parameters
  parameter [6:0] decimation = 10;
  parameter STAGES = 5; //  Sections of both Comb and Integrate
  parameter [5:0] IN_WIDTH = 18;
  parameter OUT_WIDTH = 18;

  // calculated parameters
  // ACC_WIDTH = IN_WIDTH + Ceil(STAGES * log2(MAX_DECIMATION));
  parameter ACC_WIDTH = 30;
  
  input clock;
  input in_strobe;
  output reg out_strobe;

  input signed [IN_WIDTH-1:0] in_data;
  output signed[OUT_WIDTH-1:0] out_data;


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

assign out_data = comb_data[STAGES][(ACC_WIDTH-1) -: OUT_WIDTH] + comb_data[STAGES][(ACC_WIDTH-1) - OUT_WIDTH - 1];

endmodule
