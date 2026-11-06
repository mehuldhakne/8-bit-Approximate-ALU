// ETA-2 approximate 1-bit cell
// Reconstructed directly from "approx bit for eta 2 alu.sch".
// There is NO carry-in/carry-out path in this cell.

module approxbitforeta2alu (
    input  logic oinv,
    input  logic s1,
    input  logic s0,
    input  logic Bsel,
    input  logic binv,
    input  logic ainv,
    input  logic B,
    input  logic A,
    output logic Output
);
    import alu_pkg::*;

    logic b_pre;
    logic b_n;
    logic fA;
    logic fB;
    logic x;
    logic nand_ab;
    logic nor_ab;
    logic logic_selected;
    logic function_selected;
    logic selected_n;

    // TgMux21(B, VDD, Bsel): Bsel=1 forces B to logic 1.
    assign b_pre = Bsel ? 1'b1 : B;

    // Input inversion networks from the DSCH schematic.
    assign b_n = ~b_pre;
    assign fB  = binv ? b_n : b_pre;
    assign fA  = ainv ? ~A : A;

    // Function generation.
    assign x       = fA ^ fB;
    assign nand_ab = ~(fA & fB);
    assign nor_ab  = ~(fA | fB);

    // Exact mux structure from the schematic:
    // s1=0 -> XOR path (s0 is intentionally irrelevant)
    // s1=1 -> s0=0 NAND, s0=1 NOR
    assign logic_selected    = s0 ? nor_ab : nand_ab;
    assign function_selected = s1 ? logic_selected : x;

    // Output inversion.
    assign selected_n = ~function_selected;
    assign Output     = oinv ? selected_n : function_selected;

endmodule
