`timescale 1ns/1ps

// 1-bit approximate LOA/LOR slice reconstructed from the supplied DSCH
// LOR1bit schematic.
//
// Internal structure:
//   b_pre   = B_set ? 1 : B
//   fB      = B_inv ? ~b_pre : b_pre
//   fA      = A_inv ? ~A : A
//   xor_ab  = fA ^ fB
//   nand_ab = ~(fA & fB)
//   nor_ab  = ~(fA | fB)
//
// The schematic's mux network gives:
//   S1S0 = 00 -> NOR
//   S1S0 = 01 -> XOR
//   S1S0 = 10 -> NAND
//   S1S0 = 11 -> NOR
//
// Result = O_inv ? ~selected : selected
//
// For the LOA ADD lower-bit mode the top-level controller uses:
//   A_inv=1, B_inv=1, S1=0, S0=0, O_inv=1
// giving A | B.
//
// For the LOA SUB lower-bit mode:
//   A_inv=0, B_inv=1, S1=0, S0=0, O_inv=1
// giving A | ~B.
//
// Cin is present only for interface compatibility. The approximate lower
// slice intentionally does not use ripple carry locally.

module LOA_1bit (
    input  logic A,
    input  logic B,
    input  logic Cin,
    input  logic A_inv,
    input  logic B_inv,
    input  logic B_set,
    input  logic S1,
    input  logic S0,
    input  logic O_inv,
    output logic Result,
    output logic Cout
);

    logic b_pre, fA, fB;
    logic xor_ab, nand_ab, nor_ab;
    logic selected;

    assign b_pre   = B_set ? 1'b1 : B;
    assign fB      = B_inv ? ~b_pre : b_pre;
    assign fA      = A_inv ? ~A : A;

    assign xor_ab  = fA ^ fB;
    assign nand_ab = ~(fA & fB);
    assign nor_ab  = ~(fA | fB);

    // Same mux arrangement as the supplied LOR1bit schematic.
    always_comb begin
        case ({S1, S0})
            2'b00: selected = nor_ab;
            2'b01: selected = xor_ab;
            2'b10: selected = nand_ab;
            2'b11: selected = nor_ab;
            default: selected = 1'b0;
        endcase
    end

    assign Result = O_inv ? ~selected : selected;

    // No local ripple carry in the approximate LSB slice.
    assign Cout = 1'b0;

    // Keep Cin in the module interface; it is intentionally unused.
    logic unused_cin;
    assign unused_cin = Cin;

endmodule
