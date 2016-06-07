`timescale 1ns / 1ps

module vga640x480(
	input wire pixel_clk,			//pixel clock: 25MHz
	input wire rst,			//asynchronous reset
	input wire [10:0] d_x,
	input wire [10:0] d_y,
	input wire [9:0] p1_vpos, // platform 1 vertical position
	input wire [9:0] p2_vpos,
	input wire [9:0] p3_vpos,
	input wire [9:0] p4_vpos,
	input wire [9:0] p5_vpos,
	input wire [9:0] p6_vpos,
	input wire [9:0] p7_vpos,
	input wire [9:0] p1_hpos, // platform 1 horizontal position
	input wire [9:0] p2_hpos,
	input wire [9:0] p3_hpos,
	input wire [9:0] p4_hpos,
	input wire [9:0] p5_hpos,
	input wire [9:0] p6_hpos,
	input wire [9:0] p7_hpos,
	input wire terminated,
	input wire [6:0] is_power,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 325; 	// end of horizontal back porch
parameter hfp = 625; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480
reg [9:0] hc;
reg [9:0] vc;

always @(posedge pixel_clk or posedge rst)
begin
	// reset condition
	if (rst == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else

		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

parameter doodleSize = 20;

/*
* Block Height is 20 pixels
* Block Length is 75 pixels
* Vertical Spacing is 50 pixels
* Horizontal Spacing is 50 pixels
*/

localparam height = 20;
localparam width = 75;

always @(*)
begin

	// first check if we're within vertical active video range
	if (vc >= vbp && vc <= vfp)
	begin
		if(hc <= hbp || hc >= hfp) begin
			red = 3'b111;
			green = 0;
			blue = 0;
		end
		// platfom 1
		else if ( vc >= p1_vpos && vc <= p1_vpos + height && hc >= p1_hpos && hc <= p1_hpos + width ) begin
			if (is_power[0]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		// platform 2
		else if ( vc >= p2_vpos && vc <= p2_vpos + height && hc >= p2_hpos && hc <= p2_hpos + width ) begin
			if (is_power[1]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		// platform 3
		else if ( vc >= p3_vpos && vc <= p3_vpos + height && hc >= p3_hpos && hc <= p3_hpos + width ) begin
			if (is_power[2]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		// platform 4
		else if ( vc >= p4_vpos && vc <= p4_vpos + height && hc >= p4_hpos && hc <= p4_hpos + width ) begin
			if (is_power[3]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		// platform 5
		else if ( vc >= p5_vpos && vc <= p5_vpos + height && hc >= p5_hpos && hc <= p5_hpos + width ) begin
				if (is_power[4]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		// platform 6
		else if ( vc >= p6_vpos && vc <= p6_vpos + height && hc >= p6_hpos && hc <= p6_hpos + width ) begin
				if (is_power[5]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end
		// platform 7
		else if ( vc >= p7_vpos && vc <= p7_vpos + height && hc >= p7_hpos && hc <= p7_hpos + width ) begin
			if (is_power[6]) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end
			else begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
		end

		//Doodle Character
		else if (!terminated && (vc >= d_y - doodleSize && vc <= d_y && hc >= d_x && hc <= d_x + doodleSize)) begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end
		
		// display black: empty space within game zone
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end

	end
	// display black: we're outside game zone
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
