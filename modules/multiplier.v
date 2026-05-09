`timescale 1ns/1ps

// a 16.16 multiplier using DSP slices
// -----------------------------------------------
// RESOURCE CONSUMPTION
//  DSP = 4
//  LUT = 31
//   FF = 18
// BRAM = 0
// URAM = 0
// -----------------------------------------------
module multiplier (
    input  wire clk,
    input  wire [31:0] a, // 16.16 fixed point
    input  wire [31:0] b, // 16.16 fixed point
    output reg  [31:0] result // 16.16 fixed point
);

    wire [63:0] product;

    assign product = $signed(a) * $signed(b);

    always @(posedge clk) begin
        // take the middle 32 bits for 16.16 fixed point result
        result <= product[47:16]; 
    end

endmodule
