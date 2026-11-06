// Bit Slice Modules for 8-bit LXA (ETA-1) ALU

// 1. LXA 1-Bit Approximate Slice (Bits 0..3)
// Derived from LXA 1 bit.sch (Schematic Source)
module lxa_bit_approx (
    input  logic A, B,
    input  logic A_inv, B_inv, B_set, O_inv,
    input  logic S0, S1,
    output logic Output
);
    logic w2, w3, w5, w6, w7, w8, w11, w13, w17, w20, w21, w22;

    // Input Control MUXes & Inverters
    tgmux21 TgMux21_4 (.i0(B), .i1(1'b1), .sel(B_set), .f(w2));
    assign w3 = ~w2;
    tgmux21 TgMux21_1 (.i0(w2), .i1(w3), .sel(B_inv), .f(w5));

    assign w13 = ~A;
    tgmux21 TgMux21_5 (.i0(A), .i1(w13), .sel(A_inv), .f(w17));

    // Logic Gates
    assign w6 = w17 ^ w5;
    assign w7 = ~(w5 & w17);
    assign w8 = ~(w17 | w5);

    // MUX Stage
    mux4_1 mux_11_12_13 (.I0(w7), .I1(w8), .I2(w6), .I3(w6), .S0(S0), .S1(S1), .out1(w11));

    // Output Inversion MUX
    assign w20 = ~w11;
    tgmux21 TgMux21_9 (.i0(w11), .i1(w20), .sel(O_inv), .f(Output));

endmodule

// 2. LXA Boundary Bit Slice (Bit 4)
// Derived from lsb FOR RIPPLE CARRY_approx_(b0).sch
module lxa_bit_boundary (
    input  logic A, B,
    input  logic ainv, binv, Bsel, oinv,
    input  logic s0, s1,
    output logic cout, Output
);
    logic w8, w9, w10, w13, w14, w15, w16, w17, w20, w21, w22;

    tgmux21 TgMux21_1 (.i0(B), .i1(1'b1), .sel(Bsel), .f(w13));
    assign w14 = ~w13;
    tgmux21 TgMux21_7 (.i0(w13), .i1(w14), .sel(binv), .f(w15));

    assign w20 = ~A;
    tgmux21 TgMux21_10 (.i0(A), .i1(w20), .sel(ainv), .f(w16));

    assign w8   = w16 ^ w15;
    assign w9   = ~(w15 & w16);
    assign cout = ~(w16 | w15);

    mux4_1 mux_11_12_13 (.I0(w9), .I1(cout), .I2(w8), .I3(w8), .S0(s0), .S1(s1), .out1(w10));

    assign w17 = ~w10;
    tgmux21 TgMux21_5 (.i0(w10), .i1(w17), .sel(oinv), .f(Output));

endmodule

// 3. Accurate Bit Slice (Bits 5..7)
module alu_bit_accurate (
    input  logic A, B, Cin,
    input  logic s0, s1, ainv, binv, Bsel, oinv,
    output logic Output, cout
);
    logic a_in, b_in, b_sel_out;
    logic n_out, nor_out, xor_out, exact_sum;

    tgmux21 mux_a (.i0(A), .i1(~A), .sel(ainv), .f(a_in));
    tgmux21 mux_b (.i0(B), .i1(~B), .sel(binv), .f(b_in));
    tgmux21 mux_bsel (.i0(b_in), .i1(1'b0), .sel(Bsel), .f(b_sel_out));

    assign n_out   = ~(a_in & b_sel_out);
    assign nor_out = ~(a_in | b_sel_out);
    assign xor_out = a_in ^ b_sel_out;
    
    assign exact_sum = xor_out ^ Cin;
    assign cout      = (a_in & b_sel_out) | (Cin & xor_out);

    logic final_mux_out;
    mux4_1 op_mux (.I0(n_out), .I1(nor_out), .I2(xor_out), .I3(exact_sum), .S0(s0), .S1(s1), .out1(final_mux_out));
    
    assign Output = oinv ? ~final_mux_out : final_mux_out;
endmodule
