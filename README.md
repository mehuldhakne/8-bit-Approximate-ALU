# 8-bit Approximate ALU Using LOA, ETA-I, ETA-II and ARCA

## 1. Project Overview

This project focuses on the design, implementation, and comparative analysis of an **8-bit Approximate Arithmetic Logic Unit (ALU)** using different approximate arithmetic architectures.

The project explores the concept of approximate computing, where certain computational operations are performed with controlled errors to potentially reduce hardware complexity, propagation delay, and power consumption.

Four approximate adder architectures are implemented and organized in this repository:

- Lower-part OR Adder (LOA)
- Error-Tolerant Adder-I (ETA-I / LXA)
- Error-Tolerant Adder-II (ETA-II)
- Approximate Reverse Carry Adder (ARCA)

An accurate ALU implementation is also included as a reference for comparison with the approximate designs.

The designs are developed using Verilog/SystemVerilog HDL and targeted towards FPGA implementation using the **Xilinx Basys 3 development board based on the Artix-7 FPGA**.

---

## 2. Project Objectives

- Design and implement an 8-bit accurate ALU as a reference architecture.
- Implement four different approximate adder architectures.
- Integrate approximate arithmetic architectures into ALU designs.
- Perform functional verification using Verilog/SystemVerilog testbenches.
- Generate FPGA bitstreams using AMD Xilinx Vivado.
- Analyze synthesis and implementation reports.
- Compare accurate and approximate architectures based on hardware resources, timing, and arithmetic accuracy.

---

## 3. Repository Structure

The repository is divided into two major sections:

- `ACCURATE/` – Accurate ALU implementation and reference results.
- `APPROX/` – Approximate ALU implementations using four different architectures.

```text
8-bit-Approximate-ALU/
│
├── ACCURATE/
│   │
│   ├── 8 bit/
│   │
│   ├── acc_alu_test/
│   │
│   ├── bit stream file/
│   │
│   ├── reports_Accurate_ALU/
│   │
│   ├── acc_alu_test.zip
│   │
│   └── tb_alu_bitslice_accurate.sv
│
├── APPROX/
│   │
│   ├── ARCA/
│   │   │
│   │   ├── ARCA_Basys3_Hardware_Files/
│   │   │
│   │   ├── DESIGNS AND WAVEFORMS/
│   │   │
│   │   ├── bit stream file/
│   │   │
│   │   ├── reports_ARCA/
│   │   │
│   │   └── Additional ARCA design files
│   │
│   ├── ETA - I, LXA/
│   │
│   ├── ETA - II/
│   │
│   └── LOA/
│
└── README.md
```

*Note: The tree illustrates the visible repository organization. Each architecture folder contains its respective implementation files, hardware files, simulation files, waveforms, bitstreams, or reports as applicable.*

---

## 4. Implemented Architectures

### 4.1 Accurate ALU

The accurate ALU serves as the reference implementation for evaluating the approximate architectures.

It provides conventional arithmetic functionality and allows comparison of arithmetic correctness and hardware implementation characteristics.

**Repository location:** `ACCURATE/`

### 4.2 Lower-part OR Adder (LOA)

LOA is an approximate addition architecture that simplifies lower-order bit addition using OR logic rather than conventional carry propagation.

This technique reduces carry-chain complexity in the approximate portion of the circuit, potentially improving hardware efficiency at the expense of arithmetic accuracy.

**Repository location:** `APPROX/LOA/`

### 4.3 Error-Tolerant Adder-I (ETA-I / LXA)

ETA-I is an error-tolerant approximate arithmetic architecture designed to simplify carry computation and reduce hardware complexity.

It is evaluated to understand the trade-off between arithmetic accuracy and hardware implementation efficiency.

**Repository location:** `APPROX/ETA - I, LXA/`

### 4.4 Error-Tolerant Adder-II (ETA-II)

ETA-II represents another approximate arithmetic architecture with a different approach to carry computation and error management.

It is included to compare its arithmetic behavior and hardware characteristics against the other implementations.

**Repository location:** `APPROX/ETA - II/`

### 4.5 Approximate Reverse Carry Adder (ARCA)

ARCA is an approximate arithmetic architecture that uses an alternative carry computation strategy.

Its implementation is evaluated to investigate the effects of approximate carry generation on hardware resource utilization, timing, and arithmetic accuracy.

**Repository location:** `APPROX/ARCA/`

---

## 5. Hardware and Software Requirements

### Hardware

| Component | Specification |
|---|---|
| FPGA Development Board | Digilent Basys 3 |
| FPGA Family | Xilinx Artix-7 |
| FPGA Device | XC7A35T |
| Operand Width | 8 bits |

### Software

- AMD Xilinx Vivado Design Suite
- Verilog HDL
- SystemVerilog
- Vivado Simulator
- FPGA synthesis and implementation tools

---

## 6. Design and Implementation Methodology

The project follows the following development workflow:

1. **RTL Design:** Develop accurate and approximate ALU architectures using Verilog/SystemVerilog.
2. **Functional Simulation:** Verify arithmetic operations through simulation and testbenches.
3. **Synthesis:** Convert RTL designs into FPGA hardware resources using Vivado.
4. **Implementation:** Perform placement and routing for the target Artix-7 FPGA.
5. **Bitstream Generation:** Generate configuration bitstreams for the Basys 3 board.
6. **Performance Analysis:** Collect resource utilization and timing reports.
7. **Comparative Evaluation:** Compare the four approximate architectures against the accurate reference design.

---

## 7. Performance Evaluation Parameters

The following parameters are relevant for comparing the architectures:

| Parameter | Description |
|---|---|
| LUT Utilization | FPGA Look-Up Table usage |
| Flip-Flops | Sequential resource utilization |
| Delay | Critical path propagation delay |
| Power | Estimated or measured power consumption |
| Area | Hardware resource utilization |
| MAE | Mean Absolute Error |
| MED | Maximum Error Distance |
| NMED | Normalized Mean Error Distance |

Actual experimental values should be taken from the corresponding Vivado reports and simulation results.

---

## 8. Applications

Approximate arithmetic architectures can be useful in error-tolerant applications, including:

- Image and video processing
- Digital Signal Processing (DSP)
- Machine Learning hardware
- Multimedia computing
- Low-power embedded systems
- Approximate computing systems

---

## 9. Future Scope

- Extend the architecture to 16-bit and 32-bit ALUs.
- Explore additional approximate adder architectures.
- Optimize power, performance, and area.
- Integrate approximate arithmetic units into a RISC-V processor datapath.
- Evaluate application-level computational errors.
- Investigate hybrid accurate and approximate arithmetic architectures.

---

## 10. Tools and Technologies

- Verilog HDL
- SystemVerilog
- AMD Xilinx Vivado
- Xilinx Artix-7 FPGA
- Digilent Basys 3

---

## 11. Project Status

**Project:** 8-bit Approximate ALU

**Architectures:** Accurate ALU, LOA, ETA-I (LXA), ETA-II, and ARCA.

**Target Platform:** Xilinx Basys 3 FPGA.

**Implementation:** RTL design, simulation, synthesis, and FPGA implementation files are organized in their respective directories.

---

## 12. Author

**Mehul**

Engineering Major Project

---

## 13. Acknowledgement

This project is developed as part of an engineering major project to study approximate computing and its application in digital hardware design.

The project aims to understand the trade-offs between computational accuracy and hardware efficiency through the implementation and evaluation of multiple approximate arithmetic architectures.

---

## License

Refer to the repository's LICENSE file for licensing and usage permissions.
