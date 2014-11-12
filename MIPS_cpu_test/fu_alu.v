//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: fu_alu.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Dec. 11, 2004  07:08pm
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fu_alu(  a,
                b,
                op,
                move_cond,
                result,
                carryout,
                zero,
                overflow,
                move_check
                );

        input   [31:0]  a;
        input   [31:0]  b;
        input   [3:0]   op;
        input   [1:0]   move_cond;

        output  [31:0]  result;
        output          carryout;
        output          zero;
        output          overflow;
        output          move_check;

        wire            adder_sub;
        wire    [31:0]  bus_b;
        wire    [31:0]  bus_and, bus_or, bus_xor, bus_nor;
        wire    [31:0]  bus_logic;

        wire    [31:0]  bus_add;
        wire    [31:0]  bus_slt;
        wire    [31:0]  bus_slt_move;
        wire    [31:0]  bus_lui;
        reg     [31:0]  result;
        wire            b_zero;



        //=============================================================
        //                    ALUOp     ALU Function
        //-------------------------------------------------------------
        //      ADD:          0000      ADD
        //      ADDU:         0001      ADD
        //      SUB:          0010      SUB
        //      SUBU:         0011      SUB
        //      AND:          0100      AND
        //      OR:           0101      OR
        //      XOR:          0110      XOR
        //      NOR:          0111      NOR
        //      ADDI:         1000      ADD
        //      ADDIU:        1001      ADD
        //      SLT,SLTI:     1010      SUB
        //      SLTU,SLTIU:   1011      SUB
        //      ANDI:         1100      AND
        //      ORI:          1101      OR
        //      XORI:         1110      XOR
        //      LUI:          1111      NOP
        //=============================================================


        //=============================================================
        //      Adder
        //=============================================================

        // inv
        assign  adder_sub = (op[2:1]==2'b01) ? 1'b1 : 1'b0 ;
        assign  bus_b=(adder_sub)?~b:b;

        // adder-32bit
        fu_csa32        u_adder32(
                         .din1          (a),
                         .din2          (bus_b),
                         .carry_in      (adder_sub),
                         .dout          (bus_add),
                         .carry_out     (carryout),
                         .overflow      (overflow)
                        );


        //=============================================================
        //      Logic
        //=============================================================

        // and
        assign  bus_and=a&b;

        // or
        assign  bus_or=a|b;

        // xor
        assign  bus_xor=a^b;

        // nor
        assign  bus_nor = ~(a|b);

        assign  bus_logic = (op[1:0]==2'b00)?bus_and:
                            (op[1:0]==2'b01)?bus_or:
                            (op[1:0]==2'b10)?bus_xor:
                            (op[1:0]==2'b11)?bus_nor:
                            32'b0;


        //=============================================================
        //      SLT
        //-------------------------------------------------------------
        // if (op[0]=1) ==> Unsigned
        // A[31] B[31]
        //   0     0    --> = 2'complement
        //   0     1    --> A < B
        //   1     0    --> A > B
        //   1     1    --> = 2'complement
        //=============================================================

        assign  bus_slt[31:1]=31'b0;
        assign  bus_slt[0] = (op[0]&({a[31],b[31]}==2'b01))?1'b1:
                             (op[0]&({a[31],b[31]}==2'b10))?1'b0:
                             bus_add[31];

        assign  bus_slt_move = (move_cond[1]) ? a : bus_slt ;

        //=============================================================
        //      LUI
        //=============================================================
        assign  bus_lui[31:16] = b[15:0] ;
        assign  bus_lui[15:0] = 16'b0;

        //=============================================================
        //      Output  Mux
        //=============================================================
        always@(bus_logic or bus_add or bus_slt_move or bus_lui or
                op)
        begin
            case(op)
                4'b0000: result = bus_add;      //ADD:          00 0000 ... 10 0000
                4'b0001: result = bus_add;      //ADDU:         00 0000 ... 10 0001
                4'b0010: result = bus_add;      //SUB:          00 0000 ... 10 0010
                4'b0011: result = bus_add;      //SUBU:         00 0000 ... 10 0011
                4'b0100: result = bus_logic;    //AND:          00 0000 ... 10 0100
                4'b0101: result = bus_logic;    //OR:           00 0000 ... 10 0101
                4'b0110: result = bus_logic;    //XOR:          00 0000 ... 10 0110
                4'b0111: result = bus_logic;    //NOR:          00 0000 ... 10 0111
                4'b1000: result = bus_add;      //ADDI:         00 1000 ... xx xxxx
                4'b1001: result = bus_add;      //ADDIU:        00 1001 ... xx xxxx
                4'b1010: result = bus_slt_move; //SLT,SLTI:     00 0000 ... 10 1010
                                                //SLTI:         00 1010 ... xx xxxx
                4'b1011: result = bus_slt_move; //SLTU,SLTIU:   00 0000 ... 10 1011
                                                //SLTIU:        00 1011 ... xx xxxx
                4'b1100: result = bus_logic;    //ANDI:         00 1100 ... xx xxxx
                4'b1101: result = bus_logic;    //ORI:          00 1101 ... xx xxxx
                4'b1110: result = bus_logic;    //XORI:         00 1110 ... xx xxxx
                4'b1111: result = bus_lui;      //LUI:          00 1111 ... xx xxxx
            endcase
        end

        //=============================================================
        //      Other
        //=============================================================
        //zero detection
        assign  zero=(result==32'b0)?1'b1:1'b0;

        //Move Conditional Check
        assign  b_zero = (b==32'b0)?1'b1:1'b0;
        assign  move_check = (move_cond[0]==1'b0)? b_zero : (~b_zero) ;




endmodule