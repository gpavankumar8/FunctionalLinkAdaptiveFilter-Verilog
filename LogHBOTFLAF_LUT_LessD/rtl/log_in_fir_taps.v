`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: log_in_fir_taps.v
//////////////////////////////////////////////////////////////////////////////////

module log_in_fir_taps
#(parameter WIDTH = 16, QP = 12, ORD = 64, LOG_WIDTH = 17)
(
    // input clk,
    // input reset,
    input [ORD*LOG_WIDTH-1:0] filter_in_packed,
    input [ORD-1:0]       filter_in_sign_packed,
    input [ORD-1:0]       filter_in_valid_packed,
    input [ORD*LOG_WIDTH-1:0] weight_in_packed,
    input [ORD-1:0]       weight_in_sign_packed,
    input [ORD-1:0]       weight_in_valid_packed,
    output [ORD*WIDTH-1:0] tap_out_packed
);

    wire signed [LOG_WIDTH-1:0] filter_in[ORD-1:0], weight[ORD-1:0];
    wire signed [WIDTH-1:0]     tap_out[ORD-1:0];

    genvar i;
    generate
        for(i = 0; i < ORD; i = i + 1)
        begin:taps
            log_in_multiplier #(WIDTH, LOG_WIDTH) TAP( .log_in1(filter_in[i]), .log_in1_sign(filter_in_sign_packed[i]), .log_in1_valid(filter_in_valid_packed[i]),
                                            .log_in2(weight[i]),    .log_in2_sign(weight_in_sign_packed[i]), .log_in2_valid(weight_in_valid_packed[i]), .prod_out(tap_out[i]));
        end
    endgenerate


    genvar ind;
    generate
        for ( ind = 0; ind < ORD; ind=ind+1 )
        begin:filter_pack
            assign filter_in[ind] = filter_in_packed[LOG_WIDTH*ind+:LOG_WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < ORD; ind=ind+1 )
        begin:weight_pack
            assign weight[ind] = weight_in_packed[LOG_WIDTH*ind+:LOG_WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < ORD; ind=ind+1 )
        begin:tap_pack
            assign tap_out_packed[WIDTH*ind+:WIDTH] = tap_out[ind];
        end
    endgenerate

endmodule