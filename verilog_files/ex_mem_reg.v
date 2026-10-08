module ex_mem_reg(
    input clk,
    input reset,
	 input ex_mem_read,
    input [31:0] ex_alu_result ,
	 input ex_mem_write,
	 input [31:0] ex_write_data,
    input [5:0] ex_alu_control,
	 input [31:0] ex_immediate,
	 input [31:0] ex_pc,
	 input ex_jal_flag,
	 input ex_jalr_flag,
	 input [1:0] ex_u_flag,
	 input ex_reg_write,
	 input [4:0]ex_rd,
	 output reg [31:0] ex_mem_alu_result,
	 output reg  ex_mem_mem_read,
	 output reg ex_mem_mem_write,
	 output reg [31:0] ex_mem_write_data,
	 output reg [5:0] ex_mem_alu_control,
	 output reg [31:0] ex_mem_immediate,
	 output reg [31:0] ex_mem_pc,
	 output reg ex_mem_jal_flag,
	 output reg ex_mem_jalr_flag,
	 output reg [1:0] ex_mem_u_flag,
	 output reg ex_mem_reg_write,
	 output reg [4:0] ex_mem_rd
	 );
	 
	 always @(posedge clk) begin
		if(reset) begin
			ex_mem_alu_result<= 32'b0;
			ex_mem_mem_write <= 1'b0;
			ex_mem_mem_read <=1'b0;
			ex_mem_write_data <= 32'b0;
			ex_mem_alu_control <= 6'b0;
			ex_mem_immediate <= 32'b0;
			ex_mem_pc <= 32'b0;
			ex_mem_jal_flag <= 1'b0;
			ex_mem_jalr_flag <= 1'b0;
			ex_mem_u_flag <= 2'b0;
			ex_mem_reg_write <= 1'b0;
			ex_mem_rd <= 5'b0;
		end
		else begin
			ex_mem_alu_result <= ex_alu_result;
			ex_mem_mem_write <= ex_mem_write;
			ex_mem_mem_read <= ex_mem_read;
			ex_mem_write_data <= ex_write_data;
			ex_mem_alu_control <= ex_alu_control;
			ex_mem_immediate <= ex_immediate;
			ex_mem_pc <= ex_pc;
			ex_mem_jal_flag <= ex_jal_flag;
			ex_mem_jalr_flag <= ex_jalr_flag;
			ex_mem_u_flag <= ex_u_flag;
			ex_mem_reg_write <= ex_reg_write;
			ex_mem_rd <= ex_rd;
		end
	end
endmodule	
		
		