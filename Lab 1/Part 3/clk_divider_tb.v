module clk_divider_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire new_clk;

	// Instantiate the Unit Under Test (UUT)
	clk_divider uut (
		.clk(clk), 
		.rst(rst), 
		.new_clk(new_clk)
	);

	initial begin
		clk = 0;
		rst = 1;

		#100;
		rst = 0;
		#100;
	end
	
	always 
      #10 clk = ~clk;
endmodule
