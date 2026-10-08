module if_id_reg(
	input clk,reset,flush,
	input stall,
	input [31:0] if_pc,
	input [31:0] if_instruction_code,
	output reg [31:0] if_id_pc,
	output reg [31:0] if_id_instruction_code
	);
	
	
	always @(posedge clk) begin
		
		if(reset || flush) begin
			if_id_pc <= 32'b0;
			if_id_instruction_code <= 32'b0;
		end	
		
		else if(stall) begin
			if_id_pc <= if_id_pc;
			if_id_instruction_code <= if_id_instruction_code;
		end	
		else begin
			if_id_pc <= if_pc;
			if_id_instruction_code <= if_instruction_code;
		end
			
	end
		
endmodule		
	
	