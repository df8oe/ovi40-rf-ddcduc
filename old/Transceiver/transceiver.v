//////////////////////////////////////////////////////////////////////////////////
// to enable I2S test pattern generator and pattern detector, uncomment next line
// `define DEBUG_I2S
module Transceiver(
    // ADC interface
    input [13:0] adc_data,
    input adc_clock,
    input adc_overrange,

    // DAC interface
    output [13:0] dac_data,
    output dac_clock,
    output reg level_pwm,

    // I2S bus, master mode
    input DIN,
    output DOUT,
    output BCLK,
    output LRCLK,
    output MCLK,

    // I2C slave control bus
    inout slave_SDA,
    input slave_SCL,

    // I2C master interface to clock generator
    inout master_SDA,
    inout master_SCL,

    // Miscellaneous
    input CW,
    output nRES,
    output OF,
    input _10M_in,
    output _10M_out,
    input clock_10M,
    output dummy_1,
    output dummy_2,

    // Test pins
    output led1,
    output led2,
    output test1,
    output test2,
    output test3,
    output test4

    );

    assign _10M_out = _10M_in;
    assign MCLK = ~_mclk & lock_rx;
    assign nRES = reset;

    wire _mclk;

    div2_posedge(.reset(reset), .clk(SAICLK), .div_clk(_mclk));

    // PLL 1
    wire main_clock, SAICLK, lock_rx;
    pll_rx prx (adc_clock, dac_clock, SAICLK, main_clock, lock_rx);

    // PLL 2
    wire clock_100k, clock_2M, lock_10;
    pll_10M p10M (clock_10M, clock_100k, clock_2M, lock_10);

    // This module resets everything on power start.
    wire reset;
    reset res (clock_100k, lock_10, reset);
    assign led2 = reset;

    //
    clkgen_init c_init(clock_100k, reset, master_SDA, master_SCL);

    //
    wire [31:0] rx_freq;
    wire [31:0] tx_freq;
    wire [7:0] s_rate;
    wire [7:0] tx_level;
    i2c_control i2c_slave (clock_2M, reset, slave_SDA, slave_SCL, rx_freq, tx_freq, s_rate, tx_level);

    //
    wire clipping;
    clip_led cl (clock_100k, adc_overrange | dac_of, clipping);

    wire i2s_ok;
`ifdef DEBUG_I2S
    assign led1 = i2s_ok;
`else
    assign led1 = clipping ;
`endif
    assign OF = clipping;

    // read and register ADC data
    reg [13:0] reg_adc_data;
    always @(posedge adc_clock)
    begin
        reg_adc_data <=  adc_data[13:0];
    end

    // Receiver
    wire [23:0] rx_real, rx_imag;
    Receiver rx (main_clock, reg_adc_data, rx_freq, rx_real, rx_imag, s_rate);

    // Transmitter
    wire [15:0] tx_real, tx_imag;
    wire dac_of;
    Transmitter tx (dac_clock, reset, dac_data, tx_freq, tx_real, tx_imag, CW, clock_100k, dac_of);

    // I2S modules
	 i2s_master_clocks i2s_master_clocks(
							.reset(reset),
                     .s_rate(s_rate),
							.SAICLK(SAICLK),
							.BCLK(BCLK),
							.LRCLK(LRCLK));
	 
    i2s i2s_master ( 
	                  ._reset(reset), 
                     .BCLK(BCLK), 
							.LRCLK(LRCLK), 
							.DIN(DIN), 
							.DOUT(DOUT), 
							._rx_real(rx_real), 
							._rx_imag(rx_imag), 
							.tx_real(tx_real), 
							.tx_imag(tx_imag), 
							.i2s_ok(i2s_ok));

    // Power level
    reg [7:0] pwm_cnt;

    always @(posedge SAICLK)
    begin
        if (pwm_cnt >= tx_level)
            level_pwm <= 0;
        else
            level_pwm <= 1;
        pwm_cnt <= pwm_cnt + 1'd1;
    end

endmodule
