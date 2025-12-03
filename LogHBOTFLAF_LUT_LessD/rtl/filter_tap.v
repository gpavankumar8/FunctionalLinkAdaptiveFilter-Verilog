`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 04-01-2023
// Module name: filter_tap.v
//////////////////////////////////////////////////////////////////////////////////

module filter_tap
#(parameter WIDTH = 16, QP = 12, RESET_VAL = {WIDTH{1'b0}})
(
    input clk,
    input reset,
    input [WIDTH-1:0] filter_in,
    input [WIDTH-1:0] mu_a_error_d,
    input [WIDTH-1:0] weight_pip_prod,
    output [WIDTH-1:0] filter_out,
    output [WIDTH-1:0] weight
);

    wire signed [2*WIDTH-1:0] filter_out_full, filter_out_rnd;

    assign filter_out_full = $signed(filter_in) * $signed(weight);
    assign filter_out_rnd = filter_out_full + (1'b1 << (QP-1));
    assign filter_out = filter_out_rnd[QP+:WIDTH];

    w_update_d #(WIDTH, QP, RESET_VAL) A_WUB( clk, reset, mu_a_error_d, weight_pip_prod, weight); 

endmodule