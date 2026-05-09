`timescale 1ns/1ps

module tb_divider;
    
    reg clk, rst;
    reg [31:0] a, b;
    wire [31:0] result;
    wire resReady;

    divider uut(
        .a(a), .b(b),
        .clk(clk), .rst(rst),
        .result(result),
        .resReady(resReady)
    );

    initial begin
        clk = 0;
        forever #5 clk <= ~clk;
    end

    initial begin
        rst = 1;
        #10;
        // 10.0 / 1.0 = 10.0
        a = 32'h0003_0000; // 1.0 in 16.16
        b = 32'h0004_0000; // 1.0 in 16.16
        #10;
        rst=0;
        #400;
    end

endmodule