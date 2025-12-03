`timescale 1ns / 1ps
module DelayUnit#(parameter WIDTH = 1) (clk,reset,Data_in,Delay_out); 
	input	clk,reset; 
	input	[WIDTH-1:0] Data_in; 
	output	[WIDTH-1:0] Delay_out; 
 
	reg [WIDTH-1:0] Delay_out; 
 
	always @(posedge clk ) 
           begin 
		if (reset ==1'b1) 
                    begin 
			Delay_out <= 0; 
		    end 
		else 
                    begin 
			 Delay_out <= Data_in; 
		    end 
	   end 
endmodule
