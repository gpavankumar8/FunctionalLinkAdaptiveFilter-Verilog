`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Pavan Kumar
// Create Date: 29-08-2022
// Module name: sin_taylor_approx.v
//////////////////////////////////////////////////////////////////////////////////


module sin_taylor_approx_pip(
    input [16:0] theta,
    input clk,reset,
    output signed [15:0] sin_theta
    );
wire  [15:0] pi = 16'h3244;    //pi  (int_part= 4bits, frac_part=12bits)
wire  [15:0] pib2 = 16'h1922;  //pi/2
wire  [15:0] pi3b2 = 16'h4b66; // 3pi/2
wire  [15:0] pim2 = 16'h6487;  //2pi
wire  [18:0] log24 =  19'h0495c; 
wire sign,sign2d,signd,sign_quadrant,valid;
wire [4:0] log_int;

wire signed [17:0] mul2,P,Pd;
wire signed [18:0] Q,mul4,Qd;
wire signed [5:0] int_mod1,int_mod2;
wire [11:0] log_frac;
wire [15:0] i0,i1,i2,i3,i0_tmp1,i0_tmp2,i1_tmp1,i1_tmp2,theta_tmp,theta_tmpd,th;
wire [16:0] th_abs;
wire [3:0] cy;
wire [18:0] p_t;
wire [19:0] q_t;
wire signed [19:0] cos_tmp1,cos_tmp2;
wire [15:0] theta_d;
wire signed[15:0] cos_theta,cos_theta_t;

//DelayUnit#16 th_d1(.clk(clk),.reset(reset),.Data_in(theta),.Delay_out(theta_d));
//assign th = theta_d[15]? (({16{1'b1}}^theta_d)+1'b1): theta_d;

assign th_abs = theta[16]? (({17{1'b1}}^theta)+1'b1): theta;
assign th = (th_abs > pim2) ? (th_abs - pim2) : th_abs;

assign {cy[0],i0} = pib2 - th;
assign {cy[1],i1} = pi3b2 - th;
assign {cy[2],i2} = pi-th;
// assign {cy[3],i3} = pim2 - th;

assign i0_tmp1 = i0 ^({16{cy[0]}});
assign i0_tmp2 = i0_tmp1+{15'b0,cy[0]};

assign i1_tmp1 = i1 ^({16{cy[1]}});
assign i1_tmp2 = i1_tmp1+{15'b0,cy[1]};

//assign sign = ~cy[1];
// mux4x1_1b m1(.i0(1'b0),.i1(1'b0),.i2(1'b1),.i3(1'b1),.s({cy[1],cy[0]}),.y(sign_quadrant));
// mux4x1_16b m2(.i0(i0_tmp2),.i1(i0_tmp2),.i2(i1_tmp2),.i3(i1_tmp2),.s({cy[1],cy[0]}),.y(theta_tmp));
 
assign sign_quadrant = cy[2] ? 1 : 0;
assign theta_tmp = cy[2] ? i1_tmp2 : i0_tmp2;

DelayUnit#16 cos_am_d(.clk(clk),.reset(reset),.Data_in(theta_tmp),.Delay_out(theta_tmpd));  // delay for pipeline

log_16 log1(.data(theta_tmpd),.intgr(log_int),.valid(valid),.fraction(log_frac));  //(5,12) data format

assign mul2 = {log_int,log_frac[11:0],1'b0}; //INTEGER PART 6 bits , frac = 12 bits 
assign mul4 = {log_int,log_frac[11:0],2'b0}; // (7,12)

assign P = mul2 - 18'h01000;  //(6,12)
assign Q = mul4 - log24;      //(7,12)

DelayUnit#18 cos_d1(.clk(clk),.reset(reset),.Data_in(P),.Delay_out(Pd));  // delay for pipeline
DelayUnit#19 cos_d2(.clk(clk),.reset(reset),.Data_in(Q),.Delay_out(Qd));  // delay for pipeline

alog18 alog1(.data(Pd),.adata(p_t));   //(1,18)                                          
alog19 alog2(.data(Qd),.adata(q_t));   //(1,19)

// alog18 alog1(.data(P),.adata(p_t));   //(1,18)                                          
// alog19 alog2(.data(Q),.adata(q_t));   //(1,19)

assign  cos_tmp1 = q_t - {p_t,1'b0}; //(1,19)
assign cos_tmp2  = 20'h7ffff + cos_tmp1; 


// conditional 2's complement for sign correction
assign sign = sign_quadrant^theta[16];

DelayUnit#1 sign_d(.clk(clk),.reset(reset),.Data_in(sign),.Delay_out(signd));  // delay for pipeline
DelayUnit#1 sign_2d(.clk(clk),.reset(reset),.Data_in(signd),.Delay_out(sign2d));  // delay for pipeline

assign cos_theta = ({16{sign2d}} ^ cos_tmp2[19:4]) + {15'd0,sign2d};

assign sin_theta = cos_theta;
//assign cos_theta_t = ({16{sign}} ^ cos_tmp2[19:4]) + {15'd0,sign};
//DelayUnit#16 cos_d3(.clk(clk),.reset(reset),.Data_in(cos_theta_t),.Delay_out(cos_theta));


endmodule



