//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_reg32_ne.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Apr. 01, 2005  08:51
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module cpu_reg32_ne(irq,epc,clk, rst_n, din, wren, dout,if_pc,id_pc,exe_pc,mem_pc,wb_pc, iack);

        input           clk;    // System clk
        input           rst_n;  // System Reset
        input   [31:0]  din;    // Data input
		input	[31:0]	epc;
        input           wren; // Enable Register
		input	[7:0]	irq;
		input 			iack;
        output  [31:0]  dout;   // Data Output
		output  [31:0]  if_pc;
		output  [31:0]  id_pc;
		output  [31:0]  exe_pc;
		output  [31:0]  mem_pc;
		output  [31:0]  wb_pc;

        reg     [31:0]  dout;
		reg	  	[31:0]  if_pc;
		reg  	[31:0]  id_pc;
		reg  	[31:0]  exe_pc;
		reg  	[31:0]  mem_pc;
		reg  	[31:0]  wb_pc;
		
        always@(negedge clk or negedge rst_n or posedge iack)
        begin
                if(~rst_n)    	
					begin
						dout<=32'b0;
						if_pc<=32'b0;
						id_pc<=32'b0;
						exe_pc<=32'b0;
						mem_pc<=32'b0;
						wb_pc<=32'b0;
					end
				else if(iack)
					begin
						dout<=32'h00001000;
						if_pc<=dout;
						id_pc<=if_pc;
						exe_pc<=id_pc;
						mem_pc<=exe_pc;
						wb_pc<=mem_pc;
					end

				else
					begin
						if(din ==32'h00002004)
						begin
							dout<=epc;
							if_pc<=dout;
							id_pc<=if_pc;
							exe_pc<=id_pc;
							mem_pc<=exe_pc;
							wb_pc<=mem_pc;
						end
						else if(wren) 
						begin 
							dout<=din;  $monitor("%0dns :\$monitor: wren=%b ",$stime,wren);  
							if_pc<=dout;
							id_pc<=if_pc;
							exe_pc<=id_pc;
							mem_pc<=exe_pc;
							wb_pc<=mem_pc;
						end
						else
						begin
							dout<=dout;
							if_pc<=dout;
							id_pc<=if_pc;
							exe_pc<=id_pc;
							mem_pc<=exe_pc;
							wb_pc<=mem_pc;							
						end
					end		
					
				
                 
        end


endmodule