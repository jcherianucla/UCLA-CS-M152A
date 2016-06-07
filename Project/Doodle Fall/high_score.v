`timescale 1ns / 1ps

module high_score (
	input clk,
	input rst, // reset high score
	input wire [31:0] points,
	output reg [31:0] highscore
	);

	initial begin
		highscore = 0;
	end

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			highscore <= 0;
		end
		else if (points > highscore) begin
			highscore <= points;
		end 
		else begin
			highscore <= highscore;
		end
	end

endmodule
