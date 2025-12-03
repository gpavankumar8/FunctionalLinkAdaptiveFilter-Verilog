`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 26-08-2022
// Module name: nonl_PhiMap.v
//////////////////////////////////////////////////////////////////////////////////

module nonl_PhiMap
#( parameter Q_ORD = 7, WIDTH = 16, QP = 12)
( 
    input signed [WIDTH-1:0] x_in,
    output signed [Q_ORD*WIDTH-1:0] nonl_x_out_packed    // QP = 15
);

    //wire  [15:0] pi = 16'h3244;    //pi  (int_part= 4bits, frac_part=12bits)
    //wire  [15:0] pim2 = 16'h6487;  //2pi
    localparam signed PI = 17'h3244;    // pi  (int_part= 4bits, frac_part=12bits)
    localparam signed TWOPI = 17'h6487;  // 2pi
    localparam signed THRPI = 17'h96CC;    // 3pi

    wire signed [WIDTH-1:0] nonl_x_out[Q_ORD-1:0];      // QP = 15
    wire signed [2*WIDTH:0] theta_full[(Q_ORD-1)/2-1:0], theta_rnd[(Q_ORD-1)/2-1:0];
    wire signed [2*WIDTH:0] pi_x_in[(Q_ORD-1)/2-1:0];
    wire signed [WIDTH:0] theta_in[(Q_ORD-1)/2-1:0];

    // Manual angle calculation (No genvar)
    assign pi_x_in[0] = PI*x_in;
    assign pi_x_in[1] = TWOPI*x_in;
    assign pi_x_in[2] = THRPI*x_in;

    assign nonl_x_out[0] = x_in <<< 3;

    genvar i;
    generate
        for (i = 0; i < (Q_ORD-1)/2; i = i+1) 
        begin:theta_calc

            assign theta_full[i] = pi_x_in[i];
            assign theta_rnd[i] = theta_full[i] + (1'b1 << (QP-1));
            assign theta_in[i] = theta_rnd[i][QP+:WIDTH+1];

        end
    endgenerate

    generate
        for (i = 0; i < (Q_ORD-1)/2; i = i+1) 
        begin:cos_ang
            cos_taylor_approx cos_fn( .theta(theta_in[i]), .cos_theta(nonl_x_out[2*(i+1)]));
        end
    endgenerate

    generate
        for (i = 0; i < (Q_ORD-1)/2; i = i+1) 
        begin:sin_ang
            sin_taylor_approx sin_fn( .theta(theta_in[i]), .sin_theta(nonl_x_out[2*i+1]));
        end
    endgenerate

    genvar ind;
    generate
        for ( ind = 0; ind < Q_ORD; ind=ind+1 )
        begin:out_pack
            assign nonl_x_out_packed[WIDTH*ind+:WIDTH] = (nonl_x_out[ind] >>> 3);
        end
    endgenerate

endmodule