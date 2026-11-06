`timescale 1ns/1ps

// 8-bit LXA ALU:
//   bits [3:0] = approximate LXA logic slices (no carry propagation)
//   bit  [4]   = boundary slice (NOR-based half-adder carry for ADD)
//   bits [7:5] = accurate ripple-carry slices
//
// Opcode encoding matches the previously used ALU opcode list.
// Verify SUB/control polarity against your accurate reference before
// treating arithmetic subtraction as bit-for-bit equivalent.

module LXA8bit_top (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic       zero_flag,
    output logic       sign_flag,
    output logic       overflow_flag,
    output logic       carry_flag,
    output logic       equal_flag
);

    localparam logic [3:0]
        OP_ADD  = 4'b0000,
        OP_SUB  = 4'b0001,
        OP_NOT  = 4'b0010,
        OP_XOR  = 4'b0011,
        OP_XNOR = 4'b0100,
        OP_NAND = 4'b0101,
        OP_AND  = 4'b0110,
        OP_NOR  = 4'b0111,
        OP_OR   = 4'b1000;

    logic A_inv, B_inv, B_set, S1, S0, O_inv;
    logic [8:0] carry_chain;
    logic [7:0] bit_result;
    logic [4:0] unused_approx_carry;

    // Decode operation into the shared bit-slice control signals.
    // Approximate slices map ADD/SUB to XOR-like approximate results.
    always_comb begin
        A_inv = 1'b0;
        B_inv = 1'b0;
        B_set = 1'b0;
        S1    = 1'b0;
        S0    = 1'b0;
        O_inv = 1'b0;

        case (op)
            OP_ADD: begin
                // Accurate slices select SUM; LXA slices select XOR.
                S1 = 1'b0; S0 = 1'b0;
            end

            OP_SUB: begin
                // Difference convention used in the earlier single-bit
                // discussion: invert B and invert the XOR-selected output.
                // The low approximate region intentionally omits carry.
                B_inv = 1'b1;
                S1    = 1'b0;
                S0    = 1'b1;
                O_inv = 1'b1;
            end

            OP_NOT: begin
                A_inv = 1'b1;
                S1    = 1'b0; S0 = 1'b1;
            end

            OP_XOR: begin
                S1 = 1'b0; S0 = 1'b1;
            end

            OP_XNOR: begin
                S1 = 1'b0; S0 = 1'b1; O_inv = 1'b1;
            end

            OP_NAND: begin
                S1 = 1'b1; S0 = 1'b0;
            end

            OP_AND: begin
                S1 = 1'b1; S0 = 1'b0; O_inv = 1'b1;
            end

            OP_NOR: begin
                S1 = 1'b1; S0 = 1'b1;
            end

            OP_OR: begin
                S1 = 1'b1; S0 = 1'b1; O_inv = 1'b1;
            end

            default: begin
                A_inv = 1'b0;
                B_inv = 1'b0;
                B_set = 1'b0;
                S1    = 1'b0;
                S0    = 1'b0;
                O_inv = 1'b0;
            end
        endcase
    end

    // Low four approximate bits: LXA schematic has XOR/NAND/NOR paths,
    // and does not expose carry in/out.
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LXA_APPROX_BITS
            LXA1bit u_lxa_bit (
                .B_inv (B_inv),
                .B     (B[i]),
                .A     (A[i]),
                .O_inv (O_inv),
                .A_inv (A_inv),
                .S1    (S1),
                .B_set (B_set),
                .S0    (S0),
                .O0    (bit_result[i])
            );
        end
    endgenerate

    // Approximate lower bits do not propagate carry.
    // Boundary bit starts the accurate ripple region.
    assign carry_chain[4] = (op == OP_SUB) ? 1'b1 : 1'b0;

    // Bit 4: accurate function output, special NOR/De Morgan carry for ADD.
    LXA_boundary_bit u_boundary_bit (
        .A       (A[4]),
        .B       (B[4]),
        .Cin     (carry_chain[4]),
        .A_inv   (A_inv),
        .B_inv   (B_inv),
        .B_set   (B_set),
        .S1      (S1),
        .S0      (S0),
        .O_inv   (O_inv),
        .is_add  (op == OP_ADD),
        .Result  (bit_result[4]),
        .Cout    (carry_chain[5])
    );

    // Upper three accurate bits ripple from the boundary carry.
    generate
        for (i = 5; i < 8; i = i + 1) begin : ACCURATE_BITS
            ALU1bit_accurate u_accurate_bit (
                .A       (A[i]),
                .B       (B[i]),
                .Cin     (carry_chain[i]),
                .A_inv   (A_inv),
                .B_inv   (B_inv),
                .B_set   (B_set),
                .S1      (S1),
                .S0      (S0),
                .O_inv   (O_inv),
                .Result  (bit_result[i]),
                .Cout    (carry_chain[i+1])
            );
        end
    endgenerate

    assign result = bit_result;

    assign zero_flag     = (result == 8'h00);
    assign sign_flag     = result[7];
    assign overflow_flag = carry_chain[7] ^ carry_chain[8];
    assign carry_flag    = carry_chain[8];
    assign equal_flag    = (A == B);

endmodule


// LXA approximate logic slice, matching the derived DSCH netlist:
// B_set is applied before B inversion.
module LXA1bit (
    input  logic B_inv,
    input  logic B,
    input  logic A,
    input  logic O_inv,
    input  logic A_inv,
    input  logic S1,
    input  logic B_set,
    input  logic S0,
    output logic O0
);
    logic A_eff, B_pre, B_eff;
    logic xor_ab, nand_ab, nor_ab;
    logic selected;

    assign A_eff = A ^ A_inv;
    assign B_pre = B_set ? 1'b1 : B;
    assign B_eff = B_pre ^ B_inv;

    assign xor_ab  = A_eff ^ B_eff;
    assign nand_ab = ~(A_eff & B_eff);
    assign nor_ab  = ~(A_eff | B_eff);

    always_comb begin
        case ({S1, S0})
            2'b00:   selected = xor_ab;
            2'b01:   selected = xor_ab;
            2'b10:   selected = nand_ab;
            2'b11:   selected = nor_ab;
            default: selected = 1'bx;
        endcase
    end

    assign O0 = selected ^ O_inv;
endmodule


// Boundary bit: same operation-result logic as the accurate slice.
// For ADD with Cin=0, carry is implemented structurally as
// NOR(~A_eff, ~B_eff) = A_eff & B_eff.
module LXA_boundary_bit (
    input  logic A,
    input  logic B,
    input  logic Cin,
    input  logic A_inv,
    input  logic B_inv,
    input  logic B_set,
    input  logic S1,
    input  logic S0,
    input  logic O_inv,
    input  logic is_add,
    output logic Result,
    output logic Cout
);
    logic A_eff, B_eff;
    logic xor_ab, sum_ab, nand_ab, nor_ab, selected;
    logic carry_standard;
    logic carry_nor;

    assign A_eff = A ^ A_inv;
    assign B_eff = B_set ? 1'b1 : (B ^ B_inv);

    assign xor_ab  = A_eff ^ B_eff;
    assign sum_ab  = xor_ab ^ Cin;
    assign nand_ab = ~(A_eff & B_eff);
    assign nor_ab  = ~(A_eff | B_eff);

    always_comb begin
        case ({S1, S0})
            2'b00:   selected = sum_ab;
            2'b01:   selected = xor_ab;
            2'b10:   selected = nand_ab;
            2'b11:   selected = nor_ab;
            default: selected = 1'bx;
        endcase
    end

    assign Result = selected ^ O_inv;

    assign carry_standard = (xor_ab & Cin) | (A_eff & B_eff);
    assign carry_nor = ~(~A_eff | ~B_eff);
    assign Cout = (is_add && !Cin) ? carry_nor : carry_standard;
endmodule


// Accurate slice based on the earlier bit-slice equations.
module ALU1bit_accurate (
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
    logic A_eff, B_eff;
    logic xor_ab, sum_ab, nand_ab, nor_ab, selected;

    assign A_eff = A ^ A_inv;
    assign B_eff = B_set ? 1'b1 : (B ^ B_inv);

    assign xor_ab  = A_eff ^ B_eff;
    assign sum_ab  = xor_ab ^ Cin;
    assign nand_ab = ~(A_eff & B_eff);
    assign nor_ab  = ~(A_eff | B_eff);

    always_comb begin
        case ({S1, S0})
            2'b00:   selected = sum_ab;
            2'b01:   selected = xor_ab;
            2'b10:   selected = nand_ab;
            2'b11:   selected = nor_ab;
            default: selected = 1'bx;
        endcase
    end

    assign Result = selected ^ O_inv;
    assign Cout = (xor_ab & Cin) | (A_eff & B_eff);
endmodule
