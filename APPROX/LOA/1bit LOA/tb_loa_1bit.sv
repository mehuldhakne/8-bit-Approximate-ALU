`timescale 1ns/1ps

// ============================================================================
// 1-bit LOA ALU verification
//
// The stimulus below uses exactly the same A/B/Cin/control combinations as
// the existing accurate 1-bit ALU testbench, so the two simulations can be
// compared directly.
// ============================================================================

module tb_loa_1bit;

    logic A, B, Cin;
    logic A_inv, B_inv, B_set;
    logic S1, S0, O_inv;
    logic Result, Cout;

    loa_1bit dut (
        .A(A), .B(B), .Cin(Cin),
        .A_inv(A_inv), .B_inv(B_inv), .B_set(B_set),
        .S1(S1), .S0(S0), .O_inv(O_inv),
        .Result(Result), .Cout(Cout), .XorTap()
    );

    task automatic apply_case(
        input logic tA,
        input logic tB,
        input logic tCin,
        input logic tAinv,
        input logic tBinv,
        input logic tBset,
        input logic tS1,
        input logic tS0,
        input logic tOinv,
        input string op_name
    );
        begin
            A      = tA;
            B      = tB;
            Cin    = tCin;
            A_inv  = tAinv;
            B_inv  = tBinv;
            B_set  = tBset;
            S1     = tS1;
            S0     = tS0;
            O_inv  = tOinv;

            #10;

            $display(
                "%-16s | A=%b B=%b Cin=%b | Result=%b Cout=%b",
                op_name, A, B, Cin, Result, Cout
            );
        end
    endtask

    initial begin
        $display("==============================================================");
        $display("                 1-BIT LOA ALU SIMULATION");
        $display("==============================================================");

        // ADD: SAME cases as accurate 1-bit ALU
        apply_case(0,0,0, 0,0,0, 0,0,0, "ADD 0+0+0");
        apply_case(0,1,0, 0,0,0, 0,0,0, "ADD 0+1+0");
        apply_case(1,0,0, 0,0,0, 0,0,0, "ADD 1+0+0");
        apply_case(1,1,0, 0,0,0, 0,0,0, "ADD 1+1+0");
        apply_case(0,0,1, 0,0,0, 0,0,0, "ADD 0+0+1");
        apply_case(0,1,1, 0,0,0, 0,0,0, "ADD 0+1+1");
        apply_case(1,0,1, 0,0,0, 0,0,0, "ADD 1+0+1");
        apply_case(1,1,1, 0,0,0, 0,0,0, "ADD 1+1+1");

        // SUB: SAME cases as accurate 1-bit ALU
        apply_case(0,0,1, 0,1,0, 0,0,1, "SUB 0-0");
        apply_case(0,1,1, 0,1,0, 0,0,1, "SUB 0-1");
        apply_case(1,0,1, 0,1,0, 0,0,1, "SUB 1-0");
        apply_case(1,1,1, 0,1,0, 0,0,1, "SUB 1-1");

        // XOR / XNOR
        apply_case(0,0,0, 0,0,0, 0,1,0, "XOR 0,0");
        apply_case(0,1,0, 0,0,0, 0,1,0, "XOR 0,1");
        apply_case(1,0,0, 0,0,0, 0,1,0, "XOR 1,0");
        apply_case(1,1,0, 0,0,0, 0,1,0, "XOR 1,1");

        apply_case(0,0,0, 0,0,0, 0,1,1, "XNOR 0,0");
        apply_case(0,1,0, 0,0,0, 0,1,1, "XNOR 0,1");
        apply_case(1,0,0, 0,0,0, 0,1,1, "XNOR 1,0");
        apply_case(1,1,0, 0,0,0, 0,1,1, "XNOR 1,1");

        // NOT A
        apply_case(0,0,0, 0,0,1, 0,1,0, "NOT A (A=0)");
        apply_case(1,0,0, 0,0,1, 0,1,0, "NOT A (A=1)");

        // NAND / AND
        apply_case(0,0,0, 0,0,0, 1,0,0, "NAND 0,0");
        apply_case(0,1,0, 0,0,0, 1,0,0, "NAND 0,1");
        apply_case(1,0,0, 0,0,0, 1,0,0, "NAND 1,0");
        apply_case(1,1,0, 0,0,0, 1,0,0, "NAND 1,1");

        apply_case(0,0,0, 0,0,0, 1,0,1, "AND 0,0");
        apply_case(0,1,0, 0,0,0, 1,0,1, "AND 0,1");
        apply_case(1,0,0, 0,0,0, 1,0,1, "AND 1,0");
        apply_case(1,1,0, 0,0,0, 1,0,1, "AND 1,1");

        // NOR / OR
        apply_case(0,0,0, 0,0,0, 1,1,0, "NOR 0,0");
        apply_case(0,1,0, 0,0,0, 1,1,0, "NOR 0,1");
        apply_case(1,0,0, 0,0,0, 1,1,0, "NOR 1,0");
        apply_case(1,1,0, 0,0,0, 1,1,0, "NOR 1,1");

        apply_case(0,0,0, 0,0,0, 1,1,1, "OR 0,0");
        apply_case(0,1,0, 0,0,0, 1,1,1, "OR 0,1");
        apply_case(1,0,0, 0,0,0, 1,1,1, "OR 1,0");
        apply_case(1,1,0, 0,0,0, 1,1,1, "OR 1,1");

        $display("==============================================================");
        $display("                 1-BIT LOA SIMULATION END");
        $display("==============================================================");
        #10;
        $finish;
    end

endmodule
