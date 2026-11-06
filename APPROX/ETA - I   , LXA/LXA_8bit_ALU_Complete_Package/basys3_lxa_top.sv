`timescale 1ns / 1ps
import alu_pkg::*;

module basys3_lxa_top (
    input  logic        clk,        // Onboard 100MHz clock (Pin W5)
    input  logic [15:0] sw,         // sw[7:0] = A, sw[15:8] = B
    input  logic        btnC,       // Push button Center -> ADD
    input  logic        btnU,       // Push button Up     -> SUB
    input  logic        btnL,       // Push button Left   -> NOT
    input  logic        btnR,       // Push button Right  -> XOR
    input  logic        btnD,       // Push button Down   -> NAND
    output logic [15:0] led,        // Feedback LEDs for switches
    output logic [6:0]  seg,        // 7-segment display cathodes (active low)
    output logic        dp,         // Decimal point
    output logic [3:0]  an          // 7-segment display anodes (active low)
);

    // Direct LED Monitoring
    assign led = sw;

    // Decode Push Buttons to ALU Opcode
    alu_op_e current_op;
    
    always_comb begin
        if      (btnC) current_op = OP_ADD;
        else if (btnU) current_op = OP_SUB;
        else if (btnL) current_op = OP_NOT;
        else if (btnR) current_op = OP_XOR;
        else if (btnD) current_op = OP_NAND;
        else           current_op = OP_ADD;
    end

    // Instantiate 8-bit LXA ALU
    logic [7:0] alu_result;
    logic       zero_flag, sign_flag, overflow_flag, carry_flag, equal_flag;

    lxa_8bit_alu alu_inst (
        .A(sw[7:0]),
        .B(sw[15:8]),
        .op(current_op),
        .result(alu_result),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag),
        .overflow_flag(overflow_flag),
        .carry_flag(carry_flag),
        .equal_flag(equal_flag)
    );

    // Hex 7-Segment Controller
    logic [3:0]  hex_digit;
    logic [19:0] refresh_counter = 0;
    logic [1:0]  active_digit;

    always_ff @(posedge clk) begin
        refresh_counter <= refresh_counter + 1'b1;
    end

    assign active_digit = refresh_counter[19:18];

    always_comb begin
        case (active_digit)
            2'b00: begin
                an = 4'b1110;               // AN0 Active (LSB Hex)
                hex_digit = alu_result[3:0];
            end
            2'b01: begin
                an = 4'b1101;               // AN1 Active (MSB Hex)
                hex_digit = alu_result[7:4];
            end
            2'b10: begin
                an = 4'b1011;               // AN2 Off
                hex_digit = 4'h0;
            end
            2'b11: begin
                an = 4'b0111;               // AN3 Off
                hex_digit = 4'h0;
            end
        endcase
    end

    // Hex-to-7Segment Decoder
    always_comb begin
        case (hex_digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0100010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end

    assign dp = 1'b1;

endmodule
