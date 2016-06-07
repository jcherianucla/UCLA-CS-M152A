
`timescale 1ns / 1ps 
 
module platforms( 
    input platform_clk, // determines rate at which platforms move up 
    input rst, 
     
    // new horizontal position when overlapped 
    // input received from random generator 
    input wire [9:0] new_hpos, 
    input wire terminated,
	 input wire [9:0] power_rand_in,
    //Saved vertical positions 
    output reg [9:0] p1_vpos,  
    output reg [9:0] p2_vpos, 
    output reg [9:0] p3_vpos, 
    output reg [9:0] p4_vpos, 
    output reg [9:0] p5_vpos, 
    output reg [9:0] p6_vpos, 
    output reg [9:0] p7_vpos, 
     
    //Saved horizontal positions 
    output reg [9:0] p1_hpos, 
    output reg [9:0] p2_hpos, 
    output reg [9:0] p3_hpos, 
    output reg [9:0] p4_hpos, 
    output reg [9:0] p5_hpos, 
    output reg [9:0] p6_hpos, 
    output reg [9:0] p7_hpos,
	 
	 output reg [6:0] is_power
    ); 
     
    parameter hbp = 325;     // horizontal back porch (Left of screen)
    parameter hfp = 625;     // horizontal front porch (Right of screen)
    parameter vbp = 31;         // vertical back porch (Top of screen)
    parameter vfp = 511;     // vertical front porch (Bottom of screen) 
    parameter v_spc = 50;     // vertical space 
    parameter height = 20;     // platform height 
    localparam width = 75;    // platform width 
	 
	 // frequency of power blocks
	localparam power_prob = 10;

		reg [9:0] power_rand_reg;
     
    //Initial Platform setup 
    initial begin 
        //Vertical 
        p1_vpos = vbp + 50; 
        p2_vpos = vbp + 120; 
        p3_vpos = vbp + 190; 
        p4_vpos = vbp + 260; 
        p5_vpos = vbp + 330; 
        p6_vpos = vbp + 400; 
        p7_vpos = vbp + 470; 
        //Horizontal 
        p1_hpos = hbp; 
        p2_hpos = hbp + 125; 
        p3_hpos = hbp; 
        p4_hpos = hbp + 125; 
        p5_hpos = hbp;         
        p6_hpos = hbp + 125; 
        p7_hpos = hbp; 
		  
		  power_rand_reg = power_rand_in % power_prob;
    end 
 
    always @ (posedge platform_clk or posedge rst) begin 
        if (rst) begin 
            // reset vertical positions 
            p1_vpos <= vbp + 50; 
            p2_vpos <= vbp + 120; 
            p3_vpos <= vbp + 190; 
            p4_vpos <= vbp + 260; 
            p5_vpos <= vbp + 330; 
            p6_vpos <= vbp + 400; 
            p7_vpos <= vbp + 470; 
             
            // reset horizontal positions 
            p1_hpos <= hbp; 
            p2_hpos <= hbp + 125; 
            p3_hpos <= hbp; 
            p4_hpos <= hbp + 125; 
            p5_hpos <= hbp; 
            p6_hpos <= hbp + 125; 
            p7_hpos <= hbp;     
        end 
        else begin 
            if(!terminated) begin 
                // decrement and wrap-around the vertical position 
                // and randomize the horizontal positions 
                if (p1_vpos <= vbp) begin 
                    p1_vpos <= vfp - 1; 
                    p1_hpos <= new_hpos;
							if (power_rand_reg == 1) begin
								is_power[0] <= 1;
							end
							else begin
								is_power[0] <= 0;
							end
                end 
                else begin 
                    p1_vpos <= p1_vpos - 1; 
                end 
                 
                if (p2_vpos <= vbp) begin 
                    p2_vpos <= vfp - 1; 
                    p2_hpos <= new_hpos; 
						  if (power_rand_reg == 1) begin
								is_power[1] <= 1;
							end
							else begin
								is_power[1] <= 0;
							end
                end 
                else begin 
                    p2_vpos <= p2_vpos - 1; 
                end 
                 
                if (p3_vpos <= vbp) begin 
                    p3_vpos <= vfp - 1; 
                    p3_hpos <= new_hpos; 
						  if (power_rand_reg == 1) begin
								is_power[2] <= 1;
							end
							else begin
								is_power[2] <= 0;
							end
                end 
                else begin 
                    p3_vpos <= p3_vpos - 1; 
                end 
                 
                if (p4_vpos <= vbp) begin 
                    p4_vpos <= vfp - 1; 
                    p4_hpos <= new_hpos; 
						  if (power_rand_reg == 1) begin
								is_power[3] <= 1;
							end
							else begin
								is_power[3] <= 0;
							end
                end 
                else begin 
                    p4_vpos <= p4_vpos - 1; 
                end 
                 
                if (p5_vpos <= vbp) begin 
                    p5_vpos <= vfp; 
                    p5_hpos <= new_hpos; 
						  if (power_rand_reg == 1) begin
								is_power[4] <= 1;
							end
							else begin
								is_power[4] <= 0;
							end
                end 
                else begin 
                    p5_vpos <= p5_vpos - 1; 
                end 
                 
                if (p6_vpos <= vbp) begin 
                    p6_vpos <= vfp - 1; 
                    p6_hpos <= new_hpos; 
						  if (power_rand_reg == 1) begin
								is_power[5] <= 1;
							end
							else begin
								is_power[5] <= 0;
							end
                end 
                else begin 
                    p6_vpos <= p6_vpos - 1; 
                end 
                 
                if (p7_vpos <= vbp) begin 
                    p7_vpos <= vfp - 1; 
                    p7_hpos <= new_hpos; 
						  if (power_rand_reg == 1) begin
								is_power[6] <= 1;
							end
							else begin
								is_power[6] <= 0;
							end
                end 
                else begin 
                    p7_vpos <= p7_vpos - 1; 
                end 
            end 
        end             
    end 
 
endmodule
