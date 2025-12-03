`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: tflaf_top.v
//////////////////////////////////////////////////////////////////////////////////

module tflaf_top
#(parameter L_ORD = 4, Q_ORD = 7, WIDTH = 16, QP = 12)
(
    input clk,
    input reset, 
    input [WIDTH-1:0] signal_in,
    input [WIDTH-1:0] desired_in,
    input ip_valid,
    output [WIDTH-1:0] filter_out_d,
    output reg [WIDTH-1:0] error_d
);

    localparam WRET = 1, NON_PIP = 1, E_PIP = 1;
    localparam LIN_PIP = 2 + (($clog2(L_ORD*Q_ORD+1)-1)/4);
    localparam RET = NON_PIP + LIN_PIP + WRET + E_PIP;
    localparam W_PIP = LIN_PIP + E_PIP;
    localparam LIN_ADD_LEN = 2**$clog2(L_ORD*Q_ORD+1);
    localparam LIN_ADD_ZERO_PAD = LIN_ADD_LEN - L_ORD*Q_ORD - 1;

    localparam LOG_WIDTH = WIDTH + 1;
    localparam LUT_WIDTH = 7;

    reg signed [WIDTH-1:0] signal_in_d, desired_in_d;
    wire signed [WIDTH-1:0] adder_out, adder_out_d[Q_ORD-1:0], adder_tree_out, adder_tree_out_rnd;
    wire signed [LOG_WIDTH-1:0] filter_in[Q_ORD-1:0][L_ORD+W_PIP-1:0], log_weight[Q_ORD-1:0][L_ORD-1:0], log_weight_const; 
    wire signed [LOG_WIDTH*L_ORD-1:0] log_weight_packed[Q_ORD-1:0];
    wire signed [WIDTH-1:0] error, filter_out, desired_in_ret_d;

    wire signed [L_ORD*WIDTH-1:0] tap_out_packed[Q_ORD-1:0], tap_out_packed_d[Q_ORD-1:0];
    wire signed [L_ORD*Q_ORD*WIDTH-1:0] tap_out_packed_adder;
    wire signed [(L_ORD+W_PIP-1)*LOG_WIDTH-1:0] filter_in_packed[Q_ORD-1:0];
    wire signed [L_ORD*LOG_WIDTH-1:0] filter_in_concat[Q_ORD-1:0];
    wire        [(L_ORD+W_PIP-1)-1:0] filter_in_valid_packed[Q_ORD-1:0], filter_in_sign_packed[Q_ORD-1:0];
    wire        [L_ORD-1:0] filter_in_sign_concat[Q_ORD-1:0], filter_in_valid_concat[Q_ORD-1:0];

    wire signed [Q_ORD*LOG_WIDTH-1:0] nonl_x_out_packed;
    wire signed [LOG_WIDTH-1:0] nonl_x_out[Q_ORD-1:0], nonl_x_out_d[Q_ORD-1:0];
    wire        [Q_ORD-1:0] nonl_x_out_valid_packed, nonl_x_out_sign_packed;
    wire        [Q_ORD-1:0] nonl_x_out_valid, nonl_x_out_sign, nonl_x_out_sign_d, nonl_x_out_valid_d;

    wire signed [WIDTH-1:0] tap_out_const, tap_out_const_d;
    wire log_weight_const_sign, log_weight_const_valid;

    wire [LOG_WIDTH-1:0] log_error, log_error_d;
    wire                 log_error_sign, log_error_sign_d, log_error_valid, log_error_valid_d;
    wire [L_ORD-1:0]     log_weight_sign[Q_ORD-1:0], log_weight_valid[Q_ORD-1:0];
    wire [L_ORD-1:0]     log_weight_sign_packed[Q_ORD-1:0], log_weight_valid_packed[Q_ORD-1:0];
    wire filter_in_sign[Q_ORD-1:0][L_ORD+W_PIP-1:0], filter_in_valid[Q_ORD-1:0][L_ORD+W_PIP-1:0];

    // Nonlinear Phi mapping
    nonl_PhiMap_pip_loglut #(Q_ORD, WIDTH, QP, LUT_WIDTH, LOG_WIDTH) Phi( .x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed), .nonl_x_out_valid_packed(nonl_x_out_valid), .nonl_x_out_sign_packed(nonl_x_out_sign));

    wire valid_d;
    DelayNUnit #(1, 1) VLD_PIP( clk, reset, ip_valid, valid_d);
    // Filter pipeline
    genvar f;
    generate
        for (f = 0; f < Q_ORD; f = f+1)
        begin:pipe
            //assign filter_in[f][0] = nonl_x_out[f];
            DelayNUnit #(LOG_WIDTH, 1) NONL_PIP(clk, reset, nonl_x_out[f], nonl_x_out_d[f]);      // Retiming delay after Phi
            DelayNUnit #(1, 1) NONL_VLD_PIP(clk, reset, nonl_x_out_valid[f] && valid_d, nonl_x_out_valid_d[f]);      // Retiming delay after Phi
            DelayNUnit #(1, 1) NONL_SGN_PIP(clk, reset, nonl_x_out_sign[f], nonl_x_out_sign_d[f]);      // Retiming delay after Phi
            assign filter_in[f][0] = nonl_x_out_d[f];
            assign filter_in_sign[f][0] = nonl_x_out_sign_d[f];
            assign filter_in_valid[f][0] = nonl_x_out_valid_d[f];
            pipeline #(LOG_WIDTH, (L_ORD+W_PIP-1)) PIP(clk, reset, filter_in[f][0], filter_in_packed[f]);
            pipeline #(1, (L_ORD+W_PIP-1)) VLD_PIP(clk, reset, filter_in_valid[f][0], filter_in_valid_packed[f]);
            pipeline #(1, (L_ORD+W_PIP-1)) SGN_PIP(clk, reset, filter_in_sign[f][0], filter_in_sign_packed[f]);
        end
    endgenerate

    // FIR filter taps
    // fir_taps #(WIDTH, QP, L_ORD) FIR_0({filter_in_packed[0][(L_ORD-1)*WIDTH-1:0], filter_in[0][0]}, log_weight_packed[0], tap_out_packed[0]); 
    // DelayNUnit #(L_ORD*WIDTH, 1) MULT_PIP_0(clk, reset, tap_out_packed[0], tap_out_packed_d[0]);      // Retiming delay after multipliers
    
    genvar i;
    generate
        for (i = 0; i < Q_ORD ; i = i+1) 
        begin: filters
            // fir_taps #(WIDTH, QP, L_ORD,3) FIR({filter_in_packed[i][(L_ORD-1)*WIDTH-1:0], filter_in[i][0]}, log_weight_packed[i], tap_out_packed[i]); 
            assign filter_in_concat[i] = {filter_in_packed[i][(L_ORD-1)*LOG_WIDTH-1:0], filter_in[i][0]};
            assign filter_in_valid_concat[i] = {filter_in_valid_packed[i][L_ORD-2:0], filter_in_valid[i][0]};
            assign filter_in_sign_concat[i] = {filter_in_sign_packed[i][L_ORD-2:0], filter_in_sign[i][0]};
            log_in_fir_taps #(WIDTH, QP, L_ORD, LOG_WIDTH) LOG_FIR(filter_in_concat[i], filter_in_sign_concat[i], filter_in_valid_concat[i], log_weight_packed[i], log_weight_sign[i], log_weight_valid[i], tap_out_packed[i]); 
            DelayNUnit #(L_ORD*WIDTH, 1) MULT_PIP(clk, reset, tap_out_packed[i], tap_out_packed_d[i]);      // Retiming delay after multipliers
        end
    endgenerate

    log_in_fir_taps #(WIDTH, QP, 1, LOG_WIDTH) LOG_FIR_CONST(17'b0, 1'b0, 1'b1, log_weight_const, log_weight_const_sign, log_weight_const_valid, tap_out_const);
    DelayNUnit #(WIDTH, 1) MULT_PIP_CONST(clk, reset, tap_out_const, tap_out_const_d);      // Retiming delay after multipliers

    // Using automated pipelining adder tree
    adder_tree #(WIDTH, LIN_ADD_LEN) ADD1(.clk(clk), .reset(reset), .adder_tree_in_packed({tap_out_packed_adder,tap_out_const_d,{(LIN_ADD_ZERO_PAD*WIDTH){1'b0}}}), .adder_tree_out(adder_out)); 
    assign filter_out = adder_out;
    DelayNUnit #(WIDTH, 1) FILT_OUT_PIP(clk, reset, filter_out, filter_out_d);              // Retiming delay after adder tree (also filter_out register)

    // Compute error
    log_error_compute #(WIDTH, QP, LOG_WIDTH) LOG_EC( .desired_in(desired_in_ret_d), .filter_out(filter_out_d), .error(error), .log_error(log_error), .log_error_sign(log_error_sign), .log_error_valid(log_error_valid));

    // Weight update
    // assign error_rnd = error + (1<<(9-1));
    // assign mu_error = error_rnd >>> 9;       // Multiply by mu = 0.0078125 (1/(2^7));

    DelayNUnit #(LOG_WIDTH, 1) ERR_PIP(clk, reset, log_error, log_error_d);              // Retiming delay after adder tree (also filter_out register)
    DelayNUnit #(1, 1) ERR_SGN_PIP(clk, reset, log_error_sign, log_error_sign_d);              // Retiming delay after adder tree (also filter_out register)
    DelayNUnit #(1, 1) ERR_VLD_PIP(clk, reset, log_error_valid, log_error_valid_d);              // Retiming delay after adder tree (also filter_out register)

    genvar w_q, w_l;

    // generate
    // for ( w_l = 0; w_l < L_ORD; w_l = w_l+1 ) 
    // begin: weights_l_0
    //     w_update_d #(WIDTH, QP, 0) WUB_0( clk, reset, mu_error_d, filter_in[0][w_l+W_PIP], weight[0][w_l]); 
    // end
    // endgenerate

    generate
        for( w_q = 0; w_q < Q_ORD; w_q = w_q+1 )
        begin: weights_q
            
            for ( w_l = 0; w_l < L_ORD; w_l = w_l+1 ) 
            begin: weights_l
                log_w_update_d #(WIDTH, QP, LOG_WIDTH) LOG_WUB( clk, reset, log_error_d, log_error_sign_d, log_error_valid_d, filter_in[w_q][w_l+W_PIP], filter_in_sign[w_q][w_l+W_PIP], filter_in_valid[w_q][w_l+W_PIP], log_weight[w_q][w_l], log_weight_sign[w_q][w_l], log_weight_valid[w_q][w_l]); 
            end
        end
    endgenerate

    // log_weight for constant input
    log_w_update_d #(WIDTH, QP, LOG_WIDTH) LOG_WUB_CONST( clk, reset, log_error_d, log_error_sign_d, log_error_valid_d, 16'b0, 1'b0, 1'b1, log_weight_const, log_weight_const_sign, log_weight_const_valid); 

    // Input output registers
    always @ (posedge clk)
    begin
        if (reset)
        begin
            signal_in_d <= 0;
            desired_in_d <= 0;           
        end
        else
        begin
            signal_in_d <= signal_in;
            desired_in_d <= desired_in;
        end
    end

    always @ (posedge clk)
    begin
        if (reset)
        begin
            error_d <= 0;
        end
        else
        begin
            error_d <= error;
        end
    end

    // Delay desired signal based on retiming delays in signal_in path
    DelayNUnit #(WIDTH, RET-WRET-E_PIP) DES_PIP(clk, reset, desired_in_d, desired_in_ret_d);

    // 2D and 1D array conversions
    // Unpack filter_in pipeline
    genvar ind_l, ind_q;
    generate
        for ( ind_q = 0; ind_q < Q_ORD; ind_q=ind_q+1 )
        begin:filter_pack
            for ( ind_l = 0; ind_l < L_ORD+W_PIP-1; ind_l=ind_l+1 ) 
            begin:filter_inner
                assign filter_in[ind_q][ind_l+1] = filter_in_packed[ind_q][LOG_WIDTH*ind_l+:LOG_WIDTH];
                assign filter_in_sign[ind_q][ind_l+1] = filter_in_sign_packed[ind_q][ind_l];
                assign filter_in_valid[ind_q][ind_l+1] = filter_in_valid_packed[ind_q][ind_l];
            end
        end
    endgenerate

    generate
        for ( ind_q = 0; ind_q < Q_ORD; ind_q=ind_q+1 )
        begin:weight_pack
            for ( ind_l = 0; ind_l < L_ORD; ind_l=ind_l+1 ) 
            begin:weight_inner
                assign log_weight_packed[ind_q][LOG_WIDTH*ind_l+:LOG_WIDTH] = log_weight[ind_q][ind_l];
                // assign log_weight_sign_packed[ind_q][WIDTH*ind_l+:WIDTH] = log_weight_sign[ind_q][ind_l];
                // assign log_weight_valid_packed[ind_q][WIDTH*ind_l+:WIDTH] = log_weight_valid[ind_q][ind_l];
            end
        end
    endgenerate

    genvar ind;
    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:nonl_x_pack
            assign nonl_x_out[ind] = nonl_x_out_packed[LOG_WIDTH*ind+:LOG_WIDTH];
            // assign nonl_x_out_sign[ind] = nonl_x_out_sign_packed[WIDTH*ind+:WIDTH];
            // assign nonl_x_out_valid[ind] = nonl_x_out_valid_packed[WIDTH*ind+:WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:tap_out_pack
            assign tap_out_packed_adder[L_ORD*WIDTH*ind+:L_ORD*WIDTH] = tap_out_packed_d[ind];
        end
    endgenerate

    // Pack tap_out array
    // genvar ind2;
    // generate
    //     for ( ind2 = 0; ind2 < L_ORD; ind2=ind2+1 )
    //     begin:tap32
    //         assign tap_out_packed[WIDTH*ind2+:WIDTH] = tap_out[ind2];
    //         //assign tap_out_packed[WIDTH*(ind2+1)-1:WIDTH*ind2] = tap_out[ind2];
    //     end
    // endgenerate

endmodule
