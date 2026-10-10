# Five-Stage Pipelined RISC-V Processor in Verilog

## Overview

This project implements a five-stage pipelined RISC-V processor using Verilog HDL. It builds upon my earlier single-cycle RISC-V processor and progresses from a basic pipeline implementation to a design incorporating data forwarding, hazard detection, pipeline stalling, and control-hazard handling.

The processor follows a five-stage pipeline architecture:

1. **Instruction Fetch (IF)** – Fetches instructions from instruction memory.
2. **Instruction Decode (ID)** – Decodes instructions, reads registers, and generates control information.
3. **Execute (EX)** – Performs ALU operations, evaluates branch conditions, and calculates relevant addresses.
4. **Memory Access (MEM)** – Performs data-memory read and write operations.
5. **Write Back (WB)** – Writes the final result back to the register file.

The objective is to improve instruction throughput through pipelining while correctly handling dependencies and control-flow changes.

## Project Evolution

The processor was developed incrementally:

- **Stage 1 – Single-Cycle Processor:** Implemented the base RISC-V instruction set in a modular Verilog design.
- **Stage 2 – Basic Five-Stage Pipeline:** Distributed instruction execution across IF, ID, EX, MEM, and WB stages, with pipeline registers between stages.
- **Stage 3 – Hazard Handling:** Added forwarding logic, hazard detection, stalling, and branch/jump flush handling to support dependent instructions and control-flow changes.

The earlier single-cycle implementation is available here:

[Single-Cycle RISC-V Processor – GitHub](https://github.com/NikhilSingh1216/Single-Cycle-RISC-V-Processor)

## Supported Instructions

The processor implementation covers 37 RV32I instructions across eight categories.

### 1. R-Type Instructions — 10

| Instruction | Operation |
|---|---|
| ADD | Addition |
| SUB | Subtraction |
| SLL | Logical left shift |
| SLT | Set if signed less than |
| SLTU | Set if unsigned less than |
| XOR | Bitwise XOR |
| SRL | Logical right shift |
| SRA | Arithmetic right shift |
| OR | Bitwise OR |
| AND | Bitwise AND |

### 2. I-Type ALU Instructions — 6

| Instruction | Operation |
|---|---|
| ADDI | Add immediate |
| SLTI | Set if signed less than immediate |
| SLTIU | Set if unsigned less than immediate |
| XORI | XOR immediate |
| ORI | OR immediate |
| ANDI | AND immediate |

### 3. I-Type Shift Instructions — 3

| Instruction | Operation |
|---|---|
| SLLI | Logical left shift immediate |
| SRLI | Logical right shift immediate |
| SRAI | Arithmetic right shift immediate |

### 4. Load Instructions — 5

| Instruction | Operation |
|---|---|
| LB | Load byte, sign-extended |
| LH | Load halfword, sign-extended |
| LW | Load word |
| LBU | Load byte, zero-extended |
| LHU | Load halfword, zero-extended |

### 5. S-Type Store Instructions — 3

| Instruction | Operation |
|---|---|
| SB | Store byte |
| SH | Store halfword |
| SW | Store word |

### 6. B-Type Branch Instructions — 6

| Instruction | Operation |
|---|---|
| BEQ | Branch if equal |
| BNE | Branch if not equal |
| BLT | Branch if signed less than |
| BGE | Branch if signed greater than or equal |
| BLTU | Branch if unsigned less than |
| BGEU | Branch if unsigned greater than or equal |

### 7. J-Type Jump Instructions — 2

| Instruction | Operation |
|---|---|
| JAL | Jump and link |
| JALR | Jump and link register |

### 8. U-Type Instructions — 2

| Instruction | Operation |
|---|---|
| LUI | Load upper immediate |
| AUIPC | Add upper immediate to PC |

**Total: 37 instructions.**

## Pipeline Architecture

The design uses pipeline registers to carry instruction data and control signals between consecutive stages:

- `IF/ID`
- `ID/EX`
- `EX/MEM`
- `MEM/WB`

These registers allow different instructions to occupy different pipeline stages during the same clock cycle.

### Register File

The register file is accessed during instruction decode to read source operands and during write-back to update the destination register. The design must preserve correct register values when dependent instructions execute close together.

### Data Memory

The data-memory unit supports byte, halfword, and word stores, along with the implemented load operations. The combinational read logic assigns a default value to `data_out` to avoid unintended latch inference.

## Hazard Handling

### 1. Data Forwarding

A forwarding unit resolves supported data dependencies by selecting a more recent result from a later pipeline stage rather than always waiting for the register file to be updated.

This reduces unnecessary pipeline stalls for dependencies that can be resolved through forwarding.

### 2. Hazard Detection and Stalling

Hazard detection identifies dependencies that cannot be resolved immediately through forwarding. The pipeline can stall when required to preserve correct instruction execution, including load-use dependencies.

### 3. Branch and Jump Handling

Branch and jump instructions change the normal sequential flow of instruction fetching. The implementation includes branch/jump control and pipeline flush handling to prevent incorrectly fetched instructions from affecting architectural results when control flow changes.

## Verification and Simulation

The processor was developed and verified incrementally using Verilog simulation.

### Functional Verification

- The single-cycle implementation was verified for the supported instruction categories.
- The basic five-stage pipeline was tested with all 37 supported instructions.
- A dedicated test program was used to exercise forwarding, data hazards, branch/jump behavior, and pipeline flushing in the enhanced pipeline.
- The dedicated hazard-handling testbench reported **ALL TESTS PASSED** after the final reported data-memory correction.

The dedicated hazard test program was used to check specific pipeline behavior; it should not be interpreted as a single exhaustive test of all 37 instructions in the enhanced pipeline.

The testbench used for this verification is not included in this repository.

## FPGA Timing Analysis

Static timing analysis was performed using Intel Quartus Prime and a 15 ns clock constraint.

### Reported Timing Results

| Parameter | Result |
|---|---:|
| Target clock period | 15.000 ns |
| Target clock frequency | 66.67 MHz |
| Maximum operating frequency (Fmax) | 78.65 MHz |
| Worst setup slack | +2.286 ns |
| Worst hold slack | +0.348 ns |
| Critical-path data delay | 12.455 ns |
| Timing model | Slow, 1100 mV, 85°C |

### Clock Constraint

The clock was constrained using the following SDC command:

```tcl
create_clock -name clk -period 15.000 [get_ports {clk}]
```

### Critical-Path Analysis

The reported worst setup path was:

- **Start point:** `mem_wb_reg:mem_wb_inst|mem_wb_rd[0]`
- **End point:** `id_ex_reg:id_ex_inst|id_ex_alu_control[4]`
- **Data arrival time:** 16.501 ns
- **Data required time:** 18.787 ns
- **Setup slack:** +2.286 ns

The timing report shows logic involving the forwarding unit and branch-related comparison/control logic along the reported path.

The positive setup and hold slack values indicate that the reported worst paths meet their respective timing requirements under the selected timing model and applied constraints.

**Timing limitation:** The timing summary also reported missing output-delay constraints for many output ports. Consequently, these results describe the reported constrained paths and should not be treated as proof that all external input/output paths are fully constrained.

## Tools and Technologies

- Verilog HDL
- Questa Intel FPGA Edition / Questa simulation environment
- Intel Quartus Prime
- FPGA static timing analysis
- SDC clock constraints

## Future Improvements

- Improve critical-path delay through logic optimization.
- Add complete input and output timing constraints.
- Compare area, maximum frequency, and timing slack against the single-cycle implementation.
- Expand automated regression testing for instruction combinations and pipeline hazards.
- Evaluate additional performance optimizations while maintaining functional correctness.

## Author

Nikhil Singh
