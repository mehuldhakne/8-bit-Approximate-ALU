// ETA-2 ALU - APPROXIMATE 1-bit slice.
// Direct translation of approx_bit_for_eta_2_alu.sch (netlist traced from the
// DSCH wire coordinates, not guessed from the picture).
//
// Differences from the accurate slice (alu_bitslice, HALF_ADDER=0):
//   * NO Cin input and NO carry-out: there is no carry chain through this cell.
//   * The XOR gate output drives BOTH mux inputs I0 and I1, so the "sum" path
//     (S1S0=00) is just  fA ^ fB  -- the "^ Cin" stage does not exist.
//   * Everything else (A/B inversion muxes, B-force-to-1 mux, NAND/NOR for
//     I2/I3, O_inv output stage) is identical, so every LOGIC operation
//     (XOR, XNOR, NAND, AND, NOR, OR, NOT) is still exact.
//
// Port names use the same names as alu_bitslice.sv; the DSCH labels are
// ainv -> A_inv, binv -> B_inv, oinv -> O_inv, Bsel -> Bset, Output -> out.

module eta2_apx_bit (
    input  logic A,
    input  logic B,
    input  logic A_inv,    // DSCH: ainv
    input  logic B_inv,    // DSCH: binv
    input  logic O_inv,    // DSCH: oinv
    input  logic Bset,     // DSCH: Bsel  (forces B to constant 1, used by NOT)
    input  logic S1,
    input  logic S0,
    output logic out       // DSCH: Output
);

    logic b_pre, fA, fB, xor1, nand_ab, nor_ab, out1;

    assign b_pre = Bset ? 1'b1 : B;
    assign fA    = A_inv ? ~A     : A;
    assign fB    = B_inv ? ~b_pre : b_pre;

    assign xor1    = fA ^ fB;
    assign nand_ab = ~(fA & fB);
    assign nor_ab  = ~(fA | fB);

    // 4:1 select: S1S0 = 00->I0(xor1)  01->I1(xor1)  10->I2(nand)  11->I3(nor)
    // I0 and I1 are the SAME net in the schematic, so S0 has no effect when S1=0.
    assign out1 = S1 ? (S0 ? nor_ab : nand_ab) : xor1;

    assign out = O_inv ? ~out1 : out1;

endmodule
