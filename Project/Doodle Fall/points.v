`timescale 1ns / 1ps

 module points(
	input clk,
	input rst,
	input hs_rst,
	input wire [9:0] d_y, 
	output reg terminated, 
	output reg [31:0] points
    );
	 
	localparam vbp = 31;
	localparam vfp = 511;
	localparam doodle_size = 20;
	 
	initial begin
		terminated = 0;
		points = 0;
	end

	always @ (posedge clk or posedge rst or posedge hs_rst) begin
		if (rst) begin
			points <= 0;
			terminated <= 0;
		end
		else if (hs_rst) begin
			points <= 0;
		end
		
		// game terminated, stop adding points
		else if (d_y >= 511 || d_y - doodle_size <= 31) begin
			terminated <= 1;
			points <= points;
		end
		else begin
			points <= points + 1;
		end
		
	end

endmodule
