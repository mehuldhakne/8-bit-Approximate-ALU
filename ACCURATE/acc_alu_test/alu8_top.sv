// 8-bit ALU top level: opcode decode -> broadcast control signals ->
// 8 bit-slices (bit 0 = half adder, bits 1-7 = full adder) -> flags.
//
// This is a direct 8-bit expansion of the provided 4-bit architecture.
// The 1-bit alu_bitslice module is intentionally unchanged.
//
// Opcode-to-control table:
//   Op    A_inv B_inv O_inv Bset S1 S0
//   ADD     1     1     0    0   0  0
//   SUB     0     1     1    0   0  0
//   NOT     0     0     0    1   0  1
//   XOR     0     0     0    0   0  1
//   XNOR    0     0     1    0   0  1
//   NAND    0     0     0    0   1  0
//   AND     0     0     1    0   1  0
//   NOR     0     0     0    0   1  1
//   OR      0     0     1    0   1  1
//
// Cin into bit 0 is tied to 0 for every current operation.

// Keep this enum identical to the 4-bit version so the existing opcode
// definitions can be reused by the testbench.


module alu8_top 
import alu_pkg::*;
(
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  alu_op_e    op,
    output logic [7:0] result,
    output logic       zero_flag,
    output logic       sign_flag,
    output logic       overflow_flag,
    output logic       carry_flag,     // carry-out (ADD) / borrow-out (SUB)
    output logic       equal_flag      // A == B, valid only when op == OP_SUB
);

    logic A_inv, B_inv, O_inv, Bset, S1, S0;

    // 9 positions:
    // carry_chain[0] = seed into bit 0
    // carry_chain[1] = bit 0 carry/borrow-out
    // ...
    // carry_chain[8] = final carry/borrow-out from bit 7
    logic [8:0] carry_chain;
    logic [7:0] xor1_taps;

    always_comb begin
        // Safe defaults
        A_inv = 1'b0;
        B_inv = 1'b0;
        O_inv = 1'b0;
        Bset  = 1'b0;
        S1    = 1'b0;
        S0    = 1'b0;

        unique case (op)
            OP_ADD:  begin A_inv=1'b1; B_inv=1'b1; O_inv=1'b0; Bset=1'b0; S1=1'b0; S0=1'b0; end
            OP_SUB:  begin A_inv=1'b0; B_inv=1'b1; O_inv=1'b1; Bset=1'b0; S1=1'b0; S0=1'b0; end
            OP_NOT:  begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b0; Bset=1'b1; S1=1'b0; S0=1'b1; end
            OP_XOR:  begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b0; Bset=1'b0; S1=1'b0; S0=1'b1; end
            OP_XNOR: begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b1; Bset=1'b0; S1=1'b0; S0=1'b1; end
            OP_NAND: begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b0; Bset=1'b0; S1=1'b1; S0=1'b0; end
            OP_AND:  begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b1; Bset=1'b0; S1=1'b1; S0=1'b0; end
            OP_NOR:  begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b0; Bset=1'b0; S1=1'b1; S0=1'b1; end
            OP_OR:   begin A_inv=1'b0; B_inv=1'b0; O_inv=1'b1; Bset=1'b0; S1=1'b1; S0=1'b1; end
            default: ;
        endcase
    end

    // Cin seed = 0 for all current operations
    assign carry_chain[0] = 1'b0;

    // Bit 0: half-adder version, exactly as in the 4-bit architecture.
    alu_bitslice #(.HALF_ADDER(1'b1)) u_bit0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(carry_chain[0]),
        .A_inv(A_inv),
        .B_inv(B_inv),
        .O_inv(O_inv),
        .Bset(Bset),
        .S1(S1),
        .S0(S0),
        .out3(result[0]),
        .cout(carry_chain[1]),
        .xor1_tap(xor1_taps[0])
    );

    // Bits 1-7: full-adder versions, creating the ripple carry/borrow chain.
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin : full_bits
            alu_bitslice #(.HALF_ADDER(1'b0)) u_bit (
                .A(A[i]),
                .B(B[i]),
                .Cin(carry_chain[i]),
                .A_inv(A_inv),
                .B_inv(B_inv),
                .O_inv(O_inv),
                .Bset(Bset),
                .S1(S1),
                .S0(S0),
                .out3(result[i]),
                .cout(carry_chain[i+1]),
                .xor1_tap(xor1_taps[i])
            );
        end
    endgenerate

    // ---- Flags ----
    assign zero_flag     = (result == 8'b0000_0000);
    assign sign_flag     = result[7];
    assign overflow_flag = carry_chain[7] ^ carry_chain[8];
    assign carry_flag    = carry_chain[8];
    assign equal_flag    = &xor1_taps;

endmodule
