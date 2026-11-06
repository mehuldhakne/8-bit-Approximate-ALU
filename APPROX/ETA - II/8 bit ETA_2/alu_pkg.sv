// Shared ALU opcode definition.
// Compile this package before alu_bitslice.sv, approxbitforeta2alu.sv,
// and eta2_alu_8bit.sv in the Vivado project.

package alu_pkg;

    typedef enum logic [3:0] {
        OP_ADD  = 4'b0000,
        OP_SUB  = 4'b0001,
        OP_NOT  = 4'b0010,
        OP_XOR  = 4'b0011,
        OP_XNOR = 4'b0100,
        OP_NAND = 4'b0101,
        OP_AND  = 4'b0110,
        OP_NOR  = 4'b0111,
        OP_OR   = 4'b1000
    } alu_op_e;

endpackage
