//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: mul_fsm.v
//---------------------------------------------------------------------
// RELEASE VERSION: V1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/5/31 04:46¤U¤È
//---------------------------------------------------------------------
// PURPOSE: 
//---------------------------------------------------------------------
// PARAMETERS:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module mul_fsm(clk, rst_n, cs_start, phase);

        input           clk;            // Clock
        input           rst_n;          // nReset
        input		cs_start;	// Start
        output     	phase;          // Current state 
        
        // BINARY ENCODED state machine:
        // State codes definitions:
        parameter       ST_P1   = 1'b0;
        parameter       ST_P2   = 1'b1;
        
        reg        	curr_state, next_state;
        
        //=============================================================
        //      main code
        //=============================================================      
        // Current State Logic (sequential)
        always @ (negedge clk or negedge rst_n)
        begin
                if(~rst_n)      // an asynchronous rst
                        curr_state = ST_P1;
                else
                        curr_state = next_state;
        end
        
        
        // NextState logic (combinatorial)
        always @ (curr_state or cs_start)
        begin
                case (curr_state)
                        ST_P1:     next_state = (cs_start)?ST_P2:ST_P1;
                        ST_P2:     next_state = ST_P1;
                endcase
        end
        
        assign  phase = curr_state;
        
endmodule