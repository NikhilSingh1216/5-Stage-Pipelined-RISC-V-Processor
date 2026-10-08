module control_unit(
	input reset,
	input [6:0] opcode,
	input [2:0] func3,
	input [6:0] func7,
	input [11:0] imm_value,
	output reg [5:0] alu_control,
	output reg reg_write,
	output reg alu_src_imm,
	output reg mem_read,
	output reg branch_flag,
	output reg mem_write,
	output reg jal_flag,
	output reg jalr_flag,
	output reg [1:0] u_flag,
	output reg [2:0]branch_type);
	
	
	always @(*) begin
	
		// Default control values prevent unintended operations
      // for unsupported or invalid instructions.
	
		alu_control = 6'b000000;
		reg_write = 1'b0;
		mem_read = 1'b0;
		alu_src_imm = 1'b0;
		branch_flag = 1'b0;
		branch_type = 3'b000;
		mem_write = 1'b0;
		jal_flag=1'b0;
		jalr_flag = 1'b0;
		u_flag = 2'b0;
		
		if(reset) begin
			alu_control = 6'b000000;
			reg_write = 1'b0;
			mem_read = 1'b0;
			alu_src_imm = 1'b0;
			branch_flag = 1'b0;
			branch_type = 3'b000;
			mem_write=1'b0;
			jal_flag = 1'b0;
			jalr_flag = 1'b0;
			u_flag = 2'b0;
			
		end	
			
			
		//R-type instructions	
		else if(opcode==7'b0110011) begin
			reg_write = 1'b1;
			case(func3) 
				3'b000: begin 
					if(func7==7'b0000000)
						alu_control = 6'b000000; //ADD
					else if(func7==7'b0100000)
						alu_control= 6'b000001;  //SUB
				end
				
				3'b001: alu_control = 6'b000010; //SLL
				
				3'b010: alu_control = 6'b000011; //SLT
				
				3'b011 : alu_control = 6'b000100; //SLTU
				
				3'b100 : alu_control = 6'b000101; //XOR
				
				3'b101: begin
                if (func7 == 7'b0000000)
                    alu_control = 6'b000110; // SRL
                else if (func7 == 7'b0100000)
                    alu_control = 6'b000111; // SRA
            end

            3'b110: alu_control = 6'b001000; // OR

            3'b111: alu_control = 6'b001001; // AND
				
			endcase
		end	
		
		//I-type alu and shift instructions
		else if(opcode==7'b0010011) begin
				reg_write=1'b1;
				alu_src_imm = 1'b1;
				case(func3)
					3'b000: alu_control = 6'b001010; //ADDI
					
					3'b010 : alu_control = 6'b001011; //SLTI
					
					3'b011 : alu_control = 6'b001100; //SLTIU
					
					3'b100 : alu_control = 6'b001101; //XORI
					
					3'b110 : alu_control = 6'b001110; //ORI
					
					3'b111 : alu_control = 6'b001111; //ANDI	
					
					3'b001 : alu_control = 6'b010000; //SLLI
					
					3'b101 : begin
						if(imm_value[11:5] == 7'b0000000)
							alu_control = 6'b010001;
						else if(imm_value[11:5] == 7'b0100000)
							alu_control = 6'b010010;
					end
				endcase
		end		
		
				
		//I-type load Instructions		
		else if(opcode==7'b0000011) begin
			reg_write=1'b1;
			alu_src_imm = 1'b1;
			mem_read=1'b1;
			case(func3) 
				
				3'b000 : alu_control = 6'b010011; //LB
				
				3'b001 : alu_control = 6'b010100; //LH
				
				3'b010 : alu_control = 6'b010101; //LW
				
				3'b100 : alu_control = 6'b010110; //LBU
				
				3'b101 : alu_control = 6'b010111; //LHU
			
			endcase	
		end
			
		else if(opcode==7'b1100011) begin
			branch_flag = 1'b1;
			case(func3)
				
				3'b000 : branch_type = 3'b000; //BEQ
				3'b001 : branch_type = 3'b001; //BNE
				3'b100 : branch_type = 3'b100; //BLT
				3'b101 : branch_type = 3'b101; //BGE
				3'b110 : branch_type = 3'b110; //BLTU
				3'b111 : branch_type = 3'b111; //BGEU
				
						
			endcase
		end	
		
		else if(opcode==7'b0100011) begin
			mem_write = 1'b1;
			alu_src_imm = 1'b1;
			case(func3) 
			
				3'b000 : alu_control = 6'b011000; // SB
				3'b001 : alu_control = 6'b011001; // SH
				3'b010 : alu_control = 6'b011010; // SW	
			endcase	
		end
		
		else if(opcode==7'b1101111) begin
			jal_flag=1'b1;
			reg_write=1'b1;
			alu_control = 6'b011011; //JAL
		end
			
		else if(opcode==7'b1100111) begin
			jalr_flag=1'b1;
			reg_write=1'b1;
			alu_src_imm = 1'b1;
			case(func3)
				3'b000: alu_control = 6'b011100; //JALR
			endcase
		end	
		
		else if(opcode==7'b0110111) begin
			u_flag[0] = 1'b1;  //LUI
			reg_write = 1'b1;
		end
		else if(opcode==7'b0010111) begin
			u_flag[1] = 1'b1;  //AUIPC
			reg_write = 1'b1;
		end
		
	end  
endmodule