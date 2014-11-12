//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_mem.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/22 03:07¤U¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_mem( //system input
                clk,
                rst_n,
                dmem_rdatabus,
				iack,
                //control signal input
                big_endian,
                m_memwrite,
                m_memread,
                m_store_op,
                m_mhi_en,
                m_mlo_en,
                m_align_op,
                m_mulreg_sel,
                m_wbdata_sel,
                m_regwrite,
				m_w_cp0reg,

                //datapath input
                m_result_bus,
                m_b_bus,
                m_write_num,
                mul_hi,
                mul_lo,

                //system output
                dmem_addr,
                dmem_wdatabus,
                dmem_request,
                dmem_be,
                dmem_write,

                //control signal output
                wb_align_op,
                wb_mulreg_sel,
                wb_wbdata_sel,
                wb_regwrite,
				wb_w_cp0reg,

                //datapath output
                wb_write_num,
                wb_result_bus,
                wb_rdata_bus,
                wb_mul_hi,
                wb_mul_lo,
                wb_dmem_offset

                );

        //system input
        input           clk;
        input           rst_n;
        input   [31:0]  dmem_rdatabus;
		input			iack;

        //control signal input
        input           big_endian;
        input           m_memwrite;
        input           m_memread;
        input   [2:0]   m_store_op;
        input           m_mhi_en;
        input           m_mlo_en;
        input   [2:0]   m_align_op;
        input           m_mulreg_sel;
        input   [1:0]   m_wbdata_sel;
        input           m_regwrite;
		input			m_w_cp0reg;


        //datapath input
        input   [31:0]  m_result_bus;
        input   [31:0]  m_b_bus;
        input   [4:0]   m_write_num;
        input   [31:0]  mul_hi;
        input   [31:0]  mul_lo;

        //system output
        output  [31:0]  dmem_addr;
        output  [31:0]  dmem_wdatabus;
        output          dmem_request;
        output  [3:0]   dmem_be;
        output          dmem_write;

        //control signal output
        output  [2:0]   wb_align_op;
        output          wb_mulreg_sel;
        output  [1:0]   wb_wbdata_sel;
        output          wb_regwrite;
		output			wb_w_cp0reg;

        //datapath output
        output  [4:0]   wb_write_num;
        output  [31:0]  wb_result_bus;
        output  [31:0]  wb_rdata_bus;
        output  [31:0]  wb_mul_hi;
        output  [31:0]  wb_mul_lo;
        output  [1:0]   wb_dmem_offset;

        //-------------------------------------------------------------
        // Internal Wire
        //-------------------------------------------------------------
        wire    [31:0]  m_rdata_bus;
        wire    [1:0]   m_dmem_offset;
        reg     [31:0]  dmem_wdatabus;
        reg     [3:0]   dmem_be;

//=====================================================================
//      Main Body
//=====================================================================

        assign  m_dmem_offset = m_result_bus[1:0];
        assign  dmem_addr = m_result_bus;
        assign  dmem_request = m_memwrite|m_memread;
        assign  dmem_write = m_memwrite;



        //-------------------------------------------------------------
        // dmem_wdatabus
        //-------------------------------------------------------------
        always@(m_memwrite or m_b_bus or big_endian or
                m_dmem_offset or m_store_op)
        begin

            if(m_memwrite==1'b1)
            begin
                case(m_store_op[1:0])
                //SB
                2'b00:  begin
                        if(big_endian)  //Big-Endian
                            case(m_dmem_offset)
                                2'b00:  dmem_wdatabus = {m_b_bus[7:0],24'b0};
                                2'b01:  dmem_wdatabus = {m_b_bus[15:0],16'b0};
                                2'b10:  dmem_wdatabus = {m_b_bus[23:0],8'b0};
                                2'b11:  dmem_wdatabus = m_b_bus;
                            endcase

                        else    //Little-Endian
                            case(m_dmem_offset)
                                2'b00:  dmem_wdatabus = m_b_bus;
                                2'b01:  dmem_wdatabus = {m_b_bus[23:0],8'b0};
                                2'b10:  dmem_wdatabus = {m_b_bus[15:0],16'b0};
                                2'b11:  dmem_wdatabus = {m_b_bus[7:0],24'b0};
                            endcase
                        end

                //SH
                2'b01:  begin
                        if(big_endian)  //Big-Endian
                            dmem_wdatabus = (m_dmem_offset[1]==1'b1)
                                              ? m_b_bus
                                              : {m_b_bus[15:0],16'b0};
                        else    //Little-Endian
                            dmem_wdatabus = (m_dmem_offset[1]==1'b1)
                                              ? {m_b_bus[15:0],16'b0}
                                              : m_b_bus;
                        end

                //SWL or SWR
                2'b10:  begin
                        if(m_store_op[2]==1'b1) // SWR
                            begin
                            if(big_endian)      //Big-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_wdatabus = {m_b_bus[7:0],24'b0};
                                        2'b01:  dmem_wdatabus = {m_b_bus[15:0],16'b0};
                                        2'b10:  dmem_wdatabus = {m_b_bus[23:0],8'b0};
                                        2'b11:  dmem_wdatabus = m_b_bus;
                                endcase

                            else        //Little-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_wdatabus = m_b_bus;
                                        2'b01:  dmem_wdatabus = {m_b_bus[23:0],8'b0};
                                        2'b10:  dmem_wdatabus = {m_b_bus[15:0],16'b0};
                                        2'b11:  dmem_wdatabus = {m_b_bus[7:0],24'b0};
                                endcase
                            end
                        else // SWL
                            begin
                            if(big_endian)      //Big-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_wdatabus = m_b_bus;
                                        2'b01:  dmem_wdatabus = {8'b0,m_b_bus[31:8]};
                                        2'b10:  dmem_wdatabus = {16'b0,m_b_bus[31:16]};
                                        2'b11:  dmem_wdatabus = {24'b0,m_b_bus[31:24]};
                                endcase

                            else        //Little-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_wdatabus = {24'b0,m_b_bus[31:24]};
                                        2'b01:  dmem_wdatabus = {16'b0,m_b_bus[31:16]};
                                        2'b10:  dmem_wdatabus = {8'b0,m_b_bus[31:8]};
                                        2'b11:  dmem_wdatabus = m_b_bus;
                                endcase
                            end
                        end
                //SW
                2'b11:  dmem_wdatabus = m_b_bus;
                endcase
            end
            else
                dmem_wdatabus = 32'b0;

        end





        //-------------------------------------------------------------
        // dmem_be
        //-------------------------------------------------------------
        always@(big_endian or m_dmem_offset or m_store_op)
        begin

            case(m_store_op[1:0])
                //SB
                2'b00:  begin
                        if(big_endian)  //Big-Endian
                            case(m_dmem_offset)
                                2'b00:  dmem_be = 4'b1000;
                                2'b01:  dmem_be = 4'b0100;
                                2'b10:  dmem_be = 4'b0010;
                                2'b11:  dmem_be = 4'b0001;
                            endcase

                        else    //Little-Endian
                            case(m_dmem_offset)
                                2'b00:  dmem_be = 4'b0001;
                                2'b01:  dmem_be = 4'b0010;
                                2'b10:  dmem_be = 4'b0100;
                                2'b11:  dmem_be = 4'b1000;
                            endcase
                        end

                //SH
                2'b01:  begin
                        if(big_endian)  //Big-Endian
                            dmem_be = (m_dmem_offset[1]==1'b1)
                                        ? 4'b0011
                                        : 4'b1100;
                        else    //Little-Endian
                            dmem_be = (m_dmem_offset[1]==1'b1)
                                        ? 4'b1100
                                        : 4'b0011;
                        end

                //SWL or SWR
                2'b10:  begin
                        if(m_store_op[2]==1'b1) // SWR
                            begin
                            if(big_endian)      //Big-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_be = 4'b1000;
                                        2'b01:  dmem_be = 4'b1100;
                                        2'b10:  dmem_be = 4'b1110;
                                        2'b11:  dmem_be = 4'b1111;
                                endcase

                            else        //Little-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_be = 4'b1111;
                                        2'b01:  dmem_be = 4'b1110;
                                        2'b10:  dmem_be = 4'b1100;
                                        2'b11:  dmem_be = 4'b1000;
                                endcase
                            end
                        else // SWL
                            begin
                            if(big_endian)      //Big-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_be = 4'b1111;
                                        2'b01:  dmem_be = 4'b0111;
                                        2'b10:  dmem_be = 4'b0011;
                                        2'b11:  dmem_be = 4'b0001;
                                endcase

                            else        //Little-Endian
                                case(m_dmem_offset)
                                        2'b00:  dmem_be = 4'b0001;
                                        2'b01:  dmem_be = 4'b0011;
                                        2'b10:  dmem_be = 4'b0111;
                                        2'b11:  dmem_be = 4'b1111;
                                endcase
                            end
                        end
                //SW
                2'b11:  dmem_be = 4'b1111;

            endcase

        end

        //-------------------------------------------------------------
        //      Load Data
        //-------------------------------------------------------------
        assign  m_rdata_bus = dmem_rdatabus;


        //=============================================================
        //      MEM/WB Register
        //-------------------------------------------------------------
        cpu_reg3_ne     u_m2wb_align_op(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_align_op),
                         .wren          (rst_n),
                         .dout          (wb_align_op)
                        );

        cpu_reg1_ne     u_m2wb_mulreg_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_mulreg_sel),
                         .wren          (rst_n),
                         .dout          (wb_mulreg_sel)
                        );

        cpu_reg2_ne     u_m2wb_wbdata_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_wbdata_sel),
                         .wren          (rst_n),
                         .dout          (wb_wbdata_sel)
                        );
						
		cpu_reg1_ne     u_m2wb_cp0_type(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (m_w_cp0reg),
                         .wren          (rst_n),
                         .dout          (wb_w_cp0reg)
                        );

        cpu_reg1_ne     u_m2wb_regwrite(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_regwrite),
                         .wren          (rst_n),
                         .dout          (wb_regwrite)
                        );

        cpu_reg5_ne     u_m2wb_write_num(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_write_num),
                         .wren          (rst_n),
                         .dout          (wb_write_num)
                        );

        //-------------------------------------------------------------
        cpu_reg32_ne_ex    u_m2wb_result_bus(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_result_bus),
                         .wren          (rst_n),
                         .dout          (wb_result_bus)
                        );

        cpu_reg32_ne_ex    u_mdr(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_rdata_bus),
                         .wren          (m_memread),
                         .dout          (wb_rdata_bus)
                        );

        cpu_reg32_ne_ex    u_m2wb_mul_hi(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (mul_hi),
                         .wren          (m_mhi_en),
                         .dout          (wb_mul_hi)
                        );

        cpu_reg32_ne_ex    u_m2wb_mul_lo(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (mul_lo),
                         .wren          (m_mlo_en),
                         .dout          (wb_mul_lo)
                        );

        cpu_reg2_ne    u_m2wb_dmem_offset(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (m_dmem_offset),
                         .wren          (rst_n),
                         .dout          (wb_dmem_offset)
                        );


        //=============================================================



endmodule