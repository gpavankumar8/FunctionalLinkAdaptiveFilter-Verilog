`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 17-07-2024
// Module name: log_multiplier.v
//////////////////////////////////////////////////////////////////////////////////

module log_multiplier
#(parameter WIDTH = 16, QP1 = 12, QP2 = 12)
(
    input  signed [WIDTH-1:0] in1,
    input  signed [WIDTH-1:0] in2,
    output signed [WIDTH-1:0] prod_out
);

    wire signed [16:0] log_in1, log_in2;
    wire        [ 3:0] log_in1_pos, log_in2_pos;
    wire signed [ 4:0] log_in1_qp_pos, log_in2_qp_pos;
    wire        [11:0] log_in1_frac, log_in2_frac;
    wire        log_in1_valid, log_in2_valid;

    wire signed [17:0] log_prod;
    wire        [14:0] prod_out_unsgd;
    wire signed [15:0] prod_out_unsgd_vld;

    // Sign extract and abs on inputs
    assign in1_sign = in1[WIDTH-1];
    assign in2_sign = in2[WIDTH-1];

    assign in1_abs  = in1_sign ? -in1_sign: in1_sign;
    assign in2_abs  = in2_sign ? -in2_sign: in2_sign;

    // log2() on inputs
    log_16 LOG_IN1 (  .data(in1_abs),
                      .pos(log_in1_pos),
                      .valid(log_in1_valid),
                      .fraction(log_in1_frac));

    assign log_in1_qp_pos = log_in1_pos - QP1;
    assign log_in1 = {log_in1_qp_pos, log_in1_frac};      // Q5.12 format

    log_16 LOG_IN2 (  .data(in2_abs),
                      .pos(log_in2_pos),
                      .valid(log_in2_valid),
                      .fraction(log_in2_frac));

    assign log_in2_qp_pos = log_in2_pos - QP2;
    assign log_in2 = {log_in2_qp_pos, log_in2_frac};      // Q5.12 format

    // Addition of the log2 terms
    assign log_prod = log_in1 + log_in2;

    // Antilog of product
    alog18_Q3_12 ALOG_PROD (.data(log_prod), .adata(prod_out_unsgd));

    // Valid and sign decoding
    assign log_prod_valid = log_in1_valid | log_in2_valid;
    assign prod_out_unsgd_vld = log_prod_valid ? {1'b0, prod_out_unsgd} : 16'b0;
    assign prod_out = (in1_sign ^ in2_sign) ? -prod_out_unsgd_vld: prod_out_unsgd_vld;

endmodule