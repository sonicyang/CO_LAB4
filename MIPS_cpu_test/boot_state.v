//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: boot_state.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/8 11:40¤W¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module boot_state(  
		//Input signals
                clk,
                rst_n,
                //Output signals
                state            
                );

        //Input signals
        input           clk;
        input           rst_n;
        
        //Output signals
        output	[1:0]	state;
        
        // BINARY ENCODED state machine:
        // State codes definitions:
        parameter       BS_OFF    = 2'b00;
        parameter       BS_FIRST  = 2'b01;
        parameter       BS_SECOND = 2'b10;
        parameter	BS_NORMAL = 2'b11;


        reg     [1:0]   current_state, next_state;
        
//=====================================================================
//      Main Body
//=====================================================================


        //=============================================================
        //      FSM	
        //=============================================================
       	// Current State Logic (sequential)
        always@(posedge clk or negedge rst_n)
        begin

                if (~rst_n)      // an asynchronous rst
                        current_state = BS_OFF;
                else
                        current_state = next_state;

        end


        // next_state logic (combinatorial)
        always@(current_state)
        begin

	    case(current_state)
	    	BS_OFF:    next_state = BS_FIRST;             	  	
             	BS_FIRST:  next_state = BS_SECOND;
                BS_SECOND: next_state = BS_NORMAL;
                BS_NORMAL: next_state = BS_NORMAL;
             	default:   next_state = BS_OFF;	 
	    endcase

        end
        
        
        //=============================================================
        //      Output Signals Generater
        //=============================================================
	assign	state = current_state;


endmodule
