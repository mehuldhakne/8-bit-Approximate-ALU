`timescale 1ns/1ps

module tb_LXA8bit_top;

    logic [7:0] A;
    logic [7:0] B;
    logic [3:0] op;

    logic [7:0] result;
    logic zero_flag;
    logic sign_flag;
    logic overflow_flag;
    logic carry_flag;
    logic equal_flag;

    // Match the opcode encodings in LXA8bit_top.sv
    localparam logic [3:0]
        OP_ADD  = 4'b0000,
        OP_SUB  = 4'b0001,
        OP_NOT  = 4'b0010,
        OP_XOR  = 4'b0011,
        OP_XNOR = 4'b0100,
        OP_NAND = 4'b0101,
        OP_AND  = 4'b0110,
        OP_NOR  = 4'b0111,
        OP_OR   = 4'b1000;

    LXA8bit_top DUT (
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

    task automatic run_case(
        input logic [7:0] a_value,
        input logic [7:0] b_value,
        input string case_name
    );
        begin
            A = a_value;
            B = b_value;
            $display("\n====================================================");
            $display("%s : A = 0x%02h, B = 0x%02h", case_name, a_value, b_value);
            $display("====================================================");

            op = OP_ADD;  #10;
            $display("ADD  op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_SUB;  #10;
            $display("SUB  op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_NOT;  #10;
            $display("NOT  op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_XOR;  #10;
            $display("XOR  op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_XNOR; #10;
            $display("XNOR op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_NAND; #10;
            $display("NAND op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_AND;  #10;
            $display("AND  op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_NOR;  #10;
            $display("NOR  op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);

            op = OP_OR;   #10;
            $display("OR   op=%b result=%02h zero=%b sign=%b carry=%b overflow=%b equal=%b",
                     op, result, zero_flag, sign_flag, carry_flag, overflow_flag, equal_flag);
        end
    endtask

    initial begin
        $display("Starting 8-bit LXA ALU simulation with four A/B test cases.");

        // Case 1: small positive values
        run_case(8'h05, 8'h03, "CASE 1 - small values");

        // Case 2: mixed bit pattern
        run_case(8'hAA, 8'h06, "CASE 2 - mixed pattern");

        // Case 3: maximum unsigned value plus one
        run_case(8'hFF, 8'h01, "CASE 3 - carry boundary");

        // Case 4: high-bit / signed-boundary pattern
        run_case(8'h80, 8'h80, "CASE 4 - high-bit pattern");

        $display("\nSimulation completed.");
        $finish;
    end

endmodule
