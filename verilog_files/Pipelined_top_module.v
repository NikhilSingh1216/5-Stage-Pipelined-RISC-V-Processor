module Pipelined_top_module(
    input clk,
    input reset,
    output [31:0] pc,
    output [31:0] instruction_code,
    output [5:0] alu_control,
    output [31:0] alu_result
);

	 // ============================================================
    // IF STAGE
    // ============================================================
	 wire [31:0] if_pc;
	 wire id_ex_jal_flag;
    wire id_ex_jalr_flag;
	 wire [31:0] ex_branch_target;
	 wire [31:0] ex_jump_target;
	 wire ex_branch_taken;
	 wire flush;
	 wire stall;
	 
    instruction_fetch_unit instruction_fetch_inst(
        .clk(clk),
        .reset(reset),
		  .stall(stall),
        .branch_taken(ex_branch_taken),
        .jal_flag(id_ex_jal_flag),
        .jalr_flag(id_ex_jalr_flag),
        .branch_target(ex_branch_target),
        .jump_target(ex_jump_target),
        .pc(if_pc)
    );


    // ============================================================
    // INSTRUCTION MEMORY
    // ============================================================
	wire [31:0] if_instruction_code;
	
    instruction_memory_unit instruction_memory_inst(
        .clock(clk),
        .reset(reset),

        .pc(if_pc),

        .instruction_code(if_instruction_code)
    );


    // ============================================================
    // IF/ID PIPELINE REGISTER
    //
    // Flush on a taken branch/jump.
    // ============================================================
	wire [31:0] if_id_pc;
	wire [31:0] if_id_instruction_code;
	
    if_id_reg if_id_inst(
        .clk(clk),

        .reset(reset),
		  .flush(flush),
		  .stall(stall),
        .if_pc(if_pc),
        .if_instruction_code(if_instruction_code),

        .if_id_pc(if_id_pc),
        .if_id_instruction_code(if_id_instruction_code)
    );
	 
	 
	 // ============================================================
    // CONTROL UNIT
    // ============================================================
		
	 wire [5:0] id_alu_control;
    wire id_reg_write;
    wire id_alu_src_imm;
    wire id_mem_read;
    wire id_branch_flag;
    wire id_mem_write;
    wire id_jal_flag;
    wire id_jalr_flag;
    wire [1:0] id_u_flag;
    wire [2:0] id_branch_type;


	  control_unit control_unit_inst(
        .reset(reset),
        .opcode(if_id_instruction_code[6:0]),
        .func3(if_id_instruction_code[14:12]),
        .func7(if_id_instruction_code[31:25]),
        .imm_value(if_id_instruction_code[31:20]),

        .alu_control(id_alu_control),
        .reg_write(id_reg_write),
        .alu_src_imm(id_alu_src_imm),
        .mem_read(id_mem_read),
        .branch_flag(id_branch_flag),
        .mem_write(id_mem_write),
        .jal_flag(id_jal_flag),
        .jalr_flag(id_jalr_flag),
        .u_flag(id_u_flag),
        .branch_type(id_branch_type)
    );
		
		

    // ============================================================
    // IMMEDIATE GENERATOR
    // ============================================================
	 
	 // Immediate
    wire [31:0] id_immediate;
	 
    immediate_generator immediate_generator_inst(
        .instruction_code(if_id_instruction_code),
        .immediate(id_immediate)
    );


    // ============================================================
    // REGISTER FILE
    // ============================================================

	  // Register file outputs
    wire [31:0] id_src1;
    wire [31:0] id_src2;
	 wire [31:0] wb_write_data;
	 wire [4:0] mem_wb_rd;
	 wire mem_wb_reg_write;
	 
    register_file register_file_inst(
        .clk(clk),
        .reset(reset),

        .read_reg1(if_id_instruction_code[19:15]),
        .read_reg2(if_id_instruction_code[24:20]),

        .write_reg(mem_wb_rd),
        .write_data(wb_write_data),
        .reg_write(mem_wb_reg_write),

        .read_data1(id_src1),
        .read_data2(id_src2)
    );
	 
	 wire [4:0] rd;
	 assign rd  = if_id_instruction_code[11:7];
	 
	 // ============================================================
    // ID/EX PIPELINE REGISTER
    // ============================================================
	 
	 wire [31:0] id_ex_src1;
    wire [31:0] id_ex_src2;
    wire [4:0]  id_ex_rd;
    wire [31:0] id_ex_immediate;
    wire [5:0]  id_ex_alu_control;
    wire [31:0] id_ex_pc;
	 wire [31:0] id_ex_instruction_code;

    wire id_ex_reg_write;
    wire id_ex_mem_write;
    wire id_ex_mem_read;
    wire id_ex_alu_src_imm;

    wire id_ex_branch_flag;
    wire [2:0] id_ex_branch_type;

   
    wire [1:0] id_ex_u_flag;
	 
	 
	 
	 id_ex_reg id_ex_inst(
        .clk(clk),
        .reset(reset),
		  .flush(flush),
		  .stall(stall),
        .id_src1(id_src1),
        .id_src2(id_src2),
        .id_rd(rd),
        .id_immediate(id_immediate),
        .id_alu_control(id_alu_control),
        .id_pc(if_id_pc),
        .id_reg_write(id_reg_write),
        .id_mem_write(id_mem_write),
        .id_mem_read(id_mem_read),
        .id_alu_src_imm(id_alu_src_imm),
        .id_branch_flag(id_branch_flag),
        .id_branch_type(id_branch_type),
        .id_jal_flag(id_jal_flag),
        .id_jalr_flag(id_jalr_flag),
        .id_u_flag(id_u_flag),
		  .id_instruction_code(if_id_instruction_code),

        .id_ex_src1(id_ex_src1),
        .id_ex_src2(id_ex_src2),
        .id_ex_rd(id_ex_rd),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_alu_control(id_ex_alu_control),
        .id_ex_pc(id_ex_pc),
        .id_ex_reg_write(id_ex_reg_write),
        .id_ex_mem_write(id_ex_mem_write),
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_alu_src_imm(id_ex_alu_src_imm),
        .id_ex_branch_flag(id_ex_branch_flag),
        .id_ex_branch_type(id_ex_branch_type),
        .id_ex_jal_flag(id_ex_jal_flag),
        .id_ex_jalr_flag(id_ex_jalr_flag),
        .id_ex_u_flag(id_ex_u_flag),
		  .id_ex_instruction_code(id_ex_instruction_code)
    );
	 
	 

	 // ============================================================
    // EX STAGE - ALU
    // ============================================================
	 
	 wire [31:0] ex_alu_result;
	 
	 wire [31:0] forwarding_src1;
	 wire [31:0] forwarding_src2;
	 
	 alu alu_inst(
        .input1(forwarding_src1),
        .src2(forwarding_src2),
        .immediate(id_ex_immediate),
        .alu_src_imm(id_ex_alu_src_imm),
        .mem_write(id_ex_mem_write),
        .alu_control(id_ex_alu_control),
        .result(ex_alu_result)
    );
	 
	 
	 
	 
	 branch_unit branch_unit_inst(
        .src1(forwarding_src1),
        .src2(forwarding_src2),
        .branch_imm_value(id_ex_immediate),
        .branch_flag(id_ex_branch_flag),
        .branch_type(id_ex_branch_type),
        .branch_taken(ex_branch_taken)
    );
	 
	 
	 
	 
	 
	 assign ex_branch_target = (ex_branch_taken)?(id_ex_pc + id_ex_immediate):0;
	 
	 wire jump_taken;
	 
	 assign jump_taken = (id_ex_jal_flag | id_ex_jalr_flag);
	 
	 assign flush = (ex_branch_taken | jump_taken);
	 
	 wire [31:0] jal_target;
	 wire [31:0] jalr_target;
	 

	 assign jal_target  = id_ex_pc + id_ex_immediate;
	 assign jalr_target = (forwarding_src1 + id_ex_immediate) & 32'hFFFFFFFE;

	 assign ex_jump_target = (id_ex_jalr_flag) ? jalr_target:jal_target;
	 
	  // ============================================================
    // EX/MEM REG
    // ============================================================

    wire [31:0] ex_mem_alu_result;
    wire ex_mem_mem_read;
    wire ex_mem_mem_write;
    wire [31:0] ex_mem_write_data;
    wire [5:0] ex_mem_alu_control;
    wire [31:0] ex_mem_immediate;
    wire [31:0] ex_mem_pc;

    wire ex_mem_jal_flag;
    wire ex_mem_jalr_flag;
    wire [1:0] ex_mem_u_flag;
    wire ex_mem_reg_write;
    wire [4:0] ex_mem_rd;


    ex_mem_reg ex_mem_inst(
        .clk(clk),
        .reset(reset),

        .ex_mem_read(id_ex_mem_read),
        .ex_alu_result(ex_alu_result),
        .ex_mem_write(id_ex_mem_write),
        .ex_write_data(forwarding_src2),
        .ex_alu_control(id_ex_alu_control),
        .ex_immediate(id_ex_immediate),
        .ex_pc(id_ex_pc),
        .ex_jal_flag(id_ex_jal_flag),
        .ex_jalr_flag(id_ex_jalr_flag),
        .ex_u_flag(id_ex_u_flag),
        .ex_reg_write(id_ex_reg_write),
        .ex_rd(id_ex_rd),

        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_mem_read(ex_mem_mem_read),
        .ex_mem_mem_write(ex_mem_mem_write),
        .ex_mem_write_data(ex_mem_write_data),
        .ex_mem_alu_control(ex_mem_alu_control),
        .ex_mem_immediate(ex_mem_immediate),
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_jal_flag(ex_mem_jal_flag),
        .ex_mem_jalr_flag(ex_mem_jalr_flag),
        .ex_mem_u_flag(ex_mem_u_flag),
        .ex_mem_reg_write(ex_mem_reg_write),
        .ex_mem_rd(ex_mem_rd)
    );
	 
	 
	 // ============================================================
    // MEMORY STAGE
    // ============================================================

    wire [31:0] mem_data_out;


    data_memory data_mem_inst(
        .clk(clk),
        .reset(reset),

        .read_addr(ex_mem_alu_result[7:0]),
        .write_addr(ex_mem_alu_result[7:0]),

        .mem_read(ex_mem_mem_read),
        .mem_write(ex_mem_mem_write),

        .write_data(ex_mem_write_data),
        .alu_control(ex_mem_alu_control),

        .data_out(mem_data_out)
    );


    // ============================================================
    // MEM/WB
    // ============================================================

    wire [31:0] mem_wb_pc;
    wire [31:0] mem_wb_immediate;

    wire mem_wb_mem_read;
    wire mem_wb_jal_flag;
    wire mem_wb_jalr_flag;

    wire [31:0] mem_wb_data_out;
    wire [31:0] mem_wb_alu_result;
    wire [1:0]  mem_wb_u_flag;


    mem_wb_reg mem_wb_inst(
        .clk(clk),
        .reset(reset),

        .mem_rd(ex_mem_rd),

        .mem_immediate(ex_mem_immediate),
        .mem_pc(ex_mem_pc),

        .mem_reg_write(ex_mem_reg_write),
        .mem_mem_read(ex_mem_mem_read),

        .mem_jal_flag(ex_mem_jal_flag),
        .mem_jalr_flag(ex_mem_jalr_flag),

        .mem_u_flag(ex_mem_u_flag),

        .mem_data_out(mem_data_out),
        .mem_alu_result(ex_mem_alu_result),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_pc(mem_wb_pc),
        .mem_wb_immediate(mem_wb_immediate),

        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_mem_read(mem_wb_mem_read),

        .mem_wb_data_out(mem_wb_data_out),

        .mem_wb_jal_flag(mem_wb_jal_flag),
        .mem_wb_jalr_flag(mem_wb_jalr_flag),

        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_u_flag(mem_wb_u_flag)
    );

	// ============================================================
    // WRITE BACK
    // ============================================================

	
    write_back write_back_inst(
        .mem_read(mem_wb_mem_read),

        .data_memory_out(mem_wb_data_out),

        .jal_flag(mem_wb_jal_flag),
        .jalr_flag(mem_wb_jalr_flag),

        .pc(mem_wb_pc),

        .u_flag(mem_wb_u_flag),

        .immediate(mem_wb_immediate),

        .alu_result(mem_wb_alu_result),

        .reg_file_write_data(wb_write_data)
    );
	 
	 
	 forwarding_unit forwarding_inst(
		.id_ex_rs1(id_ex_instruction_code[19:15]),
		.id_ex_rs2(id_ex_instruction_code[24:20]),
		.ex_mem_rd(ex_mem_rd),
		.ex_mem_reg_write(ex_mem_reg_write),
		.mem_wb_rd(mem_wb_rd),
		.mem_wb_reg_write(mem_wb_reg_write),
		.ex_mem_alu_result(ex_mem_alu_result),
		.wb_write_data(wb_write_data),
		.id_ex_src1(id_ex_src1),
		.id_ex_src2(id_ex_src2),
		.forwarding_src1(forwarding_src1),
		.forwarding_src2(forwarding_src2)
		
		);
			
			
	hazard_detection hazard_inst(
		.if_id_instruction_code(if_id_instruction_code),
		.id_ex_rd(id_ex_rd),
		.id_ex_mem_read(id_ex_mem_read),
		.id_ex_reg_write(id_ex_reg_write),
		.stall(stall)
		);
		
	 
	 
	 assign pc = if_pc;
	 assign instruction_code = if_instruction_code;
	 assign alu_control = id_alu_control;
	 assign alu_result = ex_alu_result;
	 
	 
endmodule    
