`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 10-07-2024
// Module name: nonl_PhiMap_pip_loglut.v
//////////////////////////////////////////////////////////////////////////////////

module nonl_PhiMap_pip_loglut
#( parameter Q_ORD = 7, WIDTH = 16, QP = 12, LUT_WIDTH = 7, LOG_WIDTH = 17)
( 
    // input clk,
    // input reset,
    input  signed [WIDTH-1:0]           x_in,
    output signed [Q_ORD*LOG_WIDTH-1:0] nonl_x_out_packed,    // QP = 15
    output        [Q_ORD-1:0]           nonl_x_out_sign_packed,
    output        [Q_ORD-1:0]           nonl_x_out_valid_packed
);

    localparam TRUNC_WIDTH = LUT_WIDTH + 3;     // Pre mapping LUT_WIDTH
    localparam ZERO_PT_FIVE = (16'b1<<(LUT_WIDTH-1));
    localparam LOG_QP = 15;

    wire signed [WIDTH-1:0] x_trunc_rnd;
    wire signed [TRUNC_WIDTH-1:0] x_trunc, x_trunc2, x_trunc3;
    wire signed [LOG_WIDTH-1:0] nonl_x_out[Q_ORD-1:0];      // QP = 12
    wire nonl_x_out_valid[Q_ORD-1:0], nonl_x_out_sign[Q_ORD-1:0];
    wire signed [2*WIDTH:0] theta_full[(Q_ORD-1)/2-1:0], theta_rnd[(Q_ORD-1)/2-1:0];
    wire signed [2*WIDTH:0] pi_x_in[3:0];
    wire signed [WIDTH:0] theta_in[(Q_ORD-1)/2-1:0], theta_in_d[(Q_ORD-1)/2-1:0];
    wire [LUT_WIDTH-1:0] x_map1, x_map_d, x_map2, x_map3;
    wire sign_sin1, sign_sin2, sign_sin3, sign_cos1, sign_cos2, sign_cos3;
    wire [Q_ORD*LOG_WIDTH-1:0] nonl_x_out_packed_out;

    wire [ 3:0]      log_x_in_pos;
    wire signed [ 4:0]      log_x_in_qp_pos;
    wire [11:0]      log_x_in_frac;
    wire [WIDTH-1:0] x_in_abs;
    wire signed [LOG_WIDTH-1:0] log_x_in;
    wire             log_x_in_valid, log_x_in_sign;

    // DelayNUnit #(WIDTH, 1) ANG_PIP(clk, reset, x_in, x_in);      // Retiming delay for x_in -> nonl_x_out[0]

    // Log of x_in - Term 1
    assign log_x_in_sign = x_in[WIDTH-1];
    assign x_in_abs = log_x_in_sign ? -x_in: x_in;

    log1_16 LOG_X_IN ( .data(x_in_abs),
    .pos(log_x_in_pos),
    .valid(log_x_in_valid),
    .fraction(log_x_in_frac));

    assign log_x_in_qp_pos = log_x_in_pos - QP;
    assign log_x_in = {log_x_in_qp_pos, log_x_in_frac};      // Q5.12 format

    // LUT terms
    // Truncating/rounding input to TRUNC_WIDTH
    assign x_trunc_rnd = x_in + (16'b1 << (QP-LUT_WIDTH)-1 );
    assign x_trunc     = x_trunc_rnd[(QP-LUT_WIDTH)+:TRUNC_WIDTH] ;
    assign x_trunc2    = (x_trunc <<< 1);
    assign x_trunc3    = x_trunc + x_trunc2;

    // Angle mapping
    angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
                     .TRUNC_WIDTH(TRUNC_WIDTH)) 
                 AM1(.x_in(x_trunc),
                     .x_map(x_map1),
                     .sign_cos(sign_cos1),
                     .sign_sin(sign_sin1));

    angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
                     .TRUNC_WIDTH(TRUNC_WIDTH)) 
                 AM2(.x_in(x_trunc2),
                     .x_map(x_map2),
                     .sign_cos(sign_cos2),
                     .sign_sin(sign_sin2));

    angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
                     .TRUNC_WIDTH(TRUNC_WIDTH)) 
                 AM3(.x_in(x_trunc3),
                     .x_map(x_map3),
                     .sign_cos(sign_cos3),
                     .sign_sin(sign_sin3));

    wire signed [15:0] logsin1, logsin2, logsin3, logcos1, logcos2, logcos3;
    wire [WIDTH-1:0] sin1_usgn, sin2_usgn, sin3_usgn, cos1_usgn, cos2_usgn, cos3_usgn;
    
    // log_sin_cos_LUT_5QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .logsin1(logsin1), .logcos1(logcos1), .logsin2(logsin2), .logcos2(logcos2), .logsin3(logsin3), .logcos3(logcos3));
    // log_sin_cos_LUT_6QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .logsin1(logsin1), .logcos1(logcos1), .logsin2(logsin2), .logcos2(logcos2), .logsin3(logsin3), .logcos3(logcos3));
    // log_sin_cos_LUT_7QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .logsin1(logsin1), .logcos1(logcos1), .logsin2(logsin2), .logcos2(logcos2), .logsin3(logsin3), .logcos3(logcos3));
    // log_sin_cos_LUT_8QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .logsin1(logsin1), .logcos1(logcos1), .logsin2(logsin2), .logcos2(logcos2), .logsin3(logsin3), .logcos3(logcos3));
    // log_sin_cos_LUT_9QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .logsin1(logsin1), .logcos1(logcos1), .logsin2(logsin2), .logcos2(logcos2), .logsin3(logsin3), .logcos3(logcos3));
    // log_sin_cos_LUT_10QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .logsin1(logsin1), .logcos1(logcos1), .logsin2(logsin2), .logcos2(logcos2), .logsin3(logsin3), .logcos3(logcos3));
    sin_cos_LUT_7QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));

    wire [WIDTH-1:0] sin1, sin2, sin3, cos1, cos2, cos3;

    // assign sin1 = sign_sin1 ? -(sin1_usgn >> 1): (sin1_usgn >> 1);
    // assign cos1 = sign_cos1 ? -(cos1_usgn >> 1): (cos1_usgn >> 1);
    // assign sin2 = sign_sin2 ? -(sin2_usgn >> 1): (sin2_usgn >> 1);
    // assign cos2 = sign_cos2 ? -(cos2_usgn >> 1): (cos2_usgn >> 1);
    // assign sin3 = sign_sin3 ? -(sin3_usgn >> 1): (sin3_usgn >> 1);
    // assign cos3 = sign_cos3 ? -(cos3_usgn >> 1): (cos3_usgn >> 1);

    // Log using Mitchell scheme
    wire [ 3:0]      log_sin1_pos;
    wire signed [ 4:0]      log_sin1_qp_pos;
    wire [11:0]      log_sin1_frac;
    wire [WIDTH-1:0] sin1_abs;
    wire signed [LOG_WIDTH-1:0] log_sin1;
    wire             log_sin1_valid, log_sin1_sign;

    // Log of sin1_d - Term 1
    assign log_sin1_sign = sign_sin1;
    assign sin1_abs = sin1_usgn;

    log1_16 LOG_sin1 ( .data(sin1_abs),
    .pos(log_sin1_pos),
    .valid(log_sin1_valid),
    .fraction(log_sin1_frac));

    assign log_sin1_qp_pos = log_sin1_pos - LOG_QP;
    assign log_sin1 = {log_sin1_qp_pos, log_sin1_frac};      // Q5.12 format

    wire [ 3:0]      log_sin2_pos;
    wire signed [ 4:0]      log_sin2_qp_pos;
    wire [11:0]      log_sin2_frac;
    wire [WIDTH-1:0] sin2_abs;
    wire signed [LOG_WIDTH-1:0] log_sin2;
    wire             log_sin2_valid, log_sin2_sign;

    // Log of sin2_d - Term 1
    assign log_sin2_sign = sign_sin2;
    assign sin2_abs = sin2_usgn;

    log1_16 LOG_sin2 ( .data(sin2_abs),
    .pos(log_sin2_pos),
    .valid(log_sin2_valid),
    .fraction(log_sin2_frac));

    assign log_sin2_qp_pos = log_sin2_pos - LOG_QP;
    assign log_sin2 = {log_sin2_qp_pos, log_sin2_frac};      // Q5.12 format

    wire [ 3:0]      log_sin3_pos;
    wire signed [ 4:0]      log_sin3_qp_pos;
    wire [11:0]      log_sin3_frac;
    wire [WIDTH-1:0] sin3_abs;
    wire signed [LOG_WIDTH-1:0] log_sin3;
    wire             log_sin3_valid, log_sin3_sign;

    // Log of sin3_d - Term 1
    assign log_sin3_sign = sign_sin3;
    assign sin3_abs = sin3_usgn;

    log1_16 LOG_sin3 ( .data(sin3_abs),
    .pos(log_sin3_pos),
    .valid(log_sin3_valid),
    .fraction(log_sin3_frac));

    assign log_sin3_qp_pos = log_sin3_pos - LOG_QP;
    assign log_sin3 = {log_sin3_qp_pos, log_sin3_frac};      // Q5.12 format

    wire [ 3:0]      log_cos1_pos;
    wire signed [ 4:0]      log_cos1_qp_pos;
    wire [11:0]      log_cos1_frac;
    wire [WIDTH-1:0] cos1_abs;
    wire signed [LOG_WIDTH-1:0] log_cos1;
    wire             log_cos1_valid, log_cos1_sign;

    // Log of cos1_d - Term 1
    assign log_cos1_sign = sign_cos1;
    assign cos1_abs = cos1_usgn;

    log1_16 LOG_cos1 ( .data(cos1_abs),
    .pos(log_cos1_pos),
    .valid(log_cos1_valid),
    .fraction(log_cos1_frac));

    assign log_cos1_qp_pos = log_cos1_pos - LOG_QP;
    assign log_cos1 = {log_cos1_qp_pos, log_cos1_frac};      // Q5.12 format

    wire [ 3:0]      log_cos2_pos;
    wire signed [ 4:0]      log_cos2_qp_pos;
    wire [11:0]      log_cos2_frac;
    wire [WIDTH-1:0] cos2_abs;
    wire signed [LOG_WIDTH-1:0] log_cos2;
    wire             log_cos2_valid, log_cos2_sign;

    // Log of cos2_d - Term 1
    assign log_cos2_sign = sign_cos2;
    assign cos2_abs = cos2_usgn;

    log1_16 LOG_cos2 ( .data(cos2_abs),
    .pos(log_cos2_pos),
    .valid(log_cos2_valid),
    .fraction(log_cos2_frac));

    assign log_cos2_qp_pos = log_cos2_pos - LOG_QP;
    assign log_cos2 = {log_cos2_qp_pos, log_cos2_frac};      // Q5.12 format

    wire [ 3:0]      log_cos3_pos;
    wire signed [ 4:0]      log_cos3_qp_pos;
    wire [11:0]      log_cos3_frac;
    wire [WIDTH-1:0] cos3_abs;
    wire signed [LOG_WIDTH-1:0] log_cos3;
    wire             log_cos3_valid, log_cos3_sign;

    // Log of cos3_d - Term 1
    assign log_cos3_sign = sign_cos3;
    assign cos3_abs = cos3_usgn;

    log1_16 LOG_cos3 ( .data(cos3_abs),
    .pos(log_cos3_pos),
    .valid(log_cos3_valid),
    .fraction(log_cos3_frac));

    assign log_cos3_qp_pos = log_cos3_pos - LOG_QP;
    assign log_cos3 = {log_cos3_qp_pos, log_cos3_frac};      // Q5.12 format

    assign nonl_x_out[0] = log_x_in;
    assign nonl_x_out[1] = {log_sin1[WIDTH-1], log_sin1};
    assign nonl_x_out[2] = {log_cos1[WIDTH-1], log_cos1};
    assign nonl_x_out[3] = {log_sin2[WIDTH-1], log_sin2};
    assign nonl_x_out[4] = {log_cos2[WIDTH-1], log_cos2};
    assign nonl_x_out[5] = {log_sin3[WIDTH-1], log_sin3};
    assign nonl_x_out[6] = {log_cos3[WIDTH-1], log_cos3};

    assign nonl_x_out_sign[0] = log_x_in_sign;
    assign nonl_x_out_sign[1] = log_sin1_sign;
    assign nonl_x_out_sign[2] = log_cos1_sign;
    assign nonl_x_out_sign[3] = log_sin2_sign;
    assign nonl_x_out_sign[4] = log_cos2_sign;
    assign nonl_x_out_sign[5] = log_sin3_sign;
    assign nonl_x_out_sign[6] = log_cos3_sign;

    assign nonl_x_out_valid[0] = log_x_in_valid;
    assign nonl_x_out_valid[1] = log_sin1_valid;
    assign nonl_x_out_valid[2] = log_cos1_valid;
    assign nonl_x_out_valid[3] = log_sin2_valid;
    assign nonl_x_out_valid[4] = log_cos2_valid;
    assign nonl_x_out_valid[5] = log_sin3_valid;
    assign nonl_x_out_valid[6] = log_cos3_valid;

    // DelayNUnit #(Q_ORD*LOG_WIDTH, 1) OUT_PIP(clk, reset, nonl_x_out_packed_out, nonl_x_out_packed); 

    genvar ind;
    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:out_pack
            assign nonl_x_out_packed[LOG_WIDTH*ind+:LOG_WIDTH] = (nonl_x_out[ind]);
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:sign_out_pack
            assign nonl_x_out_sign_packed[ind] = (nonl_x_out_sign[ind]);
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:valid_out_pack
            assign nonl_x_out_valid_packed[ind] = (nonl_x_out_valid[ind]);
        end
    endgenerate

endmodule