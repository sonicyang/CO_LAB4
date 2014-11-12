 //+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: fu_csa16.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 07-07-2004  11:55pm
//---------------------------------------------------------------------
// PURPOSE: Function Unit - 16bits Carry-Select adder
//---------------------------------------------------------------------
// PARAMETERS:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fu_csa16(din1, din2, carry_in, dout, carry_out);

        input   [15:0]  din1;
        input   [15:0]  din2;
        input           carry_in;
        output  [15:0]  dout;
        output          carry_out;

        wire            sel;
        wire    [7:0]   sum0, sum1;
        wire            carry0, carry1;

        fu_csa8         u0(
                        .din1           (din1[7:0]),
                        .din2           (din2[7:0]),
                        .carry_in       (carry_in),
                        .dout           (dout[7:0]),
                        .carry_out      (sel)
                        );

        fu_csa8         u1(
                        .din1           (din1[15:8]),
                        .din2           (din2[15:8]),
                        .carry_in       (1'b0),
                        .dout           (sum0),
                        .carry_out      (carry0)
                        );

        fu_csa8         u2(
                        .din1           (din1[15:8]),
                        .din2           (din2[15:8]),
                        .carry_in       (1'b1),
                        .dout           (sum1),
                        .carry_out      (carry1)
                        );

        assign  dout[15:8] = (sel==1'b1)?sum1:sum0;
        assign  carry_out = (sel==1'b1)?carry1:carry0;

endmodule