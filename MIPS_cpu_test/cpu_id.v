//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_id.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.1
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: May 11, 2005  15:31
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_id(  //system input
                clk,
                rst_n,
				iack,
                //control signal input
                m_regwrite,
                wb_regwrite,
				wb_w_cp0reg,
                wb_write_mask,
                mul_update_a,
                mul_update_b,
                mul_forward_a,
                mul_forward_b,
                mul_stall,
                //datapath input
                id_pca4,
                id_ins,
                ex_write_num,
                m_result_bus,
                m_write_num,
                m_memread,
                wb_write_bus,
                wb_write_num,
                //control signal output
                stall_n,
                id_pc_src,
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
				ex_w_cp0reg,
                //datapath output
                id_add_out,
                id_jump_pc,
                id_rs_data,
                ex_pca4,
                ex_ins_rs,
                ex_ins_rt,
                ex_ins_rd,
                ex_ins_sa,
                ex_a_bus,
                ex_b_bus,
                ex_extend_bus,
                mul_a,
                mul_b,
                mul_rs,
                mul_rt,
                mul_start,
                mul_sign,
                mul_type,
				//  cp2intcrl
				id2intctl, 				//(O)
				id_intctl_epc,			//(I)
				id_intctl_cause,		//(I)
				id_intctl_status,		//(I)
				
                );


        //system input
        input           clk;
        input           rst_n;
		input           iack;

        //control signal input
        input           m_regwrite;
        input           wb_regwrite;
        input   [3:0]   wb_write_mask;
		input			wb_w_cp0reg;
        input           mul_update_a;
        input           mul_update_b;
        input   [1:0]   mul_forward_a;
        input   [1:0]   mul_forward_b;
        input           mul_stall;

        //datapath input
        input   [31:0]  id_pca4;
        input   [31:0]  id_ins;
        input   [4:0]   ex_write_num;
        input   [31:0]  m_result_bus;
        input   [4:0]   m_write_num;
        input           m_memread;
        input   [31:0]  wb_write_bus;
        input   [4:0]   wb_write_num;

        //control signal output
        output          stall_n;
        output  [1:0]   id_pc_src;
        output          ex_alu_src;
        output  [3:0]   ex_alu_op;
        output  [1:0]   ex_alu_move_cond;
        output          ex_reg2sn;
        output          ex_sht;
        output          ex_shd;
        output          ex_shp;
        output  [1:0]   ex_result_sel;
        output  [1:0]   ex_reg_dst;
        output          ex_memwrite;
        output          ex_memread;
        output  [2:0]   ex_store_op;
        output          ex_mhi_en;
        output          ex_mlo_en;
        output  [2:0]   ex_align_op;
        output          ex_mulreg_sel;
        output  [1:0]   ex_wbdata_sel;
        output          ex_regwrite;
        output          ex_cpwren;
        output          ex_cprrsel;
		output 			ex_w_cp0reg;


        //datapath output
        output  [31:0]  id_add_out;
        output  [31:0]  id_jump_pc;
        output  [31:0]  id_rs_data;
        output  [31:0]  ex_pca4;
        output  [4:0]   ex_ins_rs;
        output  [4:0]   ex_ins_rt;
        output  [4:0]   ex_ins_rd;
        output  [4:0]   ex_ins_sa;
        output  [31:0]  ex_a_bus;
        output  [31:0]  ex_b_bus;
        output  [31:0]  ex_extend_bus;
        output  [31:0]  mul_a;
        output  [31:0]  mul_b;
        output  [4:0]   mul_rs;
        output  [4:0]   mul_rt;
        output          mul_start;
        output          mul_sign;
        output  [1:0]   mul_type;
		
		// for interrupt  controller
		
		output	[31:0] id2intctl;				//cp0_12
		input 	[31:0] id_intctl_epc;			//cp0_14
		input 	[31:0] id_intctl_cause;			//cp0_13
		input 	[31:0] id_intctl_status;		//cp0_12

        //internal wire
        wire            logic0;
        wire            istall_n;
        wire            interlock_hdu;
        //wire            cs_stall_check;
        wire            cs_mul_check;
        wire            cs_jump;
        wire            cs_jr;
        wire            cs_zero_ext;
        wire            cs_alu_src;
        wire    [3:0]   cs_alu_op;
        wire    [1:0]   cs_alu_move_cond;
        wire            cs_reg2sn;
        wire            cs_sht;
        wire            cs_shd;
        wire            cs_shp;
        wire    [1:0]   cs_result_sel;
        wire    [1:0]   cs_reg_dst;
        wire            cs_rs_rden;
        wire            cs_rt_rden;
        wire            cs_branch;
        wire    [2:0]   cs_branch_ctrl;
        wire            cs_branch_rs_rden;
        wire            cs_branch_rt_rden;

        wire            cs_memwrite;
        wire            cs_memread;
        wire    [2:0]   cs_store_op;
        wire            cs_mhi_en;
        wire            cs_mlo_en;

        wire    [2:0]   cs_align_op;
        wire            cs_mulreg_sel;
        wire    [1:0]   cs_wbdata_sel;
        wire            cs_regwrite;
        wire            cs_cpwren;
        wire            cs_cprrsel;

        wire            cs_mul_regen;
        wire            cs_mul_start;
        wire            cs_mul_sign;
        wire    [1:0]   cs_mul_type;

        wire            id_zero_ext;

        wire            id_alu_src;
        wire    [3:0]   id_alu_op;
        wire    [1:0]   id_alu_move_cond;
        wire            id_reg2sn;
        wire            id_sht;
        wire            id_shd;
        wire            id_shp;
        wire    [1:0]   id_result_sel;
        wire    [1:0]   id_reg_dst;
        wire            id_branch;
        wire    [2:0]   id_branch_ctrl;
        wire            id_branch_taken;

        wire            id_memwrite;
        wire            id_memread;
        wire    [2:0]   id_store_op;
        wire            id_mhi_en;
        wire            id_mlo_en;

        wire    [2:0]   id_align_op;
        wire            id_mulreg_sel;
        wire    [1:0]   id_wbdata_sel;
        wire            id_regwrite;
        wire            id_cpwren;
        wire            id_cprrsel;

        wire    [1:0]   id_forward_a;
        wire    [1:0]   id_forward_b;
        wire    [4:0]   id_ins_rs;
        wire    [4:0]   id_ins_rt;
        wire    [4:0]   id_ins_rd;
        wire    [4:0]   id_ins_sa;
        wire    [31:0]  id_a_bus;
        wire    [31:0]  id_b_bus;
        wire    [31:0]  id_extend_bus;
        wire    [31:0]  id_add_bin;
        wire    [31:0]  iid_rs_data;
        wire    [31:0]  id_rt_data;
        wire            iex_memread;
        wire            iex_regwrite;
        wire            id_mul_regen;
        wire            id_mul_start;
        wire            id_mul_sign;
        wire    [1:0]   id_mul_type;

        wire    [31:0]  mul_ain;
        wire    [31:0]  mul_bin;
        wire            mul_regen;
        wire            mul_regen_a;
        wire            mul_regen_b;

//=====================================================================
//      Main Body
//=====================================================================

        assign  logic0 = 1'b0;

        assign  id_ins_rs = id_ins[25:21];
        assign  id_ins_rt = id_ins[20:16];
        assign  id_ins_rd = id_ins[15:11];
        assign  id_ins_sa = id_ins[10:6];

        //=============================================================
        //      Sign extend
        //=============================================================

        assign  id_extend_bus[31] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[30] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[29] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[28] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[27] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[26] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[25] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[24] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[23] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[22] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[21] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[20] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[19] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[18] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[17] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[16] = (id_zero_ext==1'b1) ? 1'b0 : id_ins[15] ;
        assign  id_extend_bus[15:0] = id_ins[15:0];


        //=============================================================
        //      Control Unit
        //=============================================================
        control_unit    u_cu(
                         .ins                   (id_ins),

                         .cs_stall_check        (cs_stall_check),
                         .cs_mul_check          (cs_mul_check),
                         .cs_jump               (cs_jump),
                         .cs_jr                 (cs_jr),
                         .cs_rs_rden            (cs_rs_rden),
                         .cs_rt_rden            (cs_rt_rden),
                         .cs_branch             (cs_branch),
                         .cs_branch_ctrl        (cs_branch_ctrl),
                         .cs_zero_ext           (cs_zero_ext),
                         .cs_branch_rs_rden     (cs_branch_rs_rden),
                         .cs_branch_rt_rden     (cs_branch_rt_rden),

                         .cs_alu_src            (cs_alu_src),
                         .cs_alu_op             (cs_alu_op),
                         .cs_alu_move_cond      (cs_alu_move_cond),
                         .cs_reg2sn             (cs_reg2sn),
                         .cs_sht                (cs_sht),
                         .cs_shd                (cs_shd),
                         .cs_shp                (cs_shp),
                         .cs_result_sel         (cs_result_sel),
                         .cs_reg_dst            (cs_reg_dst),

                         .cs_mul_regen          (cs_mul_regen),
                         .cs_mul_start          (cs_mul_start),
                         .cs_mul_sign           (cs_mul_sign),
                         .cs_mul_type           (cs_mul_type),

                         .cs_memwrite           (cs_memwrite),
                         .cs_memread            (cs_memread),
                         .cs_store_op           (cs_store_op),
                         .cs_mhi_en             (cs_mhi_en),
                         .cs_mlo_en             (cs_mlo_en),

                         .cs_align_op           (cs_align_op),
                         .cs_mulreg_sel         (cs_mulreg_sel),
                         .cs_wbdata_sel         (cs_wbdata_sel),
                         .cs_regwrite           (cs_regwrite),
                         .cs_cpwren             (cs_cpwren),
                         .cs_cprrsel            (cs_cprrsel),
						 .mf_cp0_ins			(mf_cp0_ins),
						 .mt_cp0_ins			(mt_cp0_ins),
						 .cp0_ins				(cp0_ins)
                        );


        //=============================================================
        //      Hazard detection Unit
        //=============================================================

        hazard_det_unit u_hdu(
                         .id_ins_rs             (id_ins_rs),
                         .id_ins_rt             (id_ins_rt),
                         .cs_rs_rden            (cs_rs_rden),
                         .cs_rt_rden            (cs_rt_rden),
                         .cs_branch_rs_rden     (cs_branch_rs_rden),
                         .cs_branch_rt_rden     (cs_branch_rt_rden),
                         .ex_memread            (iex_memread),
                         .ex_write_num          (ex_write_num),
                         .ex_regwrite           (iex_regwrite),
                         .m_memread             (m_memread),
                         .m_write_num           (m_write_num),
                         .cs_mul_check          (cs_mul_check),
                         .mul_stall             (mul_stall),
                         .interlock_hdu         (interlock_hdu)
                        );



        assign  istall_n         = (interlock_hdu==1'b1) ? 1'b0 : 1'b1;

        assign  id_zero_ext      = (istall_n==1'b0) ? 1'b0 : cs_zero_ext ;
        assign  id_pc_src[1]     = (istall_n==1'b0) ? 1'b0 : cs_jump ;
        assign  id_alu_src       = (istall_n==1'b0) ? 1'b0 : cs_alu_src ;
        assign  id_alu_op        = (istall_n==1'b0) ? 4'b0 : cs_alu_op ;
        assign  id_alu_move_cond = (istall_n==1'b0) ? 2'b0 : cs_alu_move_cond ;
        assign  id_reg2sn        = (istall_n==1'b0) ? 1'b0 : cs_reg2sn ;
        assign  id_sht           = (istall_n==1'b0) ? 1'b0 : cs_sht ;
        assign  id_shd           = (istall_n==1'b0) ? 1'b0 : cs_shd ;
        assign  id_shp           = (istall_n==1'b0) ? 1'b0 : cs_shp ;

        assign  id_result_sel    = (istall_n==1'b0) ? 2'b0 : cs_result_sel ;
        assign  id_reg_dst       = (istall_n==1'b0) ? 2'b0 : cs_reg_dst ;
        assign  id_branch        = (istall_n==1'b0) ? 1'b0 : cs_branch ;
        assign  id_branch_ctrl   = (istall_n==1'b0) ? 3'b0 : cs_branch_ctrl ;

        assign  id_memwrite      = (istall_n==1'b0) ? 1'b0 : cs_memwrite ;
        assign  id_memread       = (istall_n==1'b0) ? 1'b0 : cs_memread ;
        assign  id_store_op      = (istall_n==1'b0) ? 3'b0 : cs_store_op ;
        assign  id_mhi_en        = (istall_n==1'b0) ? 1'b0 : cs_mhi_en ;
        assign  id_mlo_en        = (istall_n==1'b0) ? 1'b0 : cs_mlo_en ;

        assign  id_align_op      = (istall_n==1'b0) ? 3'b0 : cs_align_op ;
        assign  id_mulreg_sel    = (istall_n==1'b0) ? 1'b0 : cs_mulreg_sel ;
        assign  id_wbdata_sel    = (istall_n==1'b0) ? 2'b0 : cs_wbdata_sel ;
        assign  id_regwrite      = (istall_n==1'b0) ? 1'b0 : cs_regwrite ;
        assign  id_cpwren        = (istall_n==1'b0) ? 1'b0 : cs_cpwren ;
        assign  id_cprrsel       = (istall_n==1'b0) ? 1'b0 : cs_cprrsel ;
		assign  id_w_cp0reg     = (istall_n==1'b0) ? 1'b0 : mt_cp0_ins ;

        assign  id_mul_start     = (istall_n==1'b0) ? 1'b0 : cs_mul_start ;
        assign  id_mul_sign      = (istall_n==1'b0) ? 1'b0 : cs_mul_sign ;
        assign  id_mul_type      = (istall_n==1'b0) ? 2'b0 : cs_mul_type ;
        assign  id_mul_regen     = (istall_n==1'b0) ? 1'b0 : cs_mul_regen ;

        //=============================================================
        //      Registers bank
        //=============================================================
        cpu_regbank     u_regbank(
                         .clk                   (clk),
                         .rst_n                 (rst_n),
						 .iack					(iack),
						 .id_intctl_epc			(id_intctl_epc),
						 .id_intctl_cause		(id_intctl_cause),	
						 .id_intctl_status		(id_intctl_status),
						 .cp0_ins				(cp0_ins),
						 .mf_cp0_ins			(mf_cp0_ins),
                         .read_reg1_num         (id_ins_rs),
                         .read_reg2_num         (id_ins_rt),
						 .read_reg3_num         (id_ins_rd),
                         .write_reg_num         (wb_write_num),
						 .wb_w_cp0reg			(wb_w_cp0reg),
                         .write_data            (wb_write_bus),
                         .read_data1            (id_a_bus),
                         .read_data2            (id_b_bus),
                         .cs_regwrite           (wb_regwrite),
                         .cs_write_mask         (wb_write_mask),
						 .id2intctl				(id2intctl)				//enable interrpt
                        );

        //=============================================================
        //      Forwarding  Unit (ID)
        //=============================================================
        forward_unit    u_fuid(
                         .ins_rs                (id_ins_rs),
                         .ins_rt                (id_ins_rt),
                         .m_regwrite            (m_regwrite),
                         .m_write_num           (m_write_num),
                         .wb_regwrite           (wb_regwrite),
                         .wb_write_num          (wb_write_num),
                         .forward_a             (id_forward_a),
                         .forward_b             (id_forward_b)
                        );

        assign  iid_rs_data = (id_forward_a==2'b00) ? id_a_bus :
                             (id_forward_a==2'b01) ? wb_write_bus :
                             (id_forward_a==2'b10) ? m_result_bus :
                             32'b0;

        assign  id_rt_data = (id_forward_b==2'b00) ? id_b_bus :
                             (id_forward_b==2'b01) ? wb_write_bus :
                             (id_forward_b==2'b10) ? m_result_bus :
                             32'b0;

        //=============================================================
        //      Branch Unit
        //=============================================================
        assign  id_add_bin = {id_extend_bus[29:0],2'b0};

        fu_csa32        u_add32(
                         .din1          (id_pca4),
                         .din2          (id_add_bin),
                         .carry_in      (logic0),
                         .dout          (id_add_out),
                         .carry_out     (),
                         .overflow      ()
                        );

        branch_unit     u_bu(
                         .rs            (iid_rs_data),
                         .rt            (id_rt_data),
                         .sel           (id_branch_ctrl),
                         .taken         (id_branch_taken)
                        );

        assign  id_pc_src[0] = (id_branch&id_branch_taken)|
                                cs_jr;

        //=============================================================
        //      Jump Unit
        //=============================================================

        assign  id_jump_pc = {id_pca4[31:28],id_ins[25:0],2'b00};


        //=============================================================
        //      ID/EX Register
        //-------------------------------------------------------------

        cpu_reg1_ne     u_id2ex_alu_src(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_alu_src),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_alu_src)
                        );

        cpu_reg4_ne     u_id2ex_alu_op(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_alu_op),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_alu_op)
                        );

        cpu_reg2_ne     u_id2ex_alu_move_cond(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_alu_move_cond),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_alu_move_cond)
                        );

        cpu_reg1_ne     u_id2ex_reg2sn(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_reg2sn),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_reg2sn)
                        );

        cpu_reg1_ne     u_id2ex_sht(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_sht),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_sht)
                        );

        cpu_reg1_ne     u_id2ex_shd(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_shd),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_shd)
                        );

        cpu_reg1_ne     u_id2ex_shp(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_shp),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_shp)
                        );

        cpu_reg2_ne     u_id2ex_result_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_result_sel),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_result_sel)
                        );

        cpu_reg2_ne     u_id2ex_reg_dst(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_reg_dst),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_reg_dst)
                        );


        cpu_reg1_ne     u_id2ex_memwrite(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_memwrite),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_memwrite)
                        );

        cpu_reg1_ne     u_id2ex_memread(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_memread),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (iex_memread)
                        );

        cpu_reg3_ne     u_id2ex_store_op(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_store_op),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_store_op)
                        );


        cpu_reg1_ne     u_id2ex_mhi_en(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_mhi_en),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_mhi_en)
                        );

        cpu_reg1_ne     u_id2ex_mlo_en(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_mlo_en),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_mlo_en)
                        );

        cpu_reg3_ne     u_id2ex_align_op(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_align_op),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_align_op)
                        );


        cpu_reg1_ne     u_id2ex_mulreg_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_mulreg_sel),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_mulreg_sel)
                        );

        cpu_reg2_ne     u_id2ex_wbdata_sel(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_wbdata_sel),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_wbdata_sel)
                        );

        cpu_reg1_ne     u_id2ex_regwrite(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_regwrite),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (iex_regwrite)
                        );

        cpu_reg1_ne     u_id2ex_cpwren(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_cpwren),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_cpwren)
                        );
						
						
		cpu_reg1_ne     u_id2ex_ins_cp0(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_w_cp0reg),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_w_cp0reg)
                        );

        cpu_reg1_ne     u_id2ex_cprrsel(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_cprrsel),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_cprrsel)
                        );

        //-------------------------------------------------------------
        cpu_reg32_ne_ex    u_id2ex_pca4(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_pca4),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_pca4)
                        );

        cpu_reg32_ne_ex    u_id2ex_a_bus(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_a_bus),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_a_bus)
                        );

        cpu_reg32_ne_ex    u_id2ex_b_bus(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_b_bus),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_b_bus)
                        );



        cpu_reg32_ne_ex    u_id2ex_extend_bus(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_extend_bus),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_extend_bus)
                        );

        cpu_reg5_ne     u_id2ex_ins_rs(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_ins_rs),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_ins_rs)
                        );

        cpu_reg5_ne     u_id2ex_ins_rt(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_ins_rt),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_ins_rt)
                        );

        cpu_reg5_ne     u_id2ex_ins_rd(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_ins_rd),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_ins_rd)
                        );

        cpu_reg5_ne     u_id2ex_ins_sa(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (id_ins_sa),
						 .iack			(iack),
                         .wren          (rst_n),
                         .dout          (ex_ins_sa)
                        );


        //=============================================================
        //      Output Reg for MUL
        //=============================================================

        assign  mul_regen = id_mul_regen;
        assign  mul_regen_a = id_mul_regen | mul_update_a ;
        assign  mul_regen_b = id_mul_regen | mul_update_b ;

        assign  mul_ain = (mul_forward_a == 2'b00 ) ? id_a_bus:
                          (mul_forward_a == 2'b01 ) ? wb_write_bus :
                          (mul_forward_a == 2'b10 ) ? m_result_bus :
                          32'b0 ;

        assign  mul_bin = (mul_forward_b == 2'b00 ) ? id_b_bus :
                          (mul_forward_b == 2'b01 ) ? wb_write_bus :
                          (mul_forward_b == 2'b10 ) ? m_result_bus :
                          32'b0 ;

        assign  mul_start = id_mul_start;

        // Control signals output
        cpu_reg1_ne     u_id2ex_mul_sign(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (id_mul_sign),
                         .wren          (mul_regen),
                         .dout          (mul_sign)
                        );

        cpu_reg2_ne     u_id2ex_mul_type(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (id_mul_type),
                         .wren          (mul_regen),
                         .dout          (mul_type)
                        );


        // Data output
        cpu_reg32_ne    u_id2ex_mul_a(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (mul_ain),
                         .wren          (mul_regen_a),
                         .dout          (mul_a)
                        );

        cpu_reg32_ne    u_id2ex_mul_b(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (mul_bin),
                         .wren          (mul_regen_b),
                         .dout          (mul_b)
                        );

        cpu_reg5_ne     u_id2ex_mul_rs(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (id_ins_rs),
                         .wren          (mul_regen),
                         .dout          (mul_rs)
                        );

        cpu_reg5_ne     u_id2ex_mul_rt(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (id_ins_rt),
                         .wren          (mul_regen),
                         .dout          (mul_rt)
                        );

        //=============================================================
        //      Internal signals to Output
        //=============================================================
        assign  ex_memread = iex_memread;
        assign  ex_regwrite = iex_regwrite;
        assign  id_rs_data = iid_rs_data;
        assign  stall_n = istall_n;


endmodule