module forwarding_unit(
	input [4:0] id_ex_rs1,
	input [4:0] id_ex_rs2,
	input [4:0] ex_mem_rd,
	input ex_mem_reg_write,
	input [4:0] mem_wb_rd,
	input mem_wb_reg_write,
	input [31:0] ex_mem_alu_result,
	input [31:0] wb_write_data,
	input [31:0] id_ex_src1,
	input [31:0] id_ex_src2,
	output reg [31:0] forwarding_src1,
	output reg [31:0] forwarding_src2
	);
	
	always @(*) begin
		if((ex_mem_reg_write) && (ex_mem_rd != 5'b0) && (id_ex_rs1 == ex_mem_rd))
			forwarding_src1 = ex_mem_alu_result;
		else if((mem_wb_reg_write) && (mem_wb_rd != 5'b0) && (id_ex_rs1 == mem_wb_rd))
			forwarding_src1 = wb_write_data;
		else 
			forwarding_src1 = id_ex_src1;
	end
	
	always @(*) begin
		if((ex_mem_reg_write) && (ex_mem_rd != 5'b0) && (id_ex_rs2 == ex_mem_rd))
			forwarding_src2 = ex_mem_alu_result;
		else if((mem_wb_reg_write) && (mem_wb_rd != 5'b0) && (id_ex_rs2 == mem_wb_rd))
			forwarding_src2 = wb_write_data;
		else 
			forwarding_src2 = id_ex_src2;
	end 

endmodule	
	