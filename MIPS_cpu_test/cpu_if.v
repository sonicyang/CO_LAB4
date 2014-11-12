//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/22 12:56¤U¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_if(  //system input
                clk,
                rst_n,
                imem_databus,
				irq,
                //control signal input
                stall_n,                
                id_pc_src,
				if_intctl_epc,
                //datapath input
                id_add_out,
                id_jump_pc,
                id_rs_data,
                //system output
                imem_addr,
				mem_pc,
                imem_read,         
				iack,
                //datapath output
                id_pca4,
                id_ins
                );
        //-------------------------------------------------------------
        // System Input
        //-------------------------------------------------------------
        input           clk;
        input           rst_n;
        input   [31:0]  imem_databus;
		input   [7:0]   irq;

        //-------------------------------------------------------------
        // Control Signal Input
        //-------------------------------------------------------------
        input           stall_n;
        input   [1:0]   id_pc_src;
		input	[31:0]	if_intctl_epc;


        //-------------------------------------------------------------
        // Datapath Input
        //-------------------------------------------------------------
        input   [31:0]  id_add_out;
        input   [31:0]  id_jump_pc;
        input   [31:0]  id_rs_data;

        //-------------------------------------------------------------
        // System Output
        //-------------------------------------------------------------
        output  [31:0]  imem_addr;
		output	[31:0]	mem_pc;
        output          imem_read;
		
        //-------------------------------------------------------------
        // Datapath Output
        //-------------------------------------------------------------
        output  [31:0]  id_pca4;
        output  [31:0]  id_ins;
		input 			iack;

	//-------------------------------------------------------------        
        // Parameter
	//-------------------------------------------------------------
        // BINARY ENCODED state machine:
        // State codes definitions:
        parameter       BS_OFF    = 2'b00;
        parameter       BS_FIRST  = 2'b01;
        parameter       BS_SECOND = 2'b10;
        parameter		BS_NORMAL = 2'b11;
        
        
 	//-------------------------------------------------------------        
        // Internal Wire
	//-------------------------------------------------------------
        wire	[1:0]	bs_state;	//Boot state
        wire            if2id_r_en;
        wire    [31:0]  if_pc;
		wire	[31:0]	mem_pc;
        reg    	[31:0]  if_npc;
        wire    [31:0]  if_pca4;
        wire    [31:0]  if_ins;
        
//=====================================================================
//      Main Body
//=====================================================================

        //=============================================================
        //      Boot state
        //=============================================================
	boot_state	u_boot_state(  
			 .clk		(clk),
                	 .rst_n		(rst_n),
                	 .state		(bs_state)            
                	);
                	
	assign  if2id_r_en = ( (bs_state!=BS_OFF)&&
	                       (bs_state!=BS_FIRST) ) & stall_n ;

        //=============================================================
        //      Program Counter
        //=============================================================
	
	//Current PC
        cpu_reg32_ne    u_pc(
						 .iack			(iack),
						 .irq			(irq),
						 .epc			(if_intctl_epc),
                         .clk           (clk),
                         .rst_n         (rst_n),
                         .din           (if_npc),
                         .wren        	(if2id_r_en),
                         .dout          (if_pc),
						 .mem_pc		(mem_pc)
                        );

        assign  imem_addr = if_pc;
	assign	imem_read = (bs_state==BS_OFF) ? 1'b0 : 1'b1 ; 
        assign  if_ins = imem_databus;
        
        
	//Next PC
	always@(id_pc_src or if_pca4 or id_add_out or id_jump_pc or 
	        id_rs_data)
	begin
	    case(id_pc_src)
	    	2'b00: if_npc = if_pca4;
	    	2'b01: if_npc = id_add_out;
	    	2'b10: if_npc = id_jump_pc;
	    	2'b11: if_npc = id_rs_data;
	    endcase	  
	end

        assign  if_pca4 = if_pc + 32'h00000004;
        
        
        //=============================================================
        //      IF/ID Register
        //=============================================================

        cpu_reg32_ne_ex    u_if2id_pca4(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (if_pca4),
                         .wren          (if2id_r_en),
                         .dout          (id_pca4)
                        );

        cpu_reg32_ne_ex    u_if2id_ir(
                         .clk           (clk),
                         .rst_n         (rst_n),
						 .iack			(iack),
                         .din           (if_ins),
                         .wren          (if2id_r_en),
                         .dout          (id_ins)
                        );



endmodule
