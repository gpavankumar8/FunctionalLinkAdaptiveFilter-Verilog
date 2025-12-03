`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 10-07-2024
// Module name: nonl_PhiMap_pip.v
//////////////////////////////////////////////////////////////////////////////////

module nonl_PhiMap_pip
#( parameter Q_ORD = 7, WIDTH = 16, QP = 12)
( 
    input clk,
    input reset,
    input signed [WIDTH-1:0] x_in,
    output signed [Q_ORD*WIDTH-1:0] nonl_x_out_packed    // QP = 15
);

    //wire  [15:0] pi = 16'h3244;    //pi  (int_part= 4bits, frac_part=12bits)
    //wire  [15:0] pim2 = 16'h6487;  //2pi
    localparam signed PI = 17'h3244;    // pi  (int_part= 4bits, frac_part=12bits)
    localparam signed TWOPI = 17'h6487;  // 2pi
    localparam signed THRPI = 17'h96CC;    // 3pi
    localparam signed FOURPI = 17'hC90F;    // 3pi

    wire signed [WIDTH-1:0] x_in_d;
    wire signed [WIDTH-1:0] nonl_x_out[Q_ORD-1:0];      // QP = 15
    wire signed [2*WIDTH:0] theta_full[(Q_ORD-1)/2-1:0], theta_rnd[(Q_ORD-1)/2-1:0];
    wire signed [2*WIDTH:0] pi_x_in[3:0];
    wire signed [WIDTH:0] theta_in[(Q_ORD-1)/2-1:0], theta_in_d[(Q_ORD-1)/2-1:0];

    // Manual angle calculation (No genvar)
    assign pi_x_in[0] = PI*x_in;
    assign pi_x_in[1] = TWOPI*x_in;
    assign pi_x_in[2] = THRPI*x_in;
    assign pi_x_in[3] = FOURPI*x_in;

    DelayNUnit #(WIDTH, 3) ANG_PIP(clk, reset, x_in, x_in_d);      // Retiming delay for x_in -> nonl_x_out[0]
    // assign nonl_x_out_packed[WIDTH-1:0] = x_in_d;     // Assigning Phi[0] as x_in_d itself
    assign nonl_x_out_packed[WIDTH-1:0] = x_in_d;     // Assigning Phi[0] as x_in_d itself

    genvar i;
    generate
        for (i = 0; i < (Q_ORD-1)/2; i = i+1) 
        begin:theta_calc

            assign theta_full[i] = pi_x_in[i];
            assign theta_rnd[i] = theta_full[i] + (1'b1 << (QP-1));
            assign theta_in[i] = theta_rnd[i][QP+:WIDTH+1];

            DelayNUnit #(WIDTH+1, 1) ANG_PIP(clk, reset, theta_in[i], theta_in_d[i]);      // Retiming delay after multipliers

        end
    endgenerate

    generate
        for (i = 0; i < (Q_ORD-1)/2; i = i+1) 
        begin:cos_ang
            cos_taylor_approx_pip cos_fn( .clk(clk), .reset(reset), .theta(theta_in_d[i]), .cos_theta(nonl_x_out[2*(i+1)]));
            // cos_taylor_approx cos_fn(.theta(theta_in_d[i]), .cos_theta(nonl_x_out[2*(i+1)]));
        end
    endgenerate

    generate
        for (i = 0; i < (Q_ORD-1)/2; i = i+1) 
        begin:sin_ang
            sin_taylor_approx_pip sin_fn( .clk(clk), .reset(reset), .theta(theta_in_d[i]), .sin_theta(nonl_x_out[2*i+1]));
            // sin_taylor_approx sin_fn( .theta(theta_in_d[i]), .sin_theta(nonl_x_out[2*i+1]));
        end
    endgenerate

    genvar ind;
    generate
        for ( ind = 1; ind < Q_ORD; ind=ind+1 )
        begin:out_pack
            assign nonl_x_out_packed[WIDTH*ind+:WIDTH] = (nonl_x_out[ind]);
        end
    endgenerate

endmodule