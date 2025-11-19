# RV32I
RV32I is the base integer instruction set architecture (ISA) for the 32-bit variant of the RISC-V ISA. It is the foundation for the RISC-V architecture, providing the minimal set of instructions required to build a processor capable of supporting modern operating systems.

## 5-Stage Pipeline Process
`Fetch > Decode > Execute > Memory > Write Back`



## Block Diagram
![](images/block_diagram.png)


## Instruction Types

|  Type  |  Operation |
|--------|------------|
| R-Type | Arithmetic/logical operations that use only registers            |
| I-Type | Arithmetic/logical operations with an immmediate(constant) value            |
| S-Type | Store instructions, writing data from a register to memory            |
| B-Type | Conditional branch instructions            |
| U-Type | For lui(load upper immediate)            |
| J-Type | For unconditional jumps           |

## Used Tools (EDA/IDEs)
- Neovim (RTL Design)
- ModelSim (Functional Verification)
- Yosys (Synthesis)
- OpenSTA (Timing Analysis)
- Git (Version Control)
