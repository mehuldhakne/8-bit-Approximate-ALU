
`timescale 1ns/1ps

import alu_pkg::*;

module tb_alu8;

    logic [7:0] A;
    logic [7:0] B;
    alu_op_e op;

    logic [7:0] result;
    logic zero_flag;
    logic sign_flag;
    logic overflow_flag;
    logic carry_flag;
    logic equal_flag;

    integer total_tests = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;

    alu8_top dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag),
        .overflow_flag(overflow_flag),
        .carry_flag(carry_flag),
        .equal_flag(equal_flag)
    );

    // Apply an operation and verify its expected result.
    task automatic check_operation(
        input alu_op_e operation,
        input string operation_name,
        input logic [7:0] expected_result
    );
        begin
            op = operation;
            #10;

            total_tests = total_tests + 1;

            if (result === expected_result) begin
                passed_tests = passed_tests + 1;

                $display(
                    "PASS | A=%02h B=%02h | %-4s | Result=%02h",
                    A, B, operation_name, result
                );
            end
            else begin
                failed_tests = failed_tests + 1;

                $display(
                    "FAIL | A=%02h B=%02h | %-4s | Expected=%02h Got=%02h",
                    A, B, operation_name, expected_result, result
                );
            end

            // Verify basic result flags for every operation.
            if ((zero_flag !== (expected_result == 8'h00)) ||
                (sign_flag !== expected_result[7])) begin

                failed_tests = failed_tests + 1;

                $display(
                    "FLAG FAIL | %s | Z=%b S=%b | Expected Z=%b S=%b",
                    operation_name,
                    zero_flag,
                    sign_flag,
                    (expected_result == 8'h00),
                    expected_result[7]
                );
            end
        end
    endtask

    task automatic test_input_pair(
        input logic [7:0] test_A,
        input logic [7:0] test_B
    );
        begin
            A = test_A;
            B = test_B;

            $display("");
            $display("==============================================");
            $display("Testing A=%02h  B=%02h", A, B);
            $display("==============================================");

            check_operation(OP_ADD,  "ADD",  test_A + test_B);
            check_operation(OP_SUB,  "SUB",  test_A - test_B);
            check_operation(OP_NOT,  "NOT",  ~test_A);
            check_operation(OP_XOR,  "XOR",  test_A ^ test_B);
            check_operation(OP_XNOR, "XNOR", ~(test_A ^ test_B));
            check_operation(OP_NAND, "NAND", ~(test_A & test_B));
            check_operation(OP_AND,  "AND",  test_A & test_B);
            check_operation(OP_NOR,  "NOR",  ~(test_A | test_B));
            check_operation(OP_OR,   "OR",   test_A | test_B);
        end
    endtask

    initial begin
        $display("");
        $display("==============================================");
        $display("          8-BIT ALU TESTBENCH");
        $display("==============================================");

        test_input_pair(8'h05, 8'h03);
        test_input_pair(8'hAA, 8'h06);
        test_input_pair(8'hFF, 8'h01);
        test_input_pair(8'h80, 8'h01);
        test_input_pair(8'h80, 8'h80);
        test_input_pair(8'h00, 8'h00);
        test_input_pair(8'hFF, 8'hFF);

        $display("");
        $display("==============================================");
        $display("             TEST SUMMARY");
        $display("==============================================");
        $display("Total result checks : %0d", total_tests);
        $display("Passed result checks: %0d", passed_tests);
        $display("Failed checks       : %0d", failed_tests);

        if (failed_tests == 0)
            $display("FINAL STATUS: ALL CHECKS PASSED");
        else
            $display("FINAL STATUS: FAILURES DETECTED");

        $display("==============================================");

        #10;
        $finish;
    end

endmodule
