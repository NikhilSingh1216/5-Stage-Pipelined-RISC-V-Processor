module branch_unit(
	input [31:0] src1,
	input [31:0] src2,
	input [31:0] branch_imm_value,
	input branch_flag,
	input [2:0] branch_type,
	output reg branch_taken
	);
	
	
	always @(*) begin
		branch_taken = 1'b0;
		if(branch_flag) begin
			case(branch_type) 
				3'b000 : branch_taken = (src1==src2);
				3'b001 : branch_taken = (src1 != src2);
				3'b100 : branch_taken = (($signed(src1)) < ($signed(src2)));
				3'b101 : branch_taken = (($signed(src1)) >= ($signed(src2)));
				3'b110 : branch_taken = (src1 < src2);
				3'b111 : branch_taken = (src1 >= src2);
			endcase
		end
	end
endmodule	