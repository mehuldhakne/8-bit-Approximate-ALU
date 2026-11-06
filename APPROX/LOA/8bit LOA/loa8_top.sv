`timescale 1ns/1ps

// ============================================================================
// 8-BIT LOA ALU
// ============================================================================
// Architecture requested for the project:
//
//   result[3:0] -> approximate LOA lower section
//   result[7:4] -> accurate upper section
//
// The same alu_bitslice module used by the accurate ALU is used unchanged for
// bits [7:4]. The approximate LSB section uses LOA_1bit.
//
// For arithmetic:
//   ADD lower bits : A | B
//   ADD boundary   : C4 = A3 & B3
//
//   SUB lower bits : A | ~B
//   SUB boundary   : C4 = ~A3 & B3
//
// The upper four bits then propagate that approximate carry/borrow through
// accurate 1-bit ALU slices.
// ============================================================================

import loa_opcode_pkg::*;

module loa8_top (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  alu_op_e    op,

    output logic [7:0] result,
    output logic       zero_flag,
    output logic       sign_flag,
    output logic       overflow_flag,
    output logic       carry_flag,
    output logic       equal_flag
);

    // Accurate-section controls.
    logic A_inv_hi, B_inv_hi, Bset_hi, S1_hi, S0_hi, O_inv_hi;

    // Approximate-section controls.
    logic A_inv_lo, B_inv_lo, Bset_lo, S1_lo, S0_lo, O_inv_lo;

    // carry_chain[4] is the approximate LOA boundary carry/borrow.
    logic [8:0] carry_chain;

    // ------------------------------------------------------------------------
    // Opcode decoder. Logical controls remain identical to the exact ALU.
    // ADD has a different O_inv in the LSB section because the LOR1bit
    // arithmetic path is NOR and must be inverted to implement OR.
    // ------------------------------------------------------------------------
    always_comb begin
        A_inv_hi = 1'b0;
        B_inv_hi = 1'b0;
        Bset_hi  = 1'b0;
        S1_hi    = 1'b0;
        S0_hi    = 1'b0;
        O_inv_hi = 1'b0;

        A_inv_lo = 1'b0;
        B_inv_lo = 1'b0;
        Bset_lo  = 1'b0;
        S1_lo    = 1'b0;
        S0_lo    = 1'b0;
        O_inv_lo = 1'b0;

        unique case (op)
            OP_ADD: begin
                // Accurate MSBs: normal addition.
                A_inv_hi = 1'b1;
                B_inv_hi = 1'b1;
                S1_hi    = 1'b0;
                S0_hi    = 1'b0;
                O_inv_hi = 1'b0;

                // Approximate LSBs: OR instead of XOR+carry.
                A_inv_lo = 1'b1;
                B_inv_lo = 1'b1;
                S1_lo    = 1'b0;
                S0_lo    = 1'b0;
                O_inv_lo = 1'b1;
            end

            OP_SUB: begin
                // Accurate MSBs: exact subtraction using borrow ripple.
                A_inv_hi = 1'b0;
                B_inv_hi = 1'b1;
                S1_hi    = 1'b0;
                S0_hi    = 1'b0;
                O_inv_hi = 1'b1;

                // Approximate LSBs: OR-based lower subtractor.
                A_inv_lo = 1'b0;
                B_inv_lo = 1'b1;
                S1_lo    = 1'b0;
                S0_lo    = 1'b0;
                O_inv_lo = 1'b1;
            end

            OP_NOT: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0; Bset_hi = 1'b1;
                S1_hi = 1'b0; S0_hi = 1'b1; O_inv_hi = 1'b0;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0; Bset_lo = 1'b1;
                S1_lo = 1'b0; S0_lo = 1'b1; O_inv_lo = 1'b0;
            end

            OP_XOR: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0;
                S1_hi = 1'b0; S0_hi = 1'b1; O_inv_hi = 1'b0;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0;
                S1_lo = 1'b0; S0_lo = 1'b1; O_inv_lo = 1'b0;
            end

            OP_XNOR: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0;
                S1_hi = 1'b0; S0_hi = 1'b1; O_inv_hi = 1'b1;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0;
                S1_lo = 1'b0; S0_lo = 1'b1; O_inv_lo = 1'b1;
            end

            OP_NAND: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0;
                S1_hi = 1'b1; S0_hi = 1'b0; O_inv_hi = 1'b0;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0;
                S1_lo = 1'b1; S0_lo = 1'b0; O_inv_lo = 1'b0;
            end

            OP_AND: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0;
                S1_hi = 1'b1; S0_hi = 1'b0; O_inv_hi = 1'b1;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0;
                S1_lo = 1'b1; S0_lo = 1'b0; O_inv_lo = 1'b1;
            end

            OP_NOR: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0;
                S1_hi = 1'b1; S0_hi = 1'b1; O_inv_hi = 1'b0;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0;
                S1_lo = 1'b1; S0_lo = 1'b1; O_inv_lo = 1'b0;
            end

            OP_OR: begin
                A_inv_hi = 1'b0; B_inv_hi = 1'b0;
                S1_hi = 1'b1; S0_hi = 1'b1; O_inv_hi = 1'b1;
                A_inv_lo = 1'b0; B_inv_lo = 1'b0;
                S1_lo = 1'b1; S0_lo = 1'b1; O_inv_lo = 1'b1;
            end

            default: begin end
        endcase
    end

    assign carry_chain[0] = 1'b0;

    // ========================================================================
    // APPROXIMATE LOWER 4 BITS: [3:0]
    // ========================================================================

    LOA_1bit u_loa_bit0 (
        .A(A[0]), .B(B[0]), .Cin(1'b0),
        .A_inv(A_inv_lo), .B_inv(B_inv_lo), .B_set(Bset_lo),
        .S1(S1_lo), .S0(S0_lo), .O_inv(O_inv_lo),
        .Result(result[0]), .Cout()
    );

    LOA_1bit u_loa_bit1 (
        .A(A[1]), .B(B[1]), .Cin(1'b0),
        .A_inv(A_inv_lo), .B_inv(B_inv_lo), .B_set(Bset_lo),
        .S1(S1_lo), .S0(S0_lo), .O_inv(O_inv_lo),
        .Result(result[1]), .Cout()
    );

    LOA_1bit u_loa_bit2 (
        .A(A[2]), .B(B[2]), .Cin(1'b0),
        .A_inv(A_inv_lo), .B_inv(B_inv_lo), .B_set(Bset_lo),
        .S1(S1_lo), .S0(S0_lo), .O_inv(O_inv_lo),
        .Result(result[2]), .Cout()
    );

    LOA_1bit u_loa_bit3 (
        .A(A[3]), .B(B[3]), .Cin(1'b0),
        .A_inv(A_inv_lo), .B_inv(B_inv_lo), .B_set(Bset_lo),
        .S1(S1_lo), .S0(S0_lo), .O_inv(O_inv_lo),
        .Result(result[3]), .Cout()
    );

    // ========================================================================
    // APPROXIMATE BOUNDARY CARRY/BORROW
    // ========================================================================
    always_comb begin
        case (op)
            OP_ADD: carry_chain[4] = A[3] & B[3];
            OP_SUB: carry_chain[4] = (~A[3]) & B[3];
            default: carry_chain[4] = 1'b0;
        endcase
    end

    // ========================================================================
    // ACCURATE UPPER 4 BITS: [7:4]
    // Uses the project's original alu_bitslice unchanged.
    // ========================================================================

    alu_bitslice #(.HALF_ADDER(1'b0)) u_exact_bit4 (
        .A(A[4]), .B(B[4]), .Cin(carry_chain[4]),
        .A_inv(A_inv_hi), .B_inv(B_inv_hi), .O_inv(O_inv_hi),
        .Bset(Bset_hi), .S1(S1_hi), .S0(S0_hi),
        .out3(result[4]), .cout(carry_chain[5]), .xor1_tap()
    );

    alu_bitslice #(.HALF_ADDER(1'b0)) u_exact_bit5 (
        .A(A[5]), .B(B[5]), .Cin(carry_chain[5]),
        .A_inv(A_inv_hi), .B_inv(B_inv_hi), .O_inv(O_inv_hi),
        .Bset(Bset_hi), .S1(S1_hi), .S0(S0_hi),
        .out3(result[5]), .cout(carry_chain[6]), .xor1_tap()
    );

    alu_bitslice #(.HALF_ADDER(1'b0)) u_exact_bit6 (
        .A(A[6]), .B(B[6]), .Cin(carry_chain[6]),
        .A_inv(A_inv_hi), .B_inv(B_inv_hi), .O_inv(O_inv_hi),
        .Bset(Bset_hi), .S1(S1_hi), .S0(S0_hi),
        .out3(result[6]), .cout(carry_chain[7]), .xor1_tap()
    );

    alu_bitslice #(.HALF_ADDER(1'b0)) u_exact_bit7 (
        .A(A[7]), .B(B[7]), .Cin(carry_chain[7]),
        .A_inv(A_inv_hi), .B_inv(B_inv_hi), .O_inv(O_inv_hi),
        .Bset(Bset_hi), .S1(S1_hi), .S0(S0_hi),
        .out3(result[7]), .cout(carry_chain[8]), .xor1_tap()
    );

    // ========================================================================
    // FLAGS
    // ========================================================================
    assign zero_flag = (result == 8'b0);
    assign sign_flag = result[7];

    assign overflow_flag =
        ((op == OP_ADD) || (op == OP_SUB))
        ? (carry_chain[7] ^ carry_chain[8])
        : 1'b0;

    assign carry_flag =
        ((op == OP_ADD) || (op == OP_SUB))
        ? carry_chain[8]
        : 1'b0;

    assign equal_flag = (A == B);

endmodule
