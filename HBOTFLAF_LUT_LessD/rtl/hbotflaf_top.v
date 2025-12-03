`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 02-09-2022
// Module name: hbotflaf_top.v
//////////////////////////////////////////////////////////////////////////////////

module hbotflaf_top
#(parameter L_ORD = 32, Q_ORD = 7, WIDTH = 16, QP = 12)
(
    input clk,
    input reset, 
    input [WIDTH-1:0] signal_in,
    input [WIDTH-1:0] desired_in,
    output [WIDTH-1:0] filter_out_d,
    output reg [WIDTH-1:0] error_d
);

    localparam WRET = 0, NON_PIP = 1, E_PIP = 1;
    localparam LIN_PIP_FIR = 2 + (($clog2(L_ORD+1)-1)/4);
    localparam NON_PIP_FIR = 2 + (($clog2(Q_ORD)-1)/4);
    localparam DOTP_PIP = 2 + (($clog2(L_ORD)-1)/4);
    localparam RET = NON_PIP + NON_PIP_FIR + LIN_PIP_FIR + E_PIP + WRET;
    localparam W_PIP = LIN_PIP_FIR + E_PIP;
    localparam A_PIP = NON_PIP_FIR + LIN_PIP_FIR + E_PIP - DOTP_PIP;
    localparam LIN_ADD_LEN = 2**$clog2(L_ORD+1);
    localparam LIN_ADD_ZERO_PAD = LIN_ADD_LEN - L_ORD - 1;
    localparam NONLIN_ADD_LEN = 2**$clog2(Q_ORD);
    localparam NONLIN_ADD_ZERO_PAD = NONLIN_ADD_LEN - Q_ORD;


    reg signed  [WIDTH-1:0] signal_in_d, desired_in_d;
    wire signed [WIDTH-1:0] lin_filter_in[L_ORD+W_PIP-1:0], weight[L_ORD-1:0], tap_out[L_ORD-1:0];
    wire signed [WIDTH-1:0] mu_w_error, mu_w_error_d, error_w_rnd, mu_a_error, mu_a_error_d, error_a_rnd, adder_out;
    //wire signed [WIDTH-1:0] adder_tree_out, adder_tree_out_rnd;
    wire signed [WIDTH-1:0] error, filter_out, desired_in_ret_d;

    wire signed [L_ORD*WIDTH-1:0]     tap_out_packed, tap_out_packed_d, weight_packed, weight_packed_vmm;
    wire signed [(L_ORD+W_PIP-1)*WIDTH-1:0] lin_filter_in_packed;

    wire signed [Q_ORD*WIDTH-1:0] nonl_x_out_packed, nonl_x_out_d_packed;
    wire signed [WIDTH-1:0]       nonl_x_out[Q_ORD-1:0], nonl_x_out_d[Q_ORD-1:0], a_out[Q_ORD-1:0];

    wire signed [WIDTH-1:0] weight_const, tap_out_const, tap_out_const_d;

    wire signed [(L_ORD+A_PIP-2)*WIDTH-1:0] nonl_filter_in_packed[Q_ORD-1:0];
    wire signed [Q_ORD*WIDTH-1:0] a_out_packed, a_out_packed_d, a_weight_packed;
    wire signed [WIDTH-1:0] nonl_filter_in[Q_ORD-1:0][L_ORD+A_PIP-1:0], s_out, a_weight[Q_ORD-1:0];
    wire signed [WIDTH-1:0] weight_pip_prod[Q_ORD-1:0], weight_pip_prod_d[Q_ORD-1:0];

    // Nonlinear Phi mapping
    // nonl_PhiMap #(Q_ORD, WIDTH, QP) Phi(.x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed));
    // nonl_PhiMap_pip #(Q_ORD, WIDTH, QP) Phi( .clk(clk), .reset(reset), .x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed));
    nonl_PhiMap_pip_lut #(Q_ORD, WIDTH, QP) Phi( .x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed));

    // Filter pipeline
    genvar f;
    generate
        for (f = 0; f < Q_ORD; f = f+1)
        begin:pipe
            // assign nonl_filter_in[f][0] = nonl_x_out[f];
            DelayNUnit #(WIDTH, 1) NONL_OUT_PIP(clk, reset, nonl_x_out[f], nonl_x_out_d[f]);      // Retiming delay after Phi
            assign nonl_filter_in[f][0] = nonl_x_out_d[f];
            pipeline #(WIDTH, (L_ORD+A_PIP-2)) NONL_PIP(clk, reset, nonl_filter_in[f][0], nonl_filter_in_packed[f]);
        end
    endgenerate

    // Non-linearity weights (a)
    // fir_taps #(WIDTH, QP, Q_ORD) NONL_FIR(nonl_x_out_packed, a_weight_packed, a_out_packed); 
    fir_taps #(WIDTH, QP, Q_ORD,3,3) NONL_FIR(nonl_x_out_d_packed, a_weight_packed, a_out_packed); 
    DelayNUnit #(Q_ORD*WIDTH, 1) NONL_MULT_OUT_PIP(clk, reset, a_out_packed, a_out_packed_d);              // Retiming delay after NONL FIR multipliers

    // adder_tree #(WIDTH, Q_ORD+1) NONL_ADD1(.adder_tree_in_packed({a_out_packed,{WIDTH{1'b0}}}), .adder_tree_out(s_out)); 
    adder_tree #(WIDTH, NONLIN_ADD_LEN) NONL_ADD1(.clk(clk), .reset(reset), .adder_tree_in_packed({a_out_packed_d,{(NONLIN_ADD_ZERO_PAD*WIDTH){1'b0}}}), .adder_tree_out(s_out)); 
    // assign lin_filter_in[0] = s_out;
    DelayNUnit #(WIDTH, 1) NONL_FILT_OUT_PIP(clk, reset, s_out, lin_filter_in[0]);              // Retiming delay after NONL adder tree

    // Linear filter
    pipeline #(WIDTH, (L_ORD+W_PIP-1)) S_PIP(clk, reset, lin_filter_in[0], lin_filter_in_packed);
    fir_taps #(WIDTH, QP, L_ORD) LIN_FIR({lin_filter_in_packed[(L_ORD-1)*WIDTH-1:0], lin_filter_in[0]}, weight_packed, tap_out_packed); 
    DelayNUnit #(L_ORD*WIDTH, 1) MULT_PIP(clk, reset, tap_out_packed, tap_out_packed_d);      // Retiming delay after multipliers

    fir_taps #(WIDTH, QP, 1) FIR_CONST((1'b1 << QP), weight_const, tap_out_const);
    DelayNUnit #(WIDTH, 1) MULT_PIP_CONST(clk, reset, tap_out_const, tap_out_const_d);      // Retiming delay after multipliers

    // adder_tree #(WIDTH, L_ORD) LIN_ADD(.adder_tree_in_packed(tap_out_packed), .adder_tree_out(adder_out)); 
    adder_tree #(WIDTH, LIN_ADD_LEN) LIN_ADD(.clk(clk), .reset(reset), .adder_tree_in_packed({tap_out_packed_d,tap_out_const_d,{(LIN_ADD_ZERO_PAD*WIDTH){1'b0}}}), .adder_tree_out(adder_out)); 
    // assign filter_out = adder_out + tap_out_const;
    // assign filter_out = adder_out + tap_out_const_d;
    assign filter_out = adder_out;

    DelayNUnit #(WIDTH, 1) FILT_OUT_PIP(clk, reset, filter_out, filter_out_d);              // Retiming delay after adder tree (also filter_out register)

    // Compute error
    error_compute #(WIDTH) EC( .desired_in(desired_in_ret_d), .filter_out(filter_out_d), .error(error));

    // Linear Weight update
    assign error_w_rnd = error + (1<<(6-1));
    assign mu_w_error = error_w_rnd >>> 6;       // Multiply by mu = 0.0078125 (1/(2^7));

    DelayNUnit #(WIDTH, 1) ERR_PIP_W(clk, reset, mu_w_error, mu_w_error_d);              // Retiming delay after adder tree (also filter_out register)

    assign error_a_rnd = error + (1<<(6-1));
    assign mu_a_error = error_a_rnd >>> 6;       // Multiply by mu = 0.015625 (1/(2^6));

    DelayNUnit #(WIDTH, 1) ERR_PIP_A(clk, reset, mu_a_error, mu_a_error_d);              // Retiming delay after adder tree (also filter_out register)

    genvar w;
    generate            
        for ( w = 0; w < L_ORD; w = w+1 ) 
        begin: weights_l
            w_update_d #(WIDTH, QP) WUB( clk, reset, mu_w_error_d, lin_filter_in[w+W_PIP], weight[w]); 
            // filter_tap #(WIDTH, QP) W_TAP( clk, reset, lin_filter_in[w], mu_w_error_d, lin_filter_in[w+W_PIP], tap_out[w], weight[w]);
            // w_update #(WIDTH, QP) WUB( clk, reset, mu_w_error, lin_filter_in[w+W_PIP], weight[w]); 
        end
    endgenerate

    // Weight for constant input
    w_update_d #(WIDTH, QP) WUB_CONST( clk, reset, mu_w_error_d, (1'b1 << QP), weight_const); 
    // filter_tap #(WIDTH, QP) CONST_TAP( clk, reset, (1'b1 << QP), mu_w_error_d, (1'b1 << QP), tap_out_const, weight_const);
    // w_update #(WIDTH, QP) WUB_CONST( clk, reset, mu_w_error, (1'b1 << QP), weight_const); 

    // Nonlinear (a) weight update

    // DelayNUnit #(L_ORD*WIDTH, LIN_PIP_FIR-DOTP_PIP) WEIGHT_VMM_PIP(clk, reset, weight_packed, weight_packed_vmm);
    // dot_product #(WIDTH, QP, L_ORD) WEIGHT0_PIP({nonl_filter_in_packed[0], nonl_filter_in[0][0]}, weight_packed, weight_pip_prod[0]);
    // dot_product #(WIDTH, QP, L_ORD) WEIGHT0_PIP({nonl_filter_in_packed[0][(L_ORD+A_PIP-1)*WIDTH-1:A_PIP*WIDTH], nonl_filter_in[0][0]}, weight_packed, weight_pip_prod[0]);
    dot_product_d #(WIDTH, QP, L_ORD) WEIGHT0_PIP(clk, reset, nonl_filter_in_packed[0][(L_ORD+A_PIP-2)*WIDTH-1:(A_PIP-2)*WIDTH], weight_packed, weight_pip_prod[0]);
    DelayNUnit #(WIDTH, 1) VMM_OUT_PIP(clk, reset, weight_pip_prod[0], weight_pip_prod_d[0]);

    w_update_d #(WIDTH, QP, 16'h0001) A_WUB0( clk, reset, mu_a_error_d, weight_pip_prod_d[0], a_weight[0]); 
    // filter_tap #(WIDTH, QP, 16'h0001) A_TAP0( clk, reset, nonl_x_out_d[0], mu_a_error_d, weight_pip_prod[0], a_out[0], a_weight[0]); 
    // w_update #(WIDTH, QP, 16'h0001) A_WUB0( clk, reset, mu_a_error, weight_pip_prod[0], a_weight[0]); 

    genvar a;
    generate            
        for ( a = 1; a < Q_ORD; a = a+1 ) 
        begin: weights_nonl
            // dot_product #(WIDTH, QP, L_ORD) WEIGHT_PIP({nonl_filter_in_packed[a], nonl_filter_in[a][0]}, weight_packed, weight_pip_prod[a]);
            // dot_product #(WIDTH, QP, L_ORD) WEIGHT_PIP(nonl_filter_in_packed[a][(L_ORD+A_PIP-1)*WIDTH-1:(A_PIP-1)*WIDTH], weight_packed, weight_pip_prod[a]);
            dot_product_d #(WIDTH, QP, L_ORD,3) WEIGHT_PIP(clk, reset, nonl_filter_in_packed[a][(L_ORD+A_PIP-2)*WIDTH-1:(A_PIP-2)*WIDTH], weight_packed, weight_pip_prod[a]);
            DelayNUnit #(WIDTH, 1) VMM_OUT_PIP(clk, reset, weight_pip_prod[a], weight_pip_prod_d[a]);
            w_update_d #(WIDTH, QP) A_WUB( clk, reset, mu_a_error_d, weight_pip_prod_d[a], a_weight[a]); 
            // filter_tap #(WIDTH, QP) A_TAP( clk, reset, nonl_x_out_d[a], mu_a_error_d, weight_pip_prod[a], a_out[a], a_weight[a]);
            // w_update #(WIDTH, QP) A_WUB( clk, reset, mu_a_error, weight_pip_prod[a], a_weight[a]); 
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
                assign nonl_filter_in[ind_q][ind_l+1] = nonl_filter_in_packed[ind_q][WIDTH*ind_l+:WIDTH];
            end
        end
    endgenerate

    genvar ind;
    generate
        for ( ind = 0; ind < L_ORD; ind=ind+1 )
        begin:weight_pack
            assign weight_packed[WIDTH*ind+:WIDTH] = weight[ind];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:a_weight_pack
            assign a_weight_packed[WIDTH*ind+:WIDTH] = a_weight[ind];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:nonl_out_unpack
            assign nonl_x_out[ind] = nonl_x_out_packed[WIDTH*ind+:WIDTH];
        end
    endgenerate

    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:nonl_out_d_pack
            assign nonl_x_out_d_packed[WIDTH*ind+:WIDTH] = nonl_x_out_d[ind];
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
            assign lin_filter_in[ind+1] = lin_filter_in_packed[WIDTH*ind+:WIDTH];
        end
    endgenerate

endmodule