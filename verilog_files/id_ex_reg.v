module id_ex_reg(
	input clk,
	input reset,
	input flush,
	input stall,
	input [31:0] id_src1,
	input [31:0] id_src2,
	input [4:0] id_rd,
	input [31:0] id_immediate,
	input [5:0] id_alu_control,
	input [31:0] id_pc,
	input id_reg_write,
	input id_mem_write, 
	input id_mem_read,
	input id_alu_src_imm,
	input id_branch_flag,
	input [2:0] id_branch_type,
	input id_jal_flag,
	input id_jalr_flag,
	input [1:0] id_u_flag,
	input [31:0] id_instruction_code,
	output reg [31:0] id_ex_src1,
	output reg [31:0] id_ex_src2,
	output reg [4:0] id_ex_rd,
	output reg [31:0] id_ex_immediate,
	output reg [5:0] id_ex_alu_control,
	output reg [31:0] id_ex_pc,
	output reg id_ex_reg_write,
	output reg id_ex_mem_write,
	output reg id_ex_mem_read,
	output reg id_ex_alu_src_imm,
	output reg id_ex_branch_flag,
	output reg [2:0] id_ex_branch_type,
	output reg id_ex_jal_flag,
	output reg id_ex_jalr_flag,
	output reg [1:0] id_ex_u_flag,
	output reg [31:0] id_ex_instruction_code
	);
	
	always @(posedge clk) begin
		if(reset || flush || stall) begin
			id_ex_src1 <= 32'b0;
			id_ex_src2 <= 32'b0;
			id_ex_immediate <= 32'b0;
			id_ex_alu_control <= 6'b0;
			id_ex_pc <= 32'b0;
			id_ex_mem_write <= 1'b0;
			id_ex_mem_read <= 1'b0;
			id_ex_alu_src_imm <= 1'b0;
			id_ex_branch_flag <= 1'b0;
			id_ex_branch_type <= 3'b0;
			id_ex_jal_flag <= 1'b0;
			id_ex_jalr_flag <= 1'b0;
			id_ex_u_flag <= 2'b0;
			id_ex_reg_write <= 1'b0;
			id_ex_rd <= 5'b0;
			id_ex_instruction_code <= 32'b0;
		end
		else begin
			id_ex_src1 <= id_src1;
			id_ex_src2 <= id_src2;
			id_ex_immediate <= id_immediate;
			id_ex_alu_control <= id_alu_control;
			id_ex_pc <= id_pc;
			id_ex_mem_write <= id_mem_write;
			id_ex_mem_read <= id_mem_read;
			id_ex_alu_src_imm <= id_alu_src_imm;
			id_ex_branch_flag <= id_branch_flag;
			id_ex_branch_type <= id_branch_type;
			id_ex_jal_flag <= id_jal_flag;
			id_ex_jalr_flag <= id_jalr_flag;
			id_ex_u_flag <= id_u_flag;
			id_ex_reg_write <= id_reg_write;
			id_ex_rd <= id_rd;
			id_ex_instruction_code <= id_instruction_code;
		end
	end

endmodule	
	
	
	