




    typedef enum logic [3:0] {
        OP_ADD  = 4'b0000,
        OP_SUB  = 4'b0001,
        OP_NOT  = 4'b0010,
        OP_XOR  = 4'b0011,
        OP_XNOR = 4'b0100,
        OP_NAND = 4'b0101,
        OP_AND  = 4'b0110,
        OP_NOR  = 4'b0111,
        OP_OR   = 4'b1000
    } alu_op_e;



module basys3_alu_top(
    input  logic        CLK100MHZ,

    input  logic [15:0] sw,
    output logic [15:0] led,

    input  logic        btnC,
    input  logic        btnU,
    input  logic        btnL,
    input  logic        btnR,
    input  logic        btnD,

    output logic [6:0]  seg,
    output logic        dp,
    output logic [3:0]  an
);

    logic [7:0] alu_result;
    logic [3:0] opcode;

    logic zero_flag;
    logic sign_flag;
    logic overflow_flag;
    logic carry_flag;
    logic equal_flag;

    logic [15:0] display_value;
    logic [3:0] display_nibble;

    // LEDs directly mirror all 16 slide switches.
    assign led = sw;

    // Button priority:
    // Center > Up > Left > Right > Down.
    // No button pressed: display 00.
    always_comb begin
        opcode = 4'b1111;

        if (btnC)
            opcode = OP_ADD;
        else if (btnU)
            opcode = OP_SUB;
        else if (btnL)
            opcode = OP_NOT;
        else if (btnR)
            opcode = OP_XOR;
        else if (btnD)
            opcode = OP_NAND;
    end

    // Connect the existing ALU.
    alu8_top u_alu (
        .A(sw[7:0]),
        .B(sw[15:8]),
        .op(opcode),
        .result(alu_result),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag),
        .overflow_flag(overflow_flag),
        .carry_flag(carry_flag),
        .equal_flag(equal_flag)
    );

    // Show the result as two hexadecimal digits, with two leading zeros.
    assign display_value = {8'h00, alu_result};

    // Select one digit for a simple static display.
    // NOTE: This placeholder displays one digit only; see the
    // multiplexing note below for the complete four-digit display.
    always_comb begin
        an = 4'b1110;
        dp = 1'b1;
        display_nibble = display_value[3:0];

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
