`timescale 1ns / 1ps

module lfsr_rand_generator(
	input clk,
	input rst,
	output reg [9:0] rand_hpos
    );

/*
* rand is the random horizontal offset from horizontal back porch
*/
//	 
localparam hbp = 325;
//localparam hfp = 700;
//localparam PLAT_WIDTH = 75;

localparam range = 225;

reg [15:0] lfsr;
reg new_bit;
reg [15:0] update;

initial begin 
	lfsr = 777;
	update = 0;
end	 



always @ (posedge clk or posedge rst) begin
	if(rst) begin
		update <= update + 1;
		lfsr <= 777 + update;
		rand_hpos <= hbp;
	end
	else begin
		new_bit  <= ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ) & 1;
      lfsr <= (lfsr >> 1) | (new_bit << 15);
		
		// output is the new horizontal position
		rand_hpos <= (lfsr % range) + hbp;
	end
end
endmodule