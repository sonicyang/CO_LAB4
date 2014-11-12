//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_reg8_ne.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: May 24, 2005  11:23
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_reg8_ne(clk, rst_n, din, wren, dout);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input   [7:0]  	din;    // Data input
        input           wren; // Enable Register
        output  [7:0]  	dout;   // Data Output

        reg     [7:0]  	dout;

        always@(negedge clk or negedge rst_n)
        begin
                if(~rst_n)    	dout<=8'b0;
                else if(wren)	dout<=din;
                else 		dout<=dout;
        end


endmodule