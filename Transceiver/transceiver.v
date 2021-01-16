//////////////////////////////////////////////////////////////////////////////////

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
    input BCLK,
    input LRCLK,
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

    assign test1 = rx_clock;
    assign test2 = clock_16M;
    assign test3 = clock_2M;
    assign test4 = clock_100k;


    assign dac_clock = rx_clock;
    assign _10M_out = _10M_in;
    assign MCLK = clock_16M & lock_rx;
    assign nRES = reset;
    assign dummy_1 = 0;
    assign dummy_2 = 0;

    // PLL 1
    wire rx_clock, clock_16M, clock_2M, lock_rx;
    pll_rx prx (adc_clock, rx_clock, clock_16M, clock_2M, lock_rx);

    // PLL 2
    wire clock_100k, lock_10;
    pll_10M p10M (clock_10M, clock_100k, lock_10);

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
    assign led1 = clipping ;
    assign OF = clipping;

    // read and register ADC data
    reg [13:0] reg_adc_data;
    always @(posedge adc_clock)
    begin
        reg_adc_data <=  adc_data[13:0];
    end

    // Receiver
    wire [23:0] rx_real, rx_imag;
    Receiver rx (rx_clock, reg_adc_data, rx_freq, rx_real, rx_imag, s_rate);

    // Transmitter
    wire [15:0] tx_real, tx_imag;
    wire dac_of;
    Transmitter tx (dac_clock, reset, dac_data, tx_freq, tx_real, tx_imag, CW, clock_100k, dac_of);

    // I2S module
    i2s i2s_slave (reset, BCLK, LRCLK, DIN, DOUT, rx_real, rx_imag, tx_real, tx_imag);

    // Power level
    reg [7:0] pwm_cnt;
    always @(posedge clock_16M)
    begin
        if (pwm_cnt >= tx_level) level_pwm <= 0;
        else level_pwm <= 1;
        pwm_cnt <= pwm_cnt + 1'd1;
    end

endmodule
