`timescale 1ns/1ps

// ============================================================================
// LOA 1-BIT APPROXIMATE ALU SLICE
// ============================================================================
// This module models the 1-bit approximate slice (LOR1bit) shown in the
// supplied LOA schematic.
//
// For the ADD opcode used in the project:
//     A_inv = 1
//     B_inv = 1
//     B_set = 0
//     S1    = 0
//     S0    = 0
//     O_inv = 0
//
// Therefore:
//     A_eff = ~A
//     B_eff = ~B
//
// The NAND branch becomes:
//     ~(A_eff & B_eff) = ~(~A & ~B) = A | B
//
// Hence the approximate ADD result is:
//     Result = A | B
//
// Cin is retained in the interface so this slice can use the same control
// interface as the accurate 1-bit ALU. The approximate slice does not use Cin
// for its local result and does not generate a ripple Cout.
// ============================================================================

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

    logic A_eff;
    logic B_eff;

    logic xor_ab;
    logic nand_ab;
    logic nor_ab;
    logic selected;

    // ------------------------------------------------------------------------
    // Operand conditioning
    // ------------------------------------------------------------------------
    assign A_eff = A ^ A_inv;
    assign B_eff = B_set ? 1'b1 : (B ^ B_inv);

    // ------------------------------------------------------------------------
    // Logic generation
    // ------------------------------------------------------------------------
    assign xor_ab  = A_eff ^ B_eff;
    assign nand_ab = ~(A_eff & B_eff);
    assign nor_ab  = ~(A_eff | B_eff);

    // ------------------------------------------------------------------------
    // Approximate ALU selection
    //
    // The important LOA approximation is in the arithmetic state S1S0 = 00:
    // the carry-dependent full-adder sum is replaced by the NAND branch.
    //
    // With ADD controls, this gives:
    //     Result = A | B
    //
    // The remaining operation selections retain the ALU's existing control
    // convention:
    //     01 -> XOR
    //     10 -> NAND
    //     11 -> NOR
    // ------------------------------------------------------------------------
    always_comb begin
        case ({S1, S0})
            2'b00: selected = nand_ab;  // approximate arithmetic path
            2'b01: selected = xor_ab;
            2'b10: selected = nand_ab;
            2'b11: selected = nor_ab;
            default: selected = 1'b0;
        endcase
    end

    // ------------------------------------------------------------------------
    // Output inversion
    // ------------------------------------------------------------------------
    assign Result = selected ^ O_inv;

    // ------------------------------------------------------------------------
    // LOA lower slice: no local carry propagation
    // ------------------------------------------------------------------------
    assign Cout = 1'b0;

    // Cin is intentionally present for interface compatibility but is not
    // used in the approximate lower-bit computation.
    logic unused_cin;
    assign unused_cin = Cin;

endmodule
