`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 26-08-2022
// Module name: tflaf_top.v
//////////////////////////////////////////////////////////////////////////////////

module tflaf_top
#(parameter L_ORD = 4, Q_ORD = 7, WIDTH = 16, QP = 12)
(
    input clk,
    input reset, 
    input [WIDTH-1:0] signal_in,
    input [WIDTH-1:0] desired_in,
    output [WIDTH-1:0] filter_out_d,
    output reg [WIDTH-1:0] error_d
);

    localparam WRET = 1, NON_PIP = 1, E_PIP = 1;
    localparam LIN_PIP = 2 + (($clog2(L_ORD*Q_ORD+1)-1)/4);
    localparam RET = NON_PIP + LIN_PIP + WRET + E_PIP;
    localparam W_PIP = LIN_PIP + E_PIP;
    localparam LIN_ADD_LEN = 2**$clog2(L_ORD*Q_ORD+1);
    localparam LIN_ADD_ZERO_PAD = LIN_ADD_LEN - L_ORD*Q_ORD - 1;

    reg signed [WIDTH-1:0] signal_in_d, desired_in_d;
    wire signed [WIDTH-1:0] filter_in[Q_ORD-1:0][L_ORD+W_PIP-1:0], weight[Q_ORD-1:0][L_ORD-1:0], mu_error, mu_error_d, error_rnd, adder_out, adder_out_d[Q_ORD-1:0];
    wire signed [WIDTH-1:0] adder_tree_out, adder_tree_out_rnd;
    wire signed [WIDTH-1:0] error, filter_out, desired_in_ret_d;

    wire signed [L_ORD*WIDTH-1:0] tap_out_packed[Q_ORD-1:0], tap_out_packed_d[Q_ORD-1:0], weight_packed[Q_ORD-1:0];
    wire signed [L_ORD*Q_ORD*WIDTH-1:0] tap_out_packed_adder;
    wire signed [(L_ORD+W_PIP-1)*WIDTH-1:0] filter_in_packed[Q_ORD-1:0];

    wire signed [Q_ORD*WIDTH-1:0] nonl_x_out_packed;
    wire signed [WIDTH-1:0] nonl_x_out[Q_ORD-1:0], nonl_x_out_d[Q_ORD-1:0];

    wire signed [WIDTH-1:0] weight_const, tap_out_const, tap_out_const_d;

    // Nonlinear Phi mapping
    // nonl_PhiMap_pip #(Q_ORD, WIDTH, QP) Phi( .clk(clk), .reset(reset), .x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed));
    nonl_PhiMap_pip_lut #(Q_ORD, WIDTH, QP) Phi( .x_in(signal_in_d), .nonl_x_out_packed(nonl_x_out_packed));

    // Filter pipeline
    genvar f;
    generate
        for (f = 0; f < Q_ORD; f = f+1)
        begin:pipe
            //assign filter_in[f][0] = nonl_x_out[f];
            DelayNUnit #(WIDTH, 1) NONL_PIP(clk, reset, nonl_x_out[f], nonl_x_out_d[f]);      // Retiming delay after Phi
            assign filter_in[f][0] = nonl_x_out_d[f];
            pipeline #(WIDTH, (L_ORD+W_PIP-1)) PIP(clk, reset, filter_in[f][0], filter_in_packed[f]);
        end
    endgenerate

    // FIR filter taps
    fir_taps #(WIDTH, QP, L_ORD) FIR_0({filter_in_packed[0][(L_ORD-1)*WIDTH-1:0], filter_in[0][0]}, weight_packed[0], tap_out_packed[0]); 
    DelayNUnit #(L_ORD*WIDTH, 1) MULT_PIP_0(clk, reset, tap_out_packed[0], tap_out_packed_d[0]);      // Retiming delay after multipliers
    
    genvar i;
    generate
        for (i = 1; i < Q_ORD ; i = i+1) 
        begin: filters
            fir_taps #(WIDTH, QP, L_ORD,2) FIR({filter_in_packed[i][(L_ORD-1)*WIDTH-1:0], filter_in[i][0]}, weight_packed[i], tap_out_packed[i]); 
            DelayNUnit #(L_ORD*WIDTH, 1) MULT_PIP(clk, reset, tap_out_packed[i], tap_out_packed_d[i]);      // Retiming delay after multipliers
        end
    endgenerate

    fir_taps #(WIDTH, QP, 1) FIR_CONST((1'b1 << QP), weight_const, tap_out_const);
    DelayNUnit #(WIDTH, 1) MULT_PIP_CONST(clk, reset, tap_out_const, tap_out_const_d);      // Retiming delay after multipliers

    // Taps to adder tree
/*
    generate
        for (i = 0; i < Q_ORD ; i = i+1) 
        begin: adder_trees
            // adder_tree #(WIDTH, L_ORD) ADD1(.adder_tree_in_packed(tap_out_packed_d[i]), .adder_tree_out(adder_out[i])); 
            adder_tree #(WIDTH, L_ORD) ADD1(.clk(clk), .reset(reset), .adder_tree_in_packed(tap_out_packed_d[i]), .adder_tree_out(adder_out[i])); 
            DelayNUnit #(WIDTH, 1) ADDER_PIP(clk, reset, adder_out[i], adder_out_d[i]);      // Retiming delay after adders
        end
    endgenerate

    // Pipeline between adder tree for order > 64
    // wire [WIDTH-1:0] adder_int1, adder_int2;

    // generate
    //     for (i = 0; i < Q_ORD ; i = i+1) 
    //     begin: adder_trees
    //         adder_tree #(WIDTH, L_ORD/2) ADD1(.adder_tree_in_packed(tap_out_packed_d[i]), .adder_tree_out(adder_int1[i])); 
    //         adder_tree #(WIDTH, L_ORD/2) ADD1(.adder_tree_in_packed(tap_out_packed_d[i]), .adder_tree_out(adder_int1[i])); 
    //         DelayNUnit #(WIDTH, 1) ADDER_PIP(clk, reset, adder_out[i], adder_out_d[i]);      // Retiming delay after adders
    //     end
    // endgenerate

    // Manual adder out addition
    wire [WIDTH-1:0] adder_stg0_tmp0, adder_stg0_tmp1, adder_stg0_tmp2;
    wire [WIDTH-1:0] adder_stg1_tmp0, adder_stg1_tmp1, adder_stg1_tmp2;
    wire [WIDTH-1:0] adder_stg2_tmp0, adder_stg2_tmp1;

    // assign adder_stg0_tmp0 = adder_out[0] + adder_out[1];
    // assign adder_stg0_tmp1 = adder_out[2] + adder_out[3];
    // assign adder_stg0_tmp2 = adder_out[4] + adder_out[5];
    // assign adder_stg1_tmp0 = adder_stg0_tmp0 + adder_stg0_tmp1;
    // assign adder_stg1_tmp1 = adder_stg0_tmp2 + adder_out[6];
    // assign adder_stg2_tmp0 = adder_stg1_tmp0 + adder_stg1_tmp1;
    // assign adder_stg2_tmp1 = adder_stg2_tmp0 + tap_out_const_d;

    assign adder_stg0_tmp0 = adder_out_d[0] + adder_out_d[1];
    assign adder_stg0_tmp1 = adder_out_d[2] + adder_out_d[3];
    assign adder_stg0_tmp2 = adder_out_d[4] + adder_out_d[5];
    assign adder_stg1_tmp0 = adder_stg0_tmp0 + adder_stg0_tmp1;
    assign adder_stg1_tmp1 = adder_stg0_tmp2 + adder_out_d[6];
    assign adder_stg2_tmp0 = adder_stg1_tmp0 + adder_stg1_tmp1;
    assign adder_stg2_tmp1 = adder_stg2_tmp0 + tap_out_const_d;

    // assign filter_out = adder_stg2_tmp0;
    assign filter_out = adder_stg2_tmp1;
*/
    // Using automated pipelining adder tree
    adder_tree #(WIDTH, LIN_ADD_LEN) ADD1(.clk(clk), .reset(reset), .adder_tree_in_packed({tap_out_packed_adder,tap_out_const_d,{(LIN_ADD_ZERO_PAD*WIDTH){1'b0}}}), .adder_tree_out(adder_out)); 
    assign filter_out = adder_out;
    DelayNUnit #(WIDTH, 1) FILT_OUT_PIP(clk, reset, filter_out, filter_out_d);              // Retiming delay after adder tree (also filter_out register)

    // Compute error
    error_compute #(WIDTH) EC( .desired_in(desired_in_ret_d), .filter_out(filter_out_d), .error(error));

    // Weight update
    assign error_rnd = error + (1<<(7-1));
    assign mu_error = error_rnd >>> 7;       // Multiply by mu = 0.0078125 (1/(2^7));
    // assign mu_error = error;

    DelayNUnit #(WIDTH, 1) ERR_PIP(clk, reset, mu_error, mu_error_d);              // Retiming delay after adder tree (also filter_out register)

    genvar w_q, w_l;

    generate
    for ( w_l = 0; w_l < L_ORD; w_l = w_l+1 ) 
    begin: weights_l_0
        w_update_d #(WIDTH, QP, 0) WUB_0( clk, reset, mu_error_d, filter_in[0][w_l+W_PIP], weight[0][w_l]); 
    end
    endgenerate

    generate
        for( w_q = 1; w_q < Q_ORD; w_q = w_q+1 )
        begin: weights_q
            
            for ( w_l = 0; w_l < L_ORD; w_l = w_l+1 ) 
            begin: weights_l
                w_update_d #(WIDTH, QP, 2) WUB( clk, reset, mu_error_d, filter_in[w_q][w_l+W_PIP], weight[w_q][w_l]); 
            end
        end
    endgenerate

    // Weight for constant input
    w_update_d #(WIDTH, QP) WUB_CONST( clk, reset, mu_error_d, (1'b1 << QP), weight_const); 

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
                assign filter_in[ind_q][ind_l+1] = filter_in_packed[ind_q][WIDTH*ind_l+:WIDTH];
            end
        end
    endgenerate

    generate
        for ( ind_q = 0; ind_q < Q_ORD; ind_q=ind_q+1 )
        begin:weight_pack
            for ( ind_l = 0; ind_l < L_ORD; ind_l=ind_l+1 ) 
            begin:weight_inner
                assign weight_packed[ind_q][WIDTH*ind_l+:WIDTH] = weight[ind_q][ind_l];
            end
        end
    endgenerate

    genvar ind;
    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:nonl_x_pack
            assign nonl_x_out[ind] = nonl_x_out_packed[WIDTH*ind+:WIDTH];
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
