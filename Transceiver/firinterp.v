// Interpolate by 8 FIR filter.
// Produce an output when calc is strobed true.  Output a strobe on req
// to request an new input sample.
// Input sample bits is 16.

module FirInterp8(
    input clock,
    input calc,                                 // calculate an output sample
    output reg req,                             // request the next input sample
    input signed [15:0] x_real,                 // input samples
    input signed [15:0] x_imag,
    output reg signed [OBITS-1:0] y_real,       // output samples
    output reg signed [OBITS-1:0] y_imag
    );

    parameter OBITS = 20;                       // output bits
    parameter ABITS = 24;                       // adder bits
    parameter NTAPS = 10'd512;                  // number of filter taps, even by 8, 1024-8 max
    parameter NTAPS_BITS = 9;                   // number of address bits for coefficient memory

    reg [3:0] rstate;                           // state machine
    parameter rWait = 0;
    parameter rAddr = 1;
    parameter rAddrA = 2;
    parameter rAddrB = 3;
    parameter rRun = 4;
    parameter rDone = 5;
    parameter rEnd1 = 6;
    parameter rEnd2 = 7;
    parameter rEnd3 = 8;
    parameter rEnd4 = 9;

    // We need memory for NTAPS / 8 samples saved in memory
    reg  [5:0] waddr, raddr;                    // write and read sample memory address
    reg  we;                                    // write enable for samples
    reg  signed [ABITS-1:0] Raccum, Iaccum;     // accumulators
    wire [35:0] q;                              // I/Q sample read from memory
    reg  [35:0] reg_q;
    wire signed [17:0] q_real, q_imag;
    assign q_real = reg_q[35:18];
    assign q_imag = reg_q[17:0];
    reg  [NTAPS_BITS-1:0] caddr;                // read address for coefficient
    wire signed [17:0] coef;                    // 18-bit coefficient read from memory
    reg  signed [17:0] reg_coef;
    reg  signed [35:0] Rmult, Imult;            // multiplier result
    reg  [2:0] phase;                           // count 0, 1, ..., 7
    reg  [9:0] counter;                         // count NTAPS/8 samples + latency


    initial
    begin
        rstate = rWait;
        waddr = 0;
        req = 0;
        phase = 0;
    end

    //defparam rom.MifFile = "coefI8.mif";  Specified in MegaFunction.
    firromI rom (caddr, clock, coef);           // coefficient ROM 18 bits X NTAPS
    // sample RAM 36 bits X 64;  36 bit == 18 bits I and 18 bits Q
    // sign extend the input samples; they remain at 16 bits
    wire [35:0] sx_input;
    assign sx_input = {x_real[15], x_real[15], x_real, x_imag[15], x_imag[15], x_imag};
    firram36I ram (clock, sx_input, raddr, waddr, we, q);

    task next_addr;                             // increment address and register the next sample and coef
        raddr <= raddr - 1'd1;                  // move to prior sample
        caddr <= caddr + 4'd8;                  // move to next coefficient
        reg_q <= q;
        reg_coef <= coef;
    endtask

    always @(posedge clock)
    begin
        case (rstate)
            rWait:
            begin
                if (calc)                       // Wait until a new result is requested
                begin
                    rstate <= rAddr;
                    raddr <= waddr;             // read address -> newest sample
                    caddr <= phase;             // start coefficient
                    counter <= NTAPS / 10'd8 + 1'd1; // count samples and pipeline latency
                    Raccum <= 1'd0;
                    Iaccum <= 1'd0;
                    Rmult <= 1'd0;
                    Imult <= 1'd0;
                end
        end
            rAddr:                              // prime the memory pipeline
            begin
                rstate <= rAddrA;
                next_addr;
            end
            rAddrA:
            begin
                rstate <= rAddrB;
                next_addr;
            end
            rAddrB:
            begin
                rstate <= rRun;
                next_addr;
            end
            rRun:
            begin                                // main pipeline here
                next_addr;
                Rmult <= q_real * reg_coef;
                Imult <= q_imag * reg_coef;
                Raccum <= Raccum + Rmult[35 -: ABITS]; // Add the most significant bits
                Iaccum <= Iaccum + Imult[35 -: ABITS];
                counter <= counter - 1'd1;
                if (counter == 0)
                begin
                    rstate <= rDone;
                end
            end
            rDone:
            begin
                // Input samples were 16 bits in 18
                // Coefficients were multiplied by 8
                y_real <= Raccum[(ABITS-1-3) -: OBITS];
                y_imag <= Iaccum[(ABITS-1-3) -: OBITS];
                if (phase == 3'b111)
                    rstate <= rEnd1;
                else
                    rstate <= rWait;
                phase <= phase + 1'd1;
            end
            rEnd1:                              // This was the last output sample for this input sample
            begin
                rstate <= rEnd2;
                waddr <= waddr + 1'd1;          // next write address
            end
            rEnd2:
            begin
                rstate <= rEnd3;
                we <= 1'd1;                     // write current new sample at new address
            end
            rEnd3:
            begin
                rstate <= rEnd4;
                we <= 1'd0;
                req <= 1'd1;                    // request next sample
            end
            rEnd4:
            begin
                rstate <= rWait;
                req <= 1'd0;
            end
        endcase
end
endmodule
