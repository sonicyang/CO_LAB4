//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: fu_cla4.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Dec. 6, 2004  06:03pm
//---------------------------------------------------------------------
// PURPOSE: Function Unit - 4bit Carry Look-ahead adder
//---------------------------------------------------------------------
// PARAMETERS:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fu_cla4(din1, din2, carry_in, dout, carry_out);

        input   [3:0]   din1;
        input   [3:0]   din2;
        input           carry_in;
        output  [3:0]   dout;
        output          carry_out;

        wire    [3:0]   pi,gi,ci;

        assign  gi[0] = din1[0] & din2[0];
        assign  gi[1] = din1[1] & din2[1];
        assign  gi[2] = din1[2] & din2[2];
        assign  gi[3] = din1[3] & din2[3];

        assign  pi[0] = din1[0] | din2[0];
        assign  pi[1] = din1[1] | din2[1];
        assign  pi[2] = din1[2] | din2[2];
        assign  pi[3] = din1[3] | din2[3];

        assign  ci[0] = carry_in;
        assign  ci[1] = gi[0] | (pi[0]&ci[0]);
        assign  ci[2] = gi[1] | (pi[1]&gi[0]) | (pi[1]&pi[0]&ci[0]);
        assign  ci[3] = gi[2] | (pi[2]&gi[1]) | (pi[2]&pi[1]&gi[0]) |
                       (pi[2]&pi[1]&pi[0]&ci[0]);

        assign  carry_out = gi[3] | (pi[3]&gi[2]) | (pi[3]&pi[2]&gi[1]) |
                       (pi[3]&pi[2]&pi[1]&gi[0]) |
                       (pi[3]&pi[2]&pi[1]&pi[0]&ci[0]);

        assign  dout[0] = din1[0] ^ din2[0] ^ ci[0];
        assign  dout[1] = din1[1] ^ din2[1] ^ ci[1];
        assign  dout[2] = din1[2] ^ din2[2] ^ ci[2];
        assign  dout[3] = din1[3] ^ din2[3] ^ ci[3];

endmodule