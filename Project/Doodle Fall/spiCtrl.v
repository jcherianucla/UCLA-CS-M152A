`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    spiCtrl
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This component manages all data transfer requests,
//					 and manages the data bytes being sent to the PmodJSTK.
//
//  				 For more information on the contents of the bytes being sent/received 
//					 see page 2 in the PmodJSTK reference manual found at the link provided
//					 below.
//
//					 http://www.digilentinc.com/Data/Products/XUPV2P-COVERS/PmodJSTK_rm_RevC.pdf
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
////////////////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module spiCtrl(
			CLK,
			RST,
			sndRec,
			BUSY,
			DIN,
			RxData,
			SS,
			getByte,
			sndData,
			DOUT
    );

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================

			input CLK;						// 66.67kHz onboard clock
			input RST;						// Reset
			input sndRec;					// Send receive, initializes data read/write
			input BUSY;						// If active data transfer currently in progress
			input [7:0] DIN;				// Data that is to be sent to the slave
			input [7:0] RxData;			// Last data byte received
			output SS;						// Slave select, active low
			output getByte;				// Initiates a data transfer in SPI_Int
			output [7:0] sndData;		// Data that is to be sent to the slave
			output [39:0] DOUT;			// All data read from the slave

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================

			// Output wires and registers
			reg SS = 1'b1;
			reg getByte = 1'b0;
			reg [7:0] sndData = 8'h00;
			reg [39:0] DOUT = 40'h0000000000;

			// FSM States
			parameter [2:0] Idle = 3'd0,
								 Init = 3'd1,
								 Wait = 3'd2,
								 Check = 3'd3,
								 Done = 3'd4;
			
			// Present State
			reg [2:0] pState = Idle;

			reg [2:0] byteCnt = 3'd0;					// Number bits read/written
			parameter byteEndVal = 3'd5;				// Number of bytes to send/receive
			reg [39:0] tmpSR = 40'h0000000000;		// Temporary shift register to
																// accumulate all five data bytes

	// ===========================================================================
	// 										Implementation
	// ===========================================================================

	always @(negedge CLK) begin
			if(RST == 1'b1) begin
					// Reest everything
					SS <= 1'b1;
					getByte <= 1'b0;
					sndData <= 8'h00;
					tmpSR <= 40'h0000000000;
					DOUT <= 40'h0000000000;
					byteCnt <= 3'd0;
					pState <= Idle;
			end
			else begin
					
					case(pState)

								// Idle
								Idle : begin

										SS <= 1'b1;								// Disable slave
										getByte <= 1'b0;						// Do not request data
										sndData <= 8'h00;						// Clear data to be sent
										tmpSR <= 40'h0000000000;			// Clear temporary data
										DOUT <= DOUT;							// Retain output data
										byteCnt <= 3'd0;						// Clear byte count

										// When send receive signal received begin data transmission
										if(sndRec == 1'b1) begin
											pState <= Init;
										end
										else begin
											pState <= Idle;
										end
										
								end

								// Init
								Init : begin
								
										SS <= 1'b0;								// Enable slave
										getByte <= 1'b1;						// Initialize data transfer
										sndData <= DIN;						// Store input data to be sent
										tmpSR <= tmpSR;						// Retain temporary data
										DOUT <= DOUT;							// Retain output data
										
										if(BUSY == 1'b1) begin
												pState <= Wait;
												byteCnt <= byteCnt + 1'b1;	// Count
										end
										else begin
												pState <= Init;
										end
										
								end

								// Wait
								Wait : begin

										SS <= 1'b0;								// Enable slave
										getByte <= 1'b0;						// Data request already in progress
										sndData <= sndData;					// Retain input data to send
										tmpSR <= tmpSR;						// Retain temporary data
										DOUT <= DOUT;							// Retain output data
										byteCnt <= byteCnt;					// Count
										
										// Finished reading byte so grab data
										if(BUSY == 1'b0) begin
												pState <= Check;
										end
										// Data transmission is not finished
										else begin
												pState <= Wait;
										end

								end

								// Check
								Check : begin

										SS <= 1'b0;								// Enable slave
										getByte <= 1'b0;						// Do not request data
										sndData <= sndData;					// Retain input data to send
										tmpSR <= {tmpSR[31:0], RxData};	// Store byte just read
										DOUT <= DOUT;							// Retain output data
										byteCnt <= byteCnt;					// Do not count

										// Finished reading bytes so done
										if(byteCnt == 3'd5) begin
												pState <= Done;
										end
										// Have not sent/received enough bytes
										else begin
												pState <= Init;
										end
								end

								// Done
								Done : begin

										SS <= 1'b1;							// Disable slave
										getByte <= 1'b0;					// Do not request data
										sndData <= 8'h00;					// Clear input
										tmpSR <= tmpSR;					// Retain temporary data
										DOUT[39:0] <= tmpSR[39:0];		// Update output data
										byteCnt <= byteCnt;				// Do not count
										
										// Wait for external sndRec signal to be de-asserted
										if(sndRec == 1'b0) begin
												pState <= Idle;
										end
										else begin
												pState <= Done;
										end

								end

								// Default State
								default : pState <= Idle;
						endcase
			end
	end

endmodule
