`timescale 1ns / 1ps

module rounding(sig, fif, exp, out_sig, out_exp);

input [3:0] sig;
input wire fif;
input [2:0] exp;

output reg [3:0] out_sig;
output reg [2:0] out_exp;

always @ (*) begin
	if (fif == 0)
	begin
		// No need for rounding
		out_sig = sig;
		out_exp = exp;
	end
	else
	begin
		if (sig == 4'b1111)
		begin
			// Overflow of significand
			if (exp == 3'b111)
			begin
				// Overflow of exponent - check with Babak
				out_exp = 3'b111;
				out_sig = 4'b1111;
			end
			else
			begin
				// sig overflow but not exp overflow
				out_sig = 4'b1000;
				out_exp = exp + 1;
			end
		end
		else
		begin
			// Normal case of rounding
			out_sig = sig + 1;
			out_exp = exp;
		end
	end
end
endmodule
		