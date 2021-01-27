//
//

module Transmitter(
input clock,
input _reset,
output [13:0] dac_data,
input [31:0] tx_freq,
input [15:0] _tx_real,
input [15:0] _tx_imag,
input _CW,
input _pro_clock,
output dac_of
);

wire signed [15:0] tx_real;
cdc_sync #(16)
    re_data (.siga(_tx_real), .rstb(1'b0), .clkb(clock), .sigb(tx_real));

wire signed [15:0] tx_imag;
cdc_sync #(16)
    im_data (.siga(_tx_imag), .rstb(1'b0), .clkb(clock), .sigb(tx_imag));

wire CW;
cdc_sync #(1)
    cw (.siga(_CW), .rstb(1'b0), .clkb(clock), .sigb(CW));

wire reset;
cdc_sync #(1)
    rst_t (.siga(_reset), .rstb(1'b0), .clkb(clock), .sigb(reset));

wire pro_clock;
cdc_sync #(1)
    p_clk (.siga(_pro_clock), .rstb(1'b0), .clkb(clock), .sigb(pro_clock));

reg signed [15:0] tx_reg_real, tx_reg_imag;
always @(posedge req1) begin tx_reg_real <= tx_real; tx_reg_imag <= tx_imag;  end

// TX phase count
localparam M2 = 32'd1876499845;  // B57 = 2^57.   M2 = B57/76800000
// localparam M2 = 32'd938249922;  // B57 = 2^57.   M2 = B57/153600000
localparam M3 = 32'd16777216;    // M3 = 2^24, used to round the result
wire [63:0] ratio = tx_freq * M2 + M3;
wire [31:0] tx_tune_phase = ratio[56:25];

// Interpolate I/Q samples in memory from 48 kHz to the clock frequency
wire req1, req2;
wire signed [19:0] y1_r, y1_i, y2_r, y2_i;
FirInterp8 tx_fir (clock, req2, req1, tx_reg_real, tx_reg_imag, y1_r, y1_i);

CicInterpM5 #(.RRRR(320), .IBITS(20), .OBITS(20), .GBITS(34))
            tx_int (clock, 1'd1, req2, y1_r, y1_i, y2_r, y2_i);

//CW profile memory
wire [15:0] cw_profile;
reg [8:0] pro_cnt;
profile cw_pro (.address(pro_cnt), .clock(pro_clock), .q(cw_profile));

always @ (posedge pro_clock)
   if(!reset)
        pro_cnt <= 1'd0;
    else if(CW & pro_cnt!=511) pro_cnt <= pro_cnt + 1'd1;
    else if(!CW & pro_cnt>0) pro_cnt <= pro_cnt - 1'd1;

// CW profiling
wire [15:0] cw_level;
parameter MAX_CW_LEVEL = 16'd39000; // 65535 max
mult_16x16_uns cw_mult (MAX_CW_LEVEL, cw_profile, cw_level);

// Switch sample source
wire [15:0] ci_real =  pro_cnt!=0 ? cw_level : y2_r[19:4];
wire [15:0] ci_imag =  pro_cnt!=0 ? 16'd0    : y2_i[19:4];

// Tune transmitter with CORDIC
wire signed [15:0]cordic_out;
cordic_tx tx_cordic (clock, tx_tune_phase, ci_real, ci_imag, cordic_out);

assign dac_data = {cordic_out[13:0]};

assign dac_of = cordic_out > 8191 || cordic_out < -8191;

endmodule
