`timescale 1ns / 1ps

// ============================================================================== 
// 										  Define Module
// ==============================================================================
module top_module(
	// joystick
	input clk,
	input rst,
	input hs, // highscore signal
	input hs_rst, // highscore reset
	input MISO,
	//SW,
	output wire SS,
	output wire MOSI,
	output wire SCLK,
	
	// seven-segment display
	output wire [7:0] Led,
	output wire [3:0] AN,
	output wire [6:0] SEG,

	// VGA
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync			//vertical sync out
	);

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================

			// Holds data to be sent to PmodJSTK
			wire [7:0] sndData;

			// Signal to send/receive data to/from PmodJSTK
			wire sndRec;

			// Data read from PmodJSTK
			wire [39:0] jstkData;

			// Signal carrying output data that user selected
			wire [9:0] posData;

	// ===========================================================================
	// 										Implementation
	// ===========================================================================


			//-----------------------------------------------
			//  	  			PmodJSTK Interface
			//-----------------------------------------------
			PmodJSTK PmodJSTK_Int(
					.CLK(clk),
					.RST(rst),
					.sndRec(sndRec),
					.DIN(sndData),
					.MISO(MISO),
					.SS(SS),
					.SCLK(SCLK),
					.MOSI(MOSI),
					.DOUT(jstkData)
			);

			//-----------------------------------------------
			//  			 Send Receive Generator
			//-----------------------------------------------
			ClkDiv_5Hz genSndRec(
					.CLK(clk),
					.RST(rst),
					.CLKOUT(sndRec)
			);
			
			// Use state of switch 0 to select output of X position or Y position data to SSD
			assign posData = {jstkData[25:24], jstkData[39:32]};

	// Clocks
	wire pixel_clk;
	wire doodle_clk;
	wire platform_clk;
	wire points_clk;
	wire gravity_clk;
	
	wire rst_signal;
	wire hs_rst_signal;
	wire hs_signal;
	
	debouncer rst_debouncer (
		.clk(clk),
		.button(rst),
		.button_state(rst_signal)
	);
	
	debouncer hs_rst_debouncer(
		.clk(clk),
		.button(hs_rst),
		.button_state(hs_rst_signal)
	);
	
	debouncer hs_debouncer (
		.clk(clk),
		.button(hs),
		.button_state(hs_signal)
	);

	//Create the different clocks
	clockdiv divider(
		.clk(clk),
		.rst(rst_signal),
		.pixel_clk(pixel_clk),
		.doodle_clk(doodle_clk),
		.platform_clk(platform_clk),
		.points_clk(points_clk),
		.gravity_clk(gravity_clk)
		);
		
	//Lower left position of the doodle square
	wire [9:0] doo_x;
	wire [9:0] doo_y;
	
	//Vertical Positions for Platforms - These move upwards
	wire [9:0] p1_vpos; 
	wire [9:0] p2_vpos;
	wire [9:0] p3_vpos;
	wire [9:0] p4_vpos;
	wire [9:0] p5_vpos;
	wire [9:0] p6_vpos;
	wire [9:0] p7_vpos;
	
	//Horizontal Positions for Platforms - These are randomized
	wire [9:0] p1_hpos;
	wire [9:0] p2_hpos;
	wire [9:0] p3_hpos;
	wire [9:0] p4_hpos;
	wire [9:0] p5_hpos;
	wire [9:0] p6_hpos;
	wire [9:0] p7_hpos;
	
	//The horizontal position that is randomly set
	wire [9:0] new_hpos; 
	//Points
	wire terminated;	
	wire [31:0] points;

	points points_mod (
		.clk(points_clk),
		.rst(rst_signal),
		.hs_rst(hs_rst_signal),
		.d_y(doo_y),
		.terminated(terminated),
		.points(points)
	);

	wire [31:0] highscore;
	
	high_score highscore_mod (
		.clk(clk),
		.rst(hs_rst_signal),
		.points(points),
		.highscore(highscore)	
	);

	wire [31:0] value_to_display;

	// select whether to display points or highscore, depending on push button	
	select_display_value display_mux (
		.clk(clk),
		.hs(hs_signal),
		.points(points),
		.highscore(highscore),
		.val(value_to_display)
	);
	
	ssdCtrl points_display(
			.CLK(clk),
			.RST(rst_signal),
			.DIN(value_to_display),
			.AN(AN),
			.SEG(SEG)
	);

	//Generate random number for the random horizontal block
	lfsr_rand_generator rand_mod1 (
		.clk(clk),
		.rst(rst_signal),
		.rand_hpos(new_hpos)
	);

	//Set up the platforms in their positions, and for the blocks to move upwards
	platforms platforms_mod (
		.platform_clk(platform_clk),
		.rst(rst_signal),
		.new_hpos(new_hpos),
		.terminated(terminated),
		.p1_vpos(p1_vpos),
		.p2_vpos(p2_vpos),
		.p3_vpos(p3_vpos),
		.p4_vpos(p4_vpos),
		.p5_vpos(p5_vpos),
		.p6_vpos(p6_vpos),
		.p7_vpos(p7_vpos),
		.p1_hpos(p1_hpos),
		.p2_hpos(p2_hpos),
		.p3_hpos(p3_hpos),
		.p4_hpos(p4_hpos),
		.p5_hpos(p5_hpos),
		.p6_hpos(p6_hpos),
		.p7_hpos(p7_hpos)
	);
	
	//Modify the X position of the Doodle
	doodle_x dx_mod (
		.doodle_clk(doodle_clk),
		.rst(rst_signal),
		.posData(posData),
		// TESTING
		.Led(Led),
		// END TESTING
		.d_x(doo_x)
		);

	doodle_y dy_mod ( 
		.clk(platform_clk),
		//.platform_clk(platform_clk),
		.rst(rst_signal),
		.terminated(terminated),
		.p1_vpos(p1_vpos),
		.p2_vpos(p2_vpos),
		.p3_vpos(p3_vpos),
		.p4_vpos(p4_vpos),
		.p5_vpos(p5_vpos),
		.p6_vpos(p6_vpos),
		.p7_vpos(p7_vpos),
		.p1_hpos(p1_hpos),
		.p2_hpos(p2_hpos),
		.p3_hpos(p3_hpos),
		.p4_hpos(p4_hpos),
		.p5_hpos(p5_hpos),
		.p6_hpos(p6_hpos),
		.p7_hpos(p7_hpos),
		.d_x(doo_x),
		.d_y(doo_y)
	);

	vga640x480 vga(
		.pixel_clk(pixel_clk),
		.rst(rst_signal),
		.d_x(doo_x),
		.d_y(doo_y),
		.p1_vpos(p1_vpos),
		.p2_vpos(p2_vpos),
		.p3_vpos(p3_vpos),
		.p4_vpos(p4_vpos),
		.p5_vpos(p5_vpos),
		.p6_vpos(p6_vpos),
		.p7_vpos(p7_vpos),
		.p1_hpos(p1_hpos),
		.p2_hpos(p2_hpos),
		.p3_hpos(p3_hpos),
		.p4_hpos(p4_hpos),
		.p5_hpos(p5_hpos),
		.p6_hpos(p6_hpos),
		.p7_hpos(p7_hpos),
		.terminated(terminated),
		.hsync(hsync),
		.vsync(vsync),
		.red(red),
		.green(green),
		.blue(blue)
		);

endmodule
