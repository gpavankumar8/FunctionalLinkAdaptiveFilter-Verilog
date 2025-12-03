`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 02-08-2024
// Module name: log_in_dot_product_d.v
//////////////////////////////////////////////////////////////////////////////////

module log_in_dot_product_d
#(parameter WIDTH = 16, QP = 12, LEN = 8, LOG_WIDTH = 17)
(
    input clk,
    input reset,

    input  [LEN*LOG_WIDTH-1:0] vec1_packed,
    input  [LEN-1:0]           vec1_packed_sign,
    input  [LEN-1:0]           vec1_packed_valid,
    input  [LEN*LOG_WIDTH-1:0] vec2_packed,
    input  [LEN-1:0]           vec2_packed_sign,
    input  [LEN-1:0]           vec2_packed_valid,
    output [WIDTH-1:0]         dotp_out
);

    wire signed [LEN*WIDTH-1:0] mult_out_packed, mult_out_packed_d;
    wire signed [WIDTH-1:0]     dotp;

    log_in_fir_taps #(WIDTH, QP, LEN, LOG_WIDTH) LOG_FIR(vec1_packed, vec1_packed_sign, vec1_packed_valid, vec2_packed, vec2_packed_sign, vec2_packed_valid, mult_out_packed); 
    DelayNUnit #(LEN*WIDTH, 1) MULT_PIP(clk, reset, mult_out_packed, mult_out_packed_d);              // Retiming delay after multipliers

    adder_tree #(WIDTH, LEN) DOT_ADD(.clk(clk), .reset(reset), .adder_tree_in_packed(mult_out_packed_d), .adder_tree_out(dotp));
    DelayNUnit #(WIDTH, 1) ADD_PIP(clk, reset, dotp, dotp_out);                                       // Retiming delay after adder tree

endmodule