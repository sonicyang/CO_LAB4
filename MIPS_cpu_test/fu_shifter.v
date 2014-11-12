 //+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: fu_shifter.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: v2.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2005/6/8 11:30¤W¤È
//---------------------------------------------------------------------
// PURPOSE: Shifter (layer)
//---------------------------------------------------------------------
// PARAMETERS:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fu_shifter(din, dout, st, sd, sp, sn);

        input   [31:0]  din;
        output  [31:0]  dout;
        input           st;     // Type [0]Shift [1]Rotate
        input           sd;     // Direction [0]Left [1]Right
        input           sp;     // Property [0]Logical [1]Arithmetic
        input   [4:0]   sn;     // Offset Number

   	//-------------------------------------------------------------
	//	Internal wires
        //-------------------------------------------------------------
        
	wire	[31:0]	sl1, sl2, sl3, sl4, sl5;
	wire	[31:0]	rr1, rr2, rr3, rr4, rr5;

	wire	[31:0]	sl_result;	//Shift Left Result	
	wire	[31:0]	rr_result;	//Rotate Right Result
	wire	[31:0]	sr_result;	//Shift Right Result

	wire	[31:0]	mask;
	wire		mask_value;
	
	reg	[31:0]	dout;	
	
   	//-------------------------------------------------------------
	//	Shift Left
        //-------------------------------------------------------------

	//Level 1 (16bits)
	assign	sl1 = (sn[4]==1'b1) 
	               ? {din[15:0], 16'b0}
	               : din ;
	                          
	//Level 2 (8bits)
	assign	sl2 = (sn[3]==1'b1) 
	               ? {sl1[23:0], 8'b0}
	               : sl1 ;

	//Level 3 (4bits)
	assign	sl3 = (sn[2]==1'b1) 
	               ? {sl2[27:0], 4'b0}
	               : sl2 ;
	
	//Level 4 (2bits)
	assign	sl4 = (sn[1]==1'b1) 
	               ? {sl3[29:0], 2'b0}
	               : sl3 ;	               

	//Level 5 (1bits)
	assign	sl5 = (sn[0]==1'b1) 
	               ? {sl4[30:0], 1'b0}
	               : sl4 ;

	assign	sl_result = sl5;
	               	               
   	//-------------------------------------------------------------
	//	Rotate Right
        //-------------------------------------------------------------

	//Level 1 (16bits)
	assign	rr1 = (sn[4]==1'b1) 
	               ? {din[15:0], din[31:16]}
	               : din ;
	                          
	//Level 2 (8bits)
	assign	rr2 = (sn[3]==1'b1) 
	               ? {rr1[7:0], rr1[31:8]}
	               : rr1 ;

	//Level 3 (4bits)
	assign	rr3 = (sn[2]==1'b1) 
	               ? {rr2[3:0], rr2[31:4]}
	               : rr2 ;
	               
	//Level 4 (2bits)
	assign	rr4 = (sn[1]==1'b1) 
	               ? {rr3[1:0], rr3[31:2]}
	               : rr3 ;	               

	//Level 5 (1bits)
	assign	rr5 = (sn[0]==1'b1) 
	               ? {rr4[0], rr4[31:1]}
	               : rr4 ;
	               
	assign	rr_result = rr5;
	
   	//-------------------------------------------------------------
	//	Mask "Rotate Right Result" for "Shift Right" 
        //-------------------------------------------------------------	               
	
	fu_shifter_mask		u_shifter_mask(
	 			 .din	(sn), 
	 			 .dout	(mask)
	 			);	               
	
	assign	mask_value = sp & din[31] ;
	
	assign	sr_result[31] = ( mask[31] ) ? mask_value : rr_result[31] ;
	assign	sr_result[30] = ( mask[30] ) ? mask_value : rr_result[30] ;
	assign	sr_result[29] = ( mask[29] ) ? mask_value : rr_result[29] ;
	assign	sr_result[28] = ( mask[28] ) ? mask_value : rr_result[28] ;
	assign	sr_result[27] = ( mask[27] ) ? mask_value : rr_result[27] ;
	assign	sr_result[26] = ( mask[26] ) ? mask_value : rr_result[26] ;
	assign	sr_result[25] = ( mask[25] ) ? mask_value : rr_result[25] ;
	assign	sr_result[24] = ( mask[24] ) ? mask_value : rr_result[24] ;
	assign	sr_result[23] = ( mask[23] ) ? mask_value : rr_result[23] ;
	assign	sr_result[22] = ( mask[22] ) ? mask_value : rr_result[22] ;
	assign	sr_result[21] = ( mask[21] ) ? mask_value : rr_result[21] ;
	assign	sr_result[20] = ( mask[20] ) ? mask_value : rr_result[20] ;
	assign	sr_result[19] = ( mask[19] ) ? mask_value : rr_result[19] ;
	assign	sr_result[18] = ( mask[18] ) ? mask_value : rr_result[18] ;
	assign	sr_result[17] = ( mask[17] ) ? mask_value : rr_result[17] ;
	assign	sr_result[16] = ( mask[16] ) ? mask_value : rr_result[16] ;
	assign	sr_result[15] = ( mask[15] ) ? mask_value : rr_result[15] ;
	assign	sr_result[14] = ( mask[14] ) ? mask_value : rr_result[14] ;
	assign	sr_result[13] = ( mask[13] ) ? mask_value : rr_result[13] ;
	assign	sr_result[12] = ( mask[12] ) ? mask_value : rr_result[12] ;
	assign	sr_result[11] = ( mask[11] ) ? mask_value : rr_result[11] ;
	assign	sr_result[10] = ( mask[10] ) ? mask_value : rr_result[10] ;
	assign	sr_result[9]  = ( mask[9]  ) ? mask_value : rr_result[9]  ;
	assign	sr_result[8]  = ( mask[8]  ) ? mask_value : rr_result[8]  ;
	assign	sr_result[7]  = ( mask[7]  ) ? mask_value : rr_result[7]  ;
	assign	sr_result[6]  = ( mask[6]  ) ? mask_value : rr_result[6]  ;
	assign	sr_result[5]  = ( mask[5]  ) ? mask_value : rr_result[5]  ;
	assign	sr_result[4]  = ( mask[4]  ) ? mask_value : rr_result[4]  ;
	assign	sr_result[3]  = ( mask[3]  ) ? mask_value : rr_result[3]  ;
	assign	sr_result[2]  = ( mask[2]  ) ? mask_value : rr_result[2]  ;
	assign	sr_result[1]  = ( mask[1]  ) ? mask_value : rr_result[1]  ;
	assign	sr_result[0]  = ( mask[0]  ) ? mask_value : rr_result[0]  ;
	
   	//-------------------------------------------------------------
	//	Output Mux for "dout"
        //-------------------------------------------------------------	               
	always@(st or sd or sl_result or sr_result or rr_result)
	begin
	
	    if(st==1'b0) //shift		
	    	begin
	    	if(sd==1'b0) 		//shift left
	    	    dout = sl_result ;
	    	else 			//shift right
	    	    dout = sr_result ;
	    	end

	    else //rotate  			
	    	dout = rr_result ;
	    	
	end	               
	               
endmodule