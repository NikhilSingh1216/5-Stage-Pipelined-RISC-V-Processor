module alu(
	input [31:0] input1,
	input [31:0] src2,
	input [31:0] immediate,
	input alu_src_imm,
	input mem_write,
	input [5:0] alu_control,
	output reg [31:0] result);
	
	wire [31:0] input2;
	assign input2 = (alu_src_imm || mem_write)? immediate :src2;
	always @(*) begin
		case(alu_control) 
		
			//R-type instructions	
			
			6'b000000 : result = input1 + input2; //ADD
			
			6'b000001 : result = input1-input2; //SUB
			
			6'b000010 : result = input1 << input2; //SLL
			
			6'b000011 : result = ($signed(input1)< $signed(input2))?32'd1:32'd0; //SLT
			
			6'b000100 : result = (input1<input2)?32'd1:32'd0;    //SLTU
			
			6'b000101 : result = input1 ^ input2; // XOR
			 
			6'b000110 : result = input1>>input2; //SRL
			
			6'b000111 : result = $signed(input1) >>> input2;   //SRA
			
			6'b001000 : result = input1 | input2; //OR
			
			6'b001001 : result = input1 & input2;  //AND
			
			// I-type ALU instructions

         6'b001010: result = input1 + input2; // ADDI

         6'b001011: result = ($signed(input1) < $signed(input2)) ? 32'd1 : 32'd0; // SLTI

         6'b001100: result = (input1 < input2) ? 32'd1 : 32'd0; // SLTIU

         6'b001101: result = input1 ^ input2; // XORI

         6'b001110: result = input1 | input2; // ORI

         6'b001111: result = input1 & input2; // ANDI


         // I-type shift instructions

         6'b010000: result = input1 << input2[4:0]; // Logical Left Shift

         6'b010001: result = input1 >> input2[4:0]; // Logical Right Shift

         6'b010010: result = $signed(input1) >>> input2[4:0]; // Arithmetic Right Shift


         // I-type load instructions

         6'b010011: result = input1 + input2; // LB

         6'b010100: result = input1 + input2; // LH

         6'b010101: result = input1 + input2; // LW

         6'b010110: result = input1 + input2; // LBU

         6'b010111: result = input1 + input2; // LHU
			
			//S-type Instrucions
			
			6'b011000 : result = input1 + input2; //SB
			
			6'b011001 : result = input1 + input2; //SH
			
			6'b011010 : result = input1 + input2; //SW

			
			default : result = 32'd0;
			
		endcase
	end
endmodule	