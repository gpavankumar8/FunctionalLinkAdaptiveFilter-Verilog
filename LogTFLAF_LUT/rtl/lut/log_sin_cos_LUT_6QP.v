`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: log_sin_cos_LUT_6QP.v
//////////////////////////////////////////////////////////////////////////////////

module log_sin_cos_LUT_6QP
(
    input      [ 5:0] x_in1, x_in2, x_in3,
    output reg [15:0] logsin1, logsin2, logsin3, logcos1, logcos2, logcos3
);

    wire [15:0] mux_in_cos0, mux_in_sin0, mux_in_cos1, mux_in_sin1, mux_in_cos2, mux_in_sin2, mux_in_cos3, mux_in_sin3, mux_in_cos4, mux_in_sin4, mux_in_cos5, mux_in_sin5, mux_in_cos6, mux_in_sin6, mux_in_cos7, mux_in_sin7, mux_in_cos8, mux_in_sin8, mux_in_cos9, mux_in_sin9, mux_in_cos10, mux_in_sin10, mux_in_cos11, mux_in_sin11, mux_in_cos12, mux_in_sin12, mux_in_cos13, mux_in_sin13, mux_in_cos14, mux_in_sin14, mux_in_cos15, mux_in_sin15, mux_in_cos16, mux_in_sin16, mux_in_cos17, mux_in_sin17, mux_in_cos18, mux_in_sin18, mux_in_cos19, mux_in_sin19, mux_in_cos20, mux_in_sin20, mux_in_cos21, mux_in_sin21, mux_in_cos22, mux_in_sin22, mux_in_cos23, mux_in_sin23, mux_in_cos24, mux_in_sin24, mux_in_cos25, mux_in_sin25, mux_in_cos26, mux_in_sin26, mux_in_cos27, mux_in_sin27, mux_in_cos28, mux_in_sin28, mux_in_cos29, mux_in_sin29, mux_in_cos30, mux_in_sin30, mux_in_cos31, mux_in_sin31, mux_in_cos32, mux_in_sin32;

    assign mux_in_cos0 = 16'b0000000000000000;
    assign mux_in_sin0 = 16'b0000000000000000;
    assign mux_in_cos1 = 16'b1111111111111001;
    assign mux_in_sin1 = 16'b1011101001101010;
    assign mux_in_cos2 = 16'b1111111111100011;
    assign mux_in_sin2 = 16'b1100101001100011;
    assign mux_in_cos3 = 16'b1111111111000000;
    assign mux_in_sin3 = 16'b1101001110110011;
    assign mux_in_cos4 = 16'b1111111110001101;
    assign mux_in_sin4 = 16'b1101101001000111;
    assign mux_in_cos5 = 16'b1111111101001100;
    assign mux_in_sin5 = 16'b1101111101011000;
    assign mux_in_cos6 = 16'b1111111011111100;
    assign mux_in_sin6 = 16'b1110001101110011;
    assign mux_in_cos7 = 16'b1111111010011100;
    assign mux_in_sin7 = 16'b1110011011100011;
    assign mux_in_cos8 = 16'b1111111000101100;
    assign mux_in_sin8 = 16'b1110100111010100;
    assign mux_in_cos9 = 16'b1111110110101100;
    assign mux_in_sin9 = 16'b1110110001100011;
    assign mux_in_cos10 = 16'b1111110100011001;
    assign mux_in_sin10 = 16'b1110111010100100;
    assign mux_in_cos11 = 16'b1111110001110101;
    assign mux_in_sin11 = 16'b1111000010100100;
    assign mux_in_cos12 = 16'b1111101110111101;
    assign mux_in_sin12 = 16'b1111001001101111;
    assign mux_in_cos13 = 16'b1111101011110001;
    assign mux_in_sin13 = 16'b1111010000001011;
    assign mux_in_cos14 = 16'b1111101000001111;
    assign mux_in_sin14 = 16'b1111010101111111;
    assign mux_in_cos15 = 16'b1111100100010100;
    assign mux_in_sin15 = 16'b1111011011001111;
    assign mux_in_cos16 = 16'b1111100000000000;
    assign mux_in_sin16 = 16'b1111100000000000;
    assign mux_in_cos17 = 16'b1111011011001111;
    assign mux_in_sin17 = 16'b1111100100010100;
    assign mux_in_cos18 = 16'b1111010101111111;
    assign mux_in_sin18 = 16'b1111101000001111;
    assign mux_in_cos19 = 16'b1111010000001011;
    assign mux_in_sin19 = 16'b1111101011110001;
    assign mux_in_cos20 = 16'b1111001001101111;
    assign mux_in_sin20 = 16'b1111101110111101;
    assign mux_in_cos21 = 16'b1111000010100100;
    assign mux_in_sin21 = 16'b1111110001110101;
    assign mux_in_cos22 = 16'b1110111010100100;
    assign mux_in_sin22 = 16'b1111110100011001;
    assign mux_in_cos23 = 16'b1110110001100011;
    assign mux_in_sin23 = 16'b1111110110101100;
    assign mux_in_cos24 = 16'b1110100111010100;
    assign mux_in_sin24 = 16'b1111111000101100;
    assign mux_in_cos25 = 16'b1110011011100011;
    assign mux_in_sin25 = 16'b1111111010011100;
    assign mux_in_cos26 = 16'b1110001101110011;
    assign mux_in_sin26 = 16'b1111111011111100;
    assign mux_in_cos27 = 16'b1101111101011000;
    assign mux_in_sin27 = 16'b1111111101001100;
    assign mux_in_cos28 = 16'b1101101001000111;
    assign mux_in_sin28 = 16'b1111111110001101;
    assign mux_in_cos29 = 16'b1101001110110011;
    assign mux_in_sin29 = 16'b1111111111000000;
    assign mux_in_cos30 = 16'b1100101001100011;
    assign mux_in_sin30 = 16'b1111111111100011;
    assign mux_in_cos31 = 16'b1011101001101010;
    assign mux_in_sin31 = 16'b1111111111111001;
    assign mux_in_cos32 = 16'b0000000000000000;
    assign mux_in_sin32 = 16'b0000000000000000;

    always @ (*)
    begin
        case(x_in1)
        6'b000000 : logsin1 = mux_in_sin0;
        6'b000001 : logsin1 = mux_in_sin1;
        6'b000010 : logsin1 = mux_in_sin2;
        6'b000011 : logsin1 = mux_in_sin3;
        6'b000100 : logsin1 = mux_in_sin4;
        6'b000101 : logsin1 = mux_in_sin5;
        6'b000110 : logsin1 = mux_in_sin6;
        6'b000111 : logsin1 = mux_in_sin7;
        6'b001000 : logsin1 = mux_in_sin8;
        6'b001001 : logsin1 = mux_in_sin9;
        6'b001010 : logsin1 = mux_in_sin10;
        6'b001011 : logsin1 = mux_in_sin11;
        6'b001100 : logsin1 = mux_in_sin12;
        6'b001101 : logsin1 = mux_in_sin13;
        6'b001110 : logsin1 = mux_in_sin14;
        6'b001111 : logsin1 = mux_in_sin15;
        6'b010000 : logsin1 = mux_in_sin16;
        6'b010001 : logsin1 = mux_in_sin17;
        6'b010010 : logsin1 = mux_in_sin18;
        6'b010011 : logsin1 = mux_in_sin19;
        6'b010100 : logsin1 = mux_in_sin20;
        6'b010101 : logsin1 = mux_in_sin21;
        6'b010110 : logsin1 = mux_in_sin22;
        6'b010111 : logsin1 = mux_in_sin23;
        6'b011000 : logsin1 = mux_in_sin24;
        6'b011001 : logsin1 = mux_in_sin25;
        6'b011010 : logsin1 = mux_in_sin26;
        6'b011011 : logsin1 = mux_in_sin27;
        6'b011100 : logsin1 = mux_in_sin28;
        6'b011101 : logsin1 = mux_in_sin29;
        6'b011110 : logsin1 = mux_in_sin30;
        6'b011111 : logsin1 = mux_in_sin31;
        6'b100000 : logsin1 = mux_in_sin32;
        default: logsin1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        6'b000000 : logsin2 = mux_in_sin0;
        6'b000001 : logsin2 = mux_in_sin1;
        6'b000010 : logsin2 = mux_in_sin2;
        6'b000011 : logsin2 = mux_in_sin3;
        6'b000100 : logsin2 = mux_in_sin4;
        6'b000101 : logsin2 = mux_in_sin5;
        6'b000110 : logsin2 = mux_in_sin6;
        6'b000111 : logsin2 = mux_in_sin7;
        6'b001000 : logsin2 = mux_in_sin8;
        6'b001001 : logsin2 = mux_in_sin9;
        6'b001010 : logsin2 = mux_in_sin10;
        6'b001011 : logsin2 = mux_in_sin11;
        6'b001100 : logsin2 = mux_in_sin12;
        6'b001101 : logsin2 = mux_in_sin13;
        6'b001110 : logsin2 = mux_in_sin14;
        6'b001111 : logsin2 = mux_in_sin15;
        6'b010000 : logsin2 = mux_in_sin16;
        6'b010001 : logsin2 = mux_in_sin17;
        6'b010010 : logsin2 = mux_in_sin18;
        6'b010011 : logsin2 = mux_in_sin19;
        6'b010100 : logsin2 = mux_in_sin20;
        6'b010101 : logsin2 = mux_in_sin21;
        6'b010110 : logsin2 = mux_in_sin22;
        6'b010111 : logsin2 = mux_in_sin23;
        6'b011000 : logsin2 = mux_in_sin24;
        6'b011001 : logsin2 = mux_in_sin25;
        6'b011010 : logsin2 = mux_in_sin26;
        6'b011011 : logsin2 = mux_in_sin27;
        6'b011100 : logsin2 = mux_in_sin28;
        6'b011101 : logsin2 = mux_in_sin29;
        6'b011110 : logsin2 = mux_in_sin30;
        6'b011111 : logsin2 = mux_in_sin31;
        6'b100000 : logsin2 = mux_in_sin32;
        default: logsin2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        6'b000000 : logsin3 = mux_in_sin0;
        6'b000001 : logsin3 = mux_in_sin1;
        6'b000010 : logsin3 = mux_in_sin2;
        6'b000011 : logsin3 = mux_in_sin3;
        6'b000100 : logsin3 = mux_in_sin4;
        6'b000101 : logsin3 = mux_in_sin5;
        6'b000110 : logsin3 = mux_in_sin6;
        6'b000111 : logsin3 = mux_in_sin7;
        6'b001000 : logsin3 = mux_in_sin8;
        6'b001001 : logsin3 = mux_in_sin9;
        6'b001010 : logsin3 = mux_in_sin10;
        6'b001011 : logsin3 = mux_in_sin11;
        6'b001100 : logsin3 = mux_in_sin12;
        6'b001101 : logsin3 = mux_in_sin13;
        6'b001110 : logsin3 = mux_in_sin14;
        6'b001111 : logsin3 = mux_in_sin15;
        6'b010000 : logsin3 = mux_in_sin16;
        6'b010001 : logsin3 = mux_in_sin17;
        6'b010010 : logsin3 = mux_in_sin18;
        6'b010011 : logsin3 = mux_in_sin19;
        6'b010100 : logsin3 = mux_in_sin20;
        6'b010101 : logsin3 = mux_in_sin21;
        6'b010110 : logsin3 = mux_in_sin22;
        6'b010111 : logsin3 = mux_in_sin23;
        6'b011000 : logsin3 = mux_in_sin24;
        6'b011001 : logsin3 = mux_in_sin25;
        6'b011010 : logsin3 = mux_in_sin26;
        6'b011011 : logsin3 = mux_in_sin27;
        6'b011100 : logsin3 = mux_in_sin28;
        6'b011101 : logsin3 = mux_in_sin29;
        6'b011110 : logsin3 = mux_in_sin30;
        6'b011111 : logsin3 = mux_in_sin31;
        6'b100000 : logsin3 = mux_in_sin32;
        default: logsin3 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in1)
        6'b000000 : logcos1 = mux_in_cos0;
        6'b000001 : logcos1 = mux_in_cos1;
        6'b000010 : logcos1 = mux_in_cos2;
        6'b000011 : logcos1 = mux_in_cos3;
        6'b000100 : logcos1 = mux_in_cos4;
        6'b000101 : logcos1 = mux_in_cos5;
        6'b000110 : logcos1 = mux_in_cos6;
        6'b000111 : logcos1 = mux_in_cos7;
        6'b001000 : logcos1 = mux_in_cos8;
        6'b001001 : logcos1 = mux_in_cos9;
        6'b001010 : logcos1 = mux_in_cos10;
        6'b001011 : logcos1 = mux_in_cos11;
        6'b001100 : logcos1 = mux_in_cos12;
        6'b001101 : logcos1 = mux_in_cos13;
        6'b001110 : logcos1 = mux_in_cos14;
        6'b001111 : logcos1 = mux_in_cos15;
        6'b010000 : logcos1 = mux_in_cos16;
        6'b010001 : logcos1 = mux_in_cos17;
        6'b010010 : logcos1 = mux_in_cos18;
        6'b010011 : logcos1 = mux_in_cos19;
        6'b010100 : logcos1 = mux_in_cos20;
        6'b010101 : logcos1 = mux_in_cos21;
        6'b010110 : logcos1 = mux_in_cos22;
        6'b010111 : logcos1 = mux_in_cos23;
        6'b011000 : logcos1 = mux_in_cos24;
        6'b011001 : logcos1 = mux_in_cos25;
        6'b011010 : logcos1 = mux_in_cos26;
        6'b011011 : logcos1 = mux_in_cos27;
        6'b011100 : logcos1 = mux_in_cos28;
        6'b011101 : logcos1 = mux_in_cos29;
        6'b011110 : logcos1 = mux_in_cos30;
        6'b011111 : logcos1 = mux_in_cos31;
        6'b100000 : logcos1 = mux_in_cos32;
        default: logcos1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        6'b000000 : logcos2 = mux_in_cos0;
        6'b000001 : logcos2 = mux_in_cos1;
        6'b000010 : logcos2 = mux_in_cos2;
        6'b000011 : logcos2 = mux_in_cos3;
        6'b000100 : logcos2 = mux_in_cos4;
        6'b000101 : logcos2 = mux_in_cos5;
        6'b000110 : logcos2 = mux_in_cos6;
        6'b000111 : logcos2 = mux_in_cos7;
        6'b001000 : logcos2 = mux_in_cos8;
        6'b001001 : logcos2 = mux_in_cos9;
        6'b001010 : logcos2 = mux_in_cos10;
        6'b001011 : logcos2 = mux_in_cos11;
        6'b001100 : logcos2 = mux_in_cos12;
        6'b001101 : logcos2 = mux_in_cos13;
        6'b001110 : logcos2 = mux_in_cos14;
        6'b001111 : logcos2 = mux_in_cos15;
        6'b010000 : logcos2 = mux_in_cos16;
        6'b010001 : logcos2 = mux_in_cos17;
        6'b010010 : logcos2 = mux_in_cos18;
        6'b010011 : logcos2 = mux_in_cos19;
        6'b010100 : logcos2 = mux_in_cos20;
        6'b010101 : logcos2 = mux_in_cos21;
        6'b010110 : logcos2 = mux_in_cos22;
        6'b010111 : logcos2 = mux_in_cos23;
        6'b011000 : logcos2 = mux_in_cos24;
        6'b011001 : logcos2 = mux_in_cos25;
        6'b011010 : logcos2 = mux_in_cos26;
        6'b011011 : logcos2 = mux_in_cos27;
        6'b011100 : logcos2 = mux_in_cos28;
        6'b011101 : logcos2 = mux_in_cos29;
        6'b011110 : logcos2 = mux_in_cos30;
        6'b011111 : logcos2 = mux_in_cos31;
        6'b100000 : logcos2 = mux_in_cos32;
        default: logcos2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        6'b000000 : logcos3 = mux_in_cos0;
        6'b000001 : logcos3 = mux_in_cos1;
        6'b000010 : logcos3 = mux_in_cos2;
        6'b000011 : logcos3 = mux_in_cos3;
        6'b000100 : logcos3 = mux_in_cos4;
        6'b000101 : logcos3 = mux_in_cos5;
        6'b000110 : logcos3 = mux_in_cos6;
        6'b000111 : logcos3 = mux_in_cos7;
        6'b001000 : logcos3 = mux_in_cos8;
        6'b001001 : logcos3 = mux_in_cos9;
        6'b001010 : logcos3 = mux_in_cos10;
        6'b001011 : logcos3 = mux_in_cos11;
        6'b001100 : logcos3 = mux_in_cos12;
        6'b001101 : logcos3 = mux_in_cos13;
        6'b001110 : logcos3 = mux_in_cos14;
        6'b001111 : logcos3 = mux_in_cos15;
        6'b010000 : logcos3 = mux_in_cos16;
        6'b010001 : logcos3 = mux_in_cos17;
        6'b010010 : logcos3 = mux_in_cos18;
        6'b010011 : logcos3 = mux_in_cos19;
        6'b010100 : logcos3 = mux_in_cos20;
        6'b010101 : logcos3 = mux_in_cos21;
        6'b010110 : logcos3 = mux_in_cos22;
        6'b010111 : logcos3 = mux_in_cos23;
        6'b011000 : logcos3 = mux_in_cos24;
        6'b011001 : logcos3 = mux_in_cos25;
        6'b011010 : logcos3 = mux_in_cos26;
        6'b011011 : logcos3 = mux_in_cos27;
        6'b011100 : logcos3 = mux_in_cos28;
        6'b011101 : logcos3 = mux_in_cos29;
        6'b011110 : logcos3 = mux_in_cos30;
        6'b011111 : logcos3 = mux_in_cos31;
        6'b100000 : logcos3 = mux_in_cos32;
        default: logcos3 = 15'bx;
        endcase
    end
    
endmodule