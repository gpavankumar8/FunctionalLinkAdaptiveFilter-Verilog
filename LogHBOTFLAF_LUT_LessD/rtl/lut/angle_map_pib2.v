`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////////////////
// Author:      Pavan Kumar
// Create Date: 03-07-2024
// Module name: angle_map_pib2.v
// Description: Map the input sample x_in to x_map in [0,0.5] and further calculate pi*x_map
/////////////////////////////////////////////////////////////////////////////////////////////

module angle_map_pib2
#(parameter LUT_WIDTH = 5, TRUNC_WIDTH = 8)
(
    input signed [TRUNC_WIDTH-1:0] x_in,
    output reg   [LUT_WIDTH-1:0]   x_map,
    output reg                     sign_cos,
    output reg                     sign_sin
);

    localparam LUT_QP = LUT_WIDTH - 1;

    wire sign_sin_in;
    wire gr_0_5, gr_1, gr_1_5, gr_2;

    wire [TRUNC_WIDTH-2:0] x_abs, x_map_lvl1;

    // localparam PI_Q2_5 = 7'b11_00101;
    // wire [(2*LUT_QP+2)-1:0] pi_x_map_full, pi_x_map_rnd;

    localparam TWO_Q3_1  = 4'b010_0;     // 1
    localparam ONE_Q3_1  = 4'b001_0;     // 2
    localparam ZR_5_Q3_1 = 4'b000_1;     // 0.5
    localparam ON_5_Q3_1 = 4'b001_1;     // 1.5

    // Taking abs
    assign sign_sin_in = x_in[TRUNC_WIDTH-1];
    assign x_abs       = sign_sin_in ? -x_in: x_in;

    // greater than 2pi mapping
    assign gr_2   = x_abs > (TWO_Q3_1 <<< (LUT_WIDTH-1));
    assign x_map_lvl1 = gr_2 ? x_abs - (TWO_Q3_1 <<< (LUT_WIDTH-1)) : x_abs;

    // Comparators
    assign gr_0_5 = x_map_lvl1 > (ZR_5_Q3_1 <<< (LUT_WIDTH-1));
    assign gr_1   = x_map_lvl1 > (ONE_Q3_1 <<< (LUT_WIDTH-1));
    assign gr_1_5 = x_map_lvl1 > (ON_5_Q3_1 <<< (LUT_WIDTH-1));

    // Mapping mux

    always @(*)
    begin
        case ({gr_1_5, gr_1, gr_0_5})
            3'b111: begin    // Quadrant 4
                x_map    = (TWO_Q3_1 <<< (LUT_WIDTH-1)) - x_map_lvl1;
                sign_sin = ~sign_sin_in;
                sign_cos = 1'b0;    
            end

            3'b011: begin    // Quadrant 3
                x_map    = x_map_lvl1 - (ONE_Q3_1 <<< (LUT_WIDTH-1));
                sign_sin = ~sign_sin_in;
                sign_cos = 1'b1;
            end

            3'b001: begin    // Quadrant 2
                x_map    = (ONE_Q3_1 <<< (LUT_WIDTH-1)) - x_map_lvl1;
                sign_sin = sign_sin_in;
                sign_cos = 1'b1;
            end

            3'b000: begin    // Quadrant 1
                x_map    = x_map_lvl1;
                sign_sin = sign_sin_in;
                sign_cos = 1'b0;
            end

            default: begin 
                x_map    = 16'bx;
                sign_sin = 1'bx;
                sign_cos = 1'bx;
            end
        endcase
    end

    // theta_map generation (theta_map = PI*x_map)

    // assign pi_x_map_full = x_map * PI_Q2_5;
    // assign pi_x_map_rnd  = pi_x_map_full + (16'b1 << (LUT_QP-1));
    // assign theta_map     = pi_x_map_rnd[(LUT_QP)+:LUT_WIDTH];

endmodule