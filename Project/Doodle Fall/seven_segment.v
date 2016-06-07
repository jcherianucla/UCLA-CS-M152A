`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:23 05/10/2016 
// Design Name: 
// Module Name:    seven_segment 
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
module seven_segment(
	input wire [3:0] digit,
	output wire [7:0] seven_seg
    );

reg[7:0] SevenSeg;

always @ (*) begin
case(digit)    
	 4'h0: SevenSeg = 8'b11000000;
    4'h1: SevenSeg = 8'b11111001;
    4'h2: SevenSeg = 8'b10100100;
    4'h3: SevenSeg = 8'b10110000;
    4'h4: SevenSeg = 8'b10011001;
    4'h5: SevenSeg = 8'b10010010;
    4'h6: SevenSeg = 8'b10000010;
    4'h7: SevenSeg = 8'b11111000;
    4'h8: SevenSeg = 8'b10000000;
    4'h9: SevenSeg = 8'b10010000;
    default: SevenSeg = 8'b11111111;
endcase
end
assign seven_seg = SevenSeg;

endmodule
