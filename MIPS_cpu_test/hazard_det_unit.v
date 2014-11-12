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
// RELEASE: Dec. 25, 2004  07:22am
//---------------------------------------------------------------------
// PURPOSE: Hazard detection Unit
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module hazard_det_unit(
        id_ins_rs,
        id_ins_rt,
        cs_rs_rden,
        cs_rt_rden,
        cs_branch_rs_rden,
        cs_branch_rt_rden,
        ex_memread,
        ex_write_num,
        ex_regwrite,
        m_memread,
        m_write_num,
        cs_mul_check,
        mul_stall,
        interlock_hdu
        );

   // input           hdu_mask;
    input   [4:0]   id_ins_rs;
    input   [4:0]   id_ins_rt;
    input           cs_rs_rden;
    input           cs_rt_rden;
    input           cs_branch_rs_rden;
    input           cs_branch_rt_rden;
    input           ex_memread;
    input   [4:0]   ex_write_num;
    input           ex_regwrite;
    input           m_memread;
    input   [4:0]   m_write_num;
    input           cs_mul_check;
    input           mul_stall;
    output          interlock_hdu;


    reg             branch_hazard;
    reg             load_use_hazard;
    wire            mul_hazard;

    //Load-Use Hazard
    always@( cs_rs_rden or cs_rt_rden or
             id_ins_rs or id_ins_rt or
             ex_memread or ex_write_num)
    begin

            if( ex_memread &
                ( (cs_rs_rden & (id_ins_rs == ex_write_num) )|
                  (cs_rt_rden & (id_ins_rt == ex_write_num) )
                 )
               )
                    load_use_hazard = 1'b1 ;
            else
                    load_use_hazard = 1'b0 ;

    end


        //MIPS Branch Hazard
        always@(cs_branch_rs_rden or cs_branch_rt_rden or
                id_ins_rs or id_ins_rt or
                ex_regwrite or ex_write_num or
                ex_memread or ex_write_num or
                m_memread or m_write_num)
        begin

                if(  (  (ex_regwrite)&
                        ( ( (cs_branch_rs_rden)&
                            (id_ins_rs==ex_write_num) )|
                          ( (cs_branch_rt_rden)&
                            (id_ins_rt==ex_write_num) ) )
                      ) |
                      (  (ex_memread)&
                        ( ( (cs_branch_rs_rden)&
                            (id_ins_rs==ex_write_num) )|
                          ( (cs_branch_rt_rden)&
                            (id_ins_rt==ex_write_num) ) )
                      ) |
                      (  (m_memread)&
                        ( ( (cs_branch_rs_rden)&
                            (id_ins_rs==m_write_num) )|
                          ( (cs_branch_rt_rden)&
                            (id_ins_rt==m_write_num) ) )
                      )
                   )
                        branch_hazard = 1'b1 ;
                else
                        branch_hazard = 1'b0 ;

        end


    assign  mul_hazard = cs_mul_check & mul_stall ;

    assign  interlock_hdu = load_use_hazard | branch_hazard | mul_hazard;


endmodule