module instruction_memory_unit(
	input clock,reset,
	input [31:0] pc,
	output [31:0] instruction_code);
	
	reg [31:0] instruction_memory[0:108];
	
	assign instruction_code = instruction_memory[pc >> 2];
	
	always@(posedge clock) begin
		if(reset==1) begin
			instruction_memory[0]  <= 32'h00A00093; // 0x00: ADDI x1,  x0, 10
			instruction_memory[1]  <= 32'h01400113; // 0x04: ADDI x2,  x0, 20
			instruction_memory[2]  <= 32'h002081B3; // 0x08: ADD  x3,  x1, x2
			instruction_memory[3]  <= 32'h40118233; // 0x0C: SUB  x4,  x3, x1
			instruction_memory[4]  <= 32'h0021F2B3; // 0x10: AND  x5,  x3, x2
			instruction_memory[5]  <= 32'h0050E333; // 0x14: OR   x6,  x5, x1
			instruction_memory[6]  <= 32'h005343B3; // 0x18: XOR  x7,  x6, x5

			instruction_memory[7]  <= 32'h00200493; // 0x1C: ADDI x9,  x0, 2
			instruction_memory[8]  <= 32'h00909433; // 0x20: SLL  x8,  x1, x9

			instruction_memory[9]  <= 32'h00302023; // 0x24: SW   x3,  0(x0)
			instruction_memory[10] <= 32'h00002503; // 0x28: LW   x10, 0(x0)

			instruction_memory[11] <= 32'h001505B3; // 0x2C: ADD  x11, x10, x1
			instruction_memory[12] <= 32'h00558613; // 0x30: ADDI x12, x11, 5

			// ---------------- BRANCH TEST ----------------

			instruction_memory[13] <= 32'h00208463; // 0x34: BEQ  x1, x2, +8
																	 // NOT TAKEN

			instruction_memory[14] <= 32'h06F00693; // 0x38: ADDI x13, x0, 111
			instruction_memory[15] <= 32'h0DE00713; // 0x3C: ADDI x14, x0, 222

			instruction_memory[16] <= 32'h00C60663; // 0x40: BEQ  x12, x12, +12
																	 // TAKEN -> 0x4C
																	 // Instructions at 0x44, 0x48
																	 // must be flushed

			instruction_memory[17] <= 32'h3E700793; // 0x44: ADDI x15, x0, 999
																	 // SHOULD BE FLUSHED

			instruction_memory[18] <= 32'h3E700813; // 0x48: ADDI x16, x0, 999
																	 // SHOULD BE FLUSHED

			instruction_memory[19] <= 32'h04D00893; // 0x4C: ADDI x17, x0, 77
																	 // BRANCH TARGET

			// ---------------- JAL TEST ----------------

			instruction_memory[20] <= 32'h00C0096F; // 0x50: JAL  x18, +12
																	 // TARGET = 0x5C
																	 // x18 = return address 0x54

			instruction_memory[21] <= 32'h22B00993; // 0x54: ADDI x19, x0, 555
																	 // SHOULD BE FLUSHED

			instruction_memory[22] <= 32'h29A00A13; // 0x58: ADDI x20, x0, 666
																	 // SHOULD BE FLUSHED

			// JAL TARGET
			instruction_memory[23] <= 32'h06800A93; // 0x5C: ADDI x21, x0, 104
																	 // x21 = 0x68

			// ---------------- JALR TEST ----------------

			instruction_memory[24] <= 32'h000A8B67; // 0x60: JALR x22, 0(x21)
																	 // TARGET = x21 = 0x68
																	 // x22 = return address 0x64

			instruction_memory[25] <= 32'h30900B93; // 0x64: ADDI x23, x0, 777
																	 // SHOULD BE FLUSHED

			// JALR TARGET
			instruction_memory[26] <= 32'h05800C13; // 0x68: ADDI x24, x0, 88
			
		end
	end
	
endmodule	

