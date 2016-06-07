`timescale 1ns / 1ps

module select_clock(
	input clk, clk_adj,
	input wire [1:0] adjust,
	output clock
    );

reg clock_reg;

always @* begin
	if (adjust == 0) begin
		clock_reg = clk;
	end
	else begin //if (adjust) begin
		clock_reg = clk_adj;
	end
end

assign clock = clock_reg;

endmodule
