`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    PmodJSTK
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This component consists of three subcomponents a 66.67kHz serial clock,
//					 a SPI controller and a SPI interface. The SPI interface component is 
//					 responsible for sending and receiving a byte of data to and from the 
//					 PmodJSTK when a request is made. The SPI controller component manages all
//					 data transfer requests, and manages the data bytes being sent to the PmodJSTK.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
////////////////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module PmodJSTK(
			CLK,
			RST,
			sndRec,
			DIN,
			MISO,
			SS,
			SCLK,
			MOSI,
			DOUT
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
			input CLK;						// 100MHz onboard clock
			input RST;						// Reset
			input sndRec;					// Send receive, initializes data read/write
			input [7:0] DIN;				// Data that is to be sent to the slave
			input MISO;						// Master in slave out
			output SS;						// Slave select, active low
			output SCLK;					// Serial clock
			output MOSI;					// Master out slave in
			output [39:0] DOUT;			// All data read from the slave

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================

			// Output wires and registers
			wire SS;
			wire SCLK;
			wire MOSI;
			wire [39:0] DOUT;

			wire getByte;									// Initiates a data byte transfer in SPI_Int
			wire [7:0] sndData;							// Data to be sent to Slave
			wire [7:0] RxData;							// Output data from SPI_Int
			wire BUSY;										// Handshake from SPI_Int to SPI_Ctrl
			

			// 66.67kHz Clock Divider, period 15us
			wire iSCLK;										// Internal serial clock,
																// not directly output to slave,
																// controls state machine, etc.

// ===========================================================================
// 										Implementation
// ===========================================================================

			//-----------------------------------------------
			//  	  				SPI Controller
			//-----------------------------------------------
			spiCtrl SPI_Ctrl(
					.CLK(iSCLK),
					.RST(RST),
					.sndRec(sndRec),
					.BUSY(BUSY),
					.DIN(DIN),
					.RxData(RxData),
					.SS(SS),
					.getByte(getByte),
					.sndData(sndData),
					.DOUT(DOUT)
			);

			//-----------------------------------------------
			//  	  				  SPI Mode 0
			//-----------------------------------------------
			spiMode0 SPI_Int(
					.CLK(iSCLK),
					.RST(RST),
					.sndRec(getByte),
					.DIN(sndData),
					.MISO(MISO),
					.MOSI(MOSI),
					.SCLK(SCLK),
					.BUSY(BUSY),
					.DOUT(RxData)
			);

			//-----------------------------------------------
			//  	  				SPI Controller
			//-----------------------------------------------
			ClkDiv_66_67kHz SerialClock(
					.CLK(CLK),
					.RST(RST),
					.CLKOUT(iSCLK)
			);

endmodule
