`timescale 1ns / 1ps

module log1_16(
input [15:0] data,
output [3:0] pos,
output valid,
output reg [11:0] fraction);

wire [1:0] pos0, pos1, pos2, pos3;
wire [2:0] pos_1_1, pos_1_2;
// wire [3:0] pos;
// reg [11:0] fraction;
wire valid1, valid0,valid2,valid3,valid1_1,valid1_2;

lod_4 lod_4_1(.data1(data[15:12]),.pos(pos0), .valid(valid0));
lod_4 lod_4_2(.data1(data[11:8]),.pos(pos1), .valid(valid1));
lod_4 lod_4_3(.data1(data[7:4]),.pos(pos2), .valid(valid2));
lod_4 lod_4_4(.data1(data[3:0]),.pos(pos3), .valid(valid3));

lod_8#(1) lod_8_1(.pos0(pos0),.pos1(pos1),.valid0(valid0),.valid1(valid1),.pos(pos_1_1), .valid(valid1_1));
lod_8#(1) lod_8_2(.pos0(pos2),.pos1(pos3),.valid0(valid2),.valid1(valid3),.pos(pos_1_2), .valid(valid1_2));
lod_8#(2) lod_8_3(.pos0(pos_1_1),.pos1(pos_1_2),.valid0(valid1_1),.valid1(valid1_2),.pos(pos), .valid(valid));

 always @ (*) 
  begin 
  case (pos)
   4'd15 : fraction = {data[14:3]};        // Truncating
   4'd14 : fraction = {data[13:2]};        // the top
   4'd13 : fraction = {data[12:1]};        // four entries
   4'd12 : fraction = {data[11:0]};        // to 12 bit
    4'd11 : fraction = {data[10:0],1'b0};
    4'd10 : fraction = {data[9:0],2'b0};
    4'd9  : fraction = {data[8:0],3'b0};
    4'd8  : fraction = {data[7:0],4'b0};
    4'd7  : fraction = {data[6:0],5'b0};
    4'd6  : fraction = {data[5:0],6'b0};
    4'd5  : fraction = {data[4:0],7'b0};
    4'd4  : fraction = {data[3:0],8'b0};
    4'd3  : fraction = {data[2:0],9'b0};
    4'd2  : fraction = {data[1:0],10'b0};
    4'd1  : fraction = {data[0:0],11'b0};
    4'd0  : fraction = {12'b0};
    default : fraction = 1'bx;
  endcase 
 end


 
endmodule
