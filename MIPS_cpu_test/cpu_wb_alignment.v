//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: cpu_wb_alignment.v
// AUTHOR: Chen-Chien Wang
// CONTACT INFORMATION: ccwang@casmail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: V 1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: Apr. 27, 2005  11:54
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on


module cpu_wb_alignment(  
	//input
	addr,
	big_endian,
	align_op,
	load_data,
        //output
        write_mask, 
        dout
              
        );

        input	[1:0]	addr;
	input		big_endian;
	input	[2:0]	align_op;
	input   [31:0]  load_data;
       
       	output	[3:0]	write_mask;
	output  [31:0]  dout;
        

        //Internal wire/reg
        wire		cs_sign;
	reg	[7:0]	byte_data;
	wire	[31:0]	byte_extend;
	reg	[15:0]	halfword_data;
	wire	[31:0]	halfword_extend;
	reg	[31:0]	lwl_data;
	reg	[31:0]	lwr_data;
	wire	[31:0]	temp;
	reg	[31:0]	dout;
	
	reg	[3:0]	lwl_write_mask;
	reg	[3:0]	lwr_write_mask;
	reg	[3:0]	write_mask;
	
	
//=====================================================================
//      Main Body
//=====================================================================

        //-------------------------------------------------------------
        // Control 
        //-------------------------------------------------------------
        assign	cs_sign = (align_op[2]==1'b0) ? 1'b1 : 1'b0 ;

        //-------------------------------------------------------------
        // LB/LBU
        //-------------------------------------------------------------
	always@(big_endian or addr or load_data)
	begin
	
	    if(big_endian==1'b1) //Big-Endian
	    	begin
	    	case(addr)
	    	    2'b00: byte_data = load_data[31:24];
	    	    2'b01: byte_data = load_data[23:16];
	    	    2'b10: byte_data = load_data[15:8];
	    	    2'b11: byte_data = load_data[7:0];
	    	endcase
	    	end
	    else
	    	begin	// Littel-Endian
	    	case(addr)
	    	    2'b00: byte_data = load_data[7:0];
	    	    2'b01: byte_data = load_data[15:8];
	    	    2'b10: byte_data = load_data[23:16];
	    	    2'b11: byte_data = load_data[31:24];
	    	endcase	    	
	    	end
	end

	assign	byte_extend[31] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[30] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[29] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[28] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[27] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[26] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[25] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[24] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[23] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[22] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[21] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[20] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[19] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[18] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[17] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[16] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[15] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[14] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[13] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[12] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[11] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[10] = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[9]  = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[8]  = (cs_sign==1'b1) ? byte_data[7] : 1'b0 ;
	assign	byte_extend[7:0] = byte_data[7:0] ;
	

        //-------------------------------------------------------------
        // LH/LHU
        //-------------------------------------------------------------
	always@(big_endian or addr or load_data)
	begin
	
	    if(big_endian==1'b1) //Big-Endian
	    	begin
	    	if(addr[1]==1'b1)
	    	    halfword_data = load_data[15:0];
	    	else
	    	    halfword_data = load_data[31:16];
	    	end
	    else
	    	begin	// Littel-Endian
	    	if(addr[1]==1'b1)
	    	    halfword_data = load_data[31:16];
	    	else
	    	    halfword_data = load_data[15:0];
	    	end
	end

	assign	halfword_extend[31] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[30] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[29] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[28] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[27] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[26] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[25] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[24] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[23] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[22] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[21] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[20] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[19] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[18] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[17] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[16] = (cs_sign==1'b1) ? halfword_data[15] : 1'b0 ;
	assign	halfword_extend[15:0] = halfword_data[15:0] ;


        //-------------------------------------------------------------
        // LWL
        //-------------------------------------------------------------
	always@(big_endian or addr or load_data)
	begin
	
	    if(big_endian==1'b1) //Big-Endian
	    	begin
	    	case(addr)
	    	    2'b00: lwl_data = load_data[31:0];
	    	    2'b01: lwl_data = {load_data[23:0],8'b0};
	    	    2'b10: lwl_data = {load_data[15:0],16'b0};
	    	    2'b11: lwl_data = {load_data[7:0],24'b0};
	    	endcase
	    	end
	    else
	    	begin	// Littel-Endian
	    	case(addr)
	    	    2'b00: lwl_data = {load_data[7:0],24'b0};
	    	    2'b01: lwl_data = {load_data[15:0],16'b0};
	    	    2'b10: lwl_data = {load_data[23:0],8'b0};
	    	    2'b11: lwl_data = load_data[31:0];
	    	endcase	    	
	    	end
	end

	
        //-------------------------------------------------------------
        // LWR
        //-------------------------------------------------------------
	always@(big_endian or addr or load_data)
	begin
	
	    if(big_endian==1'b1) //Big-Endian
	    	begin
	    	case(addr)
	    	    2'b00: lwr_data = {24'b0,load_data[31:24]};
	    	    2'b01: lwr_data = {16'b0,load_data[31:16]};
	    	    2'b10: lwr_data = {8'b0,load_data[31:8]};
	    	    2'b11: lwr_data = load_data[31:0];
	    	endcase
	    	end
	    else
	    	begin	// Littel-Endian
	    	case(addr)
	    	    2'b00: lwr_data = load_data[31:0];
	    	    2'b01: lwr_data = {8'b0,load_data[31:8]};
	    	    2'b10: lwr_data = {16'b0,load_data[31:16]};
	    	    2'b11: lwr_data = {24'b0,load_data[31:24]};
	    	endcase	    	
	    	end
	end


        //-------------------------------------------------------------
        // Write Mask
        //-------------------------------------------------------------

	//lwl_write_mask
	always@(big_endian or addr)
	begin
	    if(big_endian==1'b1) //Big-Endian
	    	begin
	    	case(addr)
	    	    2'b00: lwl_write_mask = 4'b0000 ;
	    	    2'b01: lwl_write_mask = 4'b0001 ;
	    	    2'b10: lwl_write_mask = 4'b0011 ;
	    	    2'b11: lwl_write_mask = 4'b0111 ;
	    	endcase
	    	end
	    else
	    	begin	// Littel-Endian
	    	case(addr)
	    	    2'b00: lwl_write_mask = 4'b0111 ;
	    	    2'b01: lwl_write_mask = 4'b0011 ;
	    	    2'b10: lwl_write_mask = 4'b0001 ;
	    	    2'b11: lwl_write_mask = 4'b0000 ;
	    	endcase	    	
	    	end
	end

	//lwr_write_mask
	always@(big_endian or addr)
	begin
	    if(big_endian==1'b1) //Big-Endian
	    	begin
	    	case(addr)
	    	    2'b00: lwr_write_mask = 4'b1110 ;
	    	    2'b01: lwr_write_mask = 4'b1100 ;
	    	    2'b10: lwr_write_mask = 4'b1000 ;
	    	    2'b11: lwr_write_mask = 4'b0000 ;
	    	endcase
	    	end
	    else
	    	begin	// Littel-Endian
	    	case(addr)
	    	    2'b00: lwr_write_mask = 4'b0000 ;
	    	    2'b01: lwr_write_mask = 4'b1000 ;
	    	    2'b10: lwr_write_mask = 4'b1100 ;
	    	    2'b11: lwr_write_mask = 4'b1110 ;
	    	endcase	    	
	    	end
	end
		
	
	//write_mask
	always@(align_op or lwl_write_mask or lwr_write_mask)
	begin
	    case(align_op)
	    	3'b010:	write_mask = lwl_write_mask ;
	    	3'b110:	write_mask = lwr_write_mask ;
	    	default: write_mask = 4'b0000 ;
	    endcase	
	end  
	
	
        //-------------------------------------------------------------
        // Output Select
        //-------------------------------------------------------------

	//LWL or LWR
	assign	temp = (align_op[2]==1'b1) ? lwr_data : lwl_data ;   

	
	//Output
	always@(align_op or byte_extend or halfword_extend or 
	        temp or load_data)
	begin
	    case(align_op[1:0])
	    	2'b00:	dout = byte_extend ;
	    	2'b01:	dout = halfword_extend ;
	    	2'b10:	dout = temp ;
	    	2'b11: 	dout = load_data ;
	    endcase	
	end  

	        
endmodule