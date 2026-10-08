module Pipelined_top_module_tb;
	
	 reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instruction_code;
    wire [5:0] alu_control;
    wire [31:0] alu_result;
	 
	 Pipelined_top_module top_module_inst(
		.clk(clk),
		.reset(reset),
		.pc(pc),
		.instruction_code(instruction_code),
		.alu_control(alu_control),
		.alu_result(alu_result)
		);
	 
	 initial begin
		clk=0;
		forever #10 clk = ~clk;
	end

	initial begin
		reset = 1;
		
		#20 reset = 0;
		
	end
endmodule