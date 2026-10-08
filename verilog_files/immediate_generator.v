module immediate_generator (
    input  [31:0] instruction_code,
    output reg [31:0] immediate
);

wire [6:0] opcode;

assign opcode = instruction_code[6:0];

always @(*) begin
	
    case (opcode)

        // I-type
        // ADDI, SLTI, SLTIU, XORI, ORI, ANDI
        // LW, JALR
        7'b0010011,
        7'b0000011,
        7'b1100111: begin

            immediate = {{20{instruction_code[31]}},
                         instruction_code[31:20]};

        end


        // S-type
        // SB, SH, SW
        7'b0100011: begin

            immediate = {{20{instruction_code[31]}},
                         instruction_code[31:25],
                         instruction_code[11:7]};

        end


        // B-type
        // BEQ, BNE, BLT, BGE, BLTU, BGEU
        7'b1100011: begin

            immediate = {{19{instruction_code[31]}},
                         instruction_code[31],
                         instruction_code[7],
                         instruction_code[30:25],
                         instruction_code[11:8],
                         1'b0};

        end


        // U-type
        // LUI, AUIPC
        7'b0110111,
        7'b0010111: begin

            immediate = {instruction_code[31:12],
                         12'b0};

        end


        // J-type
        // JAL
        7'b1101111: begin

            immediate = {{11{instruction_code[31]}},
                         instruction_code[31],
                         instruction_code[19:12],
                         instruction_code[20],
                         instruction_code[30:21],
                         1'b0};

        end


        default: begin

            immediate = 32'b0;

        end

    endcase

end

endmodule