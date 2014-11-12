//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: mul_decode.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Dec. 6, 2004  06:19pm
//---------------------------------------------------------------------
// PURPOSE: 
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module mul_decode(sel, a34, a34x2, a34_n, a34x2_n, dout);
	
	input	[2:0]	sel;		// Input value
	
	input 	[33:0]	a34;		// A value
	input	[33:0]	a34x2;		// 2A value
	input	[33:0]	a34_n;		// -A value
	input	[33:0]	a34x2_n;	// -2A value
	
	output	[33:0]	dout;		// Output Value
	
	reg	[33:0]	dout;
	
	always@(sel or a34 or a34x2 or a34_n or a34x2_n)
	begin
	
	    case(sel)
		3'b000:	dout = 34'b0 ;
		3'b001:	dout = a34 ;
		3'b010:	dout = a34 ;
		3'b011:	dout = a34x2 ;
		3'b100:	dout = a34x2_n ;
		3'b101:	dout = a34_n ;
		3'b110:	dout = a34_n ;
		default: dout = 34'b0 ;
	    endcase  

	end

endmodule