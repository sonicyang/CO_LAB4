//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_reg8x4.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Apr. 30, 2005  17:56
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_reg8x4_ne(clk, rst_n, din, wren, mask, dout);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input   [31:0]  din;    // Data input
        input           wren;   // Write Enable
        input	[3:0]	mask;	// Byte enable mask
        output  [31:0]  dout;   // Data Output

	wire		wren_byte3;
	wire		wren_byte2;
	wire		wren_byte1;
	wire		wren_byte0;
	
	assign	wren_byte3 = wren & (~mask[3]) ;
	assign	wren_byte2 = wren & (~mask[2]) ;
	assign	wren_byte1 = wren & (~mask[1]) ;
	assign	wren_byte0 = wren & (~mask[0]) ;

	cpu_reg8_ne	u_reg_byte3(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(din[31:24]), 
			 .wren		(wren_byte3), 
			 .dout		(dout[31:24])
			);

	cpu_reg8_ne	u_reg_byte2(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(din[23:16]), 
			 .wren		(wren_byte2), 
			 .dout		(dout[23:16])
			);
			
	cpu_reg8_ne	u_reg_byte1(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(din[15:8]), 
			 .wren		(wren_byte1), 
			 .dout		(dout[15:8])
			);

	cpu_reg8_ne	u_reg_byte0(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(din[7:0]), 
			 .wren		(wren_byte0), 
			 .dout		(dout[7:0])
			);
									
endmodule