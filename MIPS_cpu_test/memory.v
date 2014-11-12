//=====================================================================
//  (C) Copyright Chen-Chieh Wang
//  All Right Reserved
//---------------------------------------------------------------------
//  Chen-Chieh (Jay) Wang
//  http://caslab.ee.ncku.edu.tw/~jay
//---------------------------------------------------------------------
//  Computer Architecture and System Laboratory (CASLab)
//  Institute of Computer and Communication Engineering
//  National Cheng Kung University, Tainan, Taiwan.
//  http://caslab.ee.ncku.edu.tw
//---------------------------------------------------------------------
//  2010/12/28 PM. 08:51:27
//=====================================================================

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module memory( clk,
               r_addr1,
               r_addr2,
               r_rden1,
               r_rden2,
               r_data1,
               r_data2,
               w_addr,
               w_wren,
               w_be,
               w_data
               );

        //-------------------------------------------------------------
        // Input/Output
        //-------------------------------------------------------------

        input           clk;
        input   [31:0]  r_addr1;
        input   [31:0]  r_addr2;
        input           r_rden1;
        input           r_rden2;
        output  [31:0]  r_data1;
        output  [31:0]  r_data2;
        input   [31:0]  w_addr;
        input           w_wren;
        input   [3:0]   w_be;
        input   [31:0]  w_data;

        //-------------------------------------------------------------
        // Define or Parameter
        //-------------------------------------------------------------
        parameter       MemoryName = "";        // Memory Name
        parameter       MemSize  = 32;          // Memory size in Kbytes

        //parameter     MemAddrWidth = 10;      // Memory size =  1 Kbytes
        //parameter     MemAddrWidth = 11;      // Memory size =  2 Kbytes
        //parameter     MemAddrWidth = 12;      // Memory size =  4 Kbytes
        //parameter     MemAddrWidth = 13;      // Memory size =  8 Kbytes
        //parameter     MemAddrWidth = 14;      // Memory size = 16 Kbytes
        parameter       MemAddrWidth = 15;      // Memory size = 32 Kbytes

        parameter       InitFileName = "";

        //-------------------------------------------------------------
        // Internal Wire
        //-------------------------------------------------------------
        reg     [31:0]  Mem [0:((MemSize * 256)-1)];    // Memory register array

        wire    [(MemAddrWidth-1):2]  MemAddr_R1;
        wire    [(MemAddrWidth-1):2]  MemAddr_R2;
        wire    [(MemAddrWidth-1):2]  MemAddr_W;

        reg     [31:0]  r_data1;
        reg     [31:0]  r_data2;
        reg     [31:0]  Data;
        integer         i;      // Loop counter used in memory initialisation

//=====================================================================
//      Main Body
//=====================================================================


        //-------------------------------------------------------------
        // initial memory
        //-------------------------------------------------------------
        initial
        begin

            for (i=0; i<=((MemSize * 256)-1); i = i+1)
                Mem[i] = 32'h0000_0000;

            if (InitFileName != "")
                begin
                $display("### Loading internal memory (%S)###", MemoryName);
                $readmemh(InitFileName, Mem);
                //$readmemb(FileName, Mem);
                end

        end


        //-------------------------------------------------------------
        // Read 1
        //-------------------------------------------------------------
        assign  MemAddr_R1 = {r_addr1[(MemAddrWidth-1):2]}; // Word address (not byte)

        always@(posedge clk)
        begin

                if(r_rden1)
                        r_data1 = Mem[MemAddr_R1];
                else  
                        r_data1 = 32'bz;
						
        end

        //-------------------------------------------------------------
        // Read 2
        //-------------------------------------------------------------
        assign  MemAddr_R2 = {r_addr2[(MemAddrWidth-1):2]}; // Word address (not byte)

        always@(posedge clk)
        begin

                if(r_rden2)
                        r_data2 = Mem[MemAddr_R2];
                else
                        r_data2 = 32'bz;

        end

        //-------------------------------------------------------------
        // Write
        //-------------------------------------------------------------
        assign  MemAddr_W = {w_addr[(MemAddrWidth-1):2]}; // Word address (not byte)


        always@(MemAddr_W or w_wren or w_data or w_be or clk)
        begin

                Data[31:24] = (w_be[3])
                                ? w_data[31:24]
                                : Mem[MemAddr_W][31:24];

                Data[23:16] = (w_be[2])
                                ? w_data[23:16]
                                : Mem[MemAddr_W][23:16];

                Data[15:8] = (w_be[1])
                                ? w_data[15:8]
                                : Mem[MemAddr_W][15:8];

                Data[7:0] = (w_be[0])
                                ? w_data[7:0]
                                : Mem[MemAddr_W][7:0];

                if(w_wren&clk)
                begin
                        Mem[MemAddr_W] = Data;
                end

        end

endmodule
