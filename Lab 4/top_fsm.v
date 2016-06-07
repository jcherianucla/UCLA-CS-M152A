`timescale 1ns / 1ps

module top_fsm(
	input clk,
	input rst,
	input pause,
	input sel,
	input wire [1:0] adjust,
	output reg [7:0] seven_seg,
	output reg [3:0] anode_count
    );

wire [3:0] sec0_count;
wire [3:0] sec1_count;
wire [3:0] min0_count;
wire [3:0] min1_count;

wire [7:0] seven_seg_min1;
wire [7:0] seven_seg_min0;
wire [7:0] seven_seg_sec1;
wire [7:0] seven_seg_sec0;

wire one_hz, two_hz, seg_hz, blink_hz;

wire rst_state, pause_state;
	
debouncer rst_btn(
	.button(rst),
	.clk(clk),
	.button_state(rst_state)
	);

debouncer pause_btn(
	.button(pause),
	.clk(clk),
	.button_state(pause_state)
	);

clock_dividers divs(
	.clk(clk),
	.rst(rst_state),
	.two_hz_clk(two_hz),
	.one_hz_clk(one_hz),
	.segment_hz_clk(seg_hz),
	.blink_hz_clk(blink_hz)
	);

counter stopwatch(
	.reset(rst_state),
	.pause(pause_state),
	.adjust(adjust),
	.select(sel),
	.clk(one_hz),
	.clk_adj(two_hz),
	.min0(min0_count),
	.min1(min1_count),
	.sec0(sec0_count),
	.sec1(sec1_count)
	);

reg [1:0] cnt = 2'b00;

/////////////////////////////////////////////////
// get 7-segment displays for each digit
/////////////////////////////////////////////////

seven_segment minute1(
	.digit(min1_count),
	.seven_seg(seven_seg_min1)
	);
	
seven_segment minute0 (
	.digit(min0_count),
	.seven_seg(seven_seg_min0)
	);
	
seven_segment second1 (
	.digit(sec1_count),
	.seven_seg(seven_seg_sec1)
	);
	
seven_segment second0(
	.digit(sec0_count),
	.seven_seg(seven_seg_sec0)
	);
	
wire [7:0] blank_digit;
seven_segment blank_val(
	.digit(4'b1111),
	.seven_seg(blank_digit)
	);

/////////////////////////////////////////////
// rapidly cycle through digits
/////////////////////////////////////////////

reg minute_blink = 1'b0;
reg second_blink = 1'b0;

always @ (posedge seg_hz) begin

	// blinking mode
	if (adjust == 1 || adjust == 2) begin
		
		// blinking mode - minutes
		if (sel == 0) begin // blink minutes
			if (cnt == 0) begin
				anode_count <= 4'b0111;
				if (blink_hz) begin
					seven_seg <= seven_seg_min1;
				end
				else begin
					seven_seg <= blank_digit;
				end
				cnt <= cnt + 1;
			end
			else if (cnt == 1) begin
				anode_count <= 4'b1011;
				if (blink_hz) begin
					seven_seg <= seven_seg_min0;
				end
				else begin
					seven_seg <= blank_digit;
				end
				cnt <= cnt + 1;
			end
			else if (cnt == 2) begin
				anode_count <= 4'b1101;
				seven_seg <= seven_seg_sec1;
				cnt <= cnt + 1;
			end
			else if (cnt == 3) begin
				anode_count <= 4'b1110;
				seven_seg <= seven_seg_sec0;
				cnt <= cnt + 1;
			end
		end
		
		// blinking mode - seconds
		else begin //if (sel == 1) begin // blink seconds
			if (cnt == 0) begin
				anode_count <= 4'b0111;
				seven_seg <= seven_seg_min1;
				cnt <= cnt + 1;
			end
			else if (cnt == 1) begin
				anode_count <= 4'b1011;
				seven_seg <= seven_seg_min0;
				cnt <= cnt + 1;
			end
			else if (cnt == 2) begin
				anode_count <= 4'b1101;
				if (blink_hz) begin
					seven_seg <= seven_seg_sec1;
				end
				else begin
					seven_seg <= blank_digit;
				end
				cnt <= cnt + 1;
			end
			else begin // if (cnt == 3) begin
				anode_count <= 4'b1110;
				if (blink_hz) begin
					seven_seg <= seven_seg_sec0;
				end
				else begin
					seven_seg <= blank_digit;
				end
				cnt <= cnt + 1;
			end
		end
	end	
	
	// regular mode
	else begin
		if (cnt == 0) begin
			anode_count <= 4'b0111;
			seven_seg <= seven_seg_min1;
			cnt <= cnt + 1;
		end
		if (cnt == 1) begin
			anode_count <= 4'b1011;
			seven_seg <= seven_seg_min0;
			cnt <= cnt + 1;
		end
		if (cnt == 2) begin
			anode_count <= 4'b1101;
			seven_seg <= seven_seg_sec1;
			cnt <= cnt + 1;
		end
		if (cnt == 3) begin
			anode_count <= 4'b1110;
			seven_seg <= seven_seg_sec0;
			cnt <= cnt + 1;
		end
	end
end
	/*if(sel == 0 && (adjust == 1 || adjust == 2)) begin
		minute_blink <= 1'b1;
		second_blink <= 1'b0;
	end
	else if (sel == 1 && (adjust == 1 || adjust == 2)) begin
		minute_blink <= 1'b0;
		second_blink <= 1'b1;
	end
	else begin
		minute_blink <= 1'b0;
		second_blink <= 1'b0;
	end*/
	/*
	if (cnt == 0 && sel == 0 && (adjust == 1 || adjust == 2)) begin
		// display min1
		if(blink_hz) begin
			anode_count <= 4'b0111;
			seven_seg <= seven_seg_min1;
		end
		else begin
			anode_count <= 4'b0111;
			seven_seg <= blank_digit;
		end
		cnt <= cnt + 2'b01;
	end
	else if (cnt == 0) begin
		anode_count <= 4'b0111;
		seven_seg <= seven_seg_min1;
		cnt <= cnt + 2'b01;
	end
	else if (cnt == 1 && sel == 0 && (adjust == 1 || adjust == 2)) begin
		// display min0
		if(blink_hz) begin
			anode_count <= 4'b1011;
			seven_seg <= seven_seg_min0;		
		end
		else begin
			anode_count <= 4'b1011;
			seven_seg <= blank_digit;
		end
		cnt <= cnt + 2'b01;
	end
	else if (cnt == 1) begin
		anode_count <= 4'b1011;
		seven_seg <= seven_seg_min0;		
		cnt <= cnt + 2'b01;
	end
	else if (cnt == 2 && sel == 1 && (adjust == 1 || adjust == 2)) begin
		// display sec1
		if(blink_hz) begin
			anode_count <= 4'b1101;
			seven_seg <= seven_seg_sec1;		
		end
		else begin
			anode_count <= 4'b1101;
			seven_seg <= blank_digit;
		end
		cnt <= cnt + 2'b01;
	end
	else if (cnt == 2) begin
		anode_count <= 4'b1101;
		seven_seg <= seven_seg_sec1;
		cnt <= cnt + 2'b01;
	end
	else if (cnt == 3 && sel == 1 && (adjust == 1 || adjust == 2)) begin
		// display sec0
		if(blink_hz) begin
			anode_count <= 4'b1110;
			seven_seg <= seven_seg_sec0;		
		end
		else begin
			anode_count <= 4'b1110;
			seven_seg <= blank_digit;
		end
		cnt <= 2'b00;
	end	
	else begin
		anode_count <= 4'b1110;
		seven_seg <= seven_seg_sec0;
		cnt <= 2'b00;
	end 
end*/
endmodule
