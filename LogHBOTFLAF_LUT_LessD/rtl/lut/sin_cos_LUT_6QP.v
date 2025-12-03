`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 10-07-2024
// Module name: sin_cos_LUT_6QP.v
//////////////////////////////////////////////////////////////////////////////////

module sin_cos_LUT_6QP
(
    input      [ 5:0] x_in1, x_in2, x_in3,
    output reg [15:0] sin1, sin2, sin3, cos1, cos2, cos3
);

    wire [15:0] mux_in_cos0, mux_in_sin0, mux_in_cos1, mux_in_sin1, mux_in_cos2, mux_in_sin2, mux_in_cos3, mux_in_sin3, mux_in_cos4, mux_in_sin4, mux_in_cos5, mux_in_sin5, mux_in_cos6, mux_in_sin6, mux_in_cos7, mux_in_sin7, mux_in_cos8, mux_in_sin8, mux_in_cos9, mux_in_sin9, mux_in_cos10, mux_in_sin10, mux_in_cos11, mux_in_sin11, mux_in_cos12, mux_in_sin12, mux_in_cos13, mux_in_sin13, mux_in_cos14, mux_in_sin14, mux_in_cos15, mux_in_sin15, mux_in_cos16, mux_in_sin16, mux_in_cos17, mux_in_sin17, mux_in_cos18, mux_in_sin18, mux_in_cos19, mux_in_sin19, mux_in_cos20, mux_in_sin20, mux_in_cos21, mux_in_sin21, mux_in_cos22, mux_in_sin22, mux_in_cos23, mux_in_sin23, mux_in_cos24, mux_in_sin24, mux_in_cos25, mux_in_sin25, mux_in_cos26, mux_in_sin26, mux_in_cos27, mux_in_sin27, mux_in_cos28, mux_in_sin28, mux_in_cos29, mux_in_sin29, mux_in_cos30, mux_in_sin30, mux_in_cos31, mux_in_sin31, mux_in_cos32, mux_in_sin32;

    assign mux_in_cos0 = 16'b1000000000000000;
    assign mux_in_sin0 = 16'b0000000000000000;
    assign mux_in_cos1 = 16'b0111111111011001;
    assign mux_in_sin1 = 16'b0000011001001000;
    assign mux_in_cos2 = 16'b0111111101100010;
    assign mux_in_sin2 = 16'b0000110010001100;
    assign mux_in_cos3 = 16'b0111111010011101;
    assign mux_in_sin3 = 16'b0001001011001000;
    assign mux_in_cos4 = 16'b0111110110001010;
    assign mux_in_sin4 = 16'b0001100011111001;
    assign mux_in_cos5 = 16'b0111110000101010;
    assign mux_in_sin5 = 16'b0001111100011010;
    assign mux_in_cos6 = 16'b0111101001111101;
    assign mux_in_sin6 = 16'b0010010100101000;
    assign mux_in_cos7 = 16'b0111100010000101;
    assign mux_in_sin7 = 16'b0010101100011111;
    assign mux_in_cos8 = 16'b0111011001000010;
    assign mux_in_sin8 = 16'b0011000011111100;
    assign mux_in_cos9 = 16'b0111001110110110;
    assign mux_in_sin9 = 16'b0011011010111010;
    assign mux_in_cos10 = 16'b0111000011100011;
    assign mux_in_sin10 = 16'b0011110001010111;
    assign mux_in_cos11 = 16'b0110110111001010;
    assign mux_in_sin11 = 16'b0100000111001110;
    assign mux_in_cos12 = 16'b0110101001101110;
    assign mux_in_sin12 = 16'b0100011100011101;
    assign mux_in_cos13 = 16'b0110011011010000;
    assign mux_in_sin13 = 16'b0100110001000000;
    assign mux_in_cos14 = 16'b0110001011110010;
    assign mux_in_sin14 = 16'b0101000100110100;
    assign mux_in_cos15 = 16'b0101111011010111;
    assign mux_in_sin15 = 16'b0101010111110110;
    assign mux_in_cos16 = 16'b0101101010000010;
    assign mux_in_sin16 = 16'b0101101010000010;
    assign mux_in_cos17 = 16'b0101010111110110;
    assign mux_in_sin17 = 16'b0101111011010111;
    assign mux_in_cos18 = 16'b0101000100110100;
    assign mux_in_sin18 = 16'b0110001011110010;
    assign mux_in_cos19 = 16'b0100110001000000;
    assign mux_in_sin19 = 16'b0110011011010000;
    assign mux_in_cos20 = 16'b0100011100011101;
    assign mux_in_sin20 = 16'b0110101001101110;
    assign mux_in_cos21 = 16'b0100000111001110;
    assign mux_in_sin21 = 16'b0110110111001010;
    assign mux_in_cos22 = 16'b0011110001010111;
    assign mux_in_sin22 = 16'b0111000011100011;
    assign mux_in_cos23 = 16'b0011011010111010;
    assign mux_in_sin23 = 16'b0111001110110110;
    assign mux_in_cos24 = 16'b0011000011111100;
    assign mux_in_sin24 = 16'b0111011001000010;
    assign mux_in_cos25 = 16'b0010101100011111;
    assign mux_in_sin25 = 16'b0111100010000101;
    assign mux_in_cos26 = 16'b0010010100101000;
    assign mux_in_sin26 = 16'b0111101001111101;
    assign mux_in_cos27 = 16'b0001111100011010;
    assign mux_in_sin27 = 16'b0111110000101010;
    assign mux_in_cos28 = 16'b0001100011111001;
    assign mux_in_sin28 = 16'b0111110110001010;
    assign mux_in_cos29 = 16'b0001001011001000;
    assign mux_in_sin29 = 16'b0111111010011101;
    assign mux_in_cos30 = 16'b0000110010001100;
    assign mux_in_sin30 = 16'b0111111101100010;
    assign mux_in_cos31 = 16'b0000011001001000;
    assign mux_in_sin31 = 16'b0111111111011001;
    assign mux_in_cos32 = 16'b0000000000000000;
    assign mux_in_sin32 = 16'b1000000000000000;

    // Sine LUTs

    always @ (*)
    begin
        case(x_in1)
        6'b000000 : sin1 = mux_in_sin0;
        6'b000001 : sin1 = mux_in_sin1;
        6'b000010 : sin1 = mux_in_sin2;
        6'b000011 : sin1 = mux_in_sin3;
        6'b000100 : sin1 = mux_in_sin4;
        6'b000101 : sin1 = mux_in_sin5;
        6'b000110 : sin1 = mux_in_sin6;
        6'b000111 : sin1 = mux_in_sin7;
        6'b001000 : sin1 = mux_in_sin8;
        6'b001001 : sin1 = mux_in_sin9;
        6'b001010 : sin1 = mux_in_sin10;
        6'b001011 : sin1 = mux_in_sin11;
        6'b001100 : sin1 = mux_in_sin12;
        6'b001101 : sin1 = mux_in_sin13;
        6'b001110 : sin1 = mux_in_sin14;
        6'b001111 : sin1 = mux_in_sin15;
        6'b010000 : sin1 = mux_in_sin16;
        6'b010001 : sin1 = mux_in_sin17;
        6'b010010 : sin1 = mux_in_sin18;
        6'b010011 : sin1 = mux_in_sin19;
        6'b010100 : sin1 = mux_in_sin20;
        6'b010101 : sin1 = mux_in_sin21;
        6'b010110 : sin1 = mux_in_sin22;
        6'b010111 : sin1 = mux_in_sin23;
        6'b011000 : sin1 = mux_in_sin24;
        6'b011001 : sin1 = mux_in_sin25;
        6'b011010 : sin1 = mux_in_sin26;
        6'b011011 : sin1 = mux_in_sin27;
        6'b011100 : sin1 = mux_in_sin28;
        6'b011101 : sin1 = mux_in_sin29;
        6'b011110 : sin1 = mux_in_sin30;
        6'b011111 : sin1 = mux_in_sin31;
        6'b100000 : sin1 = mux_in_sin32;
        default: sin1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        6'b000000 : sin2 = mux_in_sin0;
        6'b000001 : sin2 = mux_in_sin1;
        6'b000010 : sin2 = mux_in_sin2;
        6'b000011 : sin2 = mux_in_sin3;
        6'b000100 : sin2 = mux_in_sin4;
        6'b000101 : sin2 = mux_in_sin5;
        6'b000110 : sin2 = mux_in_sin6;
        6'b000111 : sin2 = mux_in_sin7;
        6'b001000 : sin2 = mux_in_sin8;
        6'b001001 : sin2 = mux_in_sin9;
        6'b001010 : sin2 = mux_in_sin10;
        6'b001011 : sin2 = mux_in_sin11;
        6'b001100 : sin2 = mux_in_sin12;
        6'b001101 : sin2 = mux_in_sin13;
        6'b001110 : sin2 = mux_in_sin14;
        6'b001111 : sin2 = mux_in_sin15;
        6'b010000 : sin2 = mux_in_sin16;
        6'b010001 : sin2 = mux_in_sin17;
        6'b010010 : sin2 = mux_in_sin18;
        6'b010011 : sin2 = mux_in_sin19;
        6'b010100 : sin2 = mux_in_sin20;
        6'b010101 : sin2 = mux_in_sin21;
        6'b010110 : sin2 = mux_in_sin22;
        6'b010111 : sin2 = mux_in_sin23;
        6'b011000 : sin2 = mux_in_sin24;
        6'b011001 : sin2 = mux_in_sin25;
        6'b011010 : sin2 = mux_in_sin26;
        6'b011011 : sin2 = mux_in_sin27;
        6'b011100 : sin2 = mux_in_sin28;
        6'b011101 : sin2 = mux_in_sin29;
        6'b011110 : sin2 = mux_in_sin30;
        6'b011111 : sin2 = mux_in_sin31;
        6'b100000 : sin2 = mux_in_sin32;
        default: sin2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        6'b000000 : sin3 = mux_in_sin0;
        6'b000001 : sin3 = mux_in_sin1;
        6'b000010 : sin3 = mux_in_sin2;
        6'b000011 : sin3 = mux_in_sin3;
        6'b000100 : sin3 = mux_in_sin4;
        6'b000101 : sin3 = mux_in_sin5;
        6'b000110 : sin3 = mux_in_sin6;
        6'b000111 : sin3 = mux_in_sin7;
        6'b001000 : sin3 = mux_in_sin8;
        6'b001001 : sin3 = mux_in_sin9;
        6'b001010 : sin3 = mux_in_sin10;
        6'b001011 : sin3 = mux_in_sin11;
        6'b001100 : sin3 = mux_in_sin12;
        6'b001101 : sin3 = mux_in_sin13;
        6'b001110 : sin3 = mux_in_sin14;
        6'b001111 : sin3 = mux_in_sin15;
        6'b010000 : sin3 = mux_in_sin16;
        6'b010001 : sin3 = mux_in_sin17;
        6'b010010 : sin3 = mux_in_sin18;
        6'b010011 : sin3 = mux_in_sin19;
        6'b010100 : sin3 = mux_in_sin20;
        6'b010101 : sin3 = mux_in_sin21;
        6'b010110 : sin3 = mux_in_sin22;
        6'b010111 : sin3 = mux_in_sin23;
        6'b011000 : sin3 = mux_in_sin24;
        6'b011001 : sin3 = mux_in_sin25;
        6'b011010 : sin3 = mux_in_sin26;
        6'b011011 : sin3 = mux_in_sin27;
        6'b011100 : sin3 = mux_in_sin28;
        6'b011101 : sin3 = mux_in_sin29;
        6'b011110 : sin3 = mux_in_sin30;
        6'b011111 : sin3 = mux_in_sin31;
        6'b100000 : sin3 = mux_in_sin32;
        default: sin3 = 15'bx;
        endcase
    end

    //Cos LUTs
    always @ (*)
    begin
        case(x_in1)
        6'b000000 : cos1 = mux_in_cos0;
        6'b000001 : cos1 = mux_in_cos1;
        6'b000010 : cos1 = mux_in_cos2;
        6'b000011 : cos1 = mux_in_cos3;
        6'b000100 : cos1 = mux_in_cos4;
        6'b000101 : cos1 = mux_in_cos5;
        6'b000110 : cos1 = mux_in_cos6;
        6'b000111 : cos1 = mux_in_cos7;
        6'b001000 : cos1 = mux_in_cos8;
        6'b001001 : cos1 = mux_in_cos9;
        6'b001010 : cos1 = mux_in_cos10;
        6'b001011 : cos1 = mux_in_cos11;
        6'b001100 : cos1 = mux_in_cos12;
        6'b001101 : cos1 = mux_in_cos13;
        6'b001110 : cos1 = mux_in_cos14;
        6'b001111 : cos1 = mux_in_cos15;
        6'b010000 : cos1 = mux_in_cos16;
        6'b010001 : cos1 = mux_in_cos17;
        6'b010010 : cos1 = mux_in_cos18;
        6'b010011 : cos1 = mux_in_cos19;
        6'b010100 : cos1 = mux_in_cos20;
        6'b010101 : cos1 = mux_in_cos21;
        6'b010110 : cos1 = mux_in_cos22;
        6'b010111 : cos1 = mux_in_cos23;
        6'b011000 : cos1 = mux_in_cos24;
        6'b011001 : cos1 = mux_in_cos25;
        6'b011010 : cos1 = mux_in_cos26;
        6'b011011 : cos1 = mux_in_cos27;
        6'b011100 : cos1 = mux_in_cos28;
        6'b011101 : cos1 = mux_in_cos29;
        6'b011110 : cos1 = mux_in_cos30;
        6'b011111 : cos1 = mux_in_cos31;
        6'b100000 : cos1 = mux_in_cos32;
        default: cos1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        6'b000000 : cos2 = mux_in_cos0;
        6'b000001 : cos2 = mux_in_cos1;
        6'b000010 : cos2 = mux_in_cos2;
        6'b000011 : cos2 = mux_in_cos3;
        6'b000100 : cos2 = mux_in_cos4;
        6'b000101 : cos2 = mux_in_cos5;
        6'b000110 : cos2 = mux_in_cos6;
        6'b000111 : cos2 = mux_in_cos7;
        6'b001000 : cos2 = mux_in_cos8;
        6'b001001 : cos2 = mux_in_cos9;
        6'b001010 : cos2 = mux_in_cos10;
        6'b001011 : cos2 = mux_in_cos11;
        6'b001100 : cos2 = mux_in_cos12;
        6'b001101 : cos2 = mux_in_cos13;
        6'b001110 : cos2 = mux_in_cos14;
        6'b001111 : cos2 = mux_in_cos15;
        6'b010000 : cos2 = mux_in_cos16;
        6'b010001 : cos2 = mux_in_cos17;
        6'b010010 : cos2 = mux_in_cos18;
        6'b010011 : cos2 = mux_in_cos19;
        6'b010100 : cos2 = mux_in_cos20;
        6'b010101 : cos2 = mux_in_cos21;
        6'b010110 : cos2 = mux_in_cos22;
        6'b010111 : cos2 = mux_in_cos23;
        6'b011000 : cos2 = mux_in_cos24;
        6'b011001 : cos2 = mux_in_cos25;
        6'b011010 : cos2 = mux_in_cos26;
        6'b011011 : cos2 = mux_in_cos27;
        6'b011100 : cos2 = mux_in_cos28;
        6'b011101 : cos2 = mux_in_cos29;
        6'b011110 : cos2 = mux_in_cos30;
        6'b011111 : cos2 = mux_in_cos31;
        6'b100000 : cos2 = mux_in_cos32;
        default: cos2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        6'b000000 : cos3 = mux_in_cos0;
        6'b000001 : cos3 = mux_in_cos1;
        6'b000010 : cos3 = mux_in_cos2;
        6'b000011 : cos3 = mux_in_cos3;
        6'b000100 : cos3 = mux_in_cos4;
        6'b000101 : cos3 = mux_in_cos5;
        6'b000110 : cos3 = mux_in_cos6;
        6'b000111 : cos3 = mux_in_cos7;
        6'b001000 : cos3 = mux_in_cos8;
        6'b001001 : cos3 = mux_in_cos9;
        6'b001010 : cos3 = mux_in_cos10;
        6'b001011 : cos3 = mux_in_cos11;
        6'b001100 : cos3 = mux_in_cos12;
        6'b001101 : cos3 = mux_in_cos13;
        6'b001110 : cos3 = mux_in_cos14;
        6'b001111 : cos3 = mux_in_cos15;
        6'b010000 : cos3 = mux_in_cos16;
        6'b010001 : cos3 = mux_in_cos17;
        6'b010010 : cos3 = mux_in_cos18;
        6'b010011 : cos3 = mux_in_cos19;
        6'b010100 : cos3 = mux_in_cos20;
        6'b010101 : cos3 = mux_in_cos21;
        6'b010110 : cos3 = mux_in_cos22;
        6'b010111 : cos3 = mux_in_cos23;
        6'b011000 : cos3 = mux_in_cos24;
        6'b011001 : cos3 = mux_in_cos25;
        6'b011010 : cos3 = mux_in_cos26;
        6'b011011 : cos3 = mux_in_cos27;
        6'b011100 : cos3 = mux_in_cos28;
        6'b011101 : cos3 = mux_in_cos29;
        6'b011110 : cos3 = mux_in_cos30;
        6'b011111 : cos3 = mux_in_cos31;
        6'b100000 : cos3 = mux_in_cos32;
        default: cos3 = 15'bx;
        endcase
    end

endmodule