`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:59:06 04/19/2016
// Design Name:   fp_converter
// Module Name:   C:/Users/152/Desktop/floating_point_conversion/fp_converter_TB.v
// Project Name:  floating_point_conversion
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fp_converter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fp_converter_TB;

	// Inputs
	reg [11:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [3:0] F;

	// Instantiate the Unit Under Test (UUT)
	fp_converter uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = -40;
		#100;
		D =0;
		#100;
		D = 125;
		#100;
		D = 44;
		#100;
		D = 56;
		#100;
		D = 422;
		#100;
	end
      
endmodule

