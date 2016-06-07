`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    ClkDiv_5Hz
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Converts input 100MHz clock signal to a 5Hz clock signal.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////

// ============================================================================== 
// 										  Define Module
// ==============================================================================
module ClkDiv_5Hz(
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
	reg CLKOUT;
	
	// Value to toggle output clock at
	parameter cntEndVal = 24'h989680;
	//parameter cntEndVal = 10000; // 50 Hz
	// Current count
	reg [23:0] clkCount = 24'h000000;
	

// ===========================================================================
// 										Implementation
// ===========================================================================

	//-------------------------------------------------
	//	5Hz Clock Divider Generates Send/Receive signal
	//-------------------------------------------------
	always @(posedge CLK) begin

			// Reset clock
			if(RST == 1'b1) begin
					CLKOUT <= 1'b0;
					clkCount <= 24'h000000;
			end
			else begin

					if(clkCount == cntEndVal) begin
							CLKOUT <= ~CLKOUT;
							clkCount <= 24'h000000;
					end
					else begin
							clkCount <= clkCount + 1'b1;
					end

			end

	end

endmodule
