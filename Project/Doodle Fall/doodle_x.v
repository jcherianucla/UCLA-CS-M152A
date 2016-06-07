`timescale 1ns / 1ps

module doodle_x(
	input doodle_clk,
	input rst,
	//Joystick Value
	input wire [9:0] posData,
	//Vertcial platform positions
	input wire [9:0] p1_vpos,
	input wire [9:0] p2_vpos,
	input wire [9:0] p3_vpos,
	input wire [9:0] p4_vpos,
	input wire [9:0] p5_vpos,
	input wire [9:0] p6_vpos,
	input wire [9:0] p7_vpos,
	//Horizontal platform positions
	input wire [9:0] p1_hpos,
	input wire [9:0] p2_hpos,
	input wire [9:0] p3_hpos,
	input wire [9:0] p4_hpos,
	input wire [9:0] p5_hpos,
	input wire [9:0] p6_hpos,
	input wire [9:0] p7_hpos,
	// TESTING
	output reg [7:0] Led,
	// END TESTING
	//New X value of the doodle
	output reg [9:0] d_x
    );
	 
parameter speed1 = 1;		//Horizontal Speed 1
parameter speed2 = 2;		//Horizontal Speed 2
parameter gravity = 4;		//Gravity for falling down
parameter hbp = 325;	//Horizontal
parameter hfp = 625;
parameter bottom = 511;
//parameter blockLength = 75;
localparam p_width = 75;
localparam p_height = 20;
localparam size = 20;

initial begin
	d_x = 450; // start on left edge of platform 4
end

//Grab the data from the PMODJystk to update the x position of the doodle
always @ (posedge doodle_clk or posedge rst) begin
	if (rst) begin
		d_x <= 450;
		// TESTING
		Led [7:0] <= 0;
		// END TESTING
	end
	
	// movement to the right
	else if(posData <= 237) begin
		// right level 2
		Led[2] <= 1;
		Led[1:0] <= 0;
		Led[7:3] <= 0;
		
		// collide with right border
		if (d_x + size >= hfp) begin
			d_x <= d_x;
		end
		
		// move sideways normally
		else begin
			d_x <= d_x + speed2;
		end
	end
	else if(posData <= 437) begin
		// right level 1
		Led[3] <= 1;
		Led[2:0] <= 0;
		Led[7:4] <= 0
		;
		// collide with right border
		if (d_x + size >= hfp) begin
			d_x <= d_x;
		end
		else begin
			d_x <= d_x + speed1;
		end
	end

	// movement to the left
	else if (posData >= 787) begin
		// left level 2
		Led[5] <= 1;
		Led[4:0] <= 0;
		Led[7:6] <= 0;
		if (d_x <= hbp) begin
			d_x <= d_x;
		end
		else begin
			d_x <= d_x - speed2;
		end
	end
	else if (posData >= 587) begin
		// left level 1
		Led[4] <= 1;
		Led[3:0] <= 0;
		Led[7:5] <= 0;
		
		if (d_x <= hbp) begin
			d_x <= d_x;
		end
		else begin
			d_x <= d_x - speed1;
		end
	end

	else begin
		Led[7:0] <= 0;
		d_x <= d_x;
	end
end

endmodule
