`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2020 09:53:30 PM
// Design Name: 
// Module Name: mux4x1_16b
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


module mux4x1_16b(
    input [15:0] i0,
    input [15:0] i1,
    input [15:0] i2,
    input [15:0] i3,
    input [1:0] s,
    output [15:0] y
    );
assign y = s[1]?(s[0]?i3:i2):(s[0]?i1:i0);   
endmodule
