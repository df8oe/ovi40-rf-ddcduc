// I2C Slave control
// David Fainitski, N7DDC
// for DDC Module 2 Project
// Seattle, 2020

// Protocol of data exchange:
// Start -> Address -> RXF3(MSB)_byte -> RXF2_byte -> RXF1_byte -> RXF0(LSB)_byte -> 
// -> TXF3(MSB)_byte -> TXF2_byte -> TXF1_byte -> TXF0(LSB)_byte -> SRATE -> TXLEVEL-> Stop
//
// Where RXF - 32 bit or 4 bytes of receiver frequency
// TXF - 32 bit or 4 bytes of transmitter frequency
// SRATE - sample rate code, 1 Byte, 0 - 50 kHz, 1 - 100 kHz, 2 - 200 kHz
// TXLEVEL - 1 byte, 0 - 255 transmitting level


module i2c_control 
#(
	parameter i2c_address = 8'hD2 // this is full 8 bit address including R/W bit
)

(
input clock, // 2 MHz
input _reset,
inout reg _SDA,
input _SCL,
output reg [31:0] rx_freq,
output reg [31:0] tx_freq,
output reg [7:0] s_rate,
output reg [7:0] tx_level
);

wire SDA;
cdc_sync #(1)
    sda (.siga(_SDA), .rstb(1'b0), .clkb(clock), .sigb(SDA));

wire SCL;
cdc_sync #(1)
    scl (.siga(_SCL), .rstb(1'b0), .clkb(clock), .sigb(SCL));

wire reset;
cdc_sync #(1)
    rst (.siga(_reset), .rstb(1'b0), .clkb(clock), .sigb(reset));


localparam Start  = 8'd0;
localparam Start1 = 8'd1;
localparam Addr   = 8'd10;
localparam Data   = 8'd20;
localparam Data1  = 8'd21;
localparam Data2  = 8'd22;
localparam Data3  = 8'd23;
localparam Byte   = 8'd30;
localparam Byte1  = 8'd31;
localparam Byte2  = 8'd32;
localparam Ack    = 8'd40;
localparam Ack1   = 8'd41;

localparam DataRead   = 8'd50;
localparam DataRead1  = 8'd51;
localparam DataRead2  = 8'd52;
localparam DataRead3  = 8'd53;
localparam ByteRead   = 8'd60;
localparam ByteRead1  = 8'd61;
localparam ByteRead2  = 8'd62;
localparam AckRead    = 8'd70;
localparam AckRead1   = 8'd71;
localparam AckRead2   = 8'd72;

localparam [7:0] i2c_address_r = i2c_address + 1;

reg [7:0] state, return_state;
reg [7:0] data;
reg [7:0] bit_cnt, byte_cnt;
reg [23:0] buffer;

wire [7:0] reg_data;
	 
i2c_rom_boardid boardid(byte_cnt, clock, reg_data);

// State maschine for I2C slave control
always @(posedge clock)
begin
    if(!reset)
    begin
        state <= 1'd0;
        return_state <= 1'd0;
        rx_freq <= 32'd7_000_000;
        tx_freq <= 32'd7_000_000;
        bit_cnt <= 1'd0;
        byte_cnt <= 1'd0;
        _SDA <= 1'bz;
        s_rate <= 0;
        tx_level <= 0;
    end
    else if(stop_flag) state <= Start1;
    //
    else case(state)
    Start:   // Waiting for Start condition
        if(SDA & SCL) state <=  Start1;
    //
    Start1:
        if(!SDA & SCL) begin return_state <= Addr; state <= Byte;  bit_cnt <= 0; byte_cnt <= 0; end 
            else if(!SCL) state <= Start;
        //
        Addr:  // Recieving first byte (address)
        if(data == i2c_address) begin return_state <= Data; state <= Ack; end
        else
			begin
				if(data == i2c_address_r)
					begin
						return_state <= DataRead; state <= Ack;
					end
				else
					state <= Addr;
			end
        //
    Data: // Receiving data bytes
       begin return_state <= Data1; state <= Byte; end
    Data1:
       begin
           if(byte_cnt==0 | byte_cnt==4) buffer[23:16] <= data;
           if(byte_cnt==1 | byte_cnt==5) buffer[15:8]  <= data;
           if(byte_cnt==2 | byte_cnt==6) buffer[7:0]   <= data;
           if(byte_cnt==3) rx_freq <= {buffer, data};
           if(byte_cnt==7) tx_freq <= {buffer, data};
           if(byte_cnt==8) s_rate <= data;
           if(byte_cnt==9) tx_level <= data;
           return_state <= Data2;
           state <= Ack;
       end
    Data2:
       if(byte_cnt !=9) begin byte_cnt <= byte_cnt + 1'd1; state <= Data; end
       else
           begin
               byte_cnt <= 1'd0;
               state <= Data3;
           end
    Data3: state <= Data3; // Waiting for Stop condition
    //
    // Routines
    Byte:
        if(!SCL) state <= Byte1;
    Byte1:
        if(SCL) begin data[7-bit_cnt] = SDA; state <= Byte2; end
    Byte2:
        if(bit_cnt != 7) begin bit_cnt <= bit_cnt + 1'd1; state <= Byte; end
        else if(!SCL) begin bit_cnt <= 1'd0; state <= return_state; end
    //
    Ack:
       begin _SDA <= 1'd0; if(SCL) state <= Ack1; end
    Ack1:
       if(!SCL) begin _SDA <= 1'bz; state <= return_state; end
	 
    DataRead: // Transmitting data bytes
       begin 
			return_state <= DataRead1; 
			state <= ByteRead;
			data <= reg_data;
       end
    DataRead1:
       begin
			  byte_cnt <= byte_cnt + 1'd1;
           return_state <= DataRead2;
           state <= AckRead;
       end
    DataRead2:
       if(byte_cnt !=31) begin state <= DataRead; end
       else
           begin
               byte_cnt <= 1'd0;
               state <= DataRead3;
           end
    DataRead3: state <= DataRead3; // Waiting for Stop condition
    //
    // Routines
    ByteRead:
        if(!SCL)
			begin
				state <= ByteRead1;
				_SDA <= data[7-bit_cnt] ? 1'bz : 1'b0;
			end
			
    ByteRead1:
        if(SCL) begin state <= ByteRead2; end
    ByteRead2:
        if(bit_cnt != 7) begin bit_cnt <= bit_cnt + 1'd1; state <= ByteRead; end
        else if(!SCL) begin bit_cnt <= 1'd0; state <= return_state; end
    //	 
    AckRead:
		begin _SDA <= 1'bz; if(SCL) state <= AckRead1; end
		
    AckRead1:
		begin
		 if(!SCL) begin state <= Start; end
       else 
			if(!SDA) begin state <= AckRead2; end
		end
    AckRead2:
       if(!SCL) begin _SDA <= 1'bz; state <= return_state; end
    //
    default: state <= Start;
    endcase
end


// State maschine for Stop condition detection
// Auto syncronisation feature
localparam Stop   = 2'd0;
localparam Stop1  = 2'd1;
localparam Stop2  = 2'd2;

reg [1:0] s_state;
reg stop_flag;

always @(posedge clock)
    if(!reset)
        begin
        s_state <= Stop;
        stop_flag <= 0;
    end
    else
    case (s_state)
    Stop:
        if(SCL & !SDA) s_state <= Stop1;
    Stop1:
        if(SCL & SDA)
        begin
            stop_flag <= 1;
            s_state <=  Stop2;
       end
       else if(!SCL) s_state <= Stop;
    Stop2:
        begin
            stop_flag <= 0;
            s_state <= Stop;
        end
        //
    default: s_state <= Stop;
    endcase
//

endmodule
