`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module fp_converter(
	D, S, E, F
    );

	input wire [11:0] D;
	output wire S;
	output wire [2:0] E;
	output wire [3:0] F;
	
	wire [11:0] temp_out;
	wire [2:0] temp_exp;
	wire [3:0] temp_sig;
	wire temp_fif;
	
	twos_to_sign_mag block1(
		.in(D),
		.out(temp_out),
		.sign(S)
		);
	count_and_extract block2(
		.a(temp_out),
		.b(temp_exp),
		.significand(temp_sig),
		.fifth_bit(temp_fif)
		);
	rounding block3(
		.sig(temp_sig),
		.fif(temp_fif),
		.exp(temp_exp),
		.out_sig(F),
		.out_exp(E)
		);
	
endmodule
