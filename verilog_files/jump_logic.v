module jump_logic(
	input [31:0] immediate,
	input [31:0] src1,
	input jal_flag,
	input jalr_flag,
	output reg jump_taken
	);
	
	always @(*) begin
		jump_taken = 1'b0; 
		
		if(jal_flag || jalr_flag)
			jump_taken = 1'b1; 
	end	
endmodule	