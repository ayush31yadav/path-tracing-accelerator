`timescale 1ns/1ps

module mux2 #(
    parameter N = 32
) (
    input  wire [N-1:0] d0, d1,
    input  wire         sel,
    output reg  [N-1:0] Y
);

    always @(*) begin
        case (sel)
            1'b0 : Y <= d0;
            1'b1 : Y <= d1;
        endcase
    end

endmodule