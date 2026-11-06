`timescale 1ns/1ps

// ============================================================================
// 1-BIT ACCURATE ALU TESTBENCH
// ============================================================================
// Purpose:
//   Same stimulus structure as the LOA 1-bit testbench so that the accurate
//   and approximate 1-bit ALUs can be compared directly.
//
// DUT:
//   alu_bitslice
//
// Important:
//   HALF_ADDER = 0 is used here because this testbench checks the general
//   accurate 1-bit slice with Cin participating in the SUM path.
//
// Operation/control mapping retained from the project:
//
//   OP_ADD   : A_inv=0, B_inv=0, Bset=0, S1=0, S0=0, O_inv=0
//              -> sum = A ^ B ^ Cin
//
//   OP_SUB   : A_inv=0, B_inv=1, Bset=0, S1=0, S0=0, O_inv=1
//              -> result = ~(A ^ ~B ^ Cin)
//
//   OP_NOT   : A_inv=0, Bset=1, S1=0, S0=1, O_inv=0
//              -> A ^ 1 = ~A
//
//   OP_XOR   : A_inv=0, B_inv=0, Bset=0, S1=0, S0=1, O_inv=0
//   OP_XNOR  : same as XOR, but O_inv=1
//   OP_NAND  : A_inv=0, B_inv=0, Bset=0, S1=1, S0=0, O_inv=0
//   OP_AND   : same as NAND, but O_inv=1
//   OP_NOR   : A_inv=0, B_inv=0, Bset=0, S1=1, S0=1, O_inv=0
//   OP_OR    : same as NOR, but O_inv=1
//
// These are the same control conditions used in the earlier ALU project.
// ============================================================================

module tb_alu_bitslice_accurate;

    logic A;
    logic B;
    logic Cin;

    logic A_inv;
    logic B_inv;
    logic O_inv;
    logic Bset;

    logic S1;
    logic S0;

    logic out3;
    logic cout;
    logic xor1_tap;

    // ------------------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------------------
    alu_bitslice #(
        .HALF_ADDER(1'b0)
    ) dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .A_inv(A_inv),
        .B_inv(B_inv),
        .O_inv(O_inv),
        .Bset(Bset),
        .S1(S1),
        .S0(S0),
        .out3(out3),
        .cout(cout),
        .xor1_tap(xor1_tap)
    );

    // ------------------------------------------------------------------------
    // Common stimulus task
    // ------------------------------------------------------------------------
    task automatic apply_case(
        input logic tA,
        input logic tB,
        input logic tCin,
        input logic tA_inv,
        input logic tB_inv,
        input logic tBset,
        input logic tS1,
        input logic tS0,
        input logic tO_inv,
        input string op_name
    );
        begin
            A     = tA;
            B     = tB;
            Cin   = tCin;
            A_inv = tA_inv;
            B_inv = tB_inv;
            Bset  = tBset;
            S1    = tS1;
            S0    = tS0;
            O_inv = tO_inv;

            #10;

            $display(
                "%-18s | A=%b B=%b Cin=%b | Ainv=%b Binv=%b Bset=%b | S1S0=%b%b Oinv=%b | OUT=%b COUT=%b XOR=%b",
                op_name,
                A, B, Cin,
                A_inv, B_inv, Bset,
                S1, S0, O_inv,
                out3, cout, xor1_tap
            );
        end
    endtask

    initial begin
        $display("");
        $display("============================================================================");
        $display("                    1-BIT ACCURATE ALU SIMULATION");
        $display("============================================================================");

        // ====================================================================
        // ADD
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 0,0,0, "OP_ADD  0+0+0");
        apply_case(0,1,0, 0,0,0, 0,0,0, "OP_ADD  0+1+0");
        apply_case(1,0,0, 0,0,0, 0,0,0, "OP_ADD  1+0+0");
        apply_case(1,1,0, 0,0,0, 0,0,0, "OP_ADD  1+1+0");
        apply_case(0,0,1, 0,0,0, 0,0,0, "OP_ADD  0+0+1");
        apply_case(0,1,1, 0,0,0, 0,0,0, "OP_ADD  0+1+1");
        apply_case(1,0,1, 0,0,0, 0,0,0, "OP_ADD  1+0+1");
        apply_case(1,1,1, 0,0,0, 0,0,0, "OP_ADD  1+1+1");

        // ====================================================================
        // SUB
        // ====================================================================
        apply_case(0,0,1, 0,1,0, 0,0,1, "OP_SUB  0-0");
        apply_case(0,1,1, 0,1,0, 0,0,1, "OP_SUB  0-1");
        apply_case(1,0,1, 0,1,0, 0,0,1, "OP_SUB  1-0");
        apply_case(1,1,1, 0,1,0, 0,0,1, "OP_SUB  1-1");

        // ====================================================================
        // XOR
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 0,1,0, "OP_XOR   0,0");
        apply_case(0,1,0, 0,0,0, 0,1,0, "OP_XOR   0,1");
        apply_case(1,0,0, 0,0,0, 0,1,0, "OP_XOR   1,0");
        apply_case(1,1,0, 0,0,0, 0,1,0, "OP_XOR   1,1");

        // ====================================================================
        // XNOR
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 0,1,1, "OP_XNOR  0,0");
        apply_case(0,1,0, 0,0,0, 0,1,1, "OP_XNOR  0,1");
        apply_case(1,0,0, 0,0,0, 0,1,1, "OP_XNOR  1,0");
        apply_case(1,1,0, 0,0,0, 0,1,1, "OP_XNOR  1,1");

        // ====================================================================
        // NOT A
        // ====================================================================
        apply_case(0,0,0, 0,0,1, 0,1,0, "OP_NOT   A=0");
        apply_case(1,0,0, 0,0,1, 0,1,0, "OP_NOT   A=1");

        // ====================================================================
        // NAND
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 1,0,0, "OP_NAND  0,0");
        apply_case(0,1,0, 0,0,0, 1,0,0, "OP_NAND  0,1");
        apply_case(1,0,0, 0,0,0, 1,0,0, "OP_NAND  1,0");
        apply_case(1,1,0, 0,0,0, 1,0,0, "OP_NAND  1,1");

        // ====================================================================
        // AND
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 1,0,1, "OP_AND   0,0");
        apply_case(0,1,0, 0,0,0, 1,0,1, "OP_AND   0,1");
        apply_case(1,0,0, 0,0,0, 1,0,1, "OP_AND   1,0");
        apply_case(1,1,0, 0,0,0, 1,0,1, "OP_AND   1,1");

        // ====================================================================
        // NOR
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 1,1,0, "OP_NOR   0,0");
        apply_case(0,1,0, 0,0,0, 1,1,0, "OP_NOR   0,1");
        apply_case(1,0,0, 0,0,0, 1,1,0, "OP_NOR   1,0");
        apply_case(1,1,0, 0,0,0, 1,1,0, "OP_NOR   1,1");

        // ====================================================================
        // OR
        // ====================================================================
        apply_case(0,0,0, 0,0,0, 1,1,1, "OP_OR    0,0");
        apply_case(0,1,0, 0,0,0, 1,1,1, "OP_OR    0,1");
        apply_case(1,0,0, 0,0,0, 1,1,1, "OP_OR    1,0");
        apply_case(1,1,0, 0,0,0, 1,1,1, "OP_OR    1,1");

        $display("");
        $display("============================================================================");
        $display("                       SIMULATION COMPLETE");
        $display("============================================================================");

        #10;
        $finish;
    end

endmodule
