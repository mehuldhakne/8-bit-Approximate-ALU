// Bit Slice Modules for ARCA 8-bit ALU
module alu_bit0 (
    input  logic A, B, Cin,
    input  logic s0, s1, ainv, binv, Bsel, oinv,
    output logic Output, cout
);
    logic a_in, b_in, b_sel_out;
    logic n_out, nor_out, xor_out, sum;

    tgmux21 mux_a (.i0(A), .i1(~A), .sel(ainv), .f(a_in));
    tgmux21 mux_b (.i0(B), .i1(~B), .sel(binv), .f(b_in));
    tgmux21 mux_bsel (.i0(b_in), .i1(1'b0), .sel(Bsel), .f(b_sel_out));

    assign n_out   = ~(a_in & b_sel_out);
    assign nor_out = ~(a_in | b_sel_out);
    assign xor_out = a_in ^ b_sel_out;
    
    assign sum  = xor_out ^ Cin;
    assign cout = (a_in & b_sel_out) | (Cin & xor_out);

    logic final_mux_out;
    mux4_1 op_mux (.I0(n_out), .I1(nor_out), .I2(xor_out), .I3(sum), .S0(s0), .S1(s1), .out1(final_mux_out));
    
    assign Output = oinv ? ~final_mux_out : final_mux_out;
endmodule

module alu_bit_approx (
    input  logic A, B, Cin,
    input  logic s0, s1, ainv, binv, Bsel, oinv,
    output logic Output, cout
);
    logic a_in, b_in, b_sel_out;
    logic n_out, nor_out, xor_out, approx_sum;

    tgmux21 mux_a (.i0(A), .i1(~A), .sel(ainv), .f(a_in));
    tgmux21 mux_b (.i0(B), .i1(~B), .sel(binv), .f(b_in));
    tgmux21 mux_bsel (.i0(b_in), .i1(1'b0), .sel(Bsel), .f(b_sel_out));

    assign n_out   = ~(a_in & b_sel_out);
    assign nor_out = ~(a_in | b_sel_out);
    assign xor_out = a_in ^ b_sel_out;
    
    assign approx_sum = xor_out | Cin; 
    assign cout       = (a_in & b_sel_out) | (Cin & (a_in | b_sel_out));

    logic final_mux_out;
    mux4_1 op_mux (.I0(n_out), .I1(nor_out), .I2(xor_out), .I3(approx_sum), .S0(s0), .S1(s1), .out1(final_mux_out));
    
    assign Output = oinv ? ~final_mux_out : final_mux_out;
endmodule

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
