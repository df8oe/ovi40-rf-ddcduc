module reset(                       // Reset the bus on power up
    input slow_clock,
    input lock_10,
    output reset                    // controller reset pin
    );

    reg [31:0] reset_timer;

    initial
    begin
        reset_timer = 32'd100000;  // time to release reset > 1 sec
    end

    assign reset = (reset_timer == 0);

    always @(posedge slow_clock)
    if (reset_timer != 0 & lock_10)
        reset_timer <= reset_timer - 1'd1;

endmodule
