`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: log_w_update_d.v
//////////////////////////////////////////////////////////////////////////////////

module log_w_update_d
#(parameter WIDTH = 16, QP = 12, LOG_WIDTH = 17)
(
    input clk,
    input reset,
    input  signed [LOG_WIDTH-1:0] log_mu_error,
    input                     log_error_sign,
    input                     log_error_valid,
    input  signed [LOG_WIDTH-1:0] log_x_n,
    input                     log_x_n_sign,
    input                     log_x_n_valid,
    output signed [LOG_WIDTH-1:0] log_weight,
    output                    log_weight_sign,
    output                    log_weight_valid
);

    wire signed [WIDTH-1:0] x_n_error, new_weight, x_n_error_d;
    reg  signed [WIDTH-1:0] weight;
    
    log_in_multiplier #(WIDTH, LOG_WIDTH) WUPD_TAP( .log_in1(log_mu_error), .log_in1_sign(log_error_sign), .log_in1_valid(log_error_valid),
                                                    .log_in2(log_x_n),   .log_in2_sign(log_x_n_sign),   .log_in2_valid(log_x_n_valid), .prod_out(x_n_error));

    DelayNUnit #(WIDTH, 1) IN_PIP(clk, reset, x_n_error, x_n_error_d);        // Retiming delay before add
    assign new_weight = weight + x_n_error_d;

    always @ ( posedge clk )
    if ( reset )
        weight <= 0;
    else
        weight <= new_weight;

    // Log weight
    wire        [ 3:0]      log_weight_pos;
    wire signed [ 4:0]      log_weight_qp_pos;
    wire        [11:0]      log_weight_frac;
    wire        [WIDTH-1:0] weight_abs;
    wire                    log_weight_sign_in, log_weight_valid_in;
    wire        [LOG_WIDTH-1:0] log_weight_in;

    // Sign detection
    assign log_weight_sign_in = weight[WIDTH-1];
    assign weight_abs = log_weight_sign_in ? -weight: weight;

    log1_16 LOG_WEIGHT ( .data(weight_abs),
                        .pos(log_weight_pos),
                        .valid(log_weight_valid_in),
                        .fraction(log_weight_frac));

    assign log_weight_qp_pos = log_weight_pos - QP;
    assign log_weight_in = {log_weight_qp_pos, log_weight_frac};      // Q5.12 format

    DelayNUnit #(LOG_WIDTH, 1) LOGW_PIP(clk, reset, log_weight_in, log_weight);        // log_w pipeline stage
    DelayNUnit #(1, 1) LOGW_VLD_PIP(clk, reset, log_weight_valid_in, log_weight_valid);
    DelayNUnit #(1, 1) LOGW_SGN_PIP(clk, reset, log_weight_sign_in, log_weight_sign);
    

endmodule