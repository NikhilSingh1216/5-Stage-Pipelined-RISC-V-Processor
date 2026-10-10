module register_file(
	input clk,
	input reset,
	input [4:0] read_reg1,
	input [4:0] read_reg2,
	input [4:0] write_reg,
	input [31:0] write_data,
	input reg_write,
	output [31:0] read_data1,
	output [31:0] read_data2);
	
	reg [31:0] register[0:31];
	
	integer i;
	
	always @(posedge clk) begin
		if(reset==1) begin
		
			register[0] <= 32'd0;
			
			for(i=1;i<32;i=i+1) begin
				register[i] <= i; // Initialize registers with known values for simulation.
			end
		end
		
		else if(reg_write==1 && write_reg != 5'd0) begin // Prevent writes to x0 because RISC-V register x0 must remain zero.
			register[write_reg] <= write_data;  // Register write occurs on the rising clock edge.
		end	
		
	end
		
	// Register reads are combinational.	
	    // Combinational reads with write-through bypass.
    // If a register is being written this cycle and is
    // also being read, return the new write data directly.

    assign read_data1 =
        (read_reg1 == 5'd0) ? 32'd0 :
        (reg_write && (write_reg != 5'd0) &&
         (write_reg == read_reg1)) ? write_data :
        register[read_reg1];

    assign read_data2 =
        (read_reg2 == 5'd0) ? 32'd0 :
        (reg_write && (write_reg != 5'd0) &&
         (write_reg == read_reg2)) ? write_data :
        register[read_reg2];
	
endmodule	