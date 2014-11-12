//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_wb.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.1
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Apr. 26, 2005  22:02
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on


module cpu_wb(  //control signal input
                big_endian,
                wb_align_op,
                wb_mulreg_sel,
                wb_wbdata_sel,
				irqn,
                //datapath input
                wb_rdata_bus,
                wb_result_bus,
                m_mul_hi,
                m_mul_lo,
                wb_mul_hi,
                wb_mul_lo,
                wb_dmem_offset,
                //control signal output
		wb_write_mask,
                //datapath output
                wb_write_bus

           );



        //control signal input
        input		big_endian;	// [1]Big-Endian or 
                                        // [0]Little-Endian
        input		irqn;
        input	[2:0]	wb_align_op;
        
        input           wb_mulreg_sel;  // 1'b0 : i_mul_hi = m_mul_hi
                                        //        i_mul_lo = m_mul_lo
                                        // 1'b1 : i_mul_hi = wb_mul_hi
                                        //        i_mul_lo = wb_mul_lo

        input   [1:0]   wb_wbdata_sel;  // 2'b00 : wb_write_bus = wb_result_bus
                                        // 2'b01 : wb_write_bus = wb_rdata_bus
                                        // 2'b10 : wb_write_bus = i_mul_hi
                                        // 2'b11 : wb_write_bus = i_mul_lo

        //datapath input
        input   [31:0]  wb_rdata_bus;
        input   [31:0]  wb_result_bus;
        input   [31:0]  m_mul_hi;
        input   [31:0]  m_mul_lo;
        input   [31:0]  wb_mul_hi;
        input   [31:0]  wb_mul_lo;
        input	[1:0]	wb_dmem_offset;

        //control signal output
	output	[3:0]	wb_write_mask;
		

        //datapath output
        output  [31:0]  wb_write_bus;

        //Internal wire/reg
        wire    [31:0]  i_mul_hi;
        wire    [31:0]  i_mul_lo;
        wire	[31:0]	i_wb_rdata_bus;
       	reg     [31:0]  wb_write_bus;
       	
       	
//=====================================================================
//      Main Body
//=====================================================================

        assign  i_mul_hi = (wb_mulreg_sel==1'b1)
                             ? wb_mul_hi
                             : m_mul_hi ;

        assign  i_mul_lo = (wb_mulreg_sel==1'b1)
                             ? wb_mul_lo
                             : m_mul_lo ;

	cpu_wb_alignment	u_cpu_wb_alignment(  
				//input
				 .addr		(wb_dmem_offset),
				 .big_endian	(big_endian),
				 .align_op	(wb_align_op),
        			 .load_data	(wb_rdata_bus),
        			//output
        			 .write_mask	(wb_write_mask),
        			 .dout 		(i_wb_rdata_bus) 
        			);


        always@(wb_wbdata_sel or wb_result_bus or i_wb_rdata_bus or
                i_mul_hi or i_mul_lo)
        begin

            case(wb_wbdata_sel)
                2'b00:  wb_write_bus = wb_result_bus;
                2'b01:  wb_write_bus = i_wb_rdata_bus;
                2'b10:  wb_write_bus = i_mul_hi;
                2'b11:  wb_write_bus = i_mul_lo;
            endcase

        end

endmodule