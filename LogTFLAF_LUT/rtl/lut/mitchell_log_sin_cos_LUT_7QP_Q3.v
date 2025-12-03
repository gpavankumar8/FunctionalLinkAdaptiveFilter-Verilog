`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 13-03-2025
// Module name: mitchell_log_sin_cos_LUT_7QP_Q3.v
//////////////////////////////////////////////////////////////////////////////////

module mitchell_log_sin_cos_LUT_7QP_Q3
(
    input      [ 6:0] x_in1,
    output reg [15:0] logsin1, logcos1
);

    wire [15:0] mux_in_cos0, mux_in_sin0, mux_in_cos1, mux_in_sin1, mux_in_cos2, mux_in_sin2, mux_in_cos3, mux_in_sin3, mux_in_cos4, mux_in_sin4, mux_in_cos5, mux_in_sin5, mux_in_cos6, mux_in_sin6, mux_in_cos7, mux_in_sin7, mux_in_cos8, mux_in_sin8, mux_in_cos9, mux_in_sin9, mux_in_cos10, mux_in_sin10, mux_in_cos11, mux_in_sin11, mux_in_cos12, mux_in_sin12, mux_in_cos13, mux_in_sin13, mux_in_cos14, mux_in_sin14, mux_in_cos15, mux_in_sin15, mux_in_cos16, mux_in_sin16, mux_in_cos17, mux_in_sin17, mux_in_cos18, mux_in_sin18, mux_in_cos19, mux_in_sin19, mux_in_cos20, mux_in_sin20, mux_in_cos21, mux_in_sin21, mux_in_cos22, mux_in_sin22, mux_in_cos23, mux_in_sin23, mux_in_cos24, mux_in_sin24, mux_in_cos25, mux_in_sin25, mux_in_cos26, mux_in_sin26, mux_in_cos27, mux_in_sin27, mux_in_cos28, mux_in_sin28, mux_in_cos29, mux_in_sin29, mux_in_cos30, mux_in_sin30, mux_in_cos31, mux_in_sin31, mux_in_cos32, mux_in_sin32, mux_in_cos33, mux_in_sin33, mux_in_cos34, mux_in_sin34, mux_in_cos35, mux_in_sin35, mux_in_cos36, mux_in_sin36, mux_in_cos37, mux_in_sin37, mux_in_cos38, mux_in_sin38, mux_in_cos39, mux_in_sin39, mux_in_cos40, mux_in_sin40, mux_in_cos41, mux_in_sin41, mux_in_cos42, mux_in_sin42, mux_in_cos43, mux_in_sin43, mux_in_cos44, mux_in_sin44, mux_in_cos45, mux_in_sin45, mux_in_cos46, mux_in_sin46, mux_in_cos47, mux_in_sin47, mux_in_cos48, mux_in_sin48, mux_in_cos49, mux_in_sin49, mux_in_cos50, mux_in_sin50, mux_in_cos51, mux_in_sin51, mux_in_cos52, mux_in_sin52, mux_in_cos53, mux_in_sin53, mux_in_cos54, mux_in_sin54, mux_in_cos55, mux_in_sin55, mux_in_cos56, mux_in_sin56, mux_in_cos57, mux_in_sin57, mux_in_cos58, mux_in_sin58, mux_in_cos59, mux_in_sin59, mux_in_cos60, mux_in_sin60, mux_in_cos61, mux_in_sin61, mux_in_cos62, mux_in_sin62, mux_in_cos63, mux_in_sin63, mux_in_cos64, mux_in_sin64;

    
    assign mux_in_cos0 = 16'b0000000000000000;
assign mux_in_sin0 = 16'b0000000000000000;
assign mux_in_cos1 = 16'b1111111111111101;
assign mux_in_sin1 = 16'b1010100100100000;
assign mux_in_cos2 = 16'b1111111111110110;
assign mux_in_sin2 = 16'b1011100100100000;
assign mux_in_cos3 = 16'b1111111111101010;
assign mux_in_sin3 = 16'b1100001011011000;
assign mux_in_cos4 = 16'b1111111111011000;
assign mux_in_sin4 = 16'b1100100100011000;
assign mux_in_cos5 = 16'b1111111111000010;
assign mux_in_sin5 = 16'b1100111101011000;
assign mux_in_cos6 = 16'b1111111110100111;
assign mux_in_sin6 = 16'b1101001011001000;
assign mux_in_cos7 = 16'b1111111110000111;
assign mux_in_sin7 = 16'b1101010111100010;
assign mux_in_cos8 = 16'b1111111101100010;
assign mux_in_sin8 = 16'b1101100011111010;
assign mux_in_cos9 = 16'b1111111100111001;
assign mux_in_sin9 = 16'b1101110000001100;
assign mux_in_cos10 = 16'b1111111100001010;
assign mux_in_sin10 = 16'b1101111100011010;
assign mux_in_cos11 = 16'b1111111011010111;
assign mux_in_sin11 = 16'b1110000100010010;
assign mux_in_cos12 = 16'b1111111010011111;
assign mux_in_sin12 = 16'b1110001010010100;
assign mux_in_cos13 = 16'b1111111001100010;
assign mux_in_sin13 = 16'b1110010000010100;
assign mux_in_cos14 = 16'b1111111000100001;
assign mux_in_sin14 = 16'b1110010110010000;
assign mux_in_cos15 = 16'b1111110111011011;
assign mux_in_sin15 = 16'b1110011100001001;
assign mux_in_cos16 = 16'b1111110110010000;
assign mux_in_sin16 = 16'b1110100001111110;
assign mux_in_cos17 = 16'b1111110101000001;
assign mux_in_sin17 = 16'b1110100111110000;
assign mux_in_cos18 = 16'b1111110011101101;
assign mux_in_sin18 = 16'b1110101101011101;
assign mux_in_cos19 = 16'b1111110010010101;
assign mux_in_sin19 = 16'b1110110011000111;
assign mux_in_cos20 = 16'b1111110000111001;
assign mux_in_sin20 = 16'b1110111000101100;
assign mux_in_cos21 = 16'b1111101111011000;
assign mux_in_sin21 = 16'b1110111110001100;
assign mux_in_cos22 = 16'b1111101101110010;
assign mux_in_sin22 = 16'b1111000001110011;
assign mux_in_cos23 = 16'b1111101100001001;
assign mux_in_sin23 = 16'b1111000100011111;
assign mux_in_cos24 = 16'b1111101010011011;
assign mux_in_sin24 = 16'b1111000111000111;
assign mux_in_cos25 = 16'b1111101000101010;
assign mux_in_sin25 = 16'b1111001001101101;
assign mux_in_cos26 = 16'b1111100110110100;
assign mux_in_sin26 = 16'b1111001100010000;
assign mux_in_cos27 = 16'b1111100100111010;
assign mux_in_sin27 = 16'b1111001110110000;
assign mux_in_cos28 = 16'b1111100010111100;
assign mux_in_sin28 = 16'b1111010001001101;
assign mux_in_cos29 = 16'b1111100000111011;
assign mux_in_sin29 = 16'b1111010011100111;
assign mux_in_cos30 = 16'b1111011110110110;
assign mux_in_sin30 = 16'b1111010101111101;
assign mux_in_cos31 = 16'b1111011100101101;
assign mux_in_sin31 = 16'b1111011000010001;
assign mux_in_cos32 = 16'b1111011010100000;
assign mux_in_sin32 = 16'b1111011010100000;
assign mux_in_cos33 = 16'b1111011000010001;
assign mux_in_sin33 = 16'b1111011100101101;
assign mux_in_cos34 = 16'b1111010101111101;
assign mux_in_sin34 = 16'b1111011110110110;
assign mux_in_cos35 = 16'b1111010011100111;
assign mux_in_sin35 = 16'b1111100000111011;
assign mux_in_cos36 = 16'b1111010001001101;
assign mux_in_sin36 = 16'b1111100010111100;
assign mux_in_cos37 = 16'b1111001110110000;
assign mux_in_sin37 = 16'b1111100100111010;
assign mux_in_cos38 = 16'b1111001100010000;
assign mux_in_sin38 = 16'b1111100110110100;
assign mux_in_cos39 = 16'b1111001001101101;
assign mux_in_sin39 = 16'b1111101000101010;
assign mux_in_cos40 = 16'b1111000111000111;
assign mux_in_sin40 = 16'b1111101010011011;
assign mux_in_cos41 = 16'b1111000100011111;
assign mux_in_sin41 = 16'b1111101100001001;
assign mux_in_cos42 = 16'b1111000001110011;
assign mux_in_sin42 = 16'b1111101101110010;
assign mux_in_cos43 = 16'b1110111110001100;
assign mux_in_sin43 = 16'b1111101111011000;
assign mux_in_cos44 = 16'b1110111000101100;
assign mux_in_sin44 = 16'b1111110000111001;
assign mux_in_cos45 = 16'b1110110011000111;
assign mux_in_sin45 = 16'b1111110010010101;
assign mux_in_cos46 = 16'b1110101101011101;
assign mux_in_sin46 = 16'b1111110011101101;
assign mux_in_cos47 = 16'b1110100111110000;
assign mux_in_sin47 = 16'b1111110101000001;
assign mux_in_cos48 = 16'b1110100001111110;
assign mux_in_sin48 = 16'b1111110110010000;
assign mux_in_cos49 = 16'b1110011100001001;
assign mux_in_sin49 = 16'b1111110111011011;
assign mux_in_cos50 = 16'b1110010110010000;
assign mux_in_sin50 = 16'b1111111000100001;
assign mux_in_cos51 = 16'b1110010000010100;
assign mux_in_sin51 = 16'b1111111001100010;
assign mux_in_cos52 = 16'b1110001010010100;
assign mux_in_sin52 = 16'b1111111010011111;
assign mux_in_cos53 = 16'b1110000100010010;
assign mux_in_sin53 = 16'b1111111011010111;
assign mux_in_cos54 = 16'b1101111100011010;
assign mux_in_sin54 = 16'b1111111100001010;
assign mux_in_cos55 = 16'b1101110000001100;
assign mux_in_sin55 = 16'b1111111100111001;
assign mux_in_cos56 = 16'b1101100011111010;
assign mux_in_sin56 = 16'b1111111101100010;
assign mux_in_cos57 = 16'b1101010111100010;
assign mux_in_sin57 = 16'b1111111110000111;
assign mux_in_cos58 = 16'b1101001011001000;
assign mux_in_sin58 = 16'b1111111110100111;
assign mux_in_cos59 = 16'b1100111101011000;
assign mux_in_sin59 = 16'b1111111111000010;
assign mux_in_cos60 = 16'b1100100100011000;
assign mux_in_sin60 = 16'b1111111111011000;
assign mux_in_cos61 = 16'b1100001011011000;
assign mux_in_sin61 = 16'b1111111111101010;
assign mux_in_cos62 = 16'b1011100100100000;
assign mux_in_sin62 = 16'b1111111111110110;
assign mux_in_cos63 = 16'b1010100100100000;
assign mux_in_sin63 = 16'b1111111111111101;
assign mux_in_cos64 = 16'b0000000000000000;
assign mux_in_sin64 = 16'b0000000000000000;

// Sine LUTs

    always @ (*)
    begin
        case(x_in1)
        7'b0000000 : logsin1 = mux_in_sin0;
        7'b0000001 : logsin1 = mux_in_sin1;
        7'b0000010 : logsin1 = mux_in_sin2;
        7'b0000011 : logsin1 = mux_in_sin3;
        7'b0000100 : logsin1 = mux_in_sin4;
        7'b0000101 : logsin1 = mux_in_sin5;
        7'b0000110 : logsin1 = mux_in_sin6;
        7'b0000111 : logsin1 = mux_in_sin7;
        7'b0001000 : logsin1 = mux_in_sin8;
        7'b0001001 : logsin1 = mux_in_sin9;
        7'b0001010 : logsin1 = mux_in_sin10;
        7'b0001011 : logsin1 = mux_in_sin11;
        7'b0001100 : logsin1 = mux_in_sin12;
        7'b0001101 : logsin1 = mux_in_sin13;
        7'b0001110 : logsin1 = mux_in_sin14;
        7'b0001111 : logsin1 = mux_in_sin15;
        7'b0010000 : logsin1 = mux_in_sin16;
        7'b0010001 : logsin1 = mux_in_sin17;
        7'b0010010 : logsin1 = mux_in_sin18;
        7'b0010011 : logsin1 = mux_in_sin19;
        7'b0010100 : logsin1 = mux_in_sin20;
        7'b0010101 : logsin1 = mux_in_sin21;
        7'b0010110 : logsin1 = mux_in_sin22;
        7'b0010111 : logsin1 = mux_in_sin23;
        7'b0011000 : logsin1 = mux_in_sin24;
        7'b0011001 : logsin1 = mux_in_sin25;
        7'b0011010 : logsin1 = mux_in_sin26;
        7'b0011011 : logsin1 = mux_in_sin27;
        7'b0011100 : logsin1 = mux_in_sin28;
        7'b0011101 : logsin1 = mux_in_sin29;
        7'b0011110 : logsin1 = mux_in_sin30;
        7'b0011111 : logsin1 = mux_in_sin31;
        7'b0100000 : logsin1 = mux_in_sin32;
        7'b0100001 : logsin1 = mux_in_sin33;
        7'b0100010 : logsin1 = mux_in_sin34;
        7'b0100011 : logsin1 = mux_in_sin35;
        7'b0100100 : logsin1 = mux_in_sin36;
        7'b0100101 : logsin1 = mux_in_sin37;
        7'b0100110 : logsin1 = mux_in_sin38;
        7'b0100111 : logsin1 = mux_in_sin39;
        7'b0101000 : logsin1 = mux_in_sin40;
        7'b0101001 : logsin1 = mux_in_sin41;
        7'b0101010 : logsin1 = mux_in_sin42;
        7'b0101011 : logsin1 = mux_in_sin43;
        7'b0101100 : logsin1 = mux_in_sin44;
        7'b0101101 : logsin1 = mux_in_sin45;
        7'b0101110 : logsin1 = mux_in_sin46;
        7'b0101111 : logsin1 = mux_in_sin47;
        7'b0110000 : logsin1 = mux_in_sin48;
        7'b0110001 : logsin1 = mux_in_sin49;
        7'b0110010 : logsin1 = mux_in_sin50;
        7'b0110011 : logsin1 = mux_in_sin51;
        7'b0110100 : logsin1 = mux_in_sin52;
        7'b0110101 : logsin1 = mux_in_sin53;
        7'b0110110 : logsin1 = mux_in_sin54;
        7'b0110111 : logsin1 = mux_in_sin55;
        7'b0111000 : logsin1 = mux_in_sin56;
        7'b0111001 : logsin1 = mux_in_sin57;
        7'b0111010 : logsin1 = mux_in_sin58;
        7'b0111011 : logsin1 = mux_in_sin59;
        7'b0111100 : logsin1 = mux_in_sin60;
        7'b0111101 : logsin1 = mux_in_sin61;
        7'b0111110 : logsin1 = mux_in_sin62;
        7'b0111111 : logsin1 = mux_in_sin63;
        7'b1000000 : logsin1 = mux_in_sin64;
        default: logsin1 = 15'bx;
        endcase
    end

    //Cos LUTs
    always @ (*)
    begin
        case(x_in1)
        7'b0000000 : logcos1 = mux_in_cos0;
        7'b0000001 : logcos1 = mux_in_cos1;
        7'b0000010 : logcos1 = mux_in_cos2;
        7'b0000011 : logcos1 = mux_in_cos3;
        7'b0000100 : logcos1 = mux_in_cos4;
        7'b0000101 : logcos1 = mux_in_cos5;
        7'b0000110 : logcos1 = mux_in_cos6;
        7'b0000111 : logcos1 = mux_in_cos7;
        7'b0001000 : logcos1 = mux_in_cos8;
        7'b0001001 : logcos1 = mux_in_cos9;
        7'b0001010 : logcos1 = mux_in_cos10;
        7'b0001011 : logcos1 = mux_in_cos11;
        7'b0001100 : logcos1 = mux_in_cos12;
        7'b0001101 : logcos1 = mux_in_cos13;
        7'b0001110 : logcos1 = mux_in_cos14;
        7'b0001111 : logcos1 = mux_in_cos15;
        7'b0010000 : logcos1 = mux_in_cos16;
        7'b0010001 : logcos1 = mux_in_cos17;
        7'b0010010 : logcos1 = mux_in_cos18;
        7'b0010011 : logcos1 = mux_in_cos19;
        7'b0010100 : logcos1 = mux_in_cos20;
        7'b0010101 : logcos1 = mux_in_cos21;
        7'b0010110 : logcos1 = mux_in_cos22;
        7'b0010111 : logcos1 = mux_in_cos23;
        7'b0011000 : logcos1 = mux_in_cos24;
        7'b0011001 : logcos1 = mux_in_cos25;
        7'b0011010 : logcos1 = mux_in_cos26;
        7'b0011011 : logcos1 = mux_in_cos27;
        7'b0011100 : logcos1 = mux_in_cos28;
        7'b0011101 : logcos1 = mux_in_cos29;
        7'b0011110 : logcos1 = mux_in_cos30;
        7'b0011111 : logcos1 = mux_in_cos31;
        7'b0100000 : logcos1 = mux_in_cos32;
        7'b0100001 : logcos1 = mux_in_cos33;
        7'b0100010 : logcos1 = mux_in_cos34;
        7'b0100011 : logcos1 = mux_in_cos35;
        7'b0100100 : logcos1 = mux_in_cos36;
        7'b0100101 : logcos1 = mux_in_cos37;
        7'b0100110 : logcos1 = mux_in_cos38;
        7'b0100111 : logcos1 = mux_in_cos39;
        7'b0101000 : logcos1 = mux_in_cos40;
        7'b0101001 : logcos1 = mux_in_cos41;
        7'b0101010 : logcos1 = mux_in_cos42;
        7'b0101011 : logcos1 = mux_in_cos43;
        7'b0101100 : logcos1 = mux_in_cos44;
        7'b0101101 : logcos1 = mux_in_cos45;
        7'b0101110 : logcos1 = mux_in_cos46;
        7'b0101111 : logcos1 = mux_in_cos47;
        7'b0110000 : logcos1 = mux_in_cos48;
        7'b0110001 : logcos1 = mux_in_cos49;
        7'b0110010 : logcos1 = mux_in_cos50;
        7'b0110011 : logcos1 = mux_in_cos51;
        7'b0110100 : logcos1 = mux_in_cos52;
        7'b0110101 : logcos1 = mux_in_cos53;
        7'b0110110 : logcos1 = mux_in_cos54;
        7'b0110111 : logcos1 = mux_in_cos55;
        7'b0111000 : logcos1 = mux_in_cos56;
        7'b0111001 : logcos1 = mux_in_cos57;
        7'b0111010 : logcos1 = mux_in_cos58;
        7'b0111011 : logcos1 = mux_in_cos59;
        7'b0111100 : logcos1 = mux_in_cos60;
        7'b0111101 : logcos1 = mux_in_cos61;
        7'b0111110 : logcos1 = mux_in_cos62;
        7'b0111111 : logcos1 = mux_in_cos63;
        7'b1000000 : logcos1 = mux_in_cos64;
        default: logcos1 = 15'bx;
        endcase
    end


endmodule