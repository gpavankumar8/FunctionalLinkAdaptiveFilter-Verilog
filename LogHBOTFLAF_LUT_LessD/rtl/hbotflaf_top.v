`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 02-08-2024
// Module name: hbotflaf_top.v
//////////////////////////////////////////////////////////////////////////////////

module hbotflaf_top
#(parameter L_ORD = 32, Q_ORD = 7, WIDTH = 16, QP = 12)
(
    input clk,
    input reset, 
    input [WIDTH-1:0] signal_in,
    input [WIDTH-1:0] desired_in,
    input ip_valid,
    output [WIDTH-1:0] filter_out_d,
    output reg [WIDTH-1:0] error_d
);

    localparam WRET = 0, NON_PIP = 1, E_PIP = 1;
    localparam LIN_PIP_FIR = 2 + (($clog2(L_ORD+1)-1)/4);
    localparam NON_PIP_FIR = 3 + (($clog2(Q_ORD)-1)/4);
    localparam DOTP_PIP = 2 + (($clog2(L_ORD)-1)/4);
    localparam RET = NON_PIP + NON_PIP_FIR + LIN_PIP_FIR + E_PIP + WRET;
    localparam W_PIP = LIN_PIP_FIR + E_PIP;
    localparam A_PIP = NON_PIP_FIR + LIN_PIP_FIR + E_PIP - DOTP_PIP;
    localparam LIN_ADD_LEN = 2**$clog2(L_ORD+1);
    localparam LIN_ADD_ZERO_PAD = LIN_ADD_LEN - L_ORD - 1;
    localparam NONLIN_ADD_LEN = 2**$clog2(Q_ORD);
    localparam NONLIN_ADD_ZERO_PAD = NONLIN_ADD_LEN - Q_ORD;

    localparam LOG_WIDTH = WIDTH + 1;
    localparam LUT_WIDTH = 7;
    localparam MU_W = 9, MU_A = 9;

    reg signed  [WIDTH-1:0] signal_in_d, desired_in_d;
    wire signed [LOG_WIDTH-1:0] lin_filter_in[L_ORD+W_PIP-1:0], log_weight[L_ORD-1:0];
    wire signed [WIDTH-1:0] tap_out[L_ORD-1:0];
    wire signed [WIDTH-1:0] mu_w_error, mu_w_error_d, error_w_rnd, mu_a_error, mu_a_error_d, error_a_rnd, adder_out;
    //wire signed [WIDTH-1:0] adder_tree_out, adder_tree_out_rnd;
    wire signed [WIDTH-1:0] error, filter_out, desired_in_ret_d;

    wire signed [L_ORD*WIDTH-1:0]     tap_out_packed, tap_out_packed_d;
    wire signed [L_ORD*LOG_WIDTH-1:0] log_weight_packed, log_weight_packed_vmm;
    wire signed [(L_ORD+W_PIP-1)*LOG_WIDTH-1:0] lin_filter_in_packed;
    wire        [L_ORD+W_PIP-2:0] lin_filter_in_valid_packed, lin_filter_in_sign_packed;
    wire signed [L_ORD*LOG_WIDTH-1:0] lin_filter_in_concat;
    wire        [L_ORD-1:0] lin_filter_in_sign_concat, lin_filter_in_valid_concat;

    wire signed [Q_ORD*LOG_WIDTH-1:0] nonl_x_out_packed, nonl_x_out_d_packed;
    wire signed [LOG_WIDTH-1:0]       nonl_x_out[Q_ORD-1:0], nonl_x_out_d[Q_ORD-1:0];
    wire signed [WIDTH-1:0]           s_out, s_out_d, a_out[Q_ORD-1:0];
    wire        [Q_ORD-1:0] nonl_x_out_valid, nonl_x_out_sign, nonl_x_out_sign_d, nonl_x_out_valid_d;

    wire signed [LOG_WIDTH-1:0] log_weight_const;
    wire                        log_weight_const_sign, log_weight_const_valid;

    wire signed [WIDTH-1:0] tap_out_const, tap_out_const_d;
    wire signed [(L_ORD+A_PIP-2)*LOG_WIDTH-1:0] nonl_filter_in_packed[Q_ORD-1:0];
    wire        [L_ORD+A_PIP-2:0]               nonl_filter_in_sign_packed[Q_ORD-1:0], nonl_filter_in_valid_packed[Q_ORD-1:0];
    wire signed [Q_ORD*WIDTH-1:0] a_out_packed, a_out_packed_d;
    wire signed [Q_ORD*LOG_WIDTH-1:0] a_log_weight_packed;
    wire signed [LOG_WIDTH-1:0] nonl_filter_in[Q_ORD-1:0][L_ORD+A_PIP-1:0], a_log_weight[Q_ORD-1:0];
    wire                        nonl_filter_in_sign[Q_ORD-1:0][L_ORD+A_PIP-1:0], nonl_filter_in_valid[Q_ORD-1:0][L_ORD+A_PIP-1:0];

    wire signed [WIDTH-1:0] weight_pip_prod[Q_ORD-1:0], weight_pip_prod_d[Q_ORD-1:0];

    wire [LOG_WIDTH-1:0] log_error, log_error_d;
    wire                 log_error_sign, log_error_sign_d, log_error_valid, log_error_valid_d;
    wire [L_ORD-1:0]     log_weight_sign, log_weight_valid;
    wire [L_ORD-1:0]     log_weight_vmm_sign, log_weight_vmm_valid;
    wire [Q_ORD-1:0]     a_log_weight_sign, a_log_weight_valid;
    wire lin_filter_in_sign[L_ORD+W_PIP-1:0], lin_filter_in_valid[L_ORD+W_PIP-1:0];

    wire signed [LOG_WIDTH-1:0] log_weight_pip_prod[Q_ORD-1:0];
    wire                        log_weight_pip_prod_sign[Q_ORD-1:0], log_weight_pip_prod_valid[Q_ORD-1:0];

    // Nonlinear Phi mapping
    nonl_PhiMap_pip_loglut #(Q_ORD, WIDTH, QP, LUT_WIDTH, LOG_WIDTH) Phi( .x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed), .nonl_x_out_valid_packed(nonl_x_out_valid), .nonl_x_out_sign_packed(nonl_x_out_sign));

    wire valid_d;
    DelayNUnit #(1, 1) VLD_PIP( clk, reset, ip_valid, valid_d);

    // Filter pipeline
    genvar f;
    generate
        for (f = 0; f < Q_ORD; f = f+1)
        begin:pipe
            // assign nonl_filter_in[f][0] = nonl_x_out[f];
            DelayNUnit #(LOG_WIDTH, 1) NONL_OUT_PIP(clk, reset, nonl_x_out[f], nonl_x_out_d[f]);      // Retiming delay after Phi
            DelayNUnit #(1, 1) NONL_VLD_PIP(clk, reset, nonl_x_out_valid[f] && valid_d, nonl_x_out_valid_d[f]);      // Retiming delay after Phi
            DelayNUnit #(1, 1) NONL_SGN_PIP(clk, reset, nonl_x_out_sign[f], nonl_x_out_sign_d[f]);      // Retiming delay after Phi
            assign nonl_filter_in[f][0] = nonl_x_out_d[f];
            assign nonl_filter_in_sign[f][0] = nonl_x_out_sign_d[f];
            assign nonl_filter_in_valid[f][0] = nonl_x_out_valid_d[f];
            pipeline #(LOG_WIDTH, (L_ORD+A_PIP-2)) NONL_PIP(clk, reset, nonl_filter_in[f][0], nonl_filter_in_packed[f]);
            pipeline #(1, (L_ORD+A_PIP-1)) A_VLD_PIP(clk, reset, nonl_filter_in_valid[f][0], nonl_filter_in_valid_packed[f]);
            pipeline #(1, (L_ORD+A_PIP-1)) A_SGN_PIP(clk, reset, nonl_filter_in_sign[f][0], nonl_filter_in_sign_packed[f]);
        end
    endgenerate

    // Non-linearity weights (a)
    log_in_fir_taps #(WIDTH, QP, Q_ORD, LOG_WIDTH) NONL_LOG_FIR(nonl_x_out_d_packed, nonl_x_out_sign_d, nonl_x_out_valid_d, a_log_weight_packed, a_log_weight_sign, a_log_weight_valid, a_out_packed); 
    DelayNUnit #(Q_ORD*WIDTH, 1) NONL_MULT_OUT_PIP(clk, reset, a_out_packed, a_out_packed_d);              // Retiming delay after NONL FIR multipliers

    // adder_tree #(WIDTH, Q_ORD+1) NONL_ADD1(.adder_tree_in_packed({a_out_packed,{WIDTH{1'b0}}}), .adder_tree_out(s_out)); 
    adder_tree #(WIDTH, NONLIN_ADD_LEN) NONL_ADD1(.clk(clk), .reset(reset), .adder_tree_in_packed({a_out_packed_d,{(NONLIN_ADD_ZERO_PAD*WIDTH){1'b0}}}), .adder_tree_out(s_out)); 
    // assign lin_filter_in[0] = s_out;
    DelayNUnit #(WIDTH, 1) NONL_FILT_OUT_PIP(clk, reset, s_out, s_out_d);              // Retiming delay after NONL adder tree

    // log_s_out generation
    wire signed [LOG_WIDTH-1:0] log_s_out;
    wire                    log_s_out_valid, log_s_out_sign;

    log_combined_16 #(WIDTH, QP, LOG_WIDTH) LOG_S_OUT( .data(s_out_d), .log_data(log_s_out), .log_data_sign(log_s_out_sign), .log_data_valid(log_s_out_valid));

    DelayNUnit #(LOG_WIDTH, 1) LIN_FILT_IN_PIP(clk, reset, log_s_out, lin_filter_in[0]);              // Retiming delay after Log
    DelayNUnit #(1, 1) LIN_FILT_IN_SGN_PIP(clk, reset, log_s_out_sign, lin_filter_in_sign[0]);              // Retiming delay after Log
    DelayNUnit #(1, 1) LIN_FILT_IN_VLD_PIP(clk, reset, log_s_out_valid, lin_filter_in_valid[0]);              // Retiming delay after Log

    // assign lin_filter_in[0] = log_s_out;
    // assign lin_filter_in_sign[0] = log_s_out_sign;
    // assign lin_filter_in_valid[0] = log_s_out_valid;

    // Linear filter
    pipeline #(LOG_WIDTH, (L_ORD+W_PIP-1)) S_PIP(clk, reset, lin_filter_in[0], lin_filter_in_packed);
    pipeline #(1, (L_ORD+W_PIP-1)) S_VLD_PIP(clk, reset, lin_filter_in_valid[0], lin_filter_in_valid_packed);
    pipeline #(1, (L_ORD+W_PIP-1)) S_SGN_PIP(clk, reset, lin_filter_in_sign[0], lin_filter_in_sign_packed);

    assign lin_filter_in_concat = {lin_filter_in_packed[(L_ORD-1)*LOG_WIDTH-1:0], lin_filter_in[0]};
    assign lin_filter_in_valid_concat = {lin_filter_in_valid_packed[L_ORD-2:0], lin_filter_in_valid[0]};
    assign lin_filter_in_sign_concat = {lin_filter_in_sign_packed[L_ORD-2:0], lin_filter_in_sign[0]};
    
    log_in_fir_taps #(WIDTH, QP, L_ORD, LOG_WIDTH) LIN_LOG_FIR(lin_filter_in_concat, lin_filter_in_sign_concat, lin_filter_in_valid_concat, log_weight_packed, log_weight_sign, log_weight_valid, tap_out_packed); 
    DelayNUnit #(L_ORD*WIDTH, 1) MULT_PIP(clk, reset, tap_out_packed, tap_out_packed_d);      // Retiming delay after multipliers

    log_in_fir_taps #(WIDTH, QP, 1, LOG_WIDTH) LIN_LOG_FIR_CONST(17'b0, 1'b0, 1'b1, log_weight_const, log_weight_const_sign, log_weight_const_valid, tap_out_const); 
    DelayNUnit #(WIDTH, 1) MULT_PIP_CONST(clk, reset, tap_out_const, tap_out_const_d);      // Retiming delay after multipliers

    // adder_tree #(WIDTH, L_ORD) LIN_ADD(.adder_tree_in_packed(tap_out_packed), .adder_tree_out(adder_out)); 
    adder_tree #(WIDTH, LIN_ADD_LEN) LIN_ADD(.clk(clk), .reset(reset), .adder_tree_in_packed({tap_out_packed_d,tap_out_const_d,{(LIN_ADD_ZERO_PAD*WIDTH){1'b0}}}), .adder_tree_out(adder_out)); 
    // assign filter_out = adder_out + tap_out_const;
    // assign filter_out = adder_out + tap_out_const_d;
    assign filter_out = adder_out;

    DelayNUnit #(WIDTH, 1) FILT_OUT_PIP(clk, reset, filter_out, filter_out_d);              // Retiming delay after adder tree (also filter_out register)

    // Compute error
    log_error_compute #(WIDTH, QP, LOG_WIDTH) LOG_EC( .desired_in(desired_in_ret_d), .filter_out(filter_out_d), .error(error), .log_error(log_error), .log_error_sign(log_error_sign), .log_error_valid(log_error_valid));

    DelayNUnit #(LOG_WIDTH, 1) ERR_PIP(clk, reset, log_error, log_error_d);              // Retiming delay after adder tree (also filter_out register)
    DelayNUnit #(1, 1) ERR_SGN_PIP(clk, reset, log_error_sign, log_error_sign_d);              // Retiming delay after adder tree (also filter_out register)
    DelayNUnit #(1, 1) ERR_VLD_PIP(clk, reset, log_error_valid, log_error_valid_d);              // Retiming delay after adder tree (also filter_out register)

    wire signed [LOG_WIDTH-1:0] log_error_2d;
    wire                        log_error_sign_2d, log_error_valid_2d;

    DelayNUnit #(LOG_WIDTH, 3) ERR_PIP2(clk, reset, log_error_d, log_error_2d);              // Retiming delay after adder tree (also filter_out register)
    DelayNUnit #(1, 3) ERR_SGN_PIP2(clk, reset, log_error_sign_d, log_error_sign_2d);              // Retiming delay after adder tree (also filter_out register)
    DelayNUnit #(1, 3) ERR_VLD_PIP2(clk, reset, log_error_valid_d, log_error_valid_2d);              // Retiming delay after adder tree (also filter_out register)

    // EXTRA_DEL for debug: Delay linear update by EXTRA_DEL so that both lin and nonlinear w updates are delayed by same delay as done in MATLAB 
    localparam EXTRA_DEL = 0;

    genvar w;
    generate            
        for ( w = 0; w < L_ORD; w = w+1 ) 
        begin: weights_l
            log_w_update_d #(.WIDTH(WIDTH), .QP(QP), .LOG_WIDTH(LOG_WIDTH), .EXTRA_DEL(EXTRA_DEL)) LOG_WUB( clk, reset, log_error_d, log_error_sign_d, log_error_valid_d, lin_filter_in[w+W_PIP], lin_filter_in_sign[w+W_PIP], lin_filter_in_valid[w+W_PIP], log_weight[w], log_weight_sign[w], log_weight_valid[w]); 
        end
    endgenerate

    // Weight for constant input
    log_w_update_d #(.WIDTH(WIDTH), .QP(QP), .LOG_WIDTH(LOG_WIDTH), .EXTRA_DEL(EXTRA_DEL)) LOG_WUB_CONST( clk, reset, log_error_d, log_error_sign_d, log_error_valid_d, 17'b0, 1'b0, 1'b1, log_weight_const, log_weight_const_sign, log_weight_const_valid); 

    // Nonlinear (a) weight update

    // DelayNUnit #(L_ORD*LOG_WIDTH, 1+LIN_PIP_FIR-DOTP_PIP) WEIGHT_VMM_PIP(clk, reset, log_weight_packed, log_weight_packed_vmm);
    // DelayNUnit #(L_ORD, 1+LIN_PIP_FIR-DOTP_PIP) SGN_WEIGHT_VMM_PIP(clk, reset, log_weight_sign, log_weight_vmm_sign);
    // DelayNUnit #(L_ORD, 1+LIN_PIP_FIR-DOTP_PIP) VLD_WEIGHT_VMM_PIP(clk, reset, log_weight_valid, log_weight_vmm_valid);

    log_in_dot_product_d #(WIDTH, QP, L_ORD, LOG_WIDTH) LOG_WEIGHT0_PIP(clk, reset, nonl_filter_in_packed[0][(L_ORD+A_PIP-2)*LOG_WIDTH-1:(A_PIP-2)*LOG_WIDTH],  nonl_filter_in_sign_packed[0][L_ORD+A_PIP-3:A_PIP-2],  nonl_filter_in_valid_packed[0][L_ORD+A_PIP-3:A_PIP-2], log_weight_packed, log_weight_sign, log_weight_valid, weight_pip_prod[0]);
    DelayNUnit #(WIDTH, 1) VMM_OUT_PIP(clk, reset, weight_pip_prod[0], weight_pip_prod_d[0]);
    log_combined_16 #(WIDTH, QP, LOG_WIDTH) LOG_WEIGHT0_PROD( .data(weight_pip_prod_d[0]), .log_data(log_weight_pip_prod[0]), .log_data_sign(log_weight_pip_prod_sign[0]), .log_data_valid(log_weight_pip_prod_valid[0]));
    log_w_update_d #(.WIDTH(WIDTH), .QP(QP), .LOG_WIDTH(LOG_WIDTH), .RESET_VAL(16'h0001)) A0_LOG_WUB( clk, reset, log_error_d, log_error_sign_d, log_error_valid_d, log_weight_pip_prod[0], log_weight_pip_prod_sign[0], log_weight_pip_prod_valid[0], a_log_weight[0], a_log_weight_sign[0], a_log_weight_valid[0]); 

    genvar a;
    generate            
        for ( a = 1; a < Q_ORD; a = a+1 ) 
        begin: weights_nonl
            log_in_dot_product_d #(WIDTH, QP, L_ORD, LOG_WIDTH) LOG_WEIGHT_PIP(clk, reset, nonl_filter_in_packed[a][(L_ORD+A_PIP-2)*LOG_WIDTH-1:(A_PIP-2)*LOG_WIDTH],  nonl_filter_in_sign_packed[a][L_ORD+A_PIP-3:A_PIP-2],  nonl_filter_in_valid_packed[a][L_ORD+A_PIP-3:A_PIP-2], log_weight_packed, log_weight_sign, log_weight_valid, weight_pip_prod[a]);
            DelayNUnit #(WIDTH, 1) VMM_OUT_PIP(clk, reset, weight_pip_prod[a], weight_pip_prod_d[a]);
            log_combined_16 #(WIDTH, QP, LOG_WIDTH) LOG_WEIGHT_PROD( .data(weight_pip_prod_d[a]), .log_data(log_weight_pip_prod[a]), .log_data_sign(log_weight_pip_prod_sign[a]), .log_data_valid(log_weight_pip_prod_valid[a]));
            log_w_update_d #(.WIDTH(WIDTH), .QP(QP), .LOG_WIDTH(LOG_WIDTH)) A_LOG_WUB( clk, reset, log_error_d, log_error_sign_d, log_error_valid_d, log_weight_pip_prod[a], log_weight_pip_prod_sign[a], log_weight_pip_prod_valid[a], a_log_weight[a], a_log_weight_sign[a], a_log_weight_valid[a]); 

        end
    endgenerate

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
    // Unpack nonl_filter_in pipeline
    genvar ind_l, ind_q;
    generate
        for ( ind_q = 0; ind_q < Q_ORD; ind_q=ind_q+1 )
        begin:filter_pack
            for ( ind_l = 0; ind_l < L_ORD+A_PIP-2; ind_l=ind_l+1 ) 
            begin:nonl_filter_inner
                assign nonl_filter_in[ind_q][ind_l+1] = nonl_filter_in_packed[ind_q][LOG_WIDTH*ind_l+:LOG_WIDTH];
                assign nonl_filter_in_sign[ind_q][ind_l+1] = nonl_filter_in_sign_packed[ind_q][ind_l];
                assign nonl_filter_in_valid[ind_q][ind_l+1] = nonl_filter_in_valid_packed[ind_q][ind_l];
            end
        end
    endgenerate

    genvar ind;
    generate
        for ( ind = 0; ind < L_ORD; ind=ind+1 )
        begin:weight_pack
            assign log_weight_packed[LOG_WIDTH*ind+:LOG_WIDTH] = log_weight[ind];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:a_weight_pack
            assign a_log_weight_packed[LOG_WIDTH*ind+:LOG_WIDTH] = a_log_weight[ind];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:nonl_out_unpack
            assign nonl_x_out[ind] = nonl_x_out_packed[LOG_WIDTH*ind+:LOG_WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:nonl_out_d_pack
            assign nonl_x_out_d_packed[LOG_WIDTH*ind+:LOG_WIDTH] = nonl_x_out_d[ind];
        end
    endgenerate

    // generate
    //     for ( ind = 0; ind < Q_ORD; ind=ind+1 )
    //     begin:a_out_pack
    //         assign a_out_packed[WIDTH*ind+:WIDTH] = a_out[ind];
    //     end
    // endgenerate

    // generate
    //     for ( ind = 0; ind < L_ORD; ind=ind+1 )
    //     begin:tap_out_pack
    //         assign tap_out_packed[WIDTH*ind+:WIDTH] = tap_out[ind];
    //     end
    // endgenerate

    generate
        for ( ind = 0; ind < L_ORD+W_PIP-1; ind=ind+1 )
        begin:lin_pack
            assign lin_filter_in[ind+1] = lin_filter_in_packed[LOG_WIDTH*ind+:LOG_WIDTH];
            assign lin_filter_in_sign[ind+1] = lin_filter_in_sign_packed[ind];
            assign lin_filter_in_valid[ind+1] = lin_filter_in_valid_packed[ind];
        end
    endgenerate

endmodule