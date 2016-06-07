`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:56 05/05/2016 
// Design Name: 
// Module Name:    clock_dividers 
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

//Create four separate clock dividers
module clock_dividers(
	input wire clk,
	input wire rst,
	output wire two_hz_clk,
	output wire one_hz_clk,
	output wire segment_hz_clk,
	output wire blink_hz_clk
    );
	 
	reg two_hz_clk_reg;
	reg one_hz_clk_reg;
	reg segment_hz_clk_reg;
	reg blink_hz_clk_reg;
	 
	localparam TWO_DIV_FACTOR = 25000000;
	localparam ONE_DIV_FACTOR = 50000000;
	//Set to 1 kHz for the seven segment display
	localparam SEGMENT_DIV_FACTOR = 50000;
	//Set to 3Hz for the blinking adjust
	localparam BLINK_DIV_FACTOR = 12500000;
	
	reg [31:0] two_counter;
	reg [31:0] one_counter;
	reg [31:0] segment_counter;
	reg [31:0] blink_counter;

	//Two Hz Clock Divider
	
	always @ (posedge(clk) or posedge(rst))
	begin
		if(rst == 1'b1)
		begin
			two_counter <= 32'b0;
			two_hz_clk_reg <= 1'b0;
		end
		else if(two_counter == TWO_DIV_FACTOR -1)
		begin
			two_counter <= 32'b0;
			two_hz_clk_reg <= ~two_hz_clk;
		end
		else
		begin
			two_counter <= two_counter + 32'b1;
			two_hz_clk_reg <= two_hz_clk;
		end	
	end
	
	//One Hz Clock Divider
	
	always @ (posedge(clk) or posedge(rst))
	begin
		if(rst == 1'b1)
		begin
			one_counter <= 32'b0;
			one_hz_clk_reg <= 1'b0;
		end
		else if(one_counter == ONE_DIV_FACTOR -1)
		begin
			one_counter <= 32'b0;
			one_hz_clk_reg <= ~one_hz_clk;
		end
		else
		begin
			one_counter <= one_counter + 32'b1;
			one_hz_clk_reg <= one_hz_clk;
		end	
	end
	
	//Segment Clock Divider
	
	always @ (posedge(clk) or posedge(rst))
	begin
		if(rst == 1'b1)
		begin
			segment_counter <= 32'b0;
			segment_hz_clk_reg <= 1'b0;
		end
		else if(segment_counter == SEGMENT_DIV_FACTOR -1)
		begin
			segment_counter <= 32'b0;
			segment_hz_clk_reg <= ~segment_hz_clk;
		end
		else
		begin
			segment_counter <= segment_counter + 32'b1;
			segment_hz_clk_reg <= segment_hz_clk;
		end	
	end
	
	//Blinking Clock Divider
	
	always @ (posedge(clk) or posedge(rst))
	begin
		if(rst == 1'b1)
		begin
			blink_counter <= 32'b0;
			blink_hz_clk_reg <= 1'b0;
		end
		else if(blink_counter == BLINK_DIV_FACTOR -1)
		begin
			blink_counter <= 32'b0;
			blink_hz_clk_reg <= ~blink_hz_clk;
		end
		else
		begin
			blink_counter <= blink_counter + 32'b1;
			blink_hz_clk_reg <= blink_hz_clk;
		end	
	end

	assign two_hz_clk = two_hz_clk_reg;
	assign one_hz_clk = one_hz_clk_reg;
	assign segment_hz_clk = segment_hz_clk_reg;
	assign blink_hz_clk = blink_hz_clk_reg;

endmodule
