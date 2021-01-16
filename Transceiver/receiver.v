//
//

module Receiver(
input clock,
input [13:0] adc_data,
input [31:0] rx_freq,
output reg signed [23:0] rx_real,
output reg signed [23:0] rx_imag,
input [7:0] rx_rate
);

// RX phase count
localparam M2 = 32'd1876499845;  // B57 = 2^57.   M2 = B57/76800000
localparam M3 = 32'd16777216;   // M3 = 2^24, used to round the result
wire [63:0] ratio = rx_freq * M2 + M3;
wire [31:0] rx_tune_phase = ratio[56:25];


reg [7:0] rate;
always @(rx_rate)
begin
    case (rx_rate)
    0: rate <= 8'd40;  // 48 k
    1: rate <= 8'd20;  // 96 k
    2: rate <= 8'd10;  // 192 k
    3: rate <= 8'd8 ;  // 240 k
    4: rate <= 8'd5 ;  // 384 k
    5: rate <= 8'd4 ;  // 480 k
    6: rate <= 8'd3 ;  // 640 k
    7: rate <= 8'd2 ;  // 960 k
    default: rate <= 8'd40;
    endcase
end


// Cordic
wire signed [21:0] cordic_outdata_I;
wire signed [21:0] cordic_outdata_Q;

cordic cordic_inst(
  .clock(clock),
  .in_data({adc_data, adc_data[0], adc_data[0]}),
  .frequency(rx_tune_phase),
  .out_data_I(cordic_outdata_I),
  .out_data_Q(cordic_outdata_Q)
  );

// Receive CIC filters
wire decimA_avail;
wire signed [17:0] decimA_real, decimA_imag;

//I channel
varcic1 cic_inst_I2(
        .decimation(rate),
        .clock(clock),
        .in_strobe(1'b1),
        .out_strobe(decimA_avail),
        .in_data(cordic_outdata_I),
        .out_data(decimA_real)
        );
//Q channel
varcic1 cic_inst_Q2(
        .decimation(rate),
        .clock(clock),
        .in_strobe(1'b1),
        .out_strobe(),
        .in_data(cordic_outdata_Q),
        .out_data(decimA_imag)
        );
//
wire decimB_avail;
wire signed [17:0] decimB_real, decimB_imag;

varcic2 varcic_inst_I1(
        .clock(clock),
        .in_strobe(decimA_avail),
        .out_strobe(decimB_avail),
        .in_data(decimA_real),
        .out_data(decimB_real)
        );
//Q channel
varcic2 varcic_inst_Q1(
        .clock(clock),
        .in_strobe(decimA_avail),
        .out_strobe(),
        .in_data(decimA_imag),
        .out_data(decimB_imag)
        );
// Polyphase decimate by 8 FIR Filter
//
wire signed [23:0]decim_real, decim_imag;
wire decim_avail;
firX8R8 fir2 (clock, decimB_avail, decimB_real, decimB_imag, decim_avail, decim_imag, decim_real);
//
always @(posedge decim_avail) begin rx_real <= decim_real; rx_imag <= decim_imag; end

endmodule
