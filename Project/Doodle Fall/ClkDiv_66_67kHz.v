`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    ClkDiv_66_67kHz 
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Converts input 100MHz clock signal to a 66.67kHz clock signal.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////

// ============================================================================== 
// 										  Define Module
// ==============================================================================
module ClkDiv_66_67kHz(
    CLK,											// 100MHz onbaord clock
    RST,											// Reset
    CLKOUT										// New clock output
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
	input CLK;
	input RST;
	output CLKOUT;

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================
	// Output register
	reg CLKOUT = 1'b1;

	// Value to toggle output clock at
	parameter cntEndVal = 10'b1011101110;
	// Current count
	reg [9:0] clkCount = 10'b0000000000;

// ===========================================================================
// 										Implementation
// ===========================================================================

	//----------------------------------------------
	//						Serial Clock
	//			66.67kHz Clock Divider, period 15us
	//----------------------------------------------
	always @(posedge CLK) begin

			// Reset clock
			if(RST == 1'b1) begin
					CLKOUT <= 1'b0;
					clkCount <= 10'b0000000000;
			end
			// Count/toggle normally
			else begin

					if(clkCount == cntEndVal) begin
							CLKOUT <= ~CLKOUT;
							clkCount <= 10'b0000000000;
					end
					else begin
							clkCount <= clkCount + 1'b1;
					end

			end

	end

endmodule
