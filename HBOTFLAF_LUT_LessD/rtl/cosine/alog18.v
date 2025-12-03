`timescale 1ns / 1ps

module alog18(
    input signed [17:0] data,
    output reg [18:0] adata
    );

wire [12:0] fraction;

assign fraction = {1'b1 ,data[11:0]};

always @ (*)
  begin
  case (data[17:12])
    6'b000000  : adata = {fraction[12:0],6'b0};   //(1,18) FORMAT
    6'b111111  : adata = {1'b0,fraction[12:0],5'b0};
    6'b111110  : adata = {2'b0,fraction[12:0],4'b0}; 
    6'b111101  : adata = {3'b0,fraction[12:0],3'b0};
    6'b111100  : adata = {4'b0,fraction[12:0],2'b0};
    6'b111011  : adata = {5'b0,fraction[12:0],1'b0};
    6'b111010  : adata = {6'b0,fraction[12:0]};
    6'b111001  : adata = {7'b0,fraction[12:1]};
    6'b111000  : adata = {8'b0,fraction[12:2]};
    6'b110111  : adata = {9'b0,fraction[12:3]};
    6'b110110  : adata = {10'b0,fraction[12:4]};
    6'b110101  : adata = {11'b0,fraction[12:5]};
    6'b110100  : adata = {12'b0,fraction[12:6]};
    6'b110011  : adata = {13'b0,fraction[12:7]};
    6'b110010  : adata = {14'b0,fraction[12:8]};
    6'b110001  : adata = {15'b0,fraction[12:9]};
    6'b110000  : adata = {16'b0,fraction[12:10]};
    6'b101111  : adata = {17'b0,fraction[12:11]};
    6'b101110  : adata = {18'b0,fraction[12:12]};
    default : adata = 19'b0;
  endcase
 end

endmodule
