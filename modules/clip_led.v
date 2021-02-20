module clip_led (                   // turn on LED for some milliseconds for clip
    input slow_clock,
    input adc_overrange,
    output led_red);

    reg [15:0] timer;
    assign led_red = ~(timer == 0);

    always @(posedge slow_clock)
    begin
        if (adc_overrange)
            timer <= 16'd20000;     // 200msec
        else if (timer != 0)
            timer <= timer - 1'd1;
    end

endmodule
