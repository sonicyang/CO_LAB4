//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: regbank.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Apr. 26, 2005  22:02
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_regbank( 	clk,
                	rst_n,
					iack,
					cp0_ins,
					mf_cp0_ins,
                	read_reg1_num,
                	read_reg2_num,
					read_reg3_num,   /*****/
                	write_reg_num,
					wb_w_cp0reg,
                	write_data,
                	read_data1,
                	read_data2,
                	cs_regwrite,
					cs_write_mask,
					
					//for interrupt controler//
					id2intctl,     		  	//  (O)
					id_intctl_epc, 			//  (I)
					id_intctl_cause,		//  (I)
					id_intctl_status		//  (I)
					
                	);

        input           clk;            // System clk
        input           rst_n;          // System nReset
		input			iack;
		//
		input			cp0_ins;		//CP0 INS
		input			mf_cp0_ins;
		//
        input   [4:0]   read_reg1_num;  // Registers Number
        input   [4:0]   read_reg2_num;  // Registers Number
		input	[4:0]   read_reg3_num;
        input   [4:0]   write_reg_num;  // Registers Number
		input			wb_w_cp0reg;
	
        input   [31:0]  write_data;     // Write data bus
        output  [31:0]  read_data1;     // Read data bus
        output  [31:0]  read_data2;     // Read data bus

        input           cs_regwrite;
        input	[3:0]	cs_write_mask;
		
		//for interrupt controler//
		output  [31:0] id2intctl;				//cp0_status//
		
		input 	[31:0] id_intctl_epc;			//cp0_14
		input 	[31:0] id_intctl_cause;			//cp0_13
		input 	[31:0] id_intctl_status;		//cp0_12
		
		


        wire    [31:0]  addr_decode;
        wire    [31:0]  reg_enable;
		wire    [31:0]  cp0_reg_enable;
        wire    [31:0]  reg00, reg01, reg02, reg03,
                        reg04, reg05, reg06, reg07,
                        reg08, reg09, reg10, reg11,
                        reg12, reg13, reg14, reg15,
                        reg16, reg17, reg18, reg19,
                        reg20, reg21, reg22, reg23,
                        reg24, reg25, reg26, reg27,
                        reg28, reg29, reg30, reg31;
						
		wire    [31:0]  cpr00, cpr01, cpr02, cpr03,
                        cpr04, cpr05, cpr06, cpr07,
                        cpr08, cpr09, cpr10, cpr11,
                        cpr12, cpr13, cpr14, cpr15,
                        cpr16, cpr17, cpr18, cpr19,
                        cpr20, cpr21, cpr22, cpr23,
                        cpr24, cpr25, cpr26, cpr27,
                        cpr28, cpr29, cpr30, cpr31;

        reg     [31:0]  read_data1_content;
        reg     [31:0]  read_data2_content;

		assign		id2intctl	= cpr12;					/*cp0_status*/
		
		
        //=============================================================
        //      Decode5to32 - Register Selector
        //=============================================================
        cpu_decode5to32 u_cpu_decode5to32(
                         .din   (write_reg_num),
                         .dout  (addr_decode)
                        );

        //=============================================================
        //      Register 32bits x 32
        //=============================================================
        assign  reg_enable[0] = 1'b0;
        assign  reg_enable[1] = cs_regwrite & addr_decode[1] & (~wb_w_cp0reg);
        assign  reg_enable[2] = cs_regwrite & addr_decode[2] & (~wb_w_cp0reg);
        assign  reg_enable[3] = cs_regwrite & addr_decode[3] & (~wb_w_cp0reg);
        assign  reg_enable[4] = cs_regwrite & addr_decode[4] & (~wb_w_cp0reg);
        assign  reg_enable[5] = cs_regwrite & addr_decode[5] & (~wb_w_cp0reg);
        assign  reg_enable[6] = cs_regwrite & addr_decode[6] & (~wb_w_cp0reg);
        assign  reg_enable[7] = cs_regwrite & addr_decode[7] & (~wb_w_cp0reg);
        assign  reg_enable[8] = cs_regwrite & addr_decode[8] & (~wb_w_cp0reg);
        assign  reg_enable[9] = cs_regwrite & addr_decode[9] & (~wb_w_cp0reg);
        assign  reg_enable[10] = cs_regwrite & addr_decode[10] & (~wb_w_cp0reg);
        assign  reg_enable[11] = cs_regwrite & addr_decode[11] & (~wb_w_cp0reg);
        assign  reg_enable[12] = cs_regwrite & addr_decode[12] & (~wb_w_cp0reg);
        assign  reg_enable[13] = cs_regwrite & addr_decode[13] & (~wb_w_cp0reg);
        assign  reg_enable[14] = cs_regwrite & addr_decode[14] & (~wb_w_cp0reg);
        assign  reg_enable[15] = cs_regwrite & addr_decode[15] & (~wb_w_cp0reg);
        assign  reg_enable[16] = cs_regwrite & addr_decode[16] & (~wb_w_cp0reg);
        assign  reg_enable[17] = cs_regwrite & addr_decode[17] & (~wb_w_cp0reg);
        assign  reg_enable[18] = cs_regwrite & addr_decode[18] & (~wb_w_cp0reg);
        assign  reg_enable[19] = cs_regwrite & addr_decode[19] & (~wb_w_cp0reg);
        assign  reg_enable[20] = cs_regwrite & addr_decode[20] & (~wb_w_cp0reg);
        assign  reg_enable[21] = cs_regwrite & addr_decode[21] & (~wb_w_cp0reg);
        assign  reg_enable[22] = cs_regwrite & addr_decode[22] & (~wb_w_cp0reg);
        assign  reg_enable[23] = cs_regwrite & addr_decode[23] & (~wb_w_cp0reg);
        assign  reg_enable[24] = cs_regwrite & addr_decode[24] & (~wb_w_cp0reg);
        assign  reg_enable[25] = cs_regwrite & addr_decode[25] & (~wb_w_cp0reg);
        assign  reg_enable[26] = cs_regwrite & addr_decode[26] & (~wb_w_cp0reg);
        assign  reg_enable[27] = cs_regwrite & addr_decode[27] & (~wb_w_cp0reg);
        assign  reg_enable[28] = cs_regwrite & addr_decode[28] & (~wb_w_cp0reg);
        assign  reg_enable[29] = cs_regwrite & addr_decode[29] & (~wb_w_cp0reg);
        assign  reg_enable[30] = cs_regwrite & addr_decode[30] & (~wb_w_cp0reg);
        assign  reg_enable[31] = cs_regwrite & addr_decode[31] & (~wb_w_cp0reg);
		
		assign  cp0_reg_enable[0] = cs_regwrite & addr_decode[0]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[1] = cs_regwrite & addr_decode[1]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[2] = cs_regwrite & addr_decode[2]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[3] = cs_regwrite & addr_decode[3]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[4] = cs_regwrite & addr_decode[4]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[5] = cs_regwrite & addr_decode[5]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[6] = cs_regwrite & addr_decode[6]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[7] = cs_regwrite & addr_decode[7]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[8] = cs_regwrite & addr_decode[8]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[9] = cs_regwrite & addr_decode[9]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[10] = cs_regwrite & addr_decode[10]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[11] = cs_regwrite & addr_decode[11]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[12] = cs_regwrite & addr_decode[12]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[13] = cs_regwrite & addr_decode[13]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[14] = cs_regwrite & addr_decode[14]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[15] = cs_regwrite & addr_decode[15]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[16] = cs_regwrite & addr_decode[16]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[17] = cs_regwrite & addr_decode[17]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[18] = cs_regwrite & addr_decode[18]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[19] = cs_regwrite & addr_decode[19]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[20] = cs_regwrite & addr_decode[20]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[21] = cs_regwrite & addr_decode[21]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[22] = cs_regwrite & addr_decode[22]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[23] = cs_regwrite & addr_decode[23]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[24] = cs_regwrite & addr_decode[24]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[25] = cs_regwrite & addr_decode[25]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[26] = cs_regwrite & addr_decode[26]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[27] = cs_regwrite & addr_decode[27]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[28] = cs_regwrite & addr_decode[28]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[29] = cs_regwrite & addr_decode[29]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[30] = cs_regwrite & addr_decode[30]  & (wb_w_cp0reg);
        assign  cp0_reg_enable[31] = cs_regwrite & addr_decode[31]  & (wb_w_cp0reg);
		


        assign  reg00 = 32'b0;
		//cp0  number 12    Status
		//cp0  number 13   	Cause
		//cp0  number 14   	EPC
		
        
        cpu_reg8x4_ne	r01(clk, rst_n, write_data, reg_enable[1], 	cs_write_mask, reg01);
        cpu_reg8x4_ne	r02(clk, rst_n, write_data, reg_enable[2], 	cs_write_mask, reg02);
        cpu_reg8x4_ne	r03(clk, rst_n, write_data, reg_enable[3], 	cs_write_mask, reg03);
        cpu_reg8x4_ne	r04(clk, rst_n, write_data, reg_enable[4], 	cs_write_mask, reg04);
        cpu_reg8x4_ne	r05(clk, rst_n, write_data, reg_enable[5], 	cs_write_mask, reg05);
        cpu_reg8x4_ne	r06(clk, rst_n, write_data, reg_enable[6], 	cs_write_mask, reg06);
        cpu_reg8x4_ne	r07(clk, rst_n, write_data, reg_enable[7], 	cs_write_mask, reg07);
        cpu_reg8x4_ne	r08(clk, rst_n, write_data, reg_enable[8], 	cs_write_mask, reg08);
        cpu_reg8x4_ne	r09(clk, rst_n, write_data, reg_enable[9], 	cs_write_mask, reg09);
        cpu_reg8x4_ne	r10(clk, rst_n, write_data, reg_enable[10], cs_write_mask, reg10);
        cpu_reg8x4_ne	r11(clk, rst_n, write_data, reg_enable[11], cs_write_mask, reg11);
        cpu_reg8x4_ne	r12(clk, rst_n, write_data, reg_enable[12], cs_write_mask, reg12);
        cpu_reg8x4_ne	r13(clk, rst_n, write_data, reg_enable[13], cs_write_mask, reg13);
        cpu_reg8x4_ne	r14(clk, rst_n, write_data, reg_enable[14], cs_write_mask, reg14);
        cpu_reg8x4_ne	r15(clk, rst_n, write_data, reg_enable[15], cs_write_mask, reg15);
        cpu_reg8x4_ne	r16(clk, rst_n, write_data, reg_enable[16], cs_write_mask, reg16);
        cpu_reg8x4_ne	r17(clk, rst_n, write_data, reg_enable[17], cs_write_mask, reg17);
        cpu_reg8x4_ne	r18(clk, rst_n, write_data, reg_enable[18], cs_write_mask, reg18);
        cpu_reg8x4_ne	r19(clk, rst_n, write_data, reg_enable[19], cs_write_mask, reg19);
        cpu_reg8x4_ne	r20(clk, rst_n, write_data, reg_enable[20], cs_write_mask, reg20);
        cpu_reg8x4_ne	r21(clk, rst_n, write_data, reg_enable[21], cs_write_mask, reg21);
        cpu_reg8x4_ne	r22(clk, rst_n, write_data, reg_enable[22], cs_write_mask, reg22);
        cpu_reg8x4_ne	r23(clk, rst_n, write_data, reg_enable[23], cs_write_mask, reg23);
        cpu_reg8x4_ne	r24(clk, rst_n, write_data, reg_enable[24], cs_write_mask, reg24);
        cpu_reg8x4_ne	r25(clk, rst_n, write_data, reg_enable[25], cs_write_mask, reg25);
        cpu_reg8x4_ne	r26(clk, rst_n, write_data, reg_enable[26], cs_write_mask, reg26);
        cpu_reg8x4_ne	r27(clk, rst_n, write_data, reg_enable[27], cs_write_mask, reg27);
        cpu_reg8x4_ne	r28(clk, rst_n, write_data, reg_enable[28], cs_write_mask, reg28);
        cpu_reg8x4_ne	r29(clk, rst_n, write_data, reg_enable[29], cs_write_mask, reg29);
        cpu_reg8x4_ne	r30(clk, rst_n, write_data, reg_enable[30], cs_write_mask, reg30);
        cpu_reg8x4_ne	r31(clk, rst_n, write_data, reg_enable[31], cs_write_mask, reg31);
		
		cpu_reg8x4_ne	cr00(clk, rst_n, write_data, cp0_reg_enable[0], cs_write_mask,cpr00);
		cpu_reg8x4_ne	cr01(clk, rst_n, write_data, cp0_reg_enable[1], cs_write_mask,cpr01);
        cpu_reg8x4_ne	cr02(clk, rst_n, write_data, cp0_reg_enable[2], cs_write_mask,cpr02);
        cpu_reg8x4_ne	cr03(clk, rst_n, write_data, cp0_reg_enable[3], cs_write_mask,cpr03);
        cpu_reg8x4_ne	cr04(clk, rst_n, write_data, cp0_reg_enable[4], cs_write_mask,cpr04);
        cpu_reg8x4_ne	cr05(clk, rst_n, write_data, cp0_reg_enable[5], cs_write_mask,cpr05);
        cpu_reg8x4_ne	cr06(clk, rst_n, write_data, cp0_reg_enable[6], cs_write_mask,cpr06);
        cpu_reg8x4_ne	cr07(clk, rst_n, write_data, cp0_reg_enable[7], cs_write_mask,cpr07);
        cpu_reg8x4_ne	cr08(clk, rst_n, write_data, cp0_reg_enable[8], cs_write_mask,cpr08);
        cpu_reg8x4_ne	cr09(clk, rst_n, write_data, cp0_reg_enable[9], cs_write_mask,cpr09);
        cpu_reg8x4_ne	cr10(clk, rst_n, write_data, cp0_reg_enable[10], cs_write_mask,cpr10);
        cpu_reg8x4_ne	cr11(clk, rst_n, write_data, cp0_reg_enable[11], cs_write_mask,cpr11);
        cpu_reg8x4_ne_cp	cr12(clk, rst_n, write_data, iack, id_intctl_status, cp0_reg_enable[12], cs_write_mask,cpr12);
        cpu_reg8x4_ne_cp	cr13(clk, rst_n, write_data, iack, id_intctl_cause , cp0_reg_enable[13], cs_write_mask,cpr13);
        cpu_reg8x4_ne_cp	cr14(clk, rst_n, write_data, iack, id_intctl_epc   , cp0_reg_enable[14], cs_write_mask,cpr14);
        cpu_reg8x4_ne	cr15(clk, rst_n, write_data, cp0_reg_enable[15], cs_write_mask,cpr15);
        cpu_reg8x4_ne	cr16(clk, rst_n, write_data, cp0_reg_enable[16], cs_write_mask,cpr16);
        cpu_reg8x4_ne	cr17(clk, rst_n, write_data, cp0_reg_enable[17], cs_write_mask,cpr17);
        cpu_reg8x4_ne	cr18(clk, rst_n, write_data, cp0_reg_enable[18], cs_write_mask,cpr18);
        cpu_reg8x4_ne	cr19(clk, rst_n, write_data, cp0_reg_enable[19], cs_write_mask,cpr19);
        cpu_reg8x4_ne	cr20(clk, rst_n, write_data, cp0_reg_enable[20], cs_write_mask,cpr20);
        cpu_reg8x4_ne	cr21(clk, rst_n, write_data, cp0_reg_enable[21], cs_write_mask,cpr21);
        cpu_reg8x4_ne	cr22(clk, rst_n, write_data, cp0_reg_enable[22], cs_write_mask,cpr22);
        cpu_reg8x4_ne	cr23(clk, rst_n, write_data, cp0_reg_enable[23], cs_write_mask,cpr23);
        cpu_reg8x4_ne	cr24(clk, rst_n, write_data, cp0_reg_enable[24], cs_write_mask,cpr24);
        cpu_reg8x4_ne	cr25(clk, rst_n, write_data, cp0_reg_enable[25], cs_write_mask,cpr25);
        cpu_reg8x4_ne	cr26(clk, rst_n, write_data, cp0_reg_enable[26], cs_write_mask,cpr26);
        cpu_reg8x4_ne	cr27(clk, rst_n, write_data, cp0_reg_enable[27], cs_write_mask,cpr27);
        cpu_reg8x4_ne	cr28(clk, rst_n, write_data, cp0_reg_enable[28], cs_write_mask,cpr28);
        cpu_reg8x4_ne	cr29(clk, rst_n, write_data, cp0_reg_enable[29], cs_write_mask,cpr29);
        cpu_reg8x4_ne	cr30(clk, rst_n, write_data, cp0_reg_enable[30], cs_write_mask,cpr30);
        cpu_reg8x4_ne	cr31(clk, rst_n, write_data, cp0_reg_enable[31], cs_write_mask,cpr31);
        //=============================================================
        //      Mux32to1 - read data 1
        //=============================================================

        always@(reg00 or reg01 or reg02 or reg03 or
                reg04 or reg05 or reg06 or reg07 or
                reg08 or reg09 or reg10 or reg11 or
                reg12 or reg13 or reg14 or reg15 or
                reg16 or reg17 or reg18 or reg19 or
                reg20 or reg21 or reg22 or reg23 or
                reg24 or reg25 or reg26 or reg27 or
                reg28 or reg29 or reg30 or reg31 or
				cpr00 or cpr01 or cpr02 or cpr03 or
                cpr04 or cpr05 or cpr06 or cpr07 or
                cpr08 or cpr09 or cpr10 or cpr11 or
                cpr12 or cpr13 or cpr14 or cpr15 or
                cpr16 or cpr17 or cpr18 or cpr19 or
                cpr20 or cpr21 or cpr22 or cpr23 or
                cpr24 or cpr25 or cpr26 or cpr27 or
                cpr28 or cpr29 or cpr30 or cpr31 or
                read_reg1_num)
        begin
			if(cp0_ins)
				begin
				case(read_reg1_num)
                5'b00000: read_data1_content = 32'b0;
                5'b00001: read_data1_content = 32'b0;
                5'b00010: read_data1_content = 32'b0;
                5'b00011: read_data1_content = 32'b0;
                5'b00100: read_data1_content = 32'b0;
                5'b00101: read_data1_content = 32'b0;
                5'b00110: read_data1_content = 32'b0;
                5'b00111: read_data1_content = 32'b0;
                5'b01000: read_data1_content = 32'b0;
                5'b01001: read_data1_content = 32'b0;
                5'b01010: read_data1_content = 32'b0;
                5'b01011: read_data1_content = 32'b0;
                5'b01100: read_data1_content = 32'b0;
                5'b01101: read_data1_content = 32'b0;
                5'b01110: read_data1_content = 32'b0;
                5'b01111: read_data1_content = 32'b0;
                5'b10000: read_data1_content = 32'b0;
                5'b10001: read_data1_content = 32'b0;
                5'b10010: read_data1_content = 32'b0;
                5'b10011: read_data1_content = 32'b0;
                5'b10100: read_data1_content = 32'b0;
                5'b10101: read_data1_content = 32'b0;
                5'b10110: read_data1_content = 32'b0;
                5'b10111: read_data1_content = 32'b0;
                5'b11000: read_data1_content = 32'b0;
                5'b11001: read_data1_content = 32'b0;
                5'b11010: read_data1_content = 32'b0;
                5'b11011: read_data1_content = 32'b0;
                5'b11100: read_data1_content = 32'b0;
                5'b11101: read_data1_content = 32'b0;
                5'b11110: read_data1_content = 32'b0;
                5'b11111: read_data1_content = 32'b0;
						
				endcase
				end
		else
			begin
            case(read_reg1_num)
                5'b00000: read_data1_content = reg00;
                5'b00001: read_data1_content = reg01;
                5'b00010: read_data1_content = reg02;
                5'b00011: read_data1_content = reg03;
                5'b00100: read_data1_content = reg04;
                5'b00101: read_data1_content = reg05;
                5'b00110: read_data1_content = reg06;
                5'b00111: read_data1_content = reg07;
                5'b01000: read_data1_content = reg08;
                5'b01001: read_data1_content = reg09;
                5'b01010: read_data1_content = reg10;
                5'b01011: read_data1_content = reg11;
                5'b01100: read_data1_content = reg12;
                5'b01101: read_data1_content = reg13;
                5'b01110: read_data1_content = reg14;
                5'b01111: read_data1_content = reg15;
                5'b10000: read_data1_content = reg16;
                5'b10001: read_data1_content = reg17;
                5'b10010: read_data1_content = reg18;
                5'b10011: read_data1_content = reg19;
                5'b10100: read_data1_content = reg20;
                5'b10101: read_data1_content = reg21;
                5'b10110: read_data1_content = reg22;
                5'b10111: read_data1_content = reg23;
                5'b11000: read_data1_content = reg24;
                5'b11001: read_data1_content = reg25;
                5'b11010: read_data1_content = reg26;
                5'b11011: read_data1_content = reg27;
                5'b11100: read_data1_content = reg28;
                5'b11101: read_data1_content = reg29;
                5'b11110: read_data1_content = reg30;
                5'b11111: read_data1_content = reg31;
            endcase
			end
        end


        //=============================================================
        //      Mux32to1 - read data 2
        //=============================================================
        always@(reg00 or reg01 or reg02 or reg03 or
                reg04 or reg05 or reg06 or reg07 or
                reg08 or reg09 or reg10 or reg11 or
                reg12 or reg13 or reg14 or reg15 or
                reg16 or reg17 or reg18 or reg19 or
                reg20 or reg21 or reg22 or reg23 or
                reg24 or reg25 or reg26 or reg27 or
                reg28 or reg29 or reg30 or reg31 or
				cpr00 or cpr01 or cpr02 or cpr03 or
                cpr04 or cpr05 or cpr06 or cpr07 or
                cpr08 or cpr09 or cpr10 or cpr11 or
                cpr12 or cpr13 or cpr14 or cpr15 or
                cpr16 or cpr17 or cpr18 or cpr19 or
                cpr20 or cpr21 or cpr22 or cpr23 or
                cpr24 or cpr25 or cpr26 or cpr27 or
                cpr28 or cpr29 or cpr30 or cpr31 or
                read_reg2_num or read_reg3_num)
        begin
		if(mf_cp0_ins)
			begin
				//**		case(read_reg2_num)    **//
				case(read_reg3_num)

                5'b00000: read_data2_content = cpr00;
                5'b00001: read_data2_content = cpr01;
                5'b00010: read_data2_content = cpr02;
                5'b00011: read_data2_content = cpr03;
                5'b00100: read_data2_content = cpr04;
                5'b00101: read_data2_content = cpr05;
                5'b00110: read_data2_content = cpr06;
                5'b00111: read_data2_content = cpr07;
                5'b01000: read_data2_content = cpr08;
                5'b01001: read_data2_content = cpr09;
                5'b01010: read_data2_content = cpr10;
                5'b01011: read_data2_content = cpr11;
                5'b01100: read_data2_content = cpr12;
                5'b01101: read_data2_content = cpr13;
                5'b01110: read_data2_content = cpr14;
                5'b01111: read_data2_content = cpr15;
                5'b10000: read_data2_content = cpr16;
                5'b10001: read_data2_content = cpr17;
                5'b10010: read_data2_content = cpr18;
                5'b10011: read_data2_content = cpr19;
                5'b10100: read_data2_content = cpr20;
                5'b10101: read_data2_content = cpr21;
                5'b10110: read_data2_content = cpr22;
                5'b10111: read_data2_content = cpr23;
                5'b11000: read_data2_content = cpr24;
                5'b11001: read_data2_content = cpr25;
                5'b11010: read_data2_content = cpr26;
                5'b11011: read_data2_content = cpr27;
                5'b11100: read_data2_content = cpr28;
                5'b11101: read_data2_content = cpr29;
                5'b11110: read_data2_content = cpr30;
                5'b11111: read_data2_content = cpr31;
				endcase
			end
		else
			begin
            case(read_reg2_num)
                5'b00000: read_data2_content = reg00;
                5'b00001: read_data2_content = reg01;
                5'b00010: read_data2_content = reg02;
                5'b00011: read_data2_content = reg03;
                5'b00100: read_data2_content = reg04;
                5'b00101: read_data2_content = reg05;
                5'b00110: read_data2_content = reg06;
                5'b00111: read_data2_content = reg07;
                5'b01000: read_data2_content = reg08;
                5'b01001: read_data2_content = reg09;
                5'b01010: read_data2_content = reg10;
                5'b01011: read_data2_content = reg11;
                5'b01100: read_data2_content = reg12;
                5'b01101: read_data2_content = reg13;
                5'b01110: read_data2_content = reg14;
                5'b01111: read_data2_content = reg15;
                5'b10000: read_data2_content = reg16;
                5'b10001: read_data2_content = reg17;
                5'b10010: read_data2_content = reg18;
                5'b10011: read_data2_content = reg19;
                5'b10100: read_data2_content = reg20;
                5'b10101: read_data2_content = reg21;
                5'b10110: read_data2_content = reg22;
                5'b10111: read_data2_content = reg23;
                5'b11000: read_data2_content = reg24;
                5'b11001: read_data2_content = reg25;
                5'b11010: read_data2_content = reg26;
                5'b11011: read_data2_content = reg27;
                5'b11100: read_data2_content = reg28;
                5'b11101: read_data2_content = reg29;
                5'b11110: read_data2_content = reg30;
                5'b11111: read_data2_content = reg31;
            endcase
			end
        end


        assign  read_data1 = ((cs_regwrite)&(read_reg1_num==write_reg_num))
                              ? write_data
                              : read_data1_content ;

         assign read_data2 = ((cs_regwrite)&(read_reg2_num==write_reg_num))
                              ? write_data
                              : read_data2_content ;


endmodule