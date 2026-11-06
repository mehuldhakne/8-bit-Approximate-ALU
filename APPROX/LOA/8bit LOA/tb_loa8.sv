`timescale 1ns/1ps

module tb_loa8;

    import loa_opcode_pkg::*;

    logic [7:0] A;
    logic [7:0] B;
    alu_op_e    op;

    logic [7:0] result;
    logic       zero_flag;
    logic       sign_flag;
    logic       overflow_flag;
    logic       carry_flag;
    logic       equal_flag;

    loa8_top dut (
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

    function automatic string op_name(input alu_op_e operation);
        case (operation)
            OP_ADD:  op_name = "OP_ADD";
            OP_SUB:  op_name = "OP_SUB";
            OP_NOT:  op_name = "OP_NOT";
            OP_XOR:  op_name = "OP_XOR";
            OP_XNOR: op_name = "OP_XNOR";
            OP_NAND: op_name = "OP_NAND";
            OP_AND:  op_name = "OP_AND";
            OP_NOR:  op_name = "OP_NOR";
            OP_OR:   op_name = "OP_OR";
            default: op_name = "UNKNOWN";
        endcase
    endfunction

    // Reference result is printed only to make exact-vs-LOA comparison easy.
    // The DUT remains the LOA implementation; this is not used to drive it.
    function automatic logic [7:0] exact_reference(
        input logic [7:0] a,
        input logic [7:0] b,
        input alu_op_e operation
    );
        case (operation)
            OP_ADD:  exact_reference = a + b;
            OP_SUB:  exact_reference = a - b;
            OP_NOT:  exact_reference = ~a;
            OP_XOR:  exact_reference = a ^ b;
            OP_XNOR: exact_reference = ~(a ^ b);
            OP_NAND: exact_reference = ~(a & b);
            OP_AND:  exact_reference = a & b;
            OP_NOR:  exact_reference = ~(a | b);
            OP_OR:   exact_reference = a | b;
            default: exact_reference = 8'h00;
        endcase
    endfunction

    task automatic perform_operation(input alu_op_e operation);
        logic [7:0] ref_result;
        integer error_value;
        begin
            op = operation;
            #10;

            ref_result  = exact_reference(A, B, operation);
            error_value = result - ref_result;

            $display(
                "A=%02h | B=%02h | %-7s | LOA=%02h | EXACT=%02h | ERROR=%0d | C/B=%b | Z=%b | S=%b | OV=%b | EQ=%b",
                A,
                B,
                op_name(operation),
                result,
                ref_result,
                error_value,
                carry_flag,
                zero_flag,
                sign_flag,
                overflow_flag,
                equal_flag
            );
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
            $display("==========================================================================");
            $display("Testing A = %02h (%08b)    B = %02h (%08b)", A, A, B, B);
            $display("==========================================================================");

            // Same nine operations as the accurate 8-bit ALU testbench.
            perform_operation(OP_ADD);
            perform_operation(OP_SUB);
            perform_operation(OP_NOT);
            perform_operation(OP_XOR);
            perform_operation(OP_XNOR);
            perform_operation(OP_NAND);
            perform_operation(OP_AND);
            perform_operation(OP_NOR);
            perform_operation(OP_OR);
        end
    endtask

    initial begin
        $display("");
        $display("**********************************************************************");
        $display("                         8-BIT LOA ALU SIMULATION");
        $display("**********************************************************************");

        // SAME seven A/B pairs used by the existing exact 8-bit ALU TB.
        test_input_pair(8'h05, 8'h03);
        test_input_pair(8'hAA, 8'h06);
        test_input_pair(8'hFF, 8'h01);
        test_input_pair(8'h80, 8'h01);
        test_input_pair(8'h80, 8'h80);
        test_input_pair(8'h00, 8'h00);
        test_input_pair(8'hFF, 8'hFF);

        $display("");
        $display("**********************************************************************");
        $display("                         SIMULATION COMPLETED");
        $display("**********************************************************************");

        #10;
        $finish;
    end

endmodule
