`timescale 1ns / 1ps
module basys3_arca_top (
    input logic CLK100MHZ,
    input logic [15:0] sw,
    output logic [15:0] led,
    input logic btnC, btnU, btnL, btnR, btnD,
    output logic [6:0] seg,
    output logic dp,
    output logic [3:0] an
);
    import alu_pkg::*;
    logic [7:0] arca_result, display_result;
    alu_op_e op;
    logic op_selected;
    logic zero_flag, sign_flag, overflow_flag, carry_flag, equal_flag;

    assign led = sw;

    // Priority: Center=ADD > Up=SUB > Left=NOT > Right=XOR > Down=NAND.
    always_comb begin
        op = OP_ADD;
        op_selected = 1'b0;
        if      (btnC) begin op = OP_ADD;  op_selected = 1'b1; end
        else if (btnU) begin op = OP_SUB;  op_selected = 1'b1; end
        else if (btnL) begin op = OP_NOT;  op_selected = 1'b1; end
        else if (btnR) begin op = OP_XOR;  op_selected = 1'b1; end
        else if (btnD) begin op = OP_NAND; op_selected = 1'b1; end
    end

    arca_8bit_alu u_arca (
        .A(sw[7:0]), .B(sw[15:8]), .op(op), .result(arca_result),
        .zero_flag(zero_flag), .sign_flag(sign_flag),
        .overflow_flag(overflow_flag), .carry_flag(carry_flag),
        .equal_flag(equal_flag)
    );

    assign display_result = op_selected ? arca_result : 8'h00;

    logic [19:0] refresh_counter = '0;
    logic [3:0] display_nibble;
    logic [1:0] active_digit;

    always_ff @(posedge CLK100MHZ)
        refresh_counter <= refresh_counter + 1'b1;

    always_comb begin
        an = 4'b1111;
        dp = 1'b1;
        display_nibble = 4'h0;
        active_digit = refresh_counter[19:18];
        case (active_digit)
            2'd0: begin an = 4'b1110; display_nibble = display_result[3:0]; end
            2'd1: begin an = 4'b1101; display_nibble = display_result[7:4]; end
            default: begin an = 4'b1111; display_nibble = 4'h0; end
        endcase
        // Active-low seven-segment codes; seg[0]=CA through seg[6]=CG.
        case (display_nibble)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
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
endmodule
