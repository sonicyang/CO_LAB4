`include "timescale.v"
// synopsys translate_on


module interrupt_controller(irq,rst_n,clk,if_pc,mem_pc,intctl_epc,intctl_status,intctl_cause,iack,id2intctl_status);			input [5:0]	irq;
			input 	rst_n;
			input 	clk;
			input 	if_pc;
			input	mem_pc;
			input	[31:0] id2intctl_status;
			
			output 	[31:0] intctl_epc;
			output 	[31:0] intctl_cause;
			output 	[31:0] intctl_status;
			output  iack;
			
			reg   	[31:0]	intctl_epc;
			reg   	[31:0]	intctl_cause;
			reg		[31:0]	intctl_status;

			wire    [31:0]	if_pc;
			wire    [31:0]	mem_pc;
			reg				iack;
			
		
		always@(negedge clk or negedge rst_n)
        begin	
			if(~rst_n)
					begin
					iack<=1'b0;
					intctl_epc <= 32'd0;		
					intctl_status<=	32'd0;				
					intctl_cause <= 32'd0;
					end
			else if( ((irq[5]&id2intctl_status[15])|(irq[4]&id2intctl_status[14])|(irq[3]&id2intctl_status[13])
					|(irq[2]&id2intctl_status[12])|(irq[1]&id2intctl_status[11])|(irq[0]&id2intctl_status[10])) & id2intctl_status[0] )
					begin
					intctl_epc <= mem_pc ;		
					intctl_status<=	{id2intctl_status[31:1],1'b0};				//disable interrupt
					intctl_cause <= {16'b0,irq,10'b0};
					iack <= 1'b1;
					end
			else   
					begin
						if(if_pc == 32'h00001000)
							begin
							iack <= 1'b0;
							end
						else  intctl_epc <= intctl_epc;
					end
		end
endmodule