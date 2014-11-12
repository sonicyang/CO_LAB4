//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: mul_reg1_ne.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/19 02:37¤W¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module mul_reg1_ne(clk, rst_n, din, wren, dout);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input     	din;    // Data input
        input           wren; 	// Enable Register
        output    	dout;   // Data Output

        reg       	dout;

        always@(negedge clk or negedge rst_n)
        begin
                if(~rst_n)    	dout<=1'b0;
                else if(wren)	dout<=din;
                else 		dout<=dout;
        end


endmodule