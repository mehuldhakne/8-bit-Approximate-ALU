// Top-Level 8-Bit ARCA ALU Module matching exact top signal naming format
import alu_pkg::*;

module arca_8bit_alu (
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

    // Internal control signals decoded from op
    logic Cin;
    logic s0, s1;
    logic ainv, binv, oinv, Bsel;

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

    // Carry propagation chain
    logic [8:0] carry;
    assign carry[0] = Cin;
    assign carry_flag = carry[8];

    // Bit 0: LSB Slice
    alu_bit0 bit0 (
        .A(A[0]), .B(B[0]), .Cin(carry[0]),
        .s0(s0), .s1(s1), .ainv(ainv), .binv(binv), .oinv(oinv), .Bsel(Bsel),
        .Output(result[0]), .cout(carry[1])
    );

    // Bits 1, 2, 3: Approximate Slices
    genvar i;
    generate
        for (i = 1; i <= 3; i++) begin : approx_bits
            alu_bit_approx bit1_to_3 (
                .A(A[i]), .B(B[i]), .Cin(carry[i]),
                .s0(s0), .s1(s1), .ainv(ainv), .binv(binv), .oinv(oinv), .Bsel(Bsel),
                .Output(result[i]), .cout(carry[i+1])
            );
        end
    endgenerate

    // Bits 4, 5, 6, 7: Accurate Slices
    generate
        for (i = 4; i <= 7; i++) begin : accurate_bits
            alu_bit_accurate bit4_to_7 (
                .A(A[i]), .B(B[i]), .Cin(carry[i]),
                .s0(s0), .s1(s1), .ainv(ainv), .binv(binv), .oinv(oinv), .Bsel(Bsel),
                .Output(result[i]), .cout(carry[i+1])
            );
        end
    endgenerate

    // Status Flags
    assign zero_flag     = (result == 8'h00);
    assign sign_flag     = result[7];
    assign overflow_flag = carry[7] ^ carry[8];
    assign equal_flag    = (A == B);

endmodule
