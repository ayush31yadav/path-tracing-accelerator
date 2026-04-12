`timescale 1ns/1ps

module tb_multiplier;
    
    reg clk;
    reg [31:0] a, b;
    wire [31:0] result;

    multiplier uut (
        .clk(clk),
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk <= ~clk;
    end

    initial begin
        #10;
        // 1.0 * 1.0 = 1.0
        a = 32'h00010000; // 1.0 in 16.16
        b = 32'h00010000; // 1.0 in 16.16
        #10;
        $display("Test 1 (in decimal) : %f * %f = %f (expected: 1.0)", $itor($signed(a))/65536.0, $itor($signed(b))/65536.0, $itor($signed(result))/65536.0);
        // 2.0 * 3.0 = 6.0
        a = 32'h00020000; // 2.0 in 16.16
        b = 32'h00030000; // 3.0 in 16.16
        #10;
        $display("Test 2 (in decimal) : %f * %f = %f (expected: 6.0)", $itor($signed(a))/65536.0, $itor($signed(b))/65536.0, $itor($signed(result))/65536.0);
        // -2.0 * 0.5 = -1.0
        a = 32'hFFFE0000; // -2.0 in 16.16
        b = 32'h00008000; // 0.5 in 16.16
        #10;
        $display("Test 3 (in decimal) : %f * %f = %f (expected: -1.0)", $itor($signed(a))/65536.0, $itor($signed(b))/65536.0, $itor($signed(result))/65536.0);
        $finish;
    end

endmodule