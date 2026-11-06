// 8-bit ETA-2 ALU
//   bits [3:0] : ETA-2 approximate cells
//   bits [7:4] : accurate alu_bitslice cells
//
// The carry into bit 4 is the carry-prediction network reconstructed
// from "ETA-2 ALU 8 BIT.sch":
//   Cpred = (A3 & B3) | ((A3 | B3) & A2 & B2)

module eta2_alu_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  alu_pkg::alu_op_e op,
    output logic [7:0] Y,
    output logic       Cout,
    output logic       zero_flag,
    output logic       sign_flag,
    output logic       overflow_flag,
    output logic       carry_flag,
    output logic       equal_flag
);
    import alu_pkg::*;

    // Shared control lines, matching the existing 1-bit accurate slice.
    logic Ainv;
    logic Binv;
    logic Oinv;
    logic Bsel;
    logic S1;
    logic S0;

    // Carry chain for the accurate section.
    // carry[4] is the ETA-2 predicted carry into bit 4.
    logic [8:4] carry;

    // ------------------------------------------------------------------
    // Opcode -> control-signal decoding
    // ------------------------------------------------------------------
    // alu_bitslice function select:
    //   S1S0 = 00 : sum / XOR+Cin
    //   S1S0 = 01 : XOR
    //   S1S0 = 10 : NAND
    //   S1S0 = 11 : NOR
    // Oinv inverts the selected function.
    // Bsel=1 forces B=1, which implements NOT(A) through XOR.
    //
    // ADD requires Ainv=Binv=1 because the original DSCH carry network is
    //   Cout = Cin ? NAND(fA,fB) : NOR(fA,fB).
    // With fA=~A and fB=~B this becomes the normal carry equation.
    // ------------------------------------------------------------------
    always_comb begin
        Ainv = 1'b0;
        Binv = 1'b0;
        Oinv = 1'b0;
        Bsel = 1'b0;
        S1   = 1'b0;
        S0   = 1'b0;

        case (op)
            OP_ADD: begin
                Ainv = 1'b1;
                Binv = 1'b1;
                S1   = 1'b0;
                S0   = 1'b0;
            end

            OP_SUB: begin
                // Two's-complement subtraction is formed as A + ~B + 1.
                // With the original DSCH NAND/NOR carry network, the
                // carry-consistent operand form is fA=~A and fB=B.
                // The approximate LSBs intentionally omit the +1 carry
                // term because the ETA-2 approximate cell has no Cin.
                Ainv = 1'b1;
                Binv = 1'b0;
                S1   = 1'b0;
                S0   = 1'b0;
            end

            OP_NOT: begin
                // Bsel forces B=1 -> A XOR 1 = ~A.
                Ainv = 1'b0;
                Binv = 1'b0;
                Bsel = 1'b1;
                S1   = 1'b0;
                S0   = 1'b1;
            end

            OP_XOR: begin
                S1   = 1'b0;
                S0   = 1'b1;
            end

            OP_XNOR: begin
                Oinv = 1'b1;
                S1   = 1'b0;
                S0   = 1'b1;
            end

            OP_NAND: begin
                S1   = 1'b1;
                S0   = 1'b0;
            end

            OP_AND: begin
                Oinv = 1'b1;
                S1   = 1'b1;
                S0   = 1'b0;
            end

            OP_NOR: begin
                S1   = 1'b1;
                S0   = 1'b1;
            end

            OP_OR: begin
                Oinv = 1'b1;
                S1   = 1'b1;
                S0   = 1'b1;
            end

            default: begin
                // Safe default for an unused opcode.
                Ainv = 1'b0;
                Binv = 1'b0;
                Oinv = 1'b0;
                Bsel = 1'b0;
                S1   = 1'b0;
                S0   = 1'b0;
            end
        endcase
    end

    // ------------------------------------------------------------------
    // ETA-2 carry predictor from the 8-bit DSCH schematic.
    // Lower 4 bits are approximate, so there is no ripple carry through
    // bits 0..3. Instead, bit 4 starts from this prediction.
    // ------------------------------------------------------------------
    assign carry[4] = (A[3] & B[3]) |
                      ((A[3] | B[3]) & A[2] & B[2]);

    // ------------------------------------------------------------------
    // Approximate LSBs: bits 0..3
    // No Cin/Cout, exactly as in approx bit for eta 2 alu.sch.
    // ------------------------------------------------------------------
    approxbitforeta2alu u_approx_bit0 (
        .oinv   (Oinv),
        .s1     (S1),
        .s0     (S0),
        .Bsel   (Bsel),
        .binv   (Binv),
        .ainv   (Ainv),
        .B      (B[0]),
        .A      (A[0]),
        .Output (Y[0])
    );

    approxbitforeta2alu u_approx_bit1 (
        .oinv   (Oinv),
        .s1     (S1),
        .s0     (S0),
        .Bsel   (Bsel),
        .binv   (Binv),
        .ainv   (Ainv),
        .B      (B[1]),
        .A      (A[1]),
        .Output (Y[1])
    );

    approxbitforeta2alu u_approx_bit2 (
        .oinv   (Oinv),
        .s1     (S1),
        .s0     (S0),
        .Bsel   (Bsel),
        .binv   (Binv),
        .ainv   (Ainv),
        .B      (B[2]),
        .A      (A[2]),
        .Output (Y[2])
    );

    approxbitforeta2alu u_approx_bit3 (
        .oinv   (Oinv),
        .s1     (S1),
        .s0     (S0),
        .Bsel   (Bsel),
        .binv   (Binv),
        .ainv   (Ainv),
        .B      (B[3]),
        .A      (A[3]),
        .Output (Y[3])
    );

    // ------------------------------------------------------------------
    // Accurate MSBs: bits 4..7
    // Use the existing alu_bitslice implementation supplied in the
    // project. These are the four ripple-carry stages.
    // ------------------------------------------------------------------
    alu_bitslice u_accurate_bit4 (
        .A        (A[4]),
        .B        (B[4]),
        .Cin      (carry[4]),
        .A_inv    (Ainv),
        .B_inv    (Binv),
        .O_inv    (Oinv),
        .Bset     (Bsel),
        .S1       (S1),
        .S0       (S0),
        .out3     (Y[4]),
        .cout     (carry[5]),
        .xor1_tap ()
    );

    alu_bitslice u_accurate_bit5 (
        .A        (A[5]),
        .B        (B[5]),
        .Cin      (carry[5]),
        .A_inv    (Ainv),
        .B_inv    (Binv),
        .O_inv    (Oinv),
        .Bset     (Bsel),
        .S1       (S1),
        .S0       (S0),
        .out3     (Y[5]),
        .cout     (carry[6]),
        .xor1_tap ()
    );

    alu_bitslice u_accurate_bit6 (
        .A        (A[6]),
        .B        (B[6]),
        .Cin      (carry[6]),
        .A_inv    (Ainv),
        .B_inv    (Binv),
        .O_inv    (Oinv),
        .Bset     (Bsel),
        .S1       (S1),
        .S0       (S0),
        .out3     (Y[6]),
        .cout     (carry[7]),
        .xor1_tap ()
    );

    alu_bitslice u_accurate_bit7 (
        .A        (A[7]),
        .B        (B[7]),
        .Cin      (carry[7]),
        .A_inv    (Ainv),
        .B_inv    (Binv),
        .O_inv    (Oinv),
        .Bset     (Bsel),
        .S1       (S1),
        .S0       (S0),
        .out3     (Y[7]),
        .cout     (carry[8]),
        .xor1_tap ()
    );

    // Final carry/borrow from the accurate MSB. Preserve the original Cout.
    assign Cout = carry[8];

    // ------------------------------------------------------------------
    // STATUS FLAGS (following the LOA 8-bit ALU flag interface)
    // These are observational outputs; the ETA-2 datapath is unchanged.
    // ------------------------------------------------------------------
    assign zero_flag = (Y == 8'b0);
    assign sign_flag = Y[7];
    assign equal_flag = (A == B);

    // Carry and overflow are meaningful for arithmetic operations only.
    assign carry_flag = ((op == OP_ADD) || (op == OP_SUB))
                      ? carry[8] : 1'b0;
    assign overflow_flag = ((op == OP_ADD) || (op == OP_SUB))
                         ? (carry[7] ^ carry[8]) : 1'b0;

endmodule
