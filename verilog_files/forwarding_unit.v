module forwarding_unit(
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,

    input [4:0] ex_mem_rd,
    input ex_mem_reg_write,
	 input ex_mem_mem_read,
    input [4:0] mem_wb_rd,
    input mem_wb_reg_write,

    input [31:0] ex_mem_alu_result,
    input [31:0] wb_write_data,

    input [31:0] id_ex_src1,
    input [31:0] id_ex_src2,

    output reg [31:0] forwarding_src1,
    output reg [31:0] forwarding_src2
);

    always @(*) begin
        // Default: use values read from the register file
        forwarding_src1 = id_ex_src1;
        forwarding_src2 = id_ex_src2;

        // Forward operand 1
        // EX/MEM has priority over MEM/WB
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) && (!ex_mem_mem_read) &&
            (ex_mem_rd == id_ex_rs1)) begin

            forwarding_src1 = ex_mem_alu_result;

        end
        else if (mem_wb_reg_write &&
                 (mem_wb_rd != 5'd0) &&
                 (mem_wb_rd == id_ex_rs1)) begin

            forwarding_src1 = wb_write_data;
        end

        // Forward operand 2
        // EX/MEM has priority over MEM/WB
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) && (!ex_mem_mem_read) &&
            (ex_mem_rd == id_ex_rs2)) begin

            forwarding_src2 = ex_mem_alu_result;

        end
        else if (mem_wb_reg_write &&
                 (mem_wb_rd != 5'd0) && 
                 (mem_wb_rd == id_ex_rs2)) begin

            forwarding_src2 = wb_write_data;
        end
    end

endmodule
