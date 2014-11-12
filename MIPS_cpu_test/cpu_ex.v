//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.1
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/22 01:18¤U¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_ex(  //system input
                clk,
                rst_n,
				iack,
                //control signal input
                ex_alu_src,
                ex_alu_op,
                ex_alu_move_cond,
                ex_reg2sn,
                ex_sht,
                ex_shd,
                ex_shp,
                ex_result_sel,
                ex_reg_dst,
                ex_memwrite,
                ex_memread,
                ex_store_op,
                ex_mhi_en,
                ex_mlo_en,
                ex_align_op,
                ex_mulreg_sel,
                ex_wbdata_sel,
                ex_regwrite,
                ex_cpwren,
				ex_cprrsel,
				ex_cprrsel,
				ex_w_cp0reg,
                mul_start,
                mul_sign,
                mul_type,
                //datapath input
                wb_regwrite,
                wb_write_num,
                ex_pca4,
                ex_ins_rs,
                ex_ins_rt,
                ex_ins_rd,
                ex_ins_sa,
                ex_a_bus,
                ex_b_bus,
                ex_extend_bus,
                wb_write_bus,
                mul_a,
                mul_b,
                mul_rs,
                mul_rt,
                //control signal output
                m_memwrite,
                m_memread,
                m_store_op,
                m_mhi_en,
                m_mlo_en,
                m_align_op,
                m_mulreg_sel,
                m_wbdata_sel,
                m_regwrite,     //
                mul_update_a,
                mul_update_b,
                mul_forward_a,
                mul_forward_b,
                mul_stall,
				m_w_cp0reg,
                //datapath output
                ex_write_num,
                m_result_bus,
                m_b_bus,
                m_write_num,
                mul_hi,
                mul_lo,
        	// Coprocessor interface signals
        	CPWDBUS,        // (O) CoProcessor Write Data BUS
        	CPWREN,        	// (O) CoProcessor WRite ENable
        	CPWRNUM,        // (O) CoProcessor Write Register NUMber
        	CPRRNUM,       	// (O) CoProcessor Read Register NUMber
        	CPRRSEL,        // (O) CoProcessor Read Register SELect
		CPRDBUS		// (I) CoProcessor Read Data BUS
                );

	//-------------------------------------------------------------
        //	system input
        //-------------------------------------------------------------
        input           clk;
        input           rst_n;
		input			iack;

	//-------------------------------------------------------------
        //	control signal input
        //-------------------------------------------------------------
        input           ex_alu_src;
        input   [3:0]   ex_alu_op;
        input   [1:0]   ex_alu_move_cond;
        input           ex_reg2sn;
        input           ex_sht;
        input           ex_shd;
        input           ex_shp;
        input   [1:0]   ex_result_sel;
        input   [1:0]   ex_reg_dst;
        input           ex_memwrite;
        input           ex_memread;
        input	[2:0]	ex_store_op;
        input           ex_mhi_en;
        input           ex_mlo_en;
        input	[2:0]	ex_align_op;
        input           ex_mulreg_sel;
        input   [1:0]   ex_wbdata_sel;
        input           ex_regwrite;
        input			ex_cpwren;
        input			ex_cprrsel;
		input			ex_w_cp0reg;
        input           mul_start;
        input           mul_sign;
        input   [1:0]   mul_type;
        
        //-------------------------------------------------------------
        //	datapath input
        //-------------------------------------------------------------
        input           wb_regwrite;
        input   [4:0]   wb_write_num;
        input   [31:0]  ex_pca4;
        input   [4:0]   ex_ins_rs;
        input   [4:0]   ex_ins_rt;
        input   [4:0]   ex_ins_rd;
        input   [4:0]   ex_ins_sa;
        input   [31:0]  ex_a_bus;
        input   [31:0]  ex_b_bus;
        input   [31:0]  ex_extend_bus;
        input   [31:0]  wb_write_bus;
        input   [31:0]  mul_a;
        input   [31:0]  mul_b;
        input   [4:0]   mul_rs;
        input   [4:0]   mul_rt;

	//-------------------------------------------------------------
        //	control signal output
        //-------------------------------------------------------------
        output          m_memwrite;
        output          m_memread;
        output	[2:0]	m_store_op;
        output          m_mhi_en;
        output          m_mlo_en;
        output	[2:0]	m_align_op;
        output          m_mulreg_sel;
        output  [1:0]   m_wbdata_sel;
        output          m_regwrite;
        output          mul_update_a;
        output          mul_update_b;
        output  [1:0]   mul_forward_a;
        output  [1:0]   mul_forward_b;
        output          mul_stall;
		//output   		m_memwrite;
		output			m_w_cp0reg;



	//-------------------------------------------------------------
        //	datapath output
        //-------------------------------------------------------------
        output  [4:0]   ex_write_num;
        output  [31:0]  m_result_bus;
        output  [31:0]  m_b_bus;
        output  [4:0]   m_write_num;
        output  [31:0]  mul_hi;
        output  [31:0]  mul_lo;

        //-------------------------------------------------------------
        //    	Coprocessor interface signals
        //-------------------------------------------------------------        
        output	[31:0]	CPWDBUS;        // (O) Write Data BUS
        output		CPWREN;        	// (O) WRite ENable
        output	[4:0]	CPWRNUM;        // (O) Write Register NUMber
        output	[4:0]	CPRRNUM;       	// (O) Read Register NUMber
        output		CPRRSEL;        // (O) Read Register SELect
	input	[31:0]	CPRDBUS;	// (I) Read Data BUS
	
	//-------------------------------------------------------------
        //	internal wire
        //-------------------------------------------------------------
        wire            im_regwrite;
        wire    [4:0]   im_write_num;
        wire    [31:0]  im_result_bus;
        wire    [1:0]   ex_forward_a;
        wire    [1:0]   ex_forward_b;
        wire            ex_regwrite2;
        wire    [31:0]  ex_pca8;
        wire    [4:0]   ex_shamt;
        wire    [4:0]   iex_write_num;
        reg    	[31:0]  ex_forward_bus_a;
        reg    	[31:0]  ex_forward_bus_b;
        wire    [31:0]  ex_fun_bus_b;
        wire    [31:0]  ex_alu_out;
        wire            ex_alu_zero;
        wire            ex_alu_carry;
        wire            ex_alu_overflow;
        wire            ex_alu_move_check;
        wire    [31:0]  ex_shifter_out;
        reg    	[31:0]  ex_result_bus;

        wire    [31:0]  mul_ain;
        wire    [31:0]  mul_bin;
        wire    [1:0]   imul_forward_a;
        wire    [1:0]   imul_forward_b;
        wire    [63:0]  mul_out;


//=====================================================================
//      Main Body
//=====================================================================

//=====================================================================
//      Path 1 ( ID -> EX -> MEM)
//=====================================================================

        //-------------------------------------------------------------
        //      Forwarding  Unit (EX)
        //-------------------------------------------------------------
        forward_unit    u_fuex(
                         .ins_rs                (ex_ins_rs),
                         .ins_rt                (ex_ins_rt),
                         .m_regwrite            (im_regwrite),
                         .m_write_num           (im_write_num),
                         .wb_regwrite           (wb_regwrite),
                         .wb_write_num          (wb_write_num),
                         .forward_a             (ex_forward_a),
                         .forward_b             (ex_forward_b)
                        );

	// Forwarding A Bus 
        always@(ex_forward_a or ex_a_bus or wb_write_bus or 
                im_result_bus)
        begin
            case(ex_forward_a)
        	2'b00 : ex_forward_bus_a = ex_a_bus ;
                2'b01 : ex_forward_bus_a = wb_write_bus ;
                2'b10 : ex_forward_bus_a = im_result_bus ;
                2'b11 : ex_forward_bus_a = 32'b0 ;
	    endcase
	end


	// Forwarding B Bus 
        always@(ex_forward_b or ex_b_bus or wb_write_bus or 
                im_result_bus)
        begin
            case(ex_forward_b)
        	2'b00 : ex_forward_bus_b = ex_b_bus ;
                2'b01 : ex_forward_bus_b = wb_write_bus ;
                2'b10 : ex_forward_bus_b = im_result_bus ;
                2'b11 : ex_forward_bus_b = 32'b0 ;
	    endcase
	end
		
	

        assign  ex_fun_bus_b = (ex_alu_src == 1'b1)
                              ? ex_extend_bus
                              : ex_forward_bus_b ;


        //-------------------------------------------------------------
        //      ALU
        //-------------------------------------------------------------
        fu_alu          u_fu_alu(
                         .a             (ex_forward_bus_a),
                         .b             (ex_fun_bus_b),
                         .op            (ex_alu_op),
                         .result        (ex_alu_out),
                         .carryout      (ex_alu_carry),
                         .zero          (ex_alu_zero),
                         .overflow      (ex_alu_overflow),
                         .move_cond     (ex_alu_move_cond),
                         .move_check    (ex_alu_move_check)
                        );

        assign  ex_regwrite2 = (ex_alu_move_cond[1]==1'b1)
                                ? ex_alu_move_check
                                : ex_regwrite ;

        //-------------------------------------------------------------
        //      Shifter
        //-------------------------------------------------------------
        assign  ex_shamt = (ex_reg2sn==1'b1)
                         ? ex_forward_bus_a[4:0]
                         : ex_ins_sa ;

        fu_shifter      u_fu_shifter(
                         .din           (ex_fun_bus_b),
                         .dout          (ex_shifter_out),
                         .st            (ex_sht),
                         .sd            (ex_shd),
                         .sp            (ex_shp),
                         .sn            (ex_shamt)
                        );

        //-------------------------------------------------------------
        //    	Coprocessor interface signals
        //-------------------------------------------------------------        
        assign	CPWDBUS = ex_forward_bus_b;
        assign	CPWREN = ex_cpwren;
        assign	CPWRNUM = ex_ins_rd;
        assign	CPRRNUM = ex_ins_rd;
        assign	CPRRSEL = ex_cprrsel;


        //-------------------------------------------------------------
        //      Execution Result Mux
        //-------------------------------------------------------------
        assign  ex_pca8 = ex_pca4 + 32'h00000004;

        always@(ex_result_sel or ex_alu_out or ex_pca8 or 
                ex_shifter_out or CPRDBUS)
        begin
            case(ex_result_sel)
        	2'b00 : ex_result_bus = ex_alu_out ;
                2'b01 : ex_result_bus = ex_pca8 ;
                2'b10 : ex_result_bus = ex_shifter_out ;
            //    2'b11 : ex_result_bus = CPRDBUS ;		// **
				2'b11 : ex_result_bus = ex_alu_out ;
	    endcase
	end


        assign  iex_write_num = (ex_reg_dst==2'b00) ? ex_ins_rt :
                               (ex_reg_dst==2'b01) ? ex_ins_rd :
                               (ex_reg_dst==2'b10) ? 5'b11111 :
                               5'b00000 ;


        //=============================================================
        //      EX/MEM Register
        //-------------------------------------------------------------

        cpu_reg1_ne     u_ex2m_memwrite(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_memwrite),
                         .wren	        (rst_n),
                         .dout          (m_memwrite)
                        );
		cpu_reg1_ne     u_ex2m_cp0_type(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (ex_w_cp0reg),
                         .wren	        (rst_n),
                         .dout          (m_w_cp0reg)
                        );

        cpu_reg1_ne     u_ex2m_memread(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_memread),
                         .wren	        (rst_n),
                         .dout          (m_memread)
                        );

        cpu_reg3_ne     u_ex2m_store_op(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_store_op),
                         .wren	        (rst_n),
                         .dout          (m_store_op)
                        );
                        
        cpu_reg1_ne     u_ex2m_mhi_en(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_mhi_en),
                         .wren	        (rst_n),
                         .dout          (m_mhi_en)
                        );

        cpu_reg1_ne     u_ex2m_mlo_en(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_mlo_en),
                         .wren	        (rst_n),
                         .dout          (m_mlo_en)
                        );

        cpu_reg3_ne     u_ex2m_align_op(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_align_op),
                         .wren	        (rst_n),
                         .dout          (m_align_op)
                        );
                        
        cpu_reg1_ne     u_ex2m_mulreg_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_mulreg_sel),
                         .wren	        (rst_n),
                         .dout          (m_mulreg_sel)
                        );

        cpu_reg2_ne     u_ex2m_wbdata_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_wbdata_sel),
                         .wren	        (rst_n),
                         .dout          (m_wbdata_sel)
                        );

        cpu_reg1_ne     u_ex2m_regwrite(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_regwrite2),
                         .wren	        (rst_n),
                         .dout          (im_regwrite)
                        );

        cpu_reg5_ne     u_ex2m_write_num(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (iex_write_num),
                         .wren	        (rst_n),
                         .dout          (im_write_num)
                        );

        //-------------------------------------------------------------
        cpu_reg32_ne_ex    u_ex2m_result_bus(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_result_bus),
                         .wren	        (rst_n),
                         .dout          (im_result_bus)
                        );

        cpu_reg32_ne_ex   u_ex2m_b_bus(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (ex_forward_bus_b),
                         .wren	        (rst_n),
                         .dout          (m_b_bus)
                        );
        //=============================================================

        assign  m_regwrite = im_regwrite;
        assign  m_write_num = im_write_num;
        assign  m_result_bus = im_result_bus;
        assign  ex_write_num = iex_write_num;


//=====================================================================
//      Path 2 ( ID -> MUL -> MEM/WB)
//=====================================================================

        //=============================================================
        //      Forwarding  Unit (MUL)
        //=============================================================
        forward_unit    u_fumul(
                         .ins_rs                (mul_rs),
                         .ins_rt                (mul_rt),
                         .m_regwrite            (im_regwrite),
                         .m_write_num           (im_write_num),
                         .wb_regwrite           (wb_regwrite),
                         .wb_write_num          (wb_write_num),
                         .forward_a             (imul_forward_a),
                         .forward_b             (imul_forward_b)
                        );

        assign  mul_forward_a = imul_forward_a;
        assign  mul_forward_b = imul_forward_b;

        assign  mul_update_a = (imul_forward_a!=2'b00) ? 1'b1 : 1'b0 ;
        assign  mul_update_b = (imul_forward_b!=2'b00) ? 1'b1 : 1'b0 ;

        assign  mul_ain = (imul_forward_a == 2'b00 ) ? mul_a :
                          (imul_forward_a == 2'b01 ) ? wb_write_bus :
                          (imul_forward_a == 2'b10 ) ? im_result_bus :
                          32'b0 ;

        assign  mul_bin = (imul_forward_b == 2'b00 ) ? mul_b :
                          (imul_forward_b == 2'b01 ) ? wb_write_bus :
                          (imul_forward_b == 2'b10 ) ? im_result_bus :
                          32'b0 ;

        //=============================================================
        //      MUL Unit
        //=============================================================
        mul_top         u_mul(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .cs_start      (mul_start),
                         .cs_sign       (mul_sign),
                         //.cs_type       (mul_type),
                         .din_a         (mul_ain),
                         .din_b         (mul_bin),
                         .mul_stall     (mul_stall),
                         .product       (mul_out)
                        );

        assign  mul_hi = mul_out[63:32];
        assign  mul_lo = mul_out[31:0];


endmodule