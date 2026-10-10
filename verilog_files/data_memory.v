module data_memory(
    input clk,
    input reset,
    input [7:0] read_addr,
	 input [7:0] write_addr,
	 input mem_read,
	 input mem_write,
	 input [31:0] write_data,
    input [5:0] alu_control,
    output reg [31:0] data_out
);

    reg [31:0] data_mem [0:255];

    integer i;

    always @(posedge clk) begin
		  
        if(reset) begin
            for(i = 0; i < 256; i = i + 1) begin
                data_mem[i] <= i;
            end
        end
		  else if(mem_write) begin // Store operations are synchronous and occur on the clock edge.
				case(alu_control) 
					6'b011000 : data_mem[write_addr][7:0] <= write_data[7:0];  // SB: Store least-significant byte
					6'b011001 : data_mem[write_addr][15:0] <= write_data[15:0]; // SH: Store least-significant half-word
					6'b011010 : data_mem[write_addr] <= write_data; // SW: Store complete 32-bit word
				endcase
			end	
				
    end
    
	 
	 // Load operations are combinational.
    always @(*) begin
			data_out = 32'd0;
			if(mem_read) begin 
		
				case(alu_control)

            // LB
					6'b010011:
						data_out = {{24{data_mem[read_addr][7]}},
                            data_mem[read_addr][7:0]};

            // LH
					6'b010100:
						data_out = {{16{data_mem[read_addr][15]}},
                            data_mem[read_addr][15:0]};

            // LW
					6'b010101:
						data_out = data_mem[read_addr];

            // LBU
					6'b010110:
						data_out = {24'd0,
                            data_mem[read_addr][7:0]};

            // LHU
					6'b010111:
						data_out = {16'd0,
                            data_mem[read_addr][15:0]};

					default:
						data_out = 32'd0;

				endcase
			end	

    end

endmodule