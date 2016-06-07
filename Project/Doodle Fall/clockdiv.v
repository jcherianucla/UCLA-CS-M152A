`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire rst,		//asynchronous reset
	output wire pixel_clk,		//pixel clock: 25MHz
	output wire doodle_clk,
	output wire platform_clk,
	output wire points_clk,
	output wire gravity_clk
	);

// 2-bit counter variable
reg [1:0] pixel_count;
//32-bit counter variables
reg [31:0] doodle_count;
reg [31:0] platform_count;
reg [31:0] points_count;
reg [31:0] gravity_count;
//Clock registers as holders
reg platform_clk_reg;
reg pixel_clk_reg;
reg doodle_clk_reg;
reg points_clk_reg;
reg gravity_clk_reg;
//Counter max values
localparam DIV_FACTOR = 2; // 25 MHz
localparam DOODLE_FACTOR = 250000; // 200 Hz
reg [31:0] PLATFORM_FACTOR; // gradually gets faster
localparam POINTS_FACTOR = 5000000; //10 Hz
localparam GRAVITY_FACTOR = 500000; // 100 Hz

initial begin
	PLATFORM_FACTOR = 500000; // starts at 100 Hz
	pixel_count = 0;
	pixel_clk_reg = 0;
	doodle_count = 0;
	doodle_clk_reg = 0;
	platform_count = 0;
	platform_clk_reg = 0;
	points_count = 0;
	points_clk_reg = 0;
	gravity_count = 0;
	gravity_clk_reg = 0;
end

// pixel clock
always @(posedge clk or posedge rst)
begin
	if (rst == 1) begin
		pixel_count <= 0;
		pixel_clk_reg <= 0;
	end
	else if (pixel_count == DIV_FACTOR - 1) begin
		pixel_count <= 0;
		pixel_clk_reg <= ~pixel_clk_reg;
	end
	else begin
		pixel_count <= pixel_count + 1;
		pixel_clk_reg <= pixel_clk_reg;
	end
end

// doodle clock
always @ (posedge clk or posedge rst)
begin
	if(rst == 1) begin
		doodle_count <= 0;
		doodle_clk_reg <= 0;
	end
	else if (doodle_count == DOODLE_FACTOR - 1) begin
		doodle_count <= 0;
		doodle_clk_reg <= ~doodle_clk_reg;
	end
	else begin
		doodle_count <= doodle_count + 1;
		doodle_clk_reg <= doodle_clk_reg;
	end
end

// platform clock
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		platform_count <= 0;
		platform_clk_reg <= 0;
	end
	else if (platform_count >= PLATFORM_FACTOR - 1) begin
		platform_count <= 0;
		platform_clk_reg <= ~platform_clk_reg;
	end
	else begin
		platform_count <= platform_count + 1;
		platform_clk_reg <= platform_clk_reg;
	end
end

//points clock
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		points_count <= 0;
		points_clk_reg <= 0;
		
		// reset platform clock rate
		PLATFORM_FACTOR <= 500000; // 100 Hz
	end
	else if (points_count == POINTS_FACTOR - 1) begin
		points_count <= 0;
		points_clk_reg <= ~points_clk_reg;
		
		// at every toggle of points clock, increase platform clock rate.
		if (PLATFORM_FACTOR >= 200000) begin // MAX 250Hz
			PLATFORM_FACTOR <= PLATFORM_FACTOR - 1000;
		end
		else begin
			PLATFORM_FACTOR <= PLATFORM_FACTOR;
		end
	end
	else begin
		points_count <= points_count + 1;
		points_clk_reg <= points_clk_reg;
	end
end

// gravity clock
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		gravity_count <= 0;
		gravity_clk_reg <= 0;
	end
	else if (gravity_count == GRAVITY_FACTOR - 1) begin
		gravity_count <= 0;
		gravity_clk_reg <= ~gravity_clk_reg;
	end
	else begin
		gravity_count <= gravity_count + 1;
		gravity_clk_reg <= gravity_clk_reg;
	end
end

assign pixel_clk = pixel_clk_reg;
assign doodle_clk = doodle_clk_reg;
assign platform_clk = platform_clk_reg;
assign points_clk = points_clk_reg;
assign gravity_clk = gravity_clk_reg;

endmodule
