module test( input clk,
	     input reset,
	     input mu_a_error,
	     input weight_pip_prod,
	    output a_weight );

	wire mu_a_error_d, weight_pip_prod_d, a_weight;

	DelayNUnit #(16, 1) IN_PIP1( clk, reset, mu_a_error, mu_a_error_d);
	DelayNUnit #(16, 1) IN_PIP2( clk, reset, weight_pip_prod, weight_pip_prod_d);
	w_update_d #(16, 12) A_WUB0( clk, reset, mu_a_error_d, weight_pip_prod_d, a_weight); 

endmodule
