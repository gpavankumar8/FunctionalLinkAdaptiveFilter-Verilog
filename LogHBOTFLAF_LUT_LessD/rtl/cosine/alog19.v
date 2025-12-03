`timescale 1ns / 1ps

module alog19(
    input signed [18:0] data,
    output reg [19:0] adata
    );

wire [12:0] fraction;

assign fraction = {1'b1 ,data[11:0]};

always @ (*)
  begin
  case (data[18:12])
    7'b000_0000  : adata = {fraction[12:0],7'b0};   //(1,19) FORMAT
    7'b111_1111  : adata = {1'b0,fraction[12:0],6'b0};
    7'b111_1110  : adata = {2'b0,fraction[12:0],5'b0}; 
    7'b111_1101  : adata = {3'b0,fraction[12:0],4'b0};
    7'b111_1100  : adata = {4'b0,fraction[12:0],3'b0};
    7'b111_1011  : adata = {5'b0,fraction[12:0],2'b0};
    7'b111_1010  : adata = {6'b0,fraction[12:0],1'b0};
    7'b111_1001  : adata = {7'b0,fraction[12:0]};
    7'b111_1000  : adata = {8'b0,fraction[12:1]};
    7'b111_0111  : adata = {9'b0,fraction[12:2]};
    7'b111_0110  : adata = {10'b0,fraction[12:3]};
    7'b111_0101  : adata = {11'b0,fraction[12:4]};
    7'b111_0100  : adata = {12'b0,fraction[12:5]};
    7'b111_0011  : adata = {13'b0,fraction[12:6]};
    7'b111_0010  : adata = {14'b0,fraction[12:7]};
    7'b111_0001  : adata = {15'b0,fraction[12:8]};
    7'b111_0000  : adata = {16'b0,fraction[12:9]};
    7'b110_1111  : adata = {17'b0,fraction[12:10]};
    7'b110_1110  : adata = {18'b0,fraction[12:11]};
    7'b110_1101  : adata = {19'b0,fraction[12]};
    default : adata = 20'b0;
  endcase
 end

endmodule
