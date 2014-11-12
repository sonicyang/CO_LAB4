//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: branch_unit.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Dec. 9, 2004  12:33am
//---------------------------------------------------------------------
// PURPOSE: Branch Unit
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on


module branch_unit( rs, rt, sel, taken );

        input   [31:0]  rs;
        input   [31:0]  rt;
        input   [2:0]   sel;
        output          taken;
        reg             taken;

        wire            rs_neg;
        wire            rs_neg_n;
        wire            rs_zero;
        wire            rs_zero_n;
        wire            rs_pos;
        wire            rs_pos_n;
        wire            rs_rt_equ;
        wire            rs_rt_equ_n;

        assign          rs_neg = rs[31];
        assign          rs_neg_n = ~rs[31];

        assign          rs_zero = (rs==32'b0) ? 1'b1 : 1'b0 ;
        assign          rs_zero_n = ~rs_zero;

        assign          rs_rt_equ = (rs==rt) ? 1'b1 : 1'b0;
        assign          rs_rt_equ_n = ~rs_rt_equ;

        assign          rs_pos_n = rs_neg | rs_zero ;
        assign          rs_pos = ~ rs_pos_n ;


        always@(sel or rs_neg or rs_neg_n or rs_pos or
                rs_pos_n or rs_rt_equ or rs_rt_equ_n)
        begin
            case(sel)
                3'b000: taken = rs_neg;
                3'b001: taken = rs_neg_n;
                3'b010: taken = 1'b0;
                3'b011: taken = 1'b0;
                3'b100: taken = rs_rt_equ;
                3'b101: taken = rs_rt_equ_n;
                3'b110: taken = rs_pos_n;
                3'b111: taken = rs_pos;
            endcase
        end

endmodule