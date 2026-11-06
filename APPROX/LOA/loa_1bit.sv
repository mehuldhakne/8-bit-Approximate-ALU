`timescale 1ns/1ps

// ============================================================================
// 1-bit LOA/ALU slice
//
// APPROX = 1 : lower-part LOA slice (LOR1bit from the DSCH schematic)
//             - no Cin used for the arithmetic path
//             - arithmetic/00 path is NAND(A_eff,B_eff)
//             - with ADD controls (A_inv=B_inv=1), this becomes A|B
//
// APPROX = 0 : upper accurate ALU slice (1bitaluapprfile from the schematic)
//             - arithmetic/00 path uses Cin
//             - Cout is the exact carry of A_eff + B_eff + Cin
//
// The control signals intentionally match the existing exact ALU project.
// ============================================================================

module loa_1bit #(
    parameter bit APPROX = 1'b1
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
    logic selected;
    logic approx_arith;
    logic exact_arith;

    // ------------------------------------------------------------------------
    // Effective operands -- same control behavior as the original ALU.
    // B_set has priority over the normal/inverted B path.
    // ------------------------------------------------------------------------
    assign A_eff = A ^ A_inv;
    assign B_eff = B_set ? 1'b1 : (B ^ B_inv);

    // Primitive functions present in the DSCH slice.
    assign xor_ab  = A_eff ^ B_eff;
    assign nand_ab = ~(A_eff & B_eff);
    assign nor_ab  = ~(A_eff | B_eff);

    // Exact arithmetic result for the accurate upper part.
    assign exact_arith = xor_ab ^ Cin;

    // LOA lower-part arithmetic result:
    // the DSCH LOR1bit 00 path selects NAND, with no carry-in.
    assign approx_arith = nand_ab;

    // ------------------------------------------------------------------------
    // Operation selection.
    // For the approximate lower slice, the DSCH LOR1bit effectively has:
    //   S1S0 = 00 -> NAND   (used as LOA arithmetic path)
    //          01 -> XOR
    //          10 -> NAND
    //          11 -> NOR
    // For the accurate upper slice:
    //   00 -> SUM
    //   01 -> XOR
    //   10 -> NAND
    //   11 -> NOR
    // ------------------------------------------------------------------------
    always_comb begin
        if (APPROX) begin
            case ({S1, S0})
                2'b00: selected = approx_arith;
                2'b01: selected = xor_ab;
                2'b10: selected = nand_ab;
                2'b11: selected = nor_ab;
                default: selected = 1'b0;
            endcase
        end
        else begin
            case ({S1, S0})
                2'b00: selected = exact_arith;
                2'b01: selected = xor_ab;
                2'b10: selected = nand_ab;
                2'b11: selected = nor_ab;
                default: selected = 1'b0;
            endcase
        end
    end

    // Final inversion stage from the schematic.
    assign Result = selected ^ O_inv;

    // Expose the operand XOR used by the equality flag in the top level.
    assign XorTap = xor_ab;

    // Carry is meaningful for the accurate/upper part.  For the lower LOA
    // region there is deliberately no carry propagation.
    assign Cout = APPROX
                ? 1'b0
                : (A_eff & B_eff) | (Cin & xor_ab);

endmodule
