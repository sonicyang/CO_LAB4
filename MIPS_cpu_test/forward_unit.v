//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: forward_unit.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Oct. 27, 2004  04:01pm
//---------------------------------------------------------------------
// PURPOSE: Forwarding Unit
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on


module forward_unit(    ins_rs,
                        ins_rt,
                        m_regwrite,
                        m_write_num,
                        wb_regwrite,
                        wb_write_num,
                        forward_a,
                        forward_b
                        );

        input   [4:0]   ins_rs;
        input   [4:0]   ins_rt;
        input           m_regwrite;
        input   [4:0]   m_write_num;
        input           wb_regwrite;
        input   [4:0]   wb_write_num;

        output  [1:0]   forward_a;
        output  [1:0]   forward_b;

        reg     [1:0]   forward_a;
        reg     [1:0]   forward_b;



        always@(m_regwrite or m_write_num or ins_rs or
                wb_regwrite or wb_write_num)
        begin
                if( (m_regwrite)&
                    (m_write_num!=5'b0000)&
                    (m_write_num==ins_rs) )

                        forward_a = 2'b10 ;

                else if( (wb_regwrite)&
                         (wb_write_num!=5'b0000)&
                         ((~m_regwrite)|(wb_write_num!=m_write_num))&
                         (wb_write_num==ins_rs) )

                        forward_a = 2'b01 ;

                else
                        forward_a = 2'b00 ;


        end


        always@(m_regwrite or m_write_num or ins_rt or
                wb_regwrite or wb_write_num)
        begin
                if( (m_regwrite)&
                    (m_write_num!=5'b0000)&
                    (m_write_num==ins_rt) )

                        forward_b = 2'b10 ;

                else if( (wb_regwrite)&
                         (wb_write_num!=5'b0000)&
                         ((~m_regwrite)|(wb_write_num!=m_write_num))&
                         (wb_write_num==ins_rt) )

                        forward_b = 2'b01 ;

                else
                        forward_b = 2'b00 ;


        end

endmodule