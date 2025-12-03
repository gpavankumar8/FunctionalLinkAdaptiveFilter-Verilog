`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2020 11:35:17
// Design Name: 
// Module Name: mux4x1_1b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux4x1_1b(
    input  i0,
    input  i1,
    input  i2,
    input  i3,
    input [1:0] s,
    output  y
    );
assign y = s[1]?(s[0]?i3:i2):(s[0]?i1:i0);   
endmodule

