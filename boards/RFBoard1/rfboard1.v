//////////////////////////////////////////////////////////////////////////////////
// to enable I2S test pattern generator and pattern detector, uncomment next line
// `define DEBUG_I2S
module RFBoard1(
    // ADC interface
    input [13:0] adc_data,
    input adc_clock,
    input adc_overrange,

    // DAC interface
    output [13:0] dac_data,
    output dac_clock,
    output level_pwm,

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

    transceiver

    trx(
    // ADC interface
    .adc_data(adc_data),
    .adc_clock(adc_clock),
    .adc_overrange(adc_overrange),

    // DAC interface
    .dac_data(dac_data),
    .dac_clock(dac_clock),
    .level_pwm(level_pwm),

    // I2S bus, master mode
    .DIN(DIN),
    .DOUT(DOUT),
    .BCLK(BCLK),
    .LRCLK(LRCLK),
    .MCLK(MCLK),

    // I2C slave control bus
    .slave_SDA(slave_SDA),
    .slave_SCL(slave_SCL),

    // I2C master interface to clock generator
    .master_SDA(master_SDA),
    .master_SCL(master_SCL),

    // Miscellaneous
    .CW(CW),
    .nRES(nRES),
    .OF(OF),
    ._10M_in(_10M_in),
    ._10M_out(_10M_out),
    .clock_10M(clock_10M),
    .dummy_1(dummy_1),
    .dummy_2(dummy_2),

    // Test pins
    .led1(led1),
    .led2(led2),
    .test1(test1),
    .test2(test2),
    .test3(test3),
    .test4(test4)
    );

endmodule
