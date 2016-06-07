`timescale 1ns / 1ps


module counter(
	input wire reset,
	input wire pause,
	input wire [1:0] adjust,
	input wire select,
	input wire clk,
	input wire clk_adj,
	output wire [3:0] min0,
	output wire [3:0] min1,
	output wire [3:0] sec0,
	output wire [3:0] sec1
    );

	reg [3:0] min1_count = 4'b0000;
	reg [3:0] min0_count = 4'b0000;
	reg [3:0] sec1_count = 4'b0000;
	reg [3:0] sec0_count = 4'b0000;

	wire clock;

	// select which clock to use
	select_clock sel_clk (
		.clk(clk),
		.clk_adj(clk_adj),
		.adjust(adjust),
		.clock(clock)
		);
	
	reg paused = 0;
	always @ (posedge clk or posedge pause) begin
		if (pause) begin
			paused <= ~paused;
		end
		else begin
			paused <= paused;
		end
	end
	
	always @(posedge clock or posedge reset) begin
		
		if (reset) begin
			min0_count <= 4'b0000;
			min1_count <= 4'b0000;
			sec0_count <= 4'b0000;
			sec1_count <= 4'b0000;
		end
		/*
		if (pause) begin
			paused <= ~paused;
		end
		else begin
			paused <= paused;
		end
		*/
		///////////////////////////////////////////
		// adjust 0 mode - regular clock mode 
		///////////////////////////////////////////
		
		else if (adjust == 0 && ~paused) begin
			// increment seconds
			if (sec0_count == 9 && sec1_count == 5) begin
				// reset seconds
				sec0_count <= 0;
				sec1_count <= 0;
				
				// increment minutes
				if (min0_count == 9 && min1_count == 9) begin
					// reset minutes
					min0_count <= 4'b0;
					min1_count <= 4'b0;
				end
				else if (min0_count == 9) begin
					// overflow min
					min0_count <= 4'b0;
					min1_count <= min1_count + 4'b1;
				end
				else begin
					min0_count <= min0_count + 4'b1;
				end
			end
			else if (sec0_count == 9) begin
				// seconds overflow
				sec0_count <= 4'b0;
				sec1_count <= sec1_count + 4'b1;
			end
			else begin
				sec0_count <= sec0_count + 4'b1;
			end
		end

		///////////////////////////////
		// adjust 1 mode - increment
		///////////////////////////////
		
		// select seconds
		else if (adjust == 1 && ~paused && select) begin
			// increment seconds
			if (sec0_count == 9 && sec1_count == 5) begin
				sec0_count <= 0;
				sec1_count <= 0;
			end
			else if (sec0_count == 9) begin
				sec0_count <= 4'b0;
				sec1_count <= sec1_count + 4'b1;
			end
			else begin
				sec0_count <= sec0_count + 4'b1;
			end
		end
		// select minutes
		else if (adjust == 1 && ~paused && ~select) begin
			// increment minutes
			if (min0_count == 9 && min1_count == 9) begin
				min0_count <= 0;
				min1_count <= 0;
			end
			else if (min0_count == 9) begin
				// overflow minutes
				min0_count <= 4'b0;
				min1_count <= min1_count + 4'b1;
			end
			else begin
				min0_count <= min0_count + 4'b1;
			end
		end
		
		///////////////////////////////
		// adjust 2 mode - decrement
		///////////////////////////////
		
		// select seconds
		else if (adjust == 2 && ~paused && select) begin
			if (sec0_count == 0 && sec1_count == 0) begin
				sec0_count <= 9;
				sec1_count <= 5;
			end
			else if (sec0_count == 0) begin
				sec0_count <= 9;
				sec1_count <= sec1_count - 4'b1;
			end
			else 
				sec0_count <= sec0_count - 4'b1;
		end
		
		// select minutes
		else if (adjust == 2 && ~paused && ~select) begin
			if (min0_count == 0 && min1_count == 0) begin
				min0_count <= 9;
				min1_count <= 9;
			end
			else if (min0_count == 0) begin
				min0_count <= 9;
				min1_count <= min1_count - 4'b1;
			end
			else begin
				min0_count <= min0_count - 4'b1;
			end
		end
	end

	assign min1 = min1_count;
	assign min0 = min0_count;
	assign sec1 = sec1_count;
	assign sec0 = sec0_count;

endmodule
