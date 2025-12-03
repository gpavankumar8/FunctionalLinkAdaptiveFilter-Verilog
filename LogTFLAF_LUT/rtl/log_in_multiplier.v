`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: log_in_multiplier.v
//////////////////////////////////////////////////////////////////////////////////

module log_in_multiplier
#(parameter WIDTH = 16, LOG_WIDTH = 17)
(
    input  signed [LOG_WIDTH-1:0] log_in1,
    input                     log_in1_sign,
    input                     log_in1_valid,
    input  signed [LOG_WIDTH-1:0] log_in2,
    input                     log_in2_sign,
    input                     log_in2_valid,
    output signed [WIDTH-1:0] prod_out
);

    wire signed [17:0] log_prod;
    wire        [14:0] prod_out_unsgd;
    wire signed [15:0] prod_out_unsgd_vld;
    wire               log_prod_valid, log_prod_sign;

    // Addition of the log2 terms
    assign log_prod = log_in1 + log_in2;

    // DelayNUnit#(18,1) L2(clk, reset, log_prod, log_prod_d);
    // Antilog of product
    alog18_Q3_12 ALOG_PROD (.data(log_prod), .adata(prod_out_unsgd));

    // Valid and sign decoding
    assign log_prod_valid = log_in1_valid & log_in2_valid;
    assign log_prod_sign  = log_in1_sign ^ log_in2_sign;

    assign prod_out_unsgd_vld = log_prod_valid ? {1'b0, prod_out_unsgd} : 16'b0;
    assign prod_out = log_prod_sign ? -prod_out_unsgd_vld: prod_out_unsgd_vld;

endmodule