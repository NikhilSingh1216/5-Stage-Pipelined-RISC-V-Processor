# 5-Stage Pipelined RISC-V Processor

A five-stage pipelined RISC-V processor implemented in Verilog HDL, designed to demonstrate instruction pipelining, datapath design, hazard detection, data forwarding, and control-flow handling.

The processor uses a modular architecture with separate instruction and data memories, pipeline registers, an ALU, a register file, and dedicated control logic.

## Architecture

The processor follows the classic five-stage pipeline architecture:

**Instruction Fetch (IF) → Instruction Decode (ID) → Execute (EX) → Memory Access (MEM) → Write Back (WB)**

| Stage | Description |
|---|---|
| **IF — Instruction Fetch** | Fetches instructions from instruction memory and manages the program counter. |
| **ID — Instruction Decode** | Decodes instructions, reads register operands, generates immediate values, and produces control signals. |
| **EX — Execute** | Performs arithmetic and logical operations, evaluates branches, calculates jump targets, and selects forwarded operands. |
| **MEM — Memory Access** | Performs data-memory reads and writes for load and store instructions. |
| **WB — Write Back** | Writes ALU results or loaded data back to the register file. |

### Pipeline Registers

Four pipeline registers separate the five stages:

- **IF/ID:** Stores the fetched instruction and associated information.
- **ID/EX:** Stores decoded operands, immediate values, register indices, and control signals.
- **EX/MEM:** Stores execution results, memory controls, and destination-register information.
- **MEM/WB:** Stores results and control information for register write-back.

## Features

- Five-stage pipelined RISC-V processor
- Modular and synthesizable Verilog RTL design
- Separate instruction and data memories
- Arithmetic Logic Unit (ALU)
- Register file and immediate generator
- Control unit and branch decision logic
- Four inter-stage pipeline registers
- Data forwarding from later pipeline stages
- Load-use hazard detection and pipeline stalling
- Conditional branch handling
- JAL and JALR jump support
- Pipeline flushing for branch and jump redirects
- Functional simulation using Questa Intel FPGA Edition
- FPGA synthesis and static timing analysis using Intel Quartus Prime

## Supported Instructions

The implemented instruction set exercised by the verification program includes:

| Format | Instructions |
|---|---|
| **R-Type** | ADD, SUB, AND, OR, XOR, SLL |
| **I-Type** | ADDI, LW, JALR |
| **S-Type** | SW |
| **B-Type** | BEQ |
| **J-Type** | JAL |

The processor includes the corresponding instruction decode, control-signal generation, and immediate-generation logic required by these instruction formats.

This list describes the instructions exercised by the current verification program; it does not claim complete RV32I compatibility.

## Hazard Handling

### Data Forwarding

The forwarding unit detects dependencies between instructions in different pipeline stages and selects the most recent available operand from later stages when possible.

Forwarding paths use results from the EX/MEM and MEM/WB stages to resolve common read-after-write (RAW) dependencies and reduce unnecessary stalls.

### Load-Use Hazard Detection

A load instruction produces its data after the memory-access stage. When a following instruction depends on that result, the hazard detection unit inserts the required stall so the dependent instruction receives the correct operand.

### Branch Handling

The branch unit evaluates conditional branch instructions using the relevant operands and comparison logic.

The processor handles taken and not-taken branches and flushes instructions fetched along an incorrect control-flow path when a redirect occurs.

### Jump Handling

- **JAL:** Performs a PC-relative jump and saves the return address.
- **JALR:** Performs a register-indirect jump and saves the return address.

Pipeline flushing prevents incorrectly fetched instructions from affecting architectural state after control-flow changes.

## Project Structure

```text
5-Stage-Pipelined-RISC-V-Processor/
│
├── Pipelined_top_module.v
├── alu.v
├── branch_unit.v
├── control_unit.v
├── data_memory.v
├── ex_mem_reg.v
├── forwarding_unit.v
├── hazard_detection.v
├── id_ex_reg.v
├── if_id_reg.v
├── immediate_generator.v
├── instruction_fetch_unit.v
├── instruction_memory_unit.v
├── mem_wb_reg.v
├── register_file.v
├── write_back.v
│
├── Pipelined_risc_v.qpf
├── Pipelined_risc_v.qsf
├── Pipelined_risc_v.sdc
│
└── README.md
```

*This structure lists the processor RTL and Quartus project files. Adjust the listing to match the files actually committed to the repository.*

## Simulation and Verification

The processor was functionally verified in Questa Intel FPGA Edition using a Verilog testbench.

The verification program covered the following scenarios:

- Arithmetic and logical instruction execution
- Register write-back and zero-register behavior
- Data forwarding between dependent instructions
- Load and store operations
- Load-use hazard handling
- Taken and not-taken conditional branches
- JAL and JALR jump behavior
- Pipeline flushing following control-flow changes

**Result:** All test cases in the verification testbench passed after the register-file forwarding and data-memory latch issues were addressed.

The testbench used for verification is not included in this repository.

## FPGA Implementation and Timing Analysis

The design was compiled and analyzed using Intel Quartus Prime. Static timing analysis was performed using the reported slow timing model at 1100 mV and 85°C.

### Timing Results

| Parameter | Result |
|---|---:|
| Clock period constraint | 15 ns |
| Constrained clock frequency | 66.67 MHz |
| Maximum operating frequency (Fmax) | 78.65 MHz |
| Worst-case setup slack | +2.286 ns |
| Worst-case hold slack | +0.348 ns |
| Inferred latches reported by `check_timing` | 0 |
| No-clock findings reported by `check_timing` | 0 |

The constrained clock frequency is calculated from the specified clock period:

\[
f_{\text{clock}}=\frac{1}{T_{\text{clock}}}
=\frac{1}{15\text{ ns}}
\approx66.67\text{ MHz}
\]

The reported Fmax of 78.65 MHz exceeds the constrained clock frequency. The positive setup and hold slack values indicate that the analyzed paths meet the corresponding timing requirements under the current constraints.

### Timing Constraints

The project uses the following SDC clock constraint:

```tcl
create_clock -name clk -period 15.000 [get_ports {clk}]
```

This defines a 15 ns clock period for the top-level `clk` input.

**Timing-analysis note:** The latest timing checks report zero inferred latches and zero no-clock findings. However, external input/output delay constraints remain incomplete. The reported Fmax and slack values therefore describe the paths analyzed under the current constraints and should not be interpreted as proof that every external interface path is fully constrained.

## Critical Path Analysis

The detailed timing report identifies forwarding and branch-comparison logic among the elements on a reported critical setup path.

These paths are useful areas to investigate for potential timing optimization because they can contribute to the combinational delay between pipeline registers.

Further optimization should be guided by the latest detailed timing reports and performed without compromising functional correctness.

## Future Improvements

- Expand instruction coverage and work toward broader RV32I support.
- Add automated regression tests for additional data and control hazards.
- Verify memory addressing and boundary conditions.
- Investigate forwarding and branch-comparison paths for timing optimization.
- Improve timing constraints for the external input/output interfaces.
- Compare single-cycle and pipelined implementations using consistent FPGA settings.
- Evaluate FPGA resource utilization, power, and performance.
- Perform additional hardware validation on a compatible FPGA board.

## Author

**Nikhil Singh**

Developed as a processor-design project to explore RISC-V architecture, pipelining, datapath implementation, hazard detection, data forwarding, and FPGA timing analysis.
