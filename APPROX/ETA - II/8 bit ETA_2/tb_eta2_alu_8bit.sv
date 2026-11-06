`timescale 1ns / 1ps

module tb_eta2_alu_8bit;

    import alu_pkg::*;

    logic [7:0] A;
    logic [7:0] B;
    alu_pkg::alu_op_e op;

    logic [7:0] Y;
    logic       Cout;
    logic       zero_flag;
    logic       sign_flag;
    logic       overflow_flag;
    logic       carry_flag;
    logic       equal_flag;

    // DUT: ETA-2 approximate ALU with status flags.
    eta2_alu_8bit dut (
        .A(A),
        .B(B),
        .op(op),
        .Y(Y),
        .Cout(Cout),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag),
        .overflow_flag(overflow_flag),
        .carry_flag(carry_flag),
        .equal_flag(equal_flag)
    );

    function automatic string op_name(input alu_pkg::alu_op_e operation);
        case (operation)
            OP_ADD:  op_name = "ADD";
            OP_SUB:  op_name = "SUB";
            OP_NOT:  op_name = "NOT";
            OP_XOR:  op_name = "XOR";
            OP_XNOR: op_name = "XNOR";
            OP_NAND: op_name = "NAND";
            OP_AND:  op_name = "AND";
            OP_NOR:  op_name = "NOR";
            OP_OR:   op_name = "OR";
            default: op_name = "UNKNOWN";
        endcase
    endfunction

    task automatic run_operation(
        input alu_pkg::alu_op_e operation,
        input logic [7:0] test_A,
        input logic [7:0] test_B
    );
        begin
            op = operation;
            A  = test_A;
            B  = test_B;
            #10;
            $display("t=%0t op=%s A=%02h B=%02h Y=%02h Cout=%b Z=%b S=%b OV=%b C=%b EQ=%b",
                     $time, op_name(op), A, B, Y, Cout,
                     zero_flag, sign_flag, overflow_flag, carry_flag, equal_flag);
        end
    endtask

    task automatic run_all_ops(input logic [7:0] test_A, input logic [7:0] test_B);
        begin
            run_operation(OP_ADD,  test_A, test_B);
            run_operation(OP_SUB,  test_A, test_B);
            run_operation(OP_NOT,  test_A, test_B);
            run_operation(OP_XOR,  test_A, test_B);
            run_operation(OP_XNOR, test_A, test_B);
            run_operation(OP_NAND, test_A, test_B);
            run_operation(OP_AND,  test_A, test_B);
            run_operation(OP_NOR,  test_A, test_B);
            run_operation(OP_OR,   test_A, test_B);
        end
    endtask

    initial begin
        // Initialize inputs so all waveform signals start in a known state.
        A = 8'h00;
        B = 8'h00;
        op = OP_ADD;
        #10;

        $display("===============================================================");
        $display("           8-BIT ETA-2 ALU WITH STATUS FLAGS");
        $display("===============================================================");
        $display("time op   A    B    Y    Cout Z S OV C EQ");

        // Cover ordinary arithmetic, overflow/sign boundaries, zero result,
        // equal operands, and varied logic-operation patterns.
        run_all_ops(8'h05, 8'h03);
        run_all_ops(8'hAA, 8'h06);
        run_all_ops(8'hFF, 8'h01);
        run_all_ops(8'h80, 8'h01);
        run_all_ops(8'h80, 8'h80);
        run_all_ops(8'h00, 8'h00);
        run_all_ops(8'hFF, 8'hFF);
        run_all_ops(8'h7F, 8'h01);
        run_all_ops(8'h10, 8'h10);

        $display("===============================================================");
        $display("Simulation completed.");
        #10;
        $finish;
    end

endmodule
