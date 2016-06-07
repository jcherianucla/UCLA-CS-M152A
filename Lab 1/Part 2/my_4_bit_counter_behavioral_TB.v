`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:03:11 04/07/2016
// Design Name:   my_4_bit_counter_behavioral
// Module Name:   /home/jahancherian/Desktop/UCLA/CSM152A/lab1/part2/my_4_bit_counter_behavioral_TB.v
// Project Name:  csm152a_lab1_behavioral_counter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: my_4_bit_counter_behavioral
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module my_4_bit_counter_behavioral_TB;

	// Inputs
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	my_4_bit_counter_behavioral uut (
		.clk(clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		// Wait 100 ns for global reset to finish
		#100;
		repeat(4) #10 clk = ~clk;
		// Add stimulus here
		#10 rst = 0;
		forever #5 clk = ~clk;

		#1000 $finish;

	end
      
endmodule

