module mem_wb_reg(
	input clk,
	input reset,
	input [4:0] mem_rd,
	input [31:0] mem_immediate,
	input [31:0] mem_pc,
	input mem_reg_write,
	input mem_mem_read,
	input mem_jal_flag,
	input mem_jalr_flag,
	input [1:0] mem_u_flag,
	input [31:0] mem_data_out,
	input [31:0] mem_alu_result,
	output reg [4:0] mem_wb_rd,
	output reg [31:0] mem_wb_pc,
	output reg [31:0] mem_wb_immediate,
	output reg mem_wb_reg_write,
	output reg mem_wb_mem_read,
	output reg [31:0] mem_wb_data_out,
	output reg mem_wb_jal_flag,
	output reg mem_wb_jalr_flag,
	output reg [31:0] mem_wb_alu_result,
	output reg [1:0] mem_wb_u_flag
	);
	
	always @(posedge clk) begin
		if(reset==1'b1) begin
			mem_wb_rd <= 5'b0;
			mem_wb_pc <= 32'b0;
			mem_wb_immediate <= 32'b0;
			mem_wb_reg_write <= 1'b0;
			mem_wb_mem_read <= 1'b0;
			mem_wb_data_out <= 32'b0;
			mem_wb_jal_flag <= 1'b0;
			mem_wb_jalr_flag <= 1'b0;
			mem_wb_u_flag <= 2'b0;
			mem_wb_alu_result <= 32'b0;
		end
		else begin
			mem_wb_rd <= mem_rd;
			mem_wb_pc <= mem_pc;
			mem_wb_immediate <= mem_immediate;
			mem_wb_reg_write <= mem_reg_write;
			mem_wb_mem_read <= mem_mem_read;
			mem_wb_data_out <= mem_data_out;
			mem_wb_jal_flag <= mem_jal_flag;
			mem_wb_jalr_flag <= mem_jalr_flag;
			mem_wb_u_flag <= mem_u_flag;
			mem_wb_alu_result <= mem_alu_result;
			
		end
	end
endmodule
	