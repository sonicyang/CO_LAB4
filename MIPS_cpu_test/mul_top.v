//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: mul_top.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/22 01:43¤U¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module mul_top( clk,
                rst_n,
                cs_start,
                cs_sign,
                din_a,
                din_b,
                mul_stall,
                product
                );

        input           clk;            // System clk
        input           rst_n;          // System Reset
        input           cs_start;       // Start (before phase1)
        input           cs_sign;        // [0]unsigned [1]signed
        input   [31:0]  din_a;          // multiplicand
        input   [31:0]  din_b;          // multiplier

        output		mul_stall;
        output  [63:0]  product;

        //-------------------------------------------------------------
        // Define or Parameter
        //-------------------------------------------------------------

        // BINARY ENCODED state machine:
        // State codes definitions:
        parameter       ST_P1   = 1'b0;
        parameter       ST_P2   = 1'b1;

        //-------------------------------------------------------------
        //      Internal signals
        //-------------------------------------------------------------
        wire            phase;
        wire            phase1, phase2;

        wire    [49:0]  result;

        wire    [32:0]  a33;
        wire    [32:0]  b33;
        wire    [33:0]  a34, a34x2, a34_n, a34x2_n;

        reg     [2:0]   decode_input01,
                        decode_input03,
                        decode_input05,
                        decode_input07,
                        decode_input09,
                        decode_input11,
                        decode_input13,
                        decode_input15;

        reg     [34:0]  column00_din;

        wire    [33:0]  column01_din,
        		column03_din,
                        column05_din,
                        column07_din,
                        column09_din,
                        column11_din,
                        column13_din,
                        column15_din;

        wire    [34:0]  phase1_input,
                        phase2_input;

        wire    [33:0]  column01_sum, column01_carry, column01_sin,
                        column02_sum, column02_carry, column02_sin, column02_cin,
                        column03_sum, column03_carry, column03_sin, column03_cin,
                        column04_sum, column04_carry, column04_sin, column04_cin,
                        column05_sum, column05_carry, column05_sin, column05_cin,
                        column06_sum, column06_carry, column06_sin, column06_cin,
                        column07_sum, column07_carry, column07_sin, column07_cin,
                        column08_sum, column08_carry, column08_sin, column08_cin,
                        column09_sum, column09_carry, column09_sin, column09_cin,
                        column10_sum, column10_carry, column10_sin, column10_cin,
                        column11_sum, column11_carry, column11_sin, column11_cin,
                        column12_sum, column12_carry, column12_sin, column12_cin,
                        column13_sum, column13_carry, column13_sin, column13_cin,
                        column14_sum, column14_carry, column14_sin, column14_cin,
                        column15_sum, column15_carry, column15_sin, column15_cin,
                        column16_sin, column16_cin;

        wire            wren_bit00, wren_bit01, wren_bit02, wren_bit03,
                        wren_bit04, wren_bit05, wren_bit06, wren_bit07,
                        wren_bit08, wren_bit09, wren_bit10, wren_bit11,
                        wren_bit12, wren_bit13, wren_bit14, wren_bit15,
                        wren_bit16, wren_bit17, wren_bit18, wren_bit19,
                        wren_bit20, wren_bit21, wren_bit22, wren_bit23,
                        wren_bit24, wren_bit25, wren_bit26, wren_bit27,
                        wren_bit28, wren_bit29, wren_bit30, wren_bit31,
                        wren_bit32, wren_bit33, wren_bit34, wren_bit35,
                        wren_bit36, wren_bit37, wren_bit38, wren_bit39,
                        wren_bit40, wren_bit41, wren_bit42, wren_bit43,
                        wren_bit44, wren_bit45, wren_bit46, wren_bit47,
                        wren_bit48, wren_bit49, wren_bit50, wren_bit51,
                        wren_bit52, wren_bit53, wren_bit54, wren_bit55,
                        wren_bit56, wren_bit57, wren_bit58, wren_bit59,
                        wren_bit60, wren_bit61, wren_bit62, wren_bit63;

        wire            logic0;
        reg     [63:0]  regin;
        wire    [63:0]  regout;

//=====================================================================
//      Main Body
//=====================================================================

        assign  logic0 = 1'b0;

        //=============================================================
        //      Timing Control Block
        //=============================================================

        // Phase Generater
        mul_fsm         u_fsm(
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .cs_start      (cs_start),
                         .phase         (phase)
                        );

        assign  phase1 = (phase==ST_P1) ? 1'b1 : 1'b0;
        assign  phase2 = (phase==ST_P2) ? 1'b1 : 1'b0;
	assign	mul_stall = phase1 ;

        //=============================================================
        // Extend Logic
        //=============================================================

        // Sign-Extend or Zero_extend a[31:0] to a33[32:0]
        assign  a33[32] = (cs_sign==0)?1'b0:din_a[31];
        assign  a33[31:0] = din_a;

        // Sign-Extend or Zero_extend b[31:0] to b33[32:0]
        assign  b33[32] = (cs_sign==0)?1'b0:din_b[31];
        assign  b33[31:0] = din_b;

        // Other Extending Function for Booth's algorithm
        assign  a34 = {a33[32],a33};
        assign  a34x2 = {a33,1'b0};
        assign  a34_n = -a34;
        assign  a34x2_n = -a34x2;

        //=============================================================
        //      Booth's Decode/Mux Block
        //=============================================================

	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input01 = b33[2:0];
        	ST_P2:   decode_input01 = b33[18:16];
        	default: decode_input01 = 3'b000;	
            endcase
        end	    	

	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input03 = b33[4:2];
        	ST_P2:   decode_input03 = b33[20:18];
        	default: decode_input03 = 3'b000;	
            endcase
        end
        	

	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input05 = b33[6:4];
        	ST_P2:   decode_input05 = b33[22:20];
        	default: decode_input05 = 3'b000;	
            endcase
        end


	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input07 = b33[8:6];
        	ST_P2:   decode_input07 = b33[24:22];
        	default: decode_input07 = 3'b000;	
            endcase
        end

	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input09 = b33[10:8];
        	ST_P2:   decode_input09 = b33[26:24];
        	default: decode_input09 = 3'b000;	
            endcase
        end	    	

	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input11 = b33[12:10];
        	ST_P2:   decode_input11 = b33[28:26];
        	default: decode_input11 = 3'b000;	
            endcase
        end
        	

	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input13 = b33[14:12];
        	ST_P2:   decode_input13 = b33[30:28];
        	default: decode_input13 = 3'b000;	
            endcase
        end


	always@(phase or b33)
	begin
	    case(phase)
        	ST_P1:   decode_input15 = b33[16:14];
        	ST_P2:   decode_input15 = b33[32:30];
        	default: decode_input15 = 3'b000;	
            endcase
        end
        

        mul_decode      u_decode01(
                         .sel           (decode_input01),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column01_din)
                        );

        mul_decode      u_decode03(
                         .sel           (decode_input03),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column03_din)
                        );

        mul_decode      u_decode05(
                         .sel           (decode_input05),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column05_din)
                        );

        mul_decode      u_decode07(
                         .sel           (decode_input07),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column07_din)
                        );

        mul_decode      u_decode09(
                         .sel           (decode_input09),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column09_din)
                        );

        mul_decode      u_decode11(
                         .sel           (decode_input11),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column11_din)
                        );

        mul_decode      u_decode13(
                         .sel           (decode_input13),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column13_din)
                        );

        mul_decode      u_decode15(
                         .sel           (decode_input15),
                         .a34           (a34),
                         .a34x2         (a34x2),
                         .a34_n         (a34_n),
                         .a34x2_n       (a34x2_n),
                         .dout          (column15_din)
                        );


        //=============================================================
        //      32-layer Carry Save Adder
        //=============================================================

        //Input Mux Logic
        assign  phase1_input = (b33[0]==1) ? {a34_n} : 34'b0 ;
        assign  phase2_input = regout[49:16];
        
        always@(phase or phase1_input or phase2_input)
        begin
            case(phase)
                ST_P1:   column00_din = phase1_input;
                ST_P2:   column00_din = phase2_input;
                default: column00_din = 34'b0;
            endcase
        end

        assign  result[0] = column00_din[0];


        //Base = Bit[1]
        assign  column01_sin = {column00_din[33], column00_din[33:1]};
        assign  column01_sum = column01_sin^column01_din;
        assign  column01_carry = column01_sin&column01_din;
        assign  result[1] = column01_sum[0];

        assign  column02_sin = {column01_sum[33],column01_sum[33:1]};
        assign  column02_cin = column01_carry;
        assign  column02_sum = column02_sin^column02_cin;
        assign  column02_carry = column02_sin&column02_cin;
        assign  result[2] = column02_sum[0];


        //Base = Bit[3]
        assign  column03_sin = {column02_sum[33],column02_sum[33:1]};
        assign  column03_cin = column02_carry;
        assign  column03_sum = column03_sin^column03_cin^column03_din;
        assign  column03_carry = (column03_sin&column03_cin)|
                                 (column03_cin&column03_din)|
                                 (column03_din&column03_sin);
        assign  result[3] = column03_sum[0];

        assign  column04_sin = {column03_sum[33],column03_sum[33:1]};
        assign  column04_cin = column03_carry;
        assign  column04_sum = column04_sin^column04_cin;
        assign  column04_carry = column04_sin&column04_cin;
        assign  result[4] = column04_sum[0];


        //Base = Bit[5]
        assign  column05_sin = {column04_sum[33],column04_sum[33:1]};
        assign  column05_cin = column04_carry;
        assign  column05_sum = column05_sin^column05_cin^column05_din;
        assign  column05_carry = (column05_sin&column05_cin)|
                                 (column05_cin&column05_din)|
                                 (column05_din&column05_sin);
        assign  result[5] = column05_sum[0];

        assign  column06_sin = {column05_sum[33],column05_sum[33:1]};
        assign  column06_cin = column05_carry;
        assign  column06_sum = column06_sin^column06_cin;
        assign  column06_carry = column06_sin&column06_cin;
        assign  result[6] = column06_sum[0];


        //Base = Bit[7]
        assign  column07_sin = {column06_sum[33],column06_sum[33:1]};
        assign  column07_cin = column06_carry;
        assign  column07_sum = column07_sin^column07_cin^column07_din;
        assign  column07_carry = (column07_sin&column07_cin)|
                                 (column07_cin&column07_din)|
                                 (column07_din&column07_sin);
        assign  result[7] = column07_sum[0];

        assign  column08_sin = {column07_sum[33],column07_sum[33:1]};
        assign  column08_cin = column07_carry;
        assign  column08_sum = column08_sin^column08_cin;
        assign  column08_carry = column08_sin&column08_cin;
        assign  result[8] = column08_sum[0];


        //Base = Bit[9]
        assign  column09_sin = {column08_sum[33],column08_sum[33:1]};
        assign  column09_cin = column08_carry;
        assign  column09_sum = column09_sin^column09_cin^column09_din;
        assign  column09_carry = (column09_sin&column09_cin)|
                                 (column09_cin&column09_din)|
                                 (column09_din&column09_sin);
        assign  result[9] = column09_sum[0];

        assign  column10_sin = {column09_sum[33],column09_sum[33:1]};
        assign  column10_cin = column09_carry;
        assign  column10_sum = column10_sin^column10_cin;
        assign  column10_carry = column10_sin&column10_cin;
        assign  result[10] = column10_sum[0];


        //Base = Bit[11]
        assign  column11_sin = {column10_sum[33],column10_sum[33:1]};
        assign  column11_cin = column10_carry;
        assign  column11_sum = column11_sin^column11_cin^column11_din;
        assign  column11_carry = (column11_sin&column11_cin)|
                                 (column11_cin&column11_din)|
                                 (column11_din&column11_sin);
        assign  result[11] = column11_sum[0];

        assign  column12_sin = {column11_sum[33],column11_sum[33:1]};
        assign  column12_cin = column11_carry;
        assign  column12_sum = column12_sin^column12_cin;
        assign  column12_carry = column12_sin&column12_cin;
        assign  result[12] = column12_sum[0];


        //Base = Bit[13]
        assign  column13_sin = {column12_sum[33],column12_sum[33:1]};
        assign  column13_cin = column12_carry;
        assign  column13_sum = column13_sin^column13_cin^column13_din;
        assign  column13_carry = (column13_sin&column13_cin)|
                                 (column13_cin&column13_din)|
                                 (column13_din&column13_sin);
        assign  result[13] = column13_sum[0];

        assign  column14_sin = {column13_sum[33],column13_sum[33:1]};
        assign  column14_cin = column13_carry;
        assign  column14_sum = column14_sin^column14_cin;
        assign  column14_carry = column14_sin&column14_cin;
        assign  result[14] = column14_sum[0];


        //Base = Bit[15]
        assign  column15_sin = {column14_sum[33],column14_sum[33:1]};
        assign  column15_cin = column14_carry;
        assign  column15_sum = column15_sin^column15_cin^column15_din;
        assign  column15_carry = (column15_sin&column15_cin)|
                                 (column15_cin&column15_din)|
                                 (column15_din&column15_sin);
        assign  result[15] = column15_sum[0];

        assign  column16_sin = {column15_sum[33],column15_sum[33:1]};
        assign  column16_cin = column15_carry;

        fu_csa34        u_csa34(
                        .din1           (column16_sin),
                        .din2           (column16_cin),
                        .carry_in       (logic0),
                        .dout           (result[49:16]),
                        .carry_out      (),
                        .overflow       ()
                        );

        //=============================================================
        //      Result Regisger
        //=============================================================

        assign  wren_bit00 = ((cs_start)&phase1) ;
        assign  wren_bit01 = ((cs_start)&phase1) ;
        assign  wren_bit02 = ((cs_start)&phase1) ;
        assign  wren_bit03 = ((cs_start)&phase1) ;
        assign  wren_bit04 = ((cs_start)&phase1) ;
        assign  wren_bit05 = ((cs_start)&phase1) ;
        assign  wren_bit06 = ((cs_start)&phase1) ;
        assign  wren_bit07 = ((cs_start)&phase1) ;
        assign  wren_bit08 = ((cs_start)&phase1) ;
        assign  wren_bit09 = ((cs_start)&phase1) ;
        assign  wren_bit10 = ((cs_start)&phase1) ;
        assign  wren_bit11 = ((cs_start)&phase1) ;
        assign  wren_bit12 = ((cs_start)&phase1) ;
        assign  wren_bit13 = ((cs_start)&phase1) ;
        assign  wren_bit14 = ((cs_start)&phase1) ;
        assign  wren_bit15 = ((cs_start)&phase1) ;
        assign  wren_bit16 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit17 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit18 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit19 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit20 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit21 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit22 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit23 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit24 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit25 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit26 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit27 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit28 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit29 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit30 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit31 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit32 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit33 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit34 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit35 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit36 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit37 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit38 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit39 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit40 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit41 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit42 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit43 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit44 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit45 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit46 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit47 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit48 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit49 = ((cs_start)&phase1) | phase2 ;
        assign  wren_bit50 =                       phase2 ;
        assign  wren_bit51 =                       phase2 ;
        assign  wren_bit52 =                       phase2 ;
        assign  wren_bit53 =                       phase2 ;
        assign  wren_bit54 =                       phase2 ;
        assign  wren_bit55 =                       phase2 ;
        assign  wren_bit56 =                       phase2 ;
        assign  wren_bit57 =                       phase2 ;
        assign  wren_bit58 =                       phase2 ;
        assign  wren_bit59 =                       phase2 ;
        assign  wren_bit60 =                       phase2 ;
        assign  wren_bit61 =                       phase2 ;
        assign  wren_bit62 =                       phase2 ;
        assign  wren_bit63 =                       phase2 ;

        always@(phase or result)
        begin
            case(phase)
                ST_P1:   regin = {14'b0, result[49:0]};
                ST_P2:   regin = {result[47:0], 16'b0};
                default: regin = 64'b0;
            endcase
        end


        mul_reg1_ne     u_reg00(clk, rst_n, regin[0], wren_bit00 ,regout[0]);
        mul_reg1_ne     u_reg01(clk, rst_n, regin[1], wren_bit01 ,regout[1]);
        mul_reg1_ne     u_reg02(clk, rst_n, regin[2], wren_bit02 ,regout[2]);
        mul_reg1_ne     u_reg03(clk, rst_n, regin[3], wren_bit03 ,regout[3]);
        mul_reg1_ne     u_reg04(clk, rst_n, regin[4], wren_bit04 ,regout[4]);
        mul_reg1_ne     u_reg05(clk, rst_n, regin[5], wren_bit05 ,regout[5]);
        mul_reg1_ne     u_reg06(clk, rst_n, regin[6], wren_bit06 ,regout[6]);
        mul_reg1_ne     u_reg07(clk, rst_n, regin[7], wren_bit07 ,regout[7]);

        mul_reg1_ne     u_reg08(clk, rst_n, regin[8], wren_bit08 ,regout[8]);
        mul_reg1_ne     u_reg09(clk, rst_n, regin[9], wren_bit09 ,regout[9]);
        mul_reg1_ne     u_reg10(clk, rst_n, regin[10], wren_bit10 ,regout[10]);
        mul_reg1_ne     u_reg11(clk, rst_n, regin[11], wren_bit11 ,regout[11]);
        mul_reg1_ne     u_reg12(clk, rst_n, regin[12], wren_bit12 ,regout[12]);
        mul_reg1_ne     u_reg13(clk, rst_n, regin[13], wren_bit13 ,regout[13]);
        mul_reg1_ne     u_reg14(clk, rst_n, regin[14], wren_bit14 ,regout[14]);
        mul_reg1_ne     u_reg15(clk, rst_n, regin[15], wren_bit15 ,regout[15]);

        mul_reg1_ne     u_reg16(clk, rst_n, regin[16], wren_bit16 ,regout[16]);
        mul_reg1_ne     u_reg17(clk, rst_n, regin[17], wren_bit17 ,regout[17]);
        mul_reg1_ne     u_reg18(clk, rst_n, regin[18], wren_bit18 ,regout[18]);
        mul_reg1_ne     u_reg19(clk, rst_n, regin[19], wren_bit19 ,regout[19]);
        mul_reg1_ne     u_reg20(clk, rst_n, regin[20], wren_bit20 ,regout[20]);
        mul_reg1_ne     u_reg21(clk, rst_n, regin[21], wren_bit21 ,regout[21]);
        mul_reg1_ne     u_reg22(clk, rst_n, regin[22], wren_bit22 ,regout[22]);
        mul_reg1_ne     u_reg23(clk, rst_n, regin[23], wren_bit23 ,regout[23]);

        mul_reg1_ne     u_reg24(clk, rst_n, regin[24], wren_bit24 ,regout[24]);
        mul_reg1_ne     u_reg25(clk, rst_n, regin[25], wren_bit25 ,regout[25]);
        mul_reg1_ne     u_reg26(clk, rst_n, regin[26], wren_bit26 ,regout[26]);
        mul_reg1_ne     u_reg27(clk, rst_n, regin[27], wren_bit27 ,regout[27]);
        mul_reg1_ne     u_reg28(clk, rst_n, regin[28], wren_bit28 ,regout[28]);
        mul_reg1_ne     u_reg29(clk, rst_n, regin[29], wren_bit29 ,regout[29]);
        mul_reg1_ne     u_reg30(clk, rst_n, regin[30], wren_bit30 ,regout[30]);
        mul_reg1_ne     u_reg31(clk, rst_n, regin[31], wren_bit31 ,regout[31]);

        mul_reg1_ne     u_reg32(clk, rst_n, regin[32], wren_bit32 ,regout[32]);
        mul_reg1_ne     u_reg33(clk, rst_n, regin[33], wren_bit33 ,regout[33]);
        mul_reg1_ne     u_reg34(clk, rst_n, regin[34], wren_bit34 ,regout[34]);
        mul_reg1_ne     u_reg35(clk, rst_n, regin[35], wren_bit35 ,regout[35]);
        mul_reg1_ne     u_reg36(clk, rst_n, regin[36], wren_bit36 ,regout[36]);
        mul_reg1_ne     u_reg37(clk, rst_n, regin[37], wren_bit37 ,regout[37]);
        mul_reg1_ne     u_reg38(clk, rst_n, regin[38], wren_bit38 ,regout[38]);
        mul_reg1_ne     u_reg39(clk, rst_n, regin[39], wren_bit39 ,regout[39]);

        mul_reg1_ne     u_reg40(clk, rst_n, regin[40], wren_bit40 ,regout[40]);
        mul_reg1_ne     u_reg41(clk, rst_n, regin[41], wren_bit41 ,regout[41]);
        mul_reg1_ne     u_reg42(clk, rst_n, regin[42], wren_bit42 ,regout[42]);
        mul_reg1_ne     u_reg43(clk, rst_n, regin[43], wren_bit43 ,regout[43]);
        mul_reg1_ne     u_reg44(clk, rst_n, regin[44], wren_bit44 ,regout[44]);
        mul_reg1_ne     u_reg45(clk, rst_n, regin[45], wren_bit45 ,regout[45]);
        mul_reg1_ne     u_reg46(clk, rst_n, regin[46], wren_bit46 ,regout[46]);
        mul_reg1_ne     u_reg47(clk, rst_n, regin[47], wren_bit47 ,regout[47]);

        mul_reg1_ne     u_reg48(clk, rst_n, regin[48], wren_bit48 ,regout[48]);
        mul_reg1_ne     u_reg49(clk, rst_n, regin[49], wren_bit49 ,regout[49]);
        mul_reg1_ne     u_reg50(clk, rst_n, regin[50], wren_bit50 ,regout[50]);
        mul_reg1_ne     u_reg51(clk, rst_n, regin[51], wren_bit51 ,regout[51]);
        mul_reg1_ne     u_reg52(clk, rst_n, regin[52], wren_bit52 ,regout[52]);
        mul_reg1_ne     u_reg53(clk, rst_n, regin[53], wren_bit53 ,regout[53]);
        mul_reg1_ne     u_reg54(clk, rst_n, regin[54], wren_bit54 ,regout[54]);
        mul_reg1_ne     u_reg55(clk, rst_n, regin[55], wren_bit55 ,regout[55]);

        mul_reg1_ne     u_reg56(clk, rst_n, regin[56], wren_bit56 ,regout[56]);
        mul_reg1_ne     u_reg57(clk, rst_n, regin[57], wren_bit57 ,regout[57]);
        mul_reg1_ne     u_reg58(clk, rst_n, regin[58], wren_bit58 ,regout[58]);
        mul_reg1_ne     u_reg59(clk, rst_n, regin[59], wren_bit59 ,regout[59]);
        mul_reg1_ne     u_reg60(clk, rst_n, regin[60], wren_bit60 ,regout[60]);
        mul_reg1_ne     u_reg61(clk, rst_n, regin[61], wren_bit61 ,regout[61]);
        mul_reg1_ne     u_reg62(clk, rst_n, regin[62], wren_bit62 ,regout[62]);
        mul_reg1_ne     u_reg63(clk, rst_n, regin[63], wren_bit63 ,regout[63]);


        //=============================================================
        //      Output
        //=============================================================
        assign  product = regout[63:0];

endmodule