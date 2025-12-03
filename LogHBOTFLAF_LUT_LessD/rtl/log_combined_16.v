`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 02-02-2024
// Module name: log_combined_16.v
//////////////////////////////////////////////////////////////////////////////////

module log_combined_16
#(parameter WIDTH = 16, QP = 12, LOG_WIDTH = 17)
(
    input  signed [WIDTH-1:0]     data,
    output signed [LOG_WIDTH-1:0] log_data,
    output                        log_data_sign,
    output                        log_data_valid
);

    wire        [ 3:0]      log_data_pos;
    wire signed [ 4:0]      log_data_qp_pos;
    wire        [11:0]      log_data_frac;   
    wire        [WIDTH-1:0] data_abs;

    // Sign detection
    assign log_data_sign = data[WIDTH-1];
    assign data_abs = log_data_sign ? -data: data;

    log1_16 LOG_data ( .data(data_abs),
    .pos(log_data_pos),
    .valid(log_data_valid),
    .fraction(log_data_frac));

    assign log_data_qp_pos = log_data_pos - QP;
    assign log_data = {log_data_qp_pos, log_data_frac};      // Q5.12 format

endmodule