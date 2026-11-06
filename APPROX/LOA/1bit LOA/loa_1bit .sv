`timescale 1ns/1ps

// ============================================================================
// 1-bit LOA ALU slice
//
// Based on the supplied DSCH LOR1bit schematic.
//
// Control mapping retained from the exact ALU project:
//   00 -> arithmetic path
//   01 -> XOR
//   10 -> NAND
//   11 -> NOR
//
// In the LOR1bit schematic, the 00 path selects NAND(A_eff,B_eff).
// For ADD controls (A_inv=B_inv=1), NAND(~A,~B) = A | B, which is the
// intentional lower-part approximation of the LOA.
//
// Cin is retained in the port list so that the exact ALU and LOA testbenches
// can use the same stimulus. The LOR1bit itself does not use Cin and does not
// propagate a carry.
// ============================================================================

module loa_1bit #(
    parameter bit ACCURATE = 1'b0
) (
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
    output logic Cout,
    output logic XorTap
);

    logic A_eff;
    logic B_eff;
    logic xor_ab;
    logic nand_ab;
    logic nor_ab;
    logic exact_sum;
    logic selected;

    // Effective operands: directly follows the LOR1bit / exact ALU structure.
    assign A_eff = A ^ A_inv;
    assign B_eff = B_set ? 1'b1 : (B ^ B_inv);

    assign xor_ab   = A_eff ^ B_eff;
    assign nand_ab  = ~(A_eff & B_eff);
    assign nor_ab   = ~(A_eff | B_eff);
    assign exact_sum = xor_ab ^ Cin;

    // LOR1bit schematic uses NAND for the S1S0=00 arithmetic path.
    // Accurate mode uses the exact full-adder sum for that path.
    always_comb begin
        if (ACCURATE) begin
            case ({S1, S0})
                2'b00: selected = exact_sum;
                2'b01: selected = xor_ab;
                2'b10: selected = nand_ab;
                2'b11: selected = nor_ab;
                default: selected = 1'b0;
            endcase
        end
        else begin
            case ({S1, S0})
                2'b00: selected = nand_ab;
                2'b01: selected = xor_ab;
                2'b10: selected = nand_ab;
                2'b11: selected = nor_ab;
                default: selected = 1'b0;
            endcase
        end
    end

    // Output inversion stage.
    assign Result = selected ^ O_inv;

    // Useful tap for the equality flag in the top-level ALU.
    assign XorTap = xor_ab;

    // Approximate lower slice has no carry propagation.
    // Accurate upper slice uses the conventional carry equation.
    assign Cout = ACCURATE
                ? ((A_eff & B_eff) | (Cin & xor_ab))
                : 1'b0;

    // Cin is intentionally ignored in approximate mode to match LOR1bit.

endmodule
