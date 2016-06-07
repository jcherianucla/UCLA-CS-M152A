`timescale 1ns / 1ps

module select_display_value (
	input clk,
	input hs,
	input [31:0] points,
	input [31:0] highscore,
	output reg [31:0] val
	);
	
	reg hs_state;

	initial begin
		hs_state = 0;
		val = points;
	end

	always @ (posedge hs) begin
		hs_state <= ~hs_state;
	end
	
	always @ (posedge clk) begin
		if (hs_state) begin
			val <= highscore;
		end
		else begin
			val <= points;
		end
	end

endmodule
