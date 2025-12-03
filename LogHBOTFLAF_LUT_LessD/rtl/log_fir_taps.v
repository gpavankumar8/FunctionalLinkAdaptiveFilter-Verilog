`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 17-07-2024
// Module name: log_fir_taps.v
//////////////////////////////////////////////////////////////////////////////////

module log_fir_taps
#(parameter WIDTH = 16, QP = 12, ORD = 64, SHIFT = 0)
(
    input [ORD*WIDTH-1:0] filter_in_packed,
    input [ORD*WIDTH-1:0] weight_in_packed,
    output [ORD*WIDTH-1:0] tap_out_packed
);

    wire signed [WIDTH-1:0] filter_in[ORD-1:0], weight[ORD-1:0], tap_out[ORD-1:0];

    log_multiplier #(WIDTH, QP, QP) TAP(filter_in[0], weight[0], tap_out[0]);

    genvar i;
    generate
        for(i = 1; i < ORD; i = i + 1)
        begin:taps
            log_multiplier #(WIDTH, QP+SHIFT, QP) TAP(filter_in[i], weight[i], tap_out[i]);
        end
    endgenerate


    genvar ind;
    generate
        for ( ind = 0; ind < ORD; ind=ind+1 )
        begin:filter_pack
            assign filter_in[ind] = filter_in_packed[WIDTH*ind+:WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < ORD; ind=ind+1 )
        begin:weight_pack
            assign weight[ind] = weight_in_packed[WIDTH*ind+:WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < ORD; ind=ind+1 )
        begin:tap_pack
            assign tap_out_packed[WIDTH*ind+:WIDTH] = tap_out[ind];
        end
    endgenerate

endmodule