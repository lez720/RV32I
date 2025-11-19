# Instruction Set Architecture (ISA)
RV32I is the base integer instruction set architecture for the 32-bit variant of the RISC-V ISA. It is the foundation for the RISC-V architecture, providing the minimal set of instructions required to build a processor capable of supporting modern operating systems.

This particular RV32I design was implemented with a 5-stage pipelined process:
`Fetch > Decode > Execute > Memory > Write Back`

## Block Diagram
![](images/block_diagram.png)

green - control signals

blue - data

## Instruction Types

|  Type  |  Operation |
|--------|------------|
| R-Type | Arithmetic/logical operations that use only registers            |
| I-Type | Arithmetic/logical operations with an immmediate(constant) value            |
| S-Type | Store instructions, writing data from a register to memory            |
| B-Type | Conditional branch instructions            |
| U-Type | For lui(load upper immediate)            |
| J-Type | For unconditional jumps           |

# RTL Design & Synthesis
Sky130 pdk library were used for the synthesis of this project

## Used Tools (EDA/IDEs)
- Neovim (RTL Design)
- ModelSim (Functional Verification)
- Yosys (Synthesis)
- OpenSTA (Timing Analysis)
- Git (Version Control)
