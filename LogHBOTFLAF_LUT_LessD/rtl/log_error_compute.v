`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: log_error_compute.v
//////////////////////////////////////////////////////////////////////////////////

module log_error_compute
#(parameter WIDTH = 16, QP = 12, LOG_WIDTH = 17)
(
    input  signed [WIDTH-1:0]     desired_in,
    input  signed [WIDTH-1:0]     filter_out,
    output signed [WIDTH-1:0]     error,
    output signed [LOG_WIDTH-1:0] log_error,
    output                        log_error_sign,
    output                        log_error_valid
);

    localparam MU_SHIFT = 6;

    wire        [ 3:0]      log_error_pos;
    wire signed [ 4:0]      log_error_qp_pos;
    wire        [11:0]      log_error_frac;
    
    wire        [WIDTH-1:0] error_abs;

    wire signed [WIDTH-1:0] error_shift, error_rnd;
    assign error = desired_in - filter_out;

    assign error_rnd = error + (16'b1 << (MU_SHIFT-1));
    assign error_shift = error_rnd >>> MU_SHIFT;

    // Sign detection
    assign log_error_sign = error_shift[WIDTH-1];
    assign error_abs = log_error_sign ? -error_shift: error_shift;

    log1_16 LOG_ERROR ( .data(error_abs),
    .pos(log_error_pos),
    .valid(log_error_valid),
    .fraction(log_error_frac));

    assign log_error_qp_pos = log_error_pos - QP;
    assign log_error = {log_error_qp_pos, log_error_frac};      // Q5.12 format

endmodule