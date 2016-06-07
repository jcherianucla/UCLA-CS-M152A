`timescale 1ns / 1ps

// clock divider
// Want to reduce 100 MHz to 1 Hz
module clk_divider(
    input wire clk,
    input wire rst,
    output reg new_clk
    );
	  
	localparam DIV_FACTOR = 100000000;
	
	reg [26:0] counter; // 26 bits for modulo-50k counter

	// module-50k counter
	always @ (posedge(clk) or posedge(rst)) 
	begin
		if (rst == 1'b1)
			counter <= 27'b0;
		else if (counter == DIV_FACTOR - 1)
			counter <= 27'b0;
		else
			counter <= counter + 27'b1;
	end
	
	// comparator
	always @ (posedge(clk) or posedge(rst))
	begin
		if (rst == 1'b1)
			new_clk <= 1'b0;
		else if (counter == DIV_FACTOR - 1)
			new_clk <= ~new_clk;
		else
			new_clk <= new_clk;		
	end

endmodule 
