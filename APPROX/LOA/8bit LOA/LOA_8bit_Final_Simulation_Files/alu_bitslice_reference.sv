// 1-bit ALU slice - matches the ACTUAL DSCH hardware (not a "corrected" model):
// carry/borrow uses the original NAND/NOR gates directly, no AND/OR swap.
// Correctness comes entirely from the opcode-to-control-signal table, verified
// exhaustively for all 9 operations before this file was written.
//
// HALF_ADDER=1 (bit 0): sum path is a single XOR, no Cin term (xor1 only).
// HALF_ADDER=0 (bits 1-3): standard two-stage XOR chain (xor1, then ^Cin).
// Both variants keep the same NAND/NOR + mux carry-out structure.

module alu_bitslice #(
    parameter bit HALF_ADDER = 1'b0
) (
    input  logic A,
    input  logic B,
    input  logic Cin,       // carry-in (bits 1-3) or seeded Cin/Bin (bit 0)
    input  logic A_inv,
    input  logic B_inv,
    input  logic O_inv,
    input  logic Bset,      // forces B to constant 1 (enables NOT via A^1)
    input  logic S1,
    input  logic S0,
    output logic out3,      // ALU bit result
    output logic cout,      // carry-out (ADD) / borrow-out (SUB), same wire
    output logic xor1_tap   // exposed for the top-level equality comparator
);

    logic b_pre, fA, fB, xor1, sum_bit, nand_ab, nor_ab, out1;

    assign b_pre = Bset ? 1'b1 : B;
    assign fA    = A_inv ? ~A     : A;
    assign fB    = B_inv ? ~b_pre : b_pre;

    assign xor1    = fA ^ fB;
    assign sum_bit = HALF_ADDER ? xor1 : (xor1 ^ Cin);   // no Cin term for bit 0
    assign nand_ab = ~(fA & fB);
    assign nor_ab  = ~(fA | fB);

    // 4:1 select: S1S0 = 00->sum  01->xor1  10->nand_ab  11->nor_ab
    assign out1 = S1 ? (S0 ? nor_ab : nand_ab)
                     : (S0 ? xor1   : sum_bit);

    assign out3 = O_inv ? ~out1 : out1;

    // Carry/borrow-out: ORIGINAL NAND/NOR gates, no gate-type fix.
    // Correctness relies on the opcode's A_inv/B_inv/Cin-seed combination,
    // not on the gate choice here matching a textbook majority function.
    assign cout = Cin ? nand_ab : nor_ab;

    assign xor1_tap = xor1;

endmodule