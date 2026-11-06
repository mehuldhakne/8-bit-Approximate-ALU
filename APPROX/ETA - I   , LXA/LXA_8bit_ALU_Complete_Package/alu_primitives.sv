// Transmission Gate 2:1 MUX and 4:1 MUX Primitives
module tgmux21 (
    input  logic i0,
    input  logic i1,
    input  logic sel,
    output logic f
);
    assign f = sel ? i1 : i0;
endmodule

module mux4_1 (
    input  logic I0, I1, I2, I3,
    input  logic S0, S1,
    output logic out1
);
    logic w5, w7;
    assign w7 = S0 ? I1 : I0;
    assign w5 = S0 ? I3 : I2;
    assign out1 = S1 ? w5 : w7;
endmodule
