`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 10-07-2024
// Module name: sin_cos_LUT_5QP.v
//////////////////////////////////////////////////////////////////////////////////

module sin_cos_LUT_5QP
(
    input      [ 4:0] x_in1, x_in2, x_in3,
    output reg [15:0] sin1, sin2, sin3, cos1, cos2, cos3
);

    wire [15:0] mux_in_cos0, mux_in_sin0, mux_in_cos1, mux_in_sin1, mux_in_cos2, mux_in_sin2, mux_in_cos3, mux_in_sin3, mux_in_cos4, mux_in_sin4, mux_in_cos5, mux_in_sin5, mux_in_cos6, mux_in_sin6, mux_in_cos7, mux_in_sin7, mux_in_cos8, mux_in_sin8, mux_in_cos9, mux_in_sin9, mux_in_cos10, mux_in_sin10, mux_in_cos11, mux_in_sin11, mux_in_cos12, mux_in_sin12, mux_in_cos13, mux_in_sin13, mux_in_cos14, mux_in_sin14, mux_in_cos15, mux_in_sin15, mux_in_cos16, mux_in_sin16;

    assign mux_in_cos0 = 16'b1000000000000000;
    assign mux_in_sin0 = 16'b0000000000000000;
    assign mux_in_cos1 = 16'b0111111101100010;
    assign mux_in_sin1 = 16'b0000110010001100;
    assign mux_in_cos2 = 16'b0111110110001010;
    assign mux_in_sin2 = 16'b0001100011111001;
    assign mux_in_cos3 = 16'b0111101001111101;
    assign mux_in_sin3 = 16'b0010010100101000;
    assign mux_in_cos4 = 16'b0111011001000010;
    assign mux_in_sin4 = 16'b0011000011111100;
    assign mux_in_cos5 = 16'b0111000011100011;
    assign mux_in_sin5 = 16'b0011110001010111;
    assign mux_in_cos6 = 16'b0110101001101110;
    assign mux_in_sin6 = 16'b0100011100011101;
    assign mux_in_cos7 = 16'b0110001011110010;
    assign mux_in_sin7 = 16'b0101000100110100;
    assign mux_in_cos8 = 16'b0101101010000010;
    assign mux_in_sin8 = 16'b0101101010000010;
    assign mux_in_cos9 = 16'b0101000100110100;
    assign mux_in_sin9 = 16'b0110001011110010;
    assign mux_in_cos10 = 16'b0100011100011101;
    assign mux_in_sin10 = 16'b0110101001101110;
    assign mux_in_cos11 = 16'b0011110001010111;
    assign mux_in_sin11 = 16'b0111000011100011;
    assign mux_in_cos12 = 16'b0011000011111100;
    assign mux_in_sin12 = 16'b0111011001000010;
    assign mux_in_cos13 = 16'b0010010100101000;
    assign mux_in_sin13 = 16'b0111101001111101;
    assign mux_in_cos14 = 16'b0001100011111001;
    assign mux_in_sin14 = 16'b0111110110001010;
    assign mux_in_cos15 = 16'b0000110010001100;
    assign mux_in_sin15 = 16'b0111111101100010;
    assign mux_in_cos16 = 16'b0000000000000000;
    assign mux_in_sin16 = 16'b1000000000000000;

    // Sine LUTs

    always @ (*)
    begin
        case(x_in1)
        5'b00000 : sin1 = mux_in_sin0;
        5'b00001 : sin1 = mux_in_sin1;
        5'b00010 : sin1 = mux_in_sin2;
        5'b00011 : sin1 = mux_in_sin3;
        5'b00100 : sin1 = mux_in_sin4;
        5'b00101 : sin1 = mux_in_sin5;
        5'b00110 : sin1 = mux_in_sin6;
        5'b00111 : sin1 = mux_in_sin7;
        5'b01000 : sin1 = mux_in_sin8;
        5'b01001 : sin1 = mux_in_sin9;
        5'b01010 : sin1 = mux_in_sin10;
        5'b01011 : sin1 = mux_in_sin11;
        5'b01100 : sin1 = mux_in_sin12;
        5'b01101 : sin1 = mux_in_sin13;
        5'b01110 : sin1 = mux_in_sin14;
        5'b01111 : sin1 = mux_in_sin15;
        5'b10000 : sin1 = mux_in_sin16;
        default: sin1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        5'b00000 : sin2 = mux_in_sin0;
        5'b00001 : sin2 = mux_in_sin1;
        5'b00010 : sin2 = mux_in_sin2;
        5'b00011 : sin2 = mux_in_sin3;
        5'b00100 : sin2 = mux_in_sin4;
        5'b00101 : sin2 = mux_in_sin5;
        5'b00110 : sin2 = mux_in_sin6;
        5'b00111 : sin2 = mux_in_sin7;
        5'b01000 : sin2 = mux_in_sin8;
        5'b01001 : sin2 = mux_in_sin9;
        5'b01010 : sin2 = mux_in_sin10;
        5'b01011 : sin2 = mux_in_sin11;
        5'b01100 : sin2 = mux_in_sin12;
        5'b01101 : sin2 = mux_in_sin13;
        5'b01110 : sin2 = mux_in_sin14;
        5'b01111 : sin2 = mux_in_sin15;
        5'b10000 : sin2 = mux_in_sin16;
        default: sin2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        5'b00000 : sin3 = mux_in_sin0;
        5'b00001 : sin3 = mux_in_sin1;
        5'b00010 : sin3 = mux_in_sin2;
        5'b00011 : sin3 = mux_in_sin3;
        5'b00100 : sin3 = mux_in_sin4;
        5'b00101 : sin3 = mux_in_sin5;
        5'b00110 : sin3 = mux_in_sin6;
        5'b00111 : sin3 = mux_in_sin7;
        5'b01000 : sin3 = mux_in_sin8;
        5'b01001 : sin3 = mux_in_sin9;
        5'b01010 : sin3 = mux_in_sin10;
        5'b01011 : sin3 = mux_in_sin11;
        5'b01100 : sin3 = mux_in_sin12;
        5'b01101 : sin3 = mux_in_sin13;
        5'b01110 : sin3 = mux_in_sin14;
        5'b01111 : sin3 = mux_in_sin15;
        5'b10000 : sin3 = mux_in_sin16;
        default: sin3 = 15'bx;
        endcase
    end

    //Cos LUTs
    always @ (*)
    begin
        case(x_in1)
        5'b00000 : cos1 = mux_in_cos0;
        5'b00001 : cos1 = mux_in_cos1;
        5'b00010 : cos1 = mux_in_cos2;
        5'b00011 : cos1 = mux_in_cos3;
        5'b00100 : cos1 = mux_in_cos4;
        5'b00101 : cos1 = mux_in_cos5;
        5'b00110 : cos1 = mux_in_cos6;
        5'b00111 : cos1 = mux_in_cos7;
        5'b01000 : cos1 = mux_in_cos8;
        5'b01001 : cos1 = mux_in_cos9;
        5'b01010 : cos1 = mux_in_cos10;
        5'b01011 : cos1 = mux_in_cos11;
        5'b01100 : cos1 = mux_in_cos12;
        5'b01101 : cos1 = mux_in_cos13;
        5'b01110 : cos1 = mux_in_cos14;
        5'b01111 : cos1 = mux_in_cos15;
        5'b10000 : cos1 = mux_in_cos16;
        default: cos1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        5'b00000 : cos2 = mux_in_cos0;
        5'b00001 : cos2 = mux_in_cos1;
        5'b00010 : cos2 = mux_in_cos2;
        5'b00011 : cos2 = mux_in_cos3;
        5'b00100 : cos2 = mux_in_cos4;
        5'b00101 : cos2 = mux_in_cos5;
        5'b00110 : cos2 = mux_in_cos6;
        5'b00111 : cos2 = mux_in_cos7;
        5'b01000 : cos2 = mux_in_cos8;
        5'b01001 : cos2 = mux_in_cos9;
        5'b01010 : cos2 = mux_in_cos10;
        5'b01011 : cos2 = mux_in_cos11;
        5'b01100 : cos2 = mux_in_cos12;
        5'b01101 : cos2 = mux_in_cos13;
        5'b01110 : cos2 = mux_in_cos14;
        5'b01111 : cos2 = mux_in_cos15;
        5'b10000 : cos2 = mux_in_cos16;
        default: cos2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        5'b00000 : cos3 = mux_in_cos0;
        5'b00001 : cos3 = mux_in_cos1;
        5'b00010 : cos3 = mux_in_cos2;
        5'b00011 : cos3 = mux_in_cos3;
        5'b00100 : cos3 = mux_in_cos4;
        5'b00101 : cos3 = mux_in_cos5;
        5'b00110 : cos3 = mux_in_cos6;
        5'b00111 : cos3 = mux_in_cos7;
        5'b01000 : cos3 = mux_in_cos8;
        5'b01001 : cos3 = mux_in_cos9;
        5'b01010 : cos3 = mux_in_cos10;
        5'b01011 : cos3 = mux_in_cos11;
        5'b01100 : cos3 = mux_in_cos12;
        5'b01101 : cos3 = mux_in_cos13;
        5'b01110 : cos3 = mux_in_cos14;
        5'b01111 : cos3 = mux_in_cos15;
        5'b10000 : cos3 = mux_in_cos16;
        default: cos3 = 15'bx;
        endcase
    end

endmodule