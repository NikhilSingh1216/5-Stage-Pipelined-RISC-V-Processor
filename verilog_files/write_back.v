module write_back(
	input mem_read,
	input [31:0] data_memory_out,
	input jal_flag,
	input jalr_flag,
	input [31:0] pc,
	input [1:0] u_flag,
	input [31:0] immediate,
	input [31:0] alu_result,
	output reg [31:0] reg_file_write_data
	);

	always @(*) begin
		reg_file_write_data = 32'b0;
		if(mem_read)
			reg_file_write_data = data_memory_out; //LOAD
		else if(jal_flag || jalr_flag)
			reg_file_write_data = pc + 4; //JAL or JALR
		
		else if(u_flag[0] || u_flag[1]) begin //U-type
		
			if(u_flag[0])
				reg_file_write_data = immediate;
			else if(u_flag[1])
				reg_file_write_data = immediate + pc;
		end
			
		else
			reg_file_write_data = alu_result; // R-type
	end	
	
endmodule	