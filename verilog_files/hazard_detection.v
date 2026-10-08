module hazard_detection(
	input [31:0] if_id_instruction_code,
	input [4:0] id_ex_rd,
	input id_ex_mem_read,
	input id_ex_reg_write,
	output reg stall
	);
	
	wire [4:0] if_id_rs1;
	wire [4:0] if_id_rs2;
	wire [6:0] opcode;
	
	assign opcode = if_id_instruction_code[6:0];
	
	assign if_id_rs1 = if_id_instruction_code[19:15];
	
	assign if_id_rs2 =
        ((opcode == 7'b0110011) ||   // R-type
         (opcode == 7'b0100011) ||   // Store
         (opcode == 7'b1100011))     // Branch
        ? if_id_instruction_code[24:20]
        : 5'b0;
	
	
	always @(*) begin
		stall = 1'b0;
		
		if((id_ex_mem_read) && (id_ex_reg_write) && (id_ex_rd != 5'b0) && (if_id_rs1 == id_ex_rd || if_id_rs2 == id_ex_rd)) 
			stall = 1'b1;
	end
	
endmodule	