module instruction_fetch_unit(
	input clk,reset,
	input stall,
	input branch_taken,
	input jal_flag,
	input jalr_flag,
	input [31:0]branch_target,
	input [31:0]jump_target,
	output reg [31:0] pc);
	
	always @(posedge clk) begin
		if(reset==1)
			pc <= 0;
			
		else if(stall)
			pc <=pc;

		else if(branch_taken)
			pc <= branch_target;
		
		else if(jal_flag || jalr_flag)
			pc <= jump_target;
		else
			pc <= pc+4;
			
	end
			
	
endmodule