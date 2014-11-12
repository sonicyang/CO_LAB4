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

module cpu_reg8x4_ne_cp(clk, rst_n, din,iack,intcrl_din, wren, mask, dout);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input   [31:0]  din;    // Data input
        input           wren;   // Write Enable
        input	[3:0]	mask;	// Byte enable mask
		input			iack;
		input   [31:0]  intcrl_din;
        output  [31:0]  dout;   // Data Output

	wire		wren_byte3;
	wire		wren_byte2;
	wire		wren_byte1;
	wire		wren_byte0;
	wire	[31:0] cp_din ;
	
	assign	wren_byte3 = iack ||(wren & (~mask[3])) ;
	assign	wren_byte2 = iack ||(wren & (~mask[2])) ;
	assign	wren_byte1 = iack ||(wren & (~mask[1])) ;
	assign	wren_byte0 = iack ||(wren & (~mask[0])) ;
	
	assign cp_din = (iack)? intcrl_din:din;
	
	cpu_reg8_ne	u_reg_byte3(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(cp_din[31:24]), 
			 .wren		(wren_byte3), 
			 .dout		(dout[31:24])
			);

	cpu_reg8_ne	u_reg_byte2(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(cp_din[23:16]), 
			 .wren		(wren_byte2), 
			 .dout		(dout[23:16])
			);
			
	cpu_reg8_ne	u_reg_byte1(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(cp_din[15:8]), 
			 .wren		(wren_byte1), 
			 .dout		(dout[15:8])
			);

	cpu_reg8_ne	u_reg_byte0(
			 .clk		(clk), 
			 .rst_n		(rst_n), 
			 .din		(cp_din[7:0]), 
			 .wren		(wren_byte0), 
			 .dout		(dout[7:0])
			);
									
endmodule