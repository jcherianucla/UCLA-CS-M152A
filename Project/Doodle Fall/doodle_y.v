`timescale 1ns / 1ps

module doodle_y(
    input clk, // gravity clock
    input platform_clk,
    input rst,
    input terminated,
    input [9:0] p1_vpos,
    input [9:0] p2_vpos,
    input [9:0] p3_vpos,
    input [9:0] p4_vpos,
    input [9:0] p5_vpos,
    input [9:0] p6_vpos,
    input [9:0] p7_vpos,
    input [9:0] p1_hpos,
    input [9:0] p2_hpos,
    input [9:0] p3_hpos,
    input [9:0] p4_hpos,
    input [9:0] p5_hpos,
    input [9:0] p6_hpos,
    input [9:0] p7_hpos,
    input wire [9:0] d_x,
    output reg [9:0] d_y
   );
     
    localparam size = 20;
    localparam plat_width = 75;
    localparam gravity = 2;
     
    initial begin
        d_y = p4_vpos - 1; // start on platform 4
    end
     
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            d_y <= p4_vpos - 1;
        end    
        else if (!terminated) begin
            // if doodle is horizontally aligned with platform 1
            if (d_y <= p1_vpos - 1 && d_y >= p1_vpos - 3) begin
                // if doodle is on top of platform 1
                if (d_x + size > p1_hpos && d_x < p1_hpos + plat_width ) begin
                    // rise with the platform
                    d_y <= d_y - 1;
                end
                else begin
                    // fall down
                    d_y <= d_y + gravity;
                end
            end
            
            // platform 2
            else if (d_y <= p2_vpos - 1 && d_y >= p2_vpos - 3) begin
                if (d_x + size > p2_hpos && d_x < p2_hpos + plat_width ) begin
                    d_y <= d_y - 1;
                end
                else begin
                    d_y <= d_y + gravity;
                end
            end
            
            // platform 3
            else if (d_y <= p3_vpos - 1  && d_y >= p3_vpos - 3) begin
                if (d_x + size > p3_hpos && d_x < p3_hpos + plat_width ) begin
                    d_y <= d_y - 1;
                end
                else begin
                    d_y <= d_y + gravity;
                end
            end
            
            // platform 4
            else if (d_y <= p4_vpos - 1  && d_y >= p4_vpos - 3) begin
                if (d_x + size > p4_hpos && d_x < p4_hpos + plat_width ) begin
                    d_y <= d_y - 1;
                end
                else begin
                    d_y <= d_y + gravity;
                end
            end
            
            // platform 5
            else if (d_y <= p5_vpos - 1 && d_y >= p5_vpos - 3) begin
                if (d_x + size > p5_hpos && d_x < p5_hpos + plat_width ) begin
                    d_y <= d_y - 1;
                end
                else begin
                    d_y <= d_y + gravity;
                end
            end
            
            // platform 6
            else if (d_y <= p6_vpos - 1 && d_y >= p6_vpos - 3) begin
                if (d_x + size > p6_hpos && d_x < p6_hpos + plat_width) begin
                    d_y <= d_y - 1;
                end
                else begin
                    d_y <= d_y + gravity;
                end
            end
            
            // platform 7
            else if (d_y <= p7_vpos - 1 && d_y >= p7_vpos - 3) begin
                if (d_x + size > p7_hpos && d_x < p7_hpos + plat_width ) begin
                    d_y <= d_y - 1;
                end
                else begin
                    d_y <= d_y + gravity;
                end
            end
            
            // free-fall
            else begin
                d_y <= d_y + gravity;
            end
        end
    end

endmodule
