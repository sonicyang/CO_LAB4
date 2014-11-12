 //+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: fu_csa8v.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 07-07-2004  11:55pm
//---------------------------------------------------------------------
// PURPOSE: Function Unit - 8bits Carry-Select adder
//                          with overflow detecting
//---------------------------------------------------------------------
// PARAMETERS:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fu_csa8v(din1, din2, carry_in, dout, carry_out, overflow);

        input   [7:0]   din1;
        input   [7:0]   din2;
        input           carry_in;
        output  [7:0]   dout;
        output          carry_out;
        output          overflow;

        wire            sel;
        wire    [3:0]   sum0, sum1;
        wire            carry0, carry1;
        wire            overflow0, overflow1;

        fu_cla4         u0(
                        .din1           (din1[3:0]),
                        .din2           (din2[3:0]),
                        .carry_in       (carry_in),
                        .dout           (dout[3:0]),
                        .carry_out      (sel)
                        );

        fu_cla4v        u1(
                        .din1           (din1[7:4]),
                        .din2           (din2[7:4]),
                        .carry_in       (1'b0),
                        .dout           (sum0),
                        .carry_out      (carry0),
                        .overflow       (overflow0)
                        );

        fu_cla4v        u2(
                        .din1           (din1[7:4]),
                        .din2           (din2[7:4]),
                        .carry_in       (1'b1),
                        .dout           (sum1),
                        .carry_out      (carry1),
                        .overflow       (overflow1)
                        );

        assign  dout[7:4] = (sel==1'b1)?sum1:sum0;
        assign  carry_out = (sel==1'b1)?carry1:carry0;
        assign  overflow = (sel==1'b1)?overflow1:overflow0;

endmodule