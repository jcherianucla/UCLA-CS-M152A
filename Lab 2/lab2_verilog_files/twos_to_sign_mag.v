`timescale 1ns / 1ps

module twos_to_sign_mag(in, out, sign);
input [11:0] in;
output [11:0] out;
output sign;
assign sign = in[11];

assign out = (in[11] == 1) ? ~in + 1'b1 : in;

endmodule