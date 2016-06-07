`timescale 1ns / 1ps

module stopwatch_tb;

	// Inputs
	reg reset;
	reg pause;
	reg [1:0] adjust;
	reg select;
	reg clk;
	reg clk_adj;

	// Outputs
	wire [3:0] min0;
	wire [3:0] min1;
	wire [3:0] sec0;
	wire [3:0] sec1;
	
	wire clock;

	select_clock sel_clock_uut (
		.clk(clk),
		.clk_adj(clk_adj),
		.adjust(adjust),
		.clock(clock)
	);

	// Instantiate the Unit Under Test (UUT)
	counter counter_uut (
		.reset(reset), 
		.pause(pause), 
		.adjust(adjust), 
		.select(select), 
		.clk(clk), 
		.clk_adj(clk_adj), 
		.min0(min0), 
		.min1(min1), 
		.sec0(sec0), 
		.sec1(sec1)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		#100
		pause = 0;
		adjust = 0;
		select = 0;
		clk = 0;
		clk_adj = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
	end

	always begin
		#10 clk = ~clk;
	end
	
	always begin
		#5 clk_adj = ~clk_adj;
	end

	initial begin
		// Add stimulus here
		
		// regular clock mode
		adjust = 0;
		
		#200
		
		// positive adjust mode, minutes
		adjust = 1;	
		select = 0;
		#200 
		
		// positive adjust mode, seconds
		select = 1;
		#200
		
		// negative adjust mode, minutes
		adjust = 2;
		select = 0;
		#200
		
		// negative adjust mode, seconds
		select = 1;
		#200
		
		pause = 1;
		#200
		
		pause = 0;
		reset = 1;
		#10
		reset = 0;
		adjust = 0;
		select = 0;
		#400; $finish;
	end
      
endmodule

