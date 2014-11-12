//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_reg2_ne.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: May 26, 2005  12:02
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_reg2_ne(clk, iack,rst_n, din, wren, dout);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input   [1:0]  	din;    // Data input
        input           wren; 	// Enable Register
		input			iack;
        output  [1:0]  	dout;   // Data Output

        reg     [1:0]  	dout;

        always@(negedge clk or negedge rst_n or iack)
        begin
                if(~rst_n || iack)    	dout<=2'b0;
                else if(wren)	dout<=din;
                else 		dout<=dout;
        end


endmodule