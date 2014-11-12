//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_reg5_ne.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/3 02:47¤U¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_reg5_ne(clk,iack, rst_n, din, wren, dout);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input   [4:0]  	din;    // Data input
        input           wren; 	// Enable Register
		input 			iack;
        output  [4:0]  	dout;   // Data Output

        reg     [4:0]  	dout;

        always@(negedge clk or negedge rst_n)
        begin
                if(~rst_n || iack)    	dout<=5'b0;
                else if(wren)	dout<=din;
                else 		dout<=dout;
        end


endmodule