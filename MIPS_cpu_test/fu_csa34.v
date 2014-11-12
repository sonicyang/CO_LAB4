 //+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: fu_csa34.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/19 04:00¤W¤È
//---------------------------------------------------------------------
// PURPOSE: Function Unit - 34bits Adder
//---------------------------------------------------------------------
// PARAMETERS:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fu_csa34(din1, din2, carry_in, dout, carry_out, overflow);

	input	[33:0]	din1;
	input	[33:0]	din2;
	input		carry_in;
	output	[33:0]	dout;
	output		carry_out;
	output		overflow;


	wire		p32, p33, g32, g33;
	wire		carry31, carry32, carry33;
	
	fu_csa32	u_csa32(
			.din1		(din1[31:0]), 
			.din2		(din2[31:0]), 
			.carry_in	(carry_in), 
			.dout		(dout[31:0]), 
			.carry_out	(carry31), 
			.overflow	()
			);
			

        assign  g32 = din1[32] & din2[32];
        assign  g33 = din1[33] & din2[33];

        assign  p32 = din1[32] | din2[32];
        assign  p33 = din1[33] | din2[33];
        
        assign  carry32 = g32 | (p32&carry31);
        assign  carry33 = g33 | (p33&g32) | (p33&p32&carry31);
                       
        assign  dout[32] = din1[32] ^ din2[32] ^ carry31;
        assign  dout[33] = din1[33] ^ din2[33] ^ carry32;
        
	assign	carry_out = carry33;
	assign	overflow = carry33^carry32;
	
						               
endmodule