`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-07-2024
// Module name: log_sin_cos_LUT_5QP.v
//////////////////////////////////////////////////////////////////////////////////

module log_sin_cos_LUT_5QP
(
    input      [ 4:0] x_in1, x_in2, x_in3,
    output reg [15:0] logsin1, logsin2, logsin3, logcos1, logcos2, logcos3
);

    wire [15:0] mux_in_cos0, mux_in_sin0, mux_in_cos1, mux_in_sin1, mux_in_cos2, mux_in_sin2, mux_in_cos3, mux_in_sin3, mux_in_cos4, mux_in_sin4, mux_in_cos5, mux_in_sin5, mux_in_cos6, mux_in_sin6, mux_in_cos7, mux_in_sin7, mux_in_cos8, mux_in_sin8, mux_in_cos9, mux_in_sin9, mux_in_cos10, mux_in_sin10, mux_in_cos11, mux_in_sin11, mux_in_cos12, mux_in_sin12, mux_in_cos13, mux_in_sin13, mux_in_cos14, mux_in_sin14, mux_in_cos15, mux_in_sin15, mux_in_cos16, mux_in_sin16;

    assign mux_in_cos0 = 16'b0000000000000000;
    assign mux_in_sin0 = 16'b0000000000000000;
    assign mux_in_cos1 = 16'b1111111111100011;
    assign mux_in_sin1 = 16'b1100101001100011;
    assign mux_in_cos2 = 16'b1111111110001101;
    assign mux_in_sin2 = 16'b1101101001000111;
    assign mux_in_cos3 = 16'b1111111011111100;
    assign mux_in_sin3 = 16'b1110001101110011;
    assign mux_in_cos4 = 16'b1111111000101100;
    assign mux_in_sin4 = 16'b1110100111010100;
    assign mux_in_cos5 = 16'b1111110100011001;
    assign mux_in_sin5 = 16'b1110111010100100;
    assign mux_in_cos6 = 16'b1111101110111101;
    assign mux_in_sin6 = 16'b1111001001101111;
    assign mux_in_cos7 = 16'b1111101000001111;
    assign mux_in_sin7 = 16'b1111010101111111;
    assign mux_in_cos8 = 16'b1111100000000000;
    assign mux_in_sin8 = 16'b1111100000000000;
    assign mux_in_cos9 = 16'b1111010101111111;
    assign mux_in_sin9 = 16'b1111101000001111;
    assign mux_in_cos10 = 16'b1111001001101111;
    assign mux_in_sin10 = 16'b1111101110111101;
    assign mux_in_cos11 = 16'b1110111010100100;
    assign mux_in_sin11 = 16'b1111110100011001;
    assign mux_in_cos12 = 16'b1110100111010100;
    assign mux_in_sin12 = 16'b1111111000101100;
    assign mux_in_cos13 = 16'b1110001101110011;
    assign mux_in_sin13 = 16'b1111111011111100;
    assign mux_in_cos14 = 16'b1101101001000111;
    assign mux_in_sin14 = 16'b1111111110001101;
    assign mux_in_cos15 = 16'b1100101001100011;
    assign mux_in_sin15 = 16'b1111111111100011;
    assign mux_in_cos16 = 16'b0000000000000000;
    assign mux_in_sin16 = 16'b0000000000000000;

    always @ (*)
    begin
        case(x_in1)
        5'b00000 : logsin1 = mux_in_sin0;
        5'b00001 : logsin1 = mux_in_sin1;
        5'b00010 : logsin1 = mux_in_sin2;
        5'b00011 : logsin1 = mux_in_sin3;
        5'b00100 : logsin1 = mux_in_sin4;
        5'b00101 : logsin1 = mux_in_sin5;
        5'b00110 : logsin1 = mux_in_sin6;
        5'b00111 : logsin1 = mux_in_sin7;
        5'b01000 : logsin1 = mux_in_sin8;
        5'b01001 : logsin1 = mux_in_sin9;
        5'b01010 : logsin1 = mux_in_sin10;
        5'b01011 : logsin1 = mux_in_sin11;
        5'b01100 : logsin1 = mux_in_sin12;
        5'b01101 : logsin1 = mux_in_sin13;
        5'b01110 : logsin1 = mux_in_sin14;
        5'b01111 : logsin1 = mux_in_sin15;
        5'b10000 : logsin1 = mux_in_sin16;
        default: logsin1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        5'b00000 : logsin2 = mux_in_sin0;
        5'b00001 : logsin2 = mux_in_sin1;
        5'b00010 : logsin2 = mux_in_sin2;
        5'b00011 : logsin2 = mux_in_sin3;
        5'b00100 : logsin2 = mux_in_sin4;
        5'b00101 : logsin2 = mux_in_sin5;
        5'b00110 : logsin2 = mux_in_sin6;
        5'b00111 : logsin2 = mux_in_sin7;
        5'b01000 : logsin2 = mux_in_sin8;
        5'b01001 : logsin2 = mux_in_sin9;
        5'b01010 : logsin2 = mux_in_sin10;
        5'b01011 : logsin2 = mux_in_sin11;
        5'b01100 : logsin2 = mux_in_sin12;
        5'b01101 : logsin2 = mux_in_sin13;
        5'b01110 : logsin2 = mux_in_sin14;
        5'b01111 : logsin2 = mux_in_sin15;
        5'b10000 : logsin2 = mux_in_sin16;
        default: logsin2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        5'b00000 : logsin3 = mux_in_sin0;
        5'b00001 : logsin3 = mux_in_sin1;
        5'b00010 : logsin3 = mux_in_sin2;
        5'b00011 : logsin3 = mux_in_sin3;
        5'b00100 : logsin3 = mux_in_sin4;
        5'b00101 : logsin3 = mux_in_sin5;
        5'b00110 : logsin3 = mux_in_sin6;
        5'b00111 : logsin3 = mux_in_sin7;
        5'b01000 : logsin3 = mux_in_sin8;
        5'b01001 : logsin3 = mux_in_sin9;
        5'b01010 : logsin3 = mux_in_sin10;
        5'b01011 : logsin3 = mux_in_sin11;
        5'b01100 : logsin3 = mux_in_sin12;
        5'b01101 : logsin3 = mux_in_sin13;
        5'b01110 : logsin3 = mux_in_sin14;
        5'b01111 : logsin3 = mux_in_sin15;
        5'b10000 : logsin3 = mux_in_sin16;
        default: logsin3 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in1)
        5'b00000 : logcos1 = mux_in_cos0;
        5'b00001 : logcos1 = mux_in_cos1;
        5'b00010 : logcos1 = mux_in_cos2;
        5'b00011 : logcos1 = mux_in_cos3;
        5'b00100 : logcos1 = mux_in_cos4;
        5'b00101 : logcos1 = mux_in_cos5;
        5'b00110 : logcos1 = mux_in_cos6;
        5'b00111 : logcos1 = mux_in_cos7;
        5'b01000 : logcos1 = mux_in_cos8;
        5'b01001 : logcos1 = mux_in_cos9;
        5'b01010 : logcos1 = mux_in_cos10;
        5'b01011 : logcos1 = mux_in_cos11;
        5'b01100 : logcos1 = mux_in_cos12;
        5'b01101 : logcos1 = mux_in_cos13;
        5'b01110 : logcos1 = mux_in_cos14;
        5'b01111 : logcos1 = mux_in_cos15;
        5'b10000 : logcos1 = mux_in_cos16;
        default: logcos1 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in2)
        5'b00000 : logcos2 = mux_in_cos0;
        5'b00001 : logcos2 = mux_in_cos1;
        5'b00010 : logcos2 = mux_in_cos2;
        5'b00011 : logcos2 = mux_in_cos3;
        5'b00100 : logcos2 = mux_in_cos4;
        5'b00101 : logcos2 = mux_in_cos5;
        5'b00110 : logcos2 = mux_in_cos6;
        5'b00111 : logcos2 = mux_in_cos7;
        5'b01000 : logcos2 = mux_in_cos8;
        5'b01001 : logcos2 = mux_in_cos9;
        5'b01010 : logcos2 = mux_in_cos10;
        5'b01011 : logcos2 = mux_in_cos11;
        5'b01100 : logcos2 = mux_in_cos12;
        5'b01101 : logcos2 = mux_in_cos13;
        5'b01110 : logcos2 = mux_in_cos14;
        5'b01111 : logcos2 = mux_in_cos15;
        5'b10000 : logcos2 = mux_in_cos16;
        default: logcos2 = 15'bx;
        endcase
    end

    always @ (*)
    begin
        case(x_in3)
        5'b00000 : logcos3 = mux_in_cos0;
        5'b00001 : logcos3 = mux_in_cos1;
        5'b00010 : logcos3 = mux_in_cos2;
        5'b00011 : logcos3 = mux_in_cos3;
        5'b00100 : logcos3 = mux_in_cos4;
        5'b00101 : logcos3 = mux_in_cos5;
        5'b00110 : logcos3 = mux_in_cos6;
        5'b00111 : logcos3 = mux_in_cos7;
        5'b01000 : logcos3 = mux_in_cos8;
        5'b01001 : logcos3 = mux_in_cos9;
        5'b01010 : logcos3 = mux_in_cos10;
        5'b01011 : logcos3 = mux_in_cos11;
        5'b01100 : logcos3 = mux_in_cos12;
        5'b01101 : logcos3 = mux_in_cos13;
        5'b01110 : logcos3 = mux_in_cos14;
        5'b01111 : logcos3 = mux_in_cos15;
        5'b10000 : logcos3 = mux_in_cos16;
        default: logcos3 = 15'bx;
        endcase
    end
endmodule