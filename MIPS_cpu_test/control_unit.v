//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: control_unit.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: May 11, 2005  15:31
//---------------------------------------------------------------------
// PURPOSE: Control Unit
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module control_unit(
            ins,
            cs_stall_check,
            cs_mul_check,
            cs_jump,
            cs_jr,
            cs_rs_rden,
            cs_rt_rden,
            cs_branch,
            cs_branch_ctrl,
            cs_zero_ext,
            cs_branch_rs_rden,
            cs_branch_rt_rden,

            cs_alu_src,
            cs_alu_op,
            cs_alu_move_cond,
            cs_reg2sn,
            cs_sht,
            cs_shd,
            cs_shp,
            cs_result_sel,
            cs_reg_dst,

            cs_mul_regen,
            cs_mul_start,
            cs_mul_sign,
            cs_mul_type,

            cs_memwrite,
            cs_memread,
            cs_store_op,
            cs_mhi_en,
            cs_mlo_en,

            cs_align_op,
            cs_mulreg_sel,
            cs_wbdata_sel,
            cs_regwrite,
            cs_cpwren,
            cs_cprrsel,
			cp0_ins,
			mf_cp0_ins,
			mt_cp0_ins
            );

    input   [31:0]  ins;

    output          cs_stall_check;
    output          cs_mul_check;
    output          cs_jump;
    output          cs_jr;
    output          cs_rs_rden;
    output          cs_rt_rden;
    output          cs_branch;
    output  [2:0]   cs_branch_ctrl;
    output          cs_zero_ext;
    output          cs_branch_rs_rden;
    output          cs_branch_rt_rden;

    output          cs_alu_src;
    output  [3:0]   cs_alu_op;
    output  [1:0]   cs_alu_move_cond;
    output          cs_reg2sn;
    output          cs_sht;
    output          cs_shd;
    output          cs_shp;
    output  [1:0]   cs_result_sel;
    output  [1:0]   cs_reg_dst;

    output          cs_mul_regen;
    output          cs_mul_start;
    output          cs_mul_sign;
    output  [1:0]   cs_mul_type;

    output          cs_memwrite;
    output          cs_memread;
    output  [2:0]   cs_store_op;
    output          cs_mhi_en;
    output          cs_mlo_en;

    output  [2:0]   cs_align_op;
    output          cs_mulreg_sel;
    output  [1:0]   cs_wbdata_sel;
    output          cs_regwrite;
    output          cs_cpwren;
    output          cs_cprrsel;
	output			cp0_ins;
	output 			mf_cp0_ins;
	output 			mt_cp0_ins;


    wire            nop_ins;
    wire            shift_ins;
    wire            shift_sa_ins;
    wire            shift_reg_ins;
    wire  SLL_ins;
    wire  SRL_ins;
    wire  SRA_ins;
    wire  ROTR_ins;
    wire  SLLV_ins;
    wire  SRLV_ins;
    wire  SRAV_ins;
    wire  ROTRV_ins;
                            
    wire            arith_reg_ins;
    wire            arith_imm_ins;
    wire            load_ins;
    wire            store_ins;

    wire            branch1_ins;
    wire            branch2_ins;
    wire            BEQ_ins;
    wire            BNE_ins;
    wire            BLEZ_ins;
    wire            BGTZ_ins;

    wire            jump_ins;
    wire            jump_reg_ins;
    wire            J_ins;
    wire            JAL_ins;
    wire            JR_ins;
    wire            JALR_ins;

    wire            move_ins;       // MOVZ, MOVN
    wire            mf_mul_ins;     // MFHI, MFLO
    wire            mt_mul_ins;     // MTHI, MTLO
    wire            multiply_ins;   // MUL, MADD, MADDU, MSUB, MSUBU
    wire            mul_ins;        // MUL
    wire            mult_ins;       // MULT, MULTU
    wire  MUL_ins;
    wire  MULT_ins;
    wire  MULTU_ins;
    wire  MADD_ins;
    wire  MADDU_ins;
    wire  MSUB_ins;
    wire  MSUBU_ins;    
    wire            cp0_ins;
    wire            mf_cp0_ins;
    wire            mt_cp0_ins;

    //=============================================================
    // instruction decoding
    //=============================================================

        assign  nop_ins = (ins[31:0]==32'b0) ? 1'b1 : 1'b0 ;


        //Branch
        assign  branch1_ins = (ins[31:26]==6'b000001) ;
        assign  branch2_ins = BEQ_ins |
                              BNE_ins |
                              BLEZ_ins |
                              BGTZ_ins ;
        assign  BLTZ_ins   = branch1_ins&(ins[20:16]==5'b00000);
        assign  BGEZ_ins   = branch1_ins&(ins[20:16]==5'b00001);
        assign  BLTZAL_ins = branch1_ins&(ins[20:16]==5'b10000);
        assign  BGEZAL_ins = branch1_ins&(ins[20:16]==5'b10001);
        assign  BEQ_ins    = (ins[31:26]==6'b000100);
        assign  BNE_ins    = (ins[31:26]==6'b000101);
        assign  BLEZ_ins   = (ins[31:26]==6'b000110)&(ins[20:16]==5'b00000);
        assign  BGTZ_ins   = (ins[31:26]==6'b000111)&(ins[20:16]==5'b00000);


        //Jump
        assign  jump_ins   = J_ins | JAL_ins ;
        assign  J_ins      = (ins[31:26]==6'b000010);
        assign  JAL_ins    = (ins[31:26]==6'b000011);

        assign  jump_reg_ins = JR_ins | JALR_ins ;
        assign  JR_ins     = (ins[31:26]==6'b0)&
                             (ins[20:11]==10'b0)&
                             (ins[10:0]==11'b00000001000);
        assign  JALR_ins   = (ins[31:26]==6'b0)&
                             (ins[20:16]==5'b0)&
                             (ins[10:0]==11'b00000001001);


        //Arithmetic (Reg.)
        assign  arith_reg_ins = (ins[31:26]==6'b0)&(ins[10:4]==7'b0000010);
        assign  ADD_ins  = arith_reg_ins&(ins[3:0]==4'b0000);
        assign  ADDU_ins = arith_reg_ins&(ins[3:0]==4'b0001);
        assign  SUB_ins  = arith_reg_ins&(ins[3:0]==4'b0010);
        assign  SUBU_ins = arith_reg_ins&(ins[3:0]==4'b0011);
        assign  AND_ins  = arith_reg_ins&(ins[3:0]==4'b0100);
        assign  OR_ins   = arith_reg_ins&(ins[3:0]==4'b0101);
        assign  XOR_ins  = arith_reg_ins&(ins[3:0]==4'b0110);
        assign  NOR_ins  = arith_reg_ins&(ins[3:0]==4'b0111);
        assign  SLT_ins  = arith_reg_ins&(ins[3:0]==4'b1010);
        assign  SLTU_ins = arith_reg_ins&(ins[3:0]==4'b1011);

        //Arithmetic (Imm.)
        assign  arith_imm_ins = (ins[31:29]==3'b001);
        assign  ADDI_ins  = arith_imm_ins&(ins[28:26]==3'b000);
        assign  ADDIU_ins = arith_imm_ins&(ins[28:26]==3'b001);
        assign  SLTI_ins  = arith_imm_ins&(ins[28:26]==3'b010);
        assign  SLTIU_ins = arith_imm_ins&(ins[28:26]==3'b011);
        assign  ANDI_ins  = arith_imm_ins&(ins[28:26]==3'b100);
        assign  ORI_ins   = arith_imm_ins&(ins[28:26]==3'b101);
        assign  XORI_ins  = arith_imm_ins&(ins[28:26]==3'b110);
        assign  LUI_ins   = arith_imm_ins&(ins[28:21]==8'b11100000);

        //CLZ & CLO
        assign  CLZ_ins = (ins[31:26]==6'b011100)&
                          (ins[10:6]==5'b00000)&
                          (ins[5:0]==6'b100000);

        assign  CLO_ins = (ins[31:26]==6'b011100)&
                          (ins[10:6]==5'b00000)&
                          (ins[5:0]==6'b100001);

        //Load
        assign  LB_ins  = (ins[31:26]==6'b100000);
        assign  LH_ins  = (ins[31:26]==6'b100001);
        assign  LWL_ins = (ins[31:26]==6'b100010);
        assign  LW_ins  = (ins[31:26]==6'b100011);
        assign  LBU_ins = (ins[31:26]==6'b100100);
        assign  LHU_ins = (ins[31:26]==6'b100101);
        assign  LWR_ins = (ins[31:26]==6'b100110);

        assign  load_ins = LB_ins  |
                           LH_ins  |
                           LWL_ins |
                           LW_ins  |
                           LBU_ins |
                           LHU_ins |
                           LWR_ins ;

        //Store
        assign  SB_ins    = (ins[31:26]==6'b101000);
        assign  SH_ins    = (ins[31:26]==6'b101001);
        assign  SWL_ins   = (ins[31:26]==6'b101010);
        assign  SW_ins    = (ins[31:26]==6'b101011);
        assign  SWR_ins   = (ins[31:26]==6'b101110);

        assign  store_ins = SB_ins  |
                            SH_ins  |
                            SWL_ins |
                            SW_ins  |
                            SWR_ins ;



       //Shift
        assign  shift_ins = SLL_ins  |
                            SRL_ins  |
                            SRA_ins  |
                            ROTR_ins |
                            SLLV_ins |
                            SRLV_ins |
                            SRAV_ins |
                            ROTRV_ins;

        assign  shift_sa_ins = SLL_ins |
                               SRL_ins |
                               SRA_ins |
                               ROTR_ins;

        assign  shift_reg_ins = SLLV_ins |
                                SRLV_ins |
                                SRAV_ins |
                                ROTRV_ins;

        assign  SLL_ins   = (ins[31:26]==6'b000000)&
                            (ins[25:21]==5'b00000)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b000);

        assign  SRL_ins   = (ins[31:26]==6'b000000)&
                            (ins[25:21]==5'b00000)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b010);

        assign  SRA_ins   = (ins[31:26]==6'b000000)&
                            (ins[25:21]==5'b00000)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b011);

        assign  ROTR_ins  = (ins[31:26]==6'b000000)&
                            (ins[25:21]==5'b00001)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b010);

        assign  SLLV_ins  = (ins[31:26]==6'b000000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b100);

        assign  SRLV_ins  = (ins[31:26]==6'b000000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b110);

        assign  SRAV_ins  = (ins[31:26]==6'b000000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b111);

        assign  ROTRV_ins = (ins[31:26]==6'b000000)&
                            (ins[10:6]==5'b00001)&
                            (ins[5:3]==3'b000)&
                            (ins[2:0]==3'b110);


        //Move
        assign  MFHI_ins = (ins[31:26]==6'b000000)&
                           (ins[25:21]==5'b00000)&
                           (ins[20:16]==5'b00000)&
                           (ins[10:6]==5'b00000)&
                           (ins[5:0]==6'b010000);

        assign  MTHI_ins = (ins[31:26]==6'b000000)&
                           (ins[20:16]==5'b00000)&
                           (ins[15:11]==5'b00000)&
                           (ins[10:6]==5'b00000)&
                           (ins[5:0]==6'b010001);

        assign  MFLO_ins = (ins[31:26]==6'b000000)&
                           (ins[25:21]==5'b00000)&
                           (ins[20:16]==5'b00000)&
                           (ins[10:6]==5'b00000)&
                           (ins[5:0]==6'b010010);

        assign  MTLO_ins = (ins[31:26]==6'b000000)&
                           (ins[20:16]==5'b00000)&
                           (ins[15:11]==5'b00000)&
                           (ins[10:6]==5'b00000)&
                           (ins[5:0]==6'b010011);

        assign  MOVZ_ins = (ins[31:26]==6'b000000)&
                           (ins[10:6]==5'b00000)&
                           (ins[5:0]==6'b001010);

        assign  MOVN_ins = (ins[31:26]==6'b000000)&
                           (ins[10:6]==5'b00000)&
                           (ins[5:0]==6'b001011);


        assign  move_ins = (ins[31:26]==6'b0)&(ins[10:1]==10'b0000000101);



        //Multiply
        assign  multiply_ins = MUL_ins   |
                               MULT_ins  |
                               MULTU_ins |
                               MADD_ins  |
                               MADDU_ins |
                               MSUB_ins  |
                               MSUBU_ins ;

        assign  mul_add_sub_ins =  MADD_ins  |
                                   MADDU_ins |
                                   MSUB_ins  |
                                   MSUBU_ins ;

        assign  MUL_ins   = (ins[31:26]==6'b011100)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b000010);

        assign  MULT_ins  = (ins[31:26]==6'b000000)&
                            (ins[15:11]==5'b00000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b011000);

        assign  MULTU_ins = (ins[31:26]==6'b000000)&
                            (ins[15:11]==5'b00000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b011001);

        assign  MADD_ins  = (ins[31:26]==6'b011100)&
                            (ins[15:11]==5'b00000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b000000);

        assign  MADDU_ins = (ins[31:26]==6'b011100)&
                            (ins[15:11]==5'b00000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b000001);

        assign  MSUB_ins  = (ins[31:26]==6'b011100)&
                            (ins[15:11]==5'b00000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b000100);

        assign  MSUBU_ins = (ins[31:26]==6'b011100)&
                            (ins[15:11]==5'b00000)&
                            (ins[10:6]==5'b00000)&
                            (ins[5:0]==6'b000101);

        assign  mf_mul_ins = (ins[31:26]==6'b0)&
                             (ins[10:2]==9'b000000100)&
                             (ins[0]==1'b0);

        assign  mt_mul_ins = (ins[31:26]==6'b0)&
                             (ins[10:2]==9'b000000100)&
                             (ins[0]==1'b1);

        assign  mul_ins =  multiply_ins & (ins[2:0]==3'b010) ;

        assign  mult_ins = (ins[31:26]==6'b0)&(ins[10:1]==10'b0000001100);

        assign  cp0_ins = (ins[31:26]==6'b010000);
        assign  mf_cp0_ins = cp0_ins & (ins[25:21]==5'b00000);
        assign  mt_cp0_ins = cp0_ins & (ins[25:21]==5'b00100);


    //=============================================================
    // ID-Stage : Branch instruction
    //=============================================================
    assign  cs_branch = branch1_ins | branch2_ins;

    assign  cs_rs_rden = arith_reg_ins |
                         ADDI_ins  |
                         ADDIU_ins |
                         SLTI_ins  |
                         SLTIU_ins |
                         ANDI_ins  |
                         ORI_ins   |
                         XORI_ins  |
                         load_ins  |
                         store_ins |
                         shift_reg_ins |
                         MTHI_ins |
                         MTLO_ins |
                         CLZ_ins  |
                         CLO_ins  |
                         MOVN_ins |
                         MOVZ_ins ;

    assign  cs_rt_rden = arith_reg_ins |
                         store_ins |
                         shift_ins |
                         MOVN_ins  |
                         MOVZ_ins  ;

    //=============================================================
    // ID-Stage : Branch/Jump control signals
    //=============================================================
    assign  cs_jump = jump_ins | jump_reg_ins;
    assign  cs_jr = jump_reg_ins;

    //=============================================================
    // ID-Stage : Hazard Detection Unit control signals
    //=============================================================
    assign  cs_stall_check = branch1_ins|branch2_ins|jump_reg_ins;
    assign  cs_mul_check = multiply_ins | mult_ins;

    assign  cs_branch_rs_rden = branch1_ins |
                                branch2_ins |
                                JR_ins |
                                JALR_ins ;

    assign  cs_branch_rt_rden = BEQ_ins |
                                BNE_ins ;

    //=============================================================
    // ID-Stage : (branch_unit) Mux the output value
    //=============================================================
    assign  cs_branch_ctrl = (branch2_ins==1'b1) ? ins[28:26] :
                             (branch1_ins==1'b1) ? {2'b0,ins[16]} :
                             3'b000 ;

    //=============================================================
    // ID-Stage : Sign or Zero Extend
    //-------------------------------------------------------------
    //      1'b0 : id_extend_bus = sign_ext(ins[15:0])
    //      1'b1 : id_extend_bus = zero_ext(ins[15:0])
    //=============================================================
    assign  cs_zero_ext = arith_imm_ins & ins[28] ;

    //=============================================================
    // EX-Stage : Mux the alu_bin data
    //-------------------------------------------------------------
    //      1'b0 : alu_bin = b_bus2
    //      1'b1 : alu_bin = sign_ext
    //=============================================================
    assign  cs_alu_src = load_ins | store_ins | arith_imm_ins;


    //=============================================================
    // EX-Stage : ALUop control signals
    //=============================================================
    assign  cs_alu_op[3] = (arith_reg_ins&ins[3])|
                           (arith_imm_ins&ins[29])|
                           (move_ins&ins[3]);
    assign  cs_alu_op[2] = (arith_reg_ins&ins[2])|
                           (arith_imm_ins&ins[28])|
                           (move_ins&ins[2]);
    assign  cs_alu_op[1] = (arith_reg_ins&ins[1])|
                           (arith_imm_ins&ins[27])|
                           (move_ins&ins[1]);
    assign  cs_alu_op[0] = (arith_reg_ins&ins[0])|
                           (arith_imm_ins&ins[26])|
                           (move_ins&ins[0]);


    //=============================================================
    // EX-Stage : Condition write control signals
    //=============================================================
    assign  cs_alu_move_cond[1] = move_ins ;
    assign  cs_alu_move_cond[0] = (move_ins&ins[0]) ;


    //=============================================================
    // EX-Stage : Shifter control signals
    //=============================================================
    assign  cs_reg2sn = shift_reg_ins;
    assign  cs_sht = (shift_sa_ins&ins[21])|(shift_reg_ins&ins[6]);
    assign  cs_shd = shift_ins & ins[1];
    assign  cs_shp = shift_ins & ins[0];

    //=============================================================
    // EX-Stage : Coprocessor Access control signals
    //=============================================================
    assign  cs_cpwren = mt_cp0_ins;
    assign  cs_cprrsel = ins[0];


    //=============================================================
    // EX-Stage : Mux the execution output value
    //-------------------------------------------------------------
    //      2'b00 : result_bus = alu_out
    //      2'b01 : result_bus = ex_pca8 (Jump)
    //      2'b10 : result_bus = shifter_out
    //      2'b11 : result_bus = coprocess read bus
    //=============================================================
    assign  cs_result_sel[1] = (shift_ins) | (mf_cp0_ins);
    assign  cs_result_sel[0] = (branch1_ins&ins[20])|
                               (JAL_ins)|
                               (JALR_ins)|
                               (mf_cp0_ins);


    //=============================================================
    // EX-Stage : Mux the destination register number
    //-------------------------------------------------------------
    //      2'b00 : write_num = ins_rt
    //      2'b01 : write_num = ins_rd
    //      2'b10 : write_num = 5'b11111
    //      2'b11 : write_num = 5'b00000
    //=============================================================
    assign  cs_reg_dst[1] = (branch1_ins&ins[20])|
                            (JAL_ins);

    assign  cs_reg_dst[0] = (shift_ins)|
                            (arith_reg_ins)|
                            (JALR_ins)|
                            (mul_ins)|
                            (mf_mul_ins)|
							(mt_cp0_ins);		//add for cp0 ins


    //=============================================================
    // EX-Stage : MUL control signals
    //=============================================================
    assign  cs_mul_regen = (mt_mul_ins) |
                           (mul_ins) |
                           (mult_ins) ;
    assign  cs_mul_start = (mul_ins) |
                           (mult_ins) ;

    // [0]unsigned [1]signed
    assign  cs_mul_sign = (mul_ins) |
                          (mult_ins&(~ins[0])) ;

    //=============================================================
    // EX-Stage : MUL control signals
    //-------------------------------------------------------------
    //      2'b0x : Multiply
    //      2'b10 : Move to HI
    //      2'b11 : Move to LO
    //=============================================================
    assign  cs_mul_type[1] = (mt_mul_ins);
    assign  cs_mul_type[0] = (mt_mul_ins&ins[1]);

    //=============================================================
    // MEM-Stage : Memory accessing
    //=============================================================
    assign  cs_memwrite = store_ins;
    assign  cs_memread = load_ins;

    assign  cs_store_op[2] = store_ins&ins[28];
    assign  cs_store_op[1] = store_ins&ins[27];
    assign  cs_store_op[0] = store_ins&ins[26];


    //=============================================================
    // MEM-Stage : HI/LO Register Enable (MFHI, MFLO)
    //=============================================================
    assign  cs_mhi_en = mf_mul_ins&(~ins[1]) ;
    assign  cs_mlo_en = mf_mul_ins&ins[1]  ;

    //=============================================================
    // WB-Stage : Alignment Opcode
    //=============================================================
    assign  cs_align_op = (load_ins|store_ins)
                          ? ins[28:26]
                          : 3'b000 ;

    //=============================================================
    // WB-Stage : Mux the value to write register
    //-------------------------------------------------------------
    //      1'b0 : i_mul_hi = m_mul_hi
    //             i_mul_lo = m_mul_lo
    //      1'b1 : i_mul_hi = wb_mul_hi
    //             i_mul_lo = wb_mul_lo
    //=============================================================
    assign  cs_mulreg_sel = mf_mul_ins ;


    //=============================================================
    // WB-Stage : Mux the value to write register
    //-------------------------------------------------------------
    //      2'b00 : write_bus = wb_result_bus
    //      2'b01 : write_bus = wb_rdata_bus
    //      2'b10 : write_bus = mul_hi
    //      2'b11 : write_bus = mul_lo
    //=============================================================
    assign  cs_wbdata_sel[1] = (mf_mul_ins)|
                               (mul_ins);

    assign  cs_wbdata_sel[0] = (load_ins)|
                               (mf_mul_ins&ins[1])|
                               (mul_ins);


    //=============================================================
    // WB-Stage : Enable the regiser to store data
    //=============================================================
    assign  cs_regwrite = (load_ins)|
                          (shift_ins&(~nop_ins))|
                          (arith_reg_ins)|
                          (arith_imm_ins)|
                          (branch1_ins&ins[20])|
                          (JAL_ins)|
                          (JALR_ins)|
                          (mf_mul_ins)|
                          (mul_ins)|
                          (mf_cp0_ins)|
						  (mt_cp0_ins)     //  add of cp0
                          ;



endmodule