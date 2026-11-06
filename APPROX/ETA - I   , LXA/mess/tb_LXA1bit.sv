`timescale 1ns/1ps

module tb_LXA1bit;

    logic B_inv;
    logic B;
    logic A;
    logic O_inv;
    logic A_inv;
    logic S1;
    logic B_set;
    logic S0;

    logic O0;

    logic [7:0] stimulus;
    integer k;

    // Device under test
    LXA1bit DUT (
        .B_inv (B_inv),
        .B     (B),
        .A     (A),
        .O_inv (O_inv),
        .A_inv (A_inv),
        .S1    (S1),
        .B_set (B_set),
        .S0    (S0),
        .O0    (O0)
    );

    initial begin
        $display("-------------------------------------------------------------");
        $display(" LXA 1-bit ALU exhaustive simulation");
        $display("-------------------------------------------------------------");
        $display("B_inv B A O_inv A_inv S1 B_set S0 | O0");
        $display("-------------------------------------------------------------");

        // Test all 2^8 input combinations
        for (k = 0; k < 256; k = k + 1) begin
            stimulus = k;

            {B_inv, B, A, O_inv,
             A_inv, S1, B_set, S0} = stimulus;

            #10;

            $display("  %b     %b %b   %b     %b    %b    %b   %b  | %b",
                     B_inv, B, A, O_inv,
                     A_inv, S1, B_set, S0, O0);
        end

        $display("-------------------------------------------------------------");
        $display("Simulation completed: 256 input combinations tested.");
        $finish;
    end

endmodule
