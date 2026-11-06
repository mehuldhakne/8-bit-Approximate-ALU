// 8-bit LXA (ETA-1) Approximate ALU Top Module
// Bit Structure:
// - Bits 0..3: LXA 1-bit approximate slices (No carry propagation)
// - Bit 4: LXA boundary bit slice (Generates cout to drive bit 5 carry chain)
// - Bits 5..7: Accurate full-adder ALU slices
import alu_pkg::*;

module lxa_8bit_alu (
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

    logic Cin;
    logic s0, s1;
    logic ainv, binv, oinv, Bsel;

    // Control Line Decoder
    always_comb begin
        Cin  = 1'b0;
        s0   = 1'b0; s1 = 1'b0;
        ainv = 1'b0; binv = 1'b0; oinv = 1'b0; Bsel = 1'b0;

        case (op)
            OP_ADD:  begin s1 = 1'b1; s0 = 1'b1; Cin = 1'b0; end
            OP_SUB:  begin s1 = 1'b1; s0 = 1'b1; binv = 1'b1; Cin = 1'b1; end
            OP_NOT:  begin s1 = 1'b1; s0 = 1'b0; ainv = 1'b1; end
            OP_XOR:  begin s1 = 1'b1; s0 = 1'b0; end
            OP_XNOR: begin s1 = 1'b1; s0 = 1'b0; oinv = 1'b1; end
            OP_NAND: begin s1 = 1'b0; s0 = 1'b0; oinv = 1'b1; end
            OP_AND:  begin s1 = 1'b0; s0 = 1'b0; end
            OP_NOR:  begin s1 = 1'b0; s0 = 1'b1; oinv = 1'b1; end
            OP_OR:   begin s1 = 1'b0; s0 = 1'b1; end
            default: begin s1 = 1'b0; s0 = 1'b0; end
        endcase
    end

    // Carry Chain Interconnections
    logic [7:4] carry;

    // Bits 0..3: LXA 1-Bit Approximate Slices
    genvar i;
    generate
        for (i = 0; i <= 3; i++) begin : lxa_approx_bits
            lxa_bit_approx bit0_to_3 (
                .A(A[i]), .B(B[i]),
                .A_inv(ainv), .B_inv(binv), .B_set(Bsel), .O_inv(oinv),
                .S0(s0), .S1(s1),
                .Output(result[i])
            );
        end
    endgenerate

    // Bit 4: LXA Boundary Slice (Generates carry[4] for Bit 5)
    lxa_bit_boundary bit4 (
        .A(A[4]), .B(B[4]),
        .ainv(ainv), .binv(binv), .Bsel(Bsel), .oinv(oinv),
        .s0(s0), .s1(s1),
        .cout(carry[4]),
        .Output(result[4])
    );

    // Bits 5..7: Accurate Slices
    generate
        for (i = 5; i <= 7; i++) begin : accurate_bits
            alu_bit_accurate bit5_to_7 (
                .A(A[i]), .B(B[i]), .Cin(carry[i-1]),
                .s0(s0), .s1(s1), .ainv(ainv), .binv(binv), .Bsel(Bsel), .oinv(oinv),
                .Output(result[i]), .cout(carry[i])
            );
        end
    endgenerate

    // Status Flags
    assign carry_flag    = carry[7];
    assign zero_flag     = (result == 8'h00);
    assign sign_flag     = result[7];
    assign overflow_flag = carry[6] ^ carry[7];
    assign equal_flag    = (A == B);

endmodule
