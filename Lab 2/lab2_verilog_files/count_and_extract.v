`timescale 1ns / 1ps

module count_and_extract(a, b, significand, fifth_bit);
			
	input wire [11:0] a; // D[11] is guaranteed to be 0, so it is not part of this module.
	output wire [2:0] b;
	output wire [3:0] significand;
	output wire fifth_bit;
	
	assign b =	(a[11] == 1)? 3'b111 :
					(a[10] == 1)? 3'b111 :
					(a[9] == 1)? 3'b110 :
					(a[8] == 1)? 3'b101 :
					(a[7] == 1)? 3'b100 :
					(a[6] == 1)? 3'b011 :
					(a[5] == 1)? 3'b010 :
					(a[4] == 1)? 3'b001 :
					3'b000;

	assign significand = (a[11] == 1) ? 3'b111 :
							(a[10] == 1) ? a[10:7] :
							(a[9] == 1) ? a[9:6] :
							(a[8] == 1) ? a[8:5]:
							(a[7] == 1) ? a[7:4] :
							(a[6] == 1) ? a[6:3] :
							(a[5] == 1) ? a[5:2] :
							(a[4] == 1) ? a[4:1] :
							a[3:0];

	assign fifth_bit = (a[11] == 1) ? 1 :
							(a[10] == 1) ? a[6]:
							(a[9] == 1) ? a[5] :
							(a[8] == 1) ? a[4] :
							(a[7] == 1) ? a[3] :
							(a[6] == 1) ? a[2] :
							(a[5] == 1) ? a[1] :
							(a[4] == 1) ? a[0] :
							0;
							

endmodule
