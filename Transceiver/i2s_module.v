//**************************
// I2S Slave mode
// David Fainitski, N7DDC
// for DDC Module 2 project
// Seattle, 2020
// modified by DF8OE
//***************************

module i2s (
   input _reset,
   input SAICLK,
   output reg BCLK,
   output reg LRCLK,
   input DIN,
   output DOUT,
   input [23:0] _rx_real,
   input [23:0] _rx_imag,
   output [15:0] tx_real,
   output [15:0] tx_imag
);

// generation of BCLK from SAICLK
reg div2_clks;

always @(posedge SAICLK) begin div2_clks <= ~div2_clks; end
always @(posedge div2_clks) begin BCLK <= ~BCLK; end


// generation of LRCLK from BCLK
reg div2_clk;
reg div4_clk;
reg div8_clk;
reg div16_clk;
reg div32_clk;

always @(posedge BCLK) begin div2_clk <= ~div2_clk; end
always @(posedge div2_clk) begin div4_clk <= ~div4_clk; end
always @(posedge div4_clk) begin div8_clk <= ~div8_clk; end
always @(posedge div8_clk) begin div16_clk <= ~div16_clk; end
always @(posedge div16_clk) begin div32_clk <= ~div32_clk; end
always @(posedge div32_clk) begin LRCLK <= ~LRCLK; end

wire [23:0] rx_real;
cdc_sync #(24)
    real_ (.siga(_rx_real), .rstb(1'b0), .clkb(BCLK), .sigb(rx_real));

wire [23:0] rx_imag;
cdc_sync #(24)
    imag_ (.siga(_rx_imag), .rstb(1'b0), .clkb(BCLK), .sigb(rx_imag));

wire reset;
cdc_sync #(1)
    rst_i (.siga(_reset), .rstb(1'b0), .clkb(BCLK), .sigb(reset));

wire sync;
rcv_i2s rcv_i2s (BCLK, reset, LRCLK, DIN, sync, tx_real, tx_imag);

trm_i2s trm_i2s (BCLK, DOUT, sync, rx_real, rx_imag);

endmodule

//-----------------------------------------------------------------------
//  Receive data from I2S bus
//-----------------------------------------------------------------------
module rcv_i2s (
    input clock,
    input reset,
    input WS,
    input DIN,
    output reg sync,
    output reg [15:0] data_right,
    output reg [15:0] data_left
    );


// State maschine for I2S bus
reg [2:0] state;
reg [5:0] bit_cnt;
reg [63:0] buffer;

always @(posedge clock)
   if(!reset)
        begin
            state <= 0;
            bit_cnt <= 0;
            sync <= 0;
        end
    else case(state)
    0:
        begin
            sync <= 0;
            if(!WS) state <= 1;
        end
    1:
        if(WS)
            begin
                sync <= 1;
                state <= 2;
            end
    2:
        begin
            buffer[63-bit_cnt] <= DIN;
            if(bit_cnt==63)
                bit_cnt <= 1'd0;
            else
                bit_cnt <= bit_cnt + 1'd1;
            if(bit_cnt==63 & !WS)
                state <= 0; // Auto syncronisation
            if(bit_cnt==31 &  WS)
                state <= 0; // Auto syncronisation
        end
    default:
        state <= 0;
    endcase

always @(negedge clock)
    if(bit_cnt==0)
        begin
            data_right <= buffer[63:48];
            data_left <= buffer[31:16];
        end

endmodule

//--------------------------------------------------------------------
// Send data to I2S bus
//--------------------------------------------------------------------
module trm_i2s (
    input clock,
    output reg DOUT,
    input sync,
    input [23:0] data_right,
    input [23:0] data_left
    );

reg [5:0] bit_cnt;
reg [63:0] buffer;

always @(negedge clock)
    if(!sync)
        bit_cnt <= 1'd0;
    else
        begin
            DOUT <= buffer[63-bit_cnt];
            if(bit_cnt==63)
                bit_cnt <= 1'd0;
            else
                bit_cnt <= bit_cnt + 1'd1;
        end

always @(posedge clock)
   if(bit_cnt==0)
       buffer <= {data_right, 8'd0, data_left, 8'd0};
//       buffer <= {24'h123456, 8'd0, 24'habcdef, 8'd0};

endmodule
