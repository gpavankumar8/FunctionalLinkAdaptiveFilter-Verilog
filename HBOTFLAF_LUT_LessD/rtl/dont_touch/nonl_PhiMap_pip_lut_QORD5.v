`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 10-07-2024
// Module name: nonl_PhiMap_pip_lut.v
//////////////////////////////////////////////////////////////////////////////////

module nonl_PhiMap_pip_lut
#( parameter Q_ORD = 7, WIDTH = 16, QP = 12, LUT_WIDTH = 7)
( 
    // input clk,
    // input reset,
    input signed [WIDTH-1:0] x_in,
    output signed [Q_ORD*WIDTH-1:0] nonl_x_out_packed    // QP = 15
);

    localparam TRUNC_WIDTH = LUT_WIDTH + 3;     // Pre mapping LUT_WIDTH

    wire signed [WIDTH-1:0] x_in_d, x_trunc_rnd;
    wire signed [TRUNC_WIDTH-1:0] x_trunc, x_trunc2, x_trunc3, x_trunc4, x_trunc5, x_trunc6, x_trunc7;
    wire signed [WIDTH-1:0] nonl_x_out[Q_ORD-1:0];      // QP = 15
    wire signed [2*WIDTH:0] theta_full[(Q_ORD-1)/2-1:0], theta_rnd[(Q_ORD-1)/2-1:0];
    wire signed [2*WIDTH:0] pi_x_in[3:0];
    wire signed [WIDTH:0] theta_in[(Q_ORD-1)/2-1:0], theta_in_d[(Q_ORD-1)/2-1:0];
    wire [LUT_WIDTH-1:0] x_map1, x_map_d, x_map2, x_map3, x_map4, x_map5, x_map6, x_map7;
    wire sign_sin1, sign_sin2, sign_sin3, sign_sin4, sign_sin5, sign_sin6, sign_sin7, sign_cos1, sign_cos2, sign_cos3, sign_cos4, sign_cos5, sign_cos6, sign_cos7;
    wire [Q_ORD*WIDTH-1:0] nonl_x_out_packed_out;

    assign nonl_x_out_packed[WIDTH-1:0] = x_in;     // Assigning Phi[0] as x_in_d itself

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

    // angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
    //                  .TRUNC_WIDTH(TRUNC_WIDTH)) 
    //              AM3(.x_in(x_trunc3),
    //                  .x_map(x_map3),
    //                  .sign_cos(sign_cos3),
    //                  .sign_sin(sign_sin3));

    // angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
    //                 .TRUNC_WIDTH(TRUNC_WIDTH)) 
    //             AM4(.x_in(x_trunc4),
    //                 .x_map(x_map4),
    //                 .sign_cos(sign_cos4),
    //                 .sign_sin(sign_sin4));

    // angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
    //                 .TRUNC_WIDTH(TRUNC_WIDTH)) 
    //             AM5(.x_in(x_trunc5),
    //                 .x_map(x_map5),
    //                 .sign_cos(sign_cos5),
    //                 .sign_sin(sign_sin5));

    // angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
    //                 .TRUNC_WIDTH(TRUNC_WIDTH)) 
    //             AM6(.x_in(x_trunc6),
    //                 .x_map(x_map6),
    //                 .sign_cos(sign_cos6),
    //                 .sign_sin(sign_sin6));

    // angle_map_pib2 #(.LUT_WIDTH(LUT_WIDTH),
    //                 .TRUNC_WIDTH(TRUNC_WIDTH)) 
    //             AM7(.x_in(x_trunc7),
    //                 .x_map(x_map7),
    //                 .sign_cos(sign_cos7),
    //                 .sign_sin(sign_sin7));

    wire [WIDTH-1:0] sin1_usgn, sin2_usgn, sin3_usgn, sin4_usgn, sin5_usgn, sin6_usgn, sin7_usgn, cos1_usgn, cos2_usgn, cos3_usgn, cos4_usgn, cos5_usgn, cos6_usgn, cos7_usgn;
    
    // sin_cos_LUT_5QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));
    // sin_cos_LUT_6QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));
    // sin_cos_LUT_7QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));
    // sin_cos_LUT_8QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));
    // sin_cos_LUT_9QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));
    // sin_cos_LUT_10QP SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn));

    // sin_cos_LUT_7QP_QORD3 SC_LUT(.x_in1(x_map1), .sin1(sin1_usgn), .cos1(cos1_usgn));
    sin_cos_LUT_7QP_QORD5 SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn));
    // sin_cos_LUT_7QP_QORD9 SC_LUT(.x_in1(x_map1), .x_in2(x_map2), .x_in3(x_map3), .x_in4(x_map4),.sin1(sin1_usgn), .cos1(cos1_usgn), .sin2(sin2_usgn), .cos2(cos2_usgn), .sin3(sin3_usgn), .cos3(cos3_usgn), .sin4(sin4_usgn), .cos4(cos4_usgn));

    assign nonl_x_out[1] = sign_sin1 ? -(sin1_usgn >> 1): (sin1_usgn >> 1);
    assign nonl_x_out[2] = sign_cos1 ? -(cos1_usgn >> 1): (cos1_usgn >> 1);
    assign nonl_x_out[3] = sign_sin2 ? -(sin2_usgn >> 1): (sin2_usgn >> 1);
    assign nonl_x_out[4] = sign_cos2 ? -(cos2_usgn >> 1): (cos2_usgn >> 1);
    // assign nonl_x_out[5] = sign_sin3 ? -(sin3_usgn >> 1): (sin3_usgn >> 1);
    // assign nonl_x_out[6] = sign_cos3 ? -(cos3_usgn >> 1): (cos3_usgn >> 1);
    // assign nonl_x_out[7] = sign_sin4 ? -(sin4_usgn >> 1): (sin4_usgn >> 1);
    // assign nonl_x_out[8] = sign_cos4 ? -(cos4_usgn >> 1): (cos4_usgn >> 1);

    // DelayNUnit #(Q_ORD*WIDTH, 1) OUT_PIP(clk, reset, nonl_x_out_packed_out, nonl_x_out_packed); 

    genvar ind;
    generate
        for ( ind = 1; ind < Q_ORD; ind=ind+1 )
        begin:out_pack
            assign nonl_x_out_packed[WIDTH*ind+:WIDTH] = (nonl_x_out[ind]);
        end
    endgenerate

endmodule