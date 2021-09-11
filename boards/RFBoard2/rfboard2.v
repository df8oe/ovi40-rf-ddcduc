//////////////////////////////////////////////////////////////////////////////////
// to enable I2S test pattern generator and pattern detector, uncomment next line
// `define DEBUG_I2S
module RFBoard2(
    // ADC interfaces
    input [13:0] adc_data,
    input adc_clock,
    input adc_overrange,

    input [13:0] adc2_data,
    input adc2_clock,
    input adc2_overrange,

	// AD936x interface
	output [11:0] ad936x_p0,
	input [11:0] ad936x_p1,
	input rx_frame_p,
	output enable,
	output nresetb,
	output tx_frame_p,
	output fb_clk_p,
	output txnrx,
	input data_clk_p,
	output nspi_enb,
	output spi_clk,
	output spi_di,
	input spi_do,

	// RAM interface
	inout [7:0] ram,
	output ram_ncs,
	output ram_nreset,
	output ram_nck,
	output ram_ck,
	inout ram_rwds,

	// USB interface
	inout [7:0] usb,
	input usb_dir,
	input usb_nxt,
	output usb_refclk,
	output usb_resetb,
	output usb_stp,

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
    inout RESET,

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
    output smps_13_enable,
    output _10M_out,
    input clock_10M,

    // Test pins
    output led1,
    output led2,
    output led3,
    output test1,
    input test2,
    output test3,
    output test4,
    output test5
    );
	 
    transceiver
	 
	 trx(
    // ADC interfaces
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

    // Test pins
    .led1(led1),
    .led2(led2),
	 .led3(led3),
    .test1(test1),
    .test2(test2),
    .test3(test3),
    .test4(test4),
	 .test5(test5)
    );

endmodule
