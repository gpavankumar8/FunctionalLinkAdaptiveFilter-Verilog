Readme
------

Synthesizable RTL Verilog code for the trigonometric functional link adaptive filter (TFLAF) and the Hammerstein block-oriented TFLAF (HBO-TFLAF). Code accompanying the following Springer CSSP paper "High-throughput and Area-efficient VLSI Architectures for Functional Link Adaptive Filters."

This repo consists of the RTL and test bench files of the following designs

1. TFLAF_LUT
2. HBOTFLAF_LUT_LessD
3. LogTFLAF_LUT
4. LogHBOTFLAF_LUT_LessD

The test bench and its inputs are available in the simulation folder. Multiple test inputs are available in `LogHBOTFLAF_LUT_LessD` folder.

Instructions to run simulation
------------------------------

* Run the test bench using simulator of choice. 
* The outputs are written to the outputs folder.
* Plot the error using `plot_rtl_mse.m` MATLAB file. Ensure file paths are updated correctly.

