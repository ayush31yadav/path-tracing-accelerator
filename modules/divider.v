`timescale 1ns/1ps

// this module performs multi-cycle division, it takes 32 cycles for 16.16 bit division
// performs A / B, after asserting the values rst should be asserted for atleast 1 cycles
// A is latched inside a internal register so after reset it can be changed safely however B
// must be kept asserted for th entire duration
// when the result is calculated "resReady" is asserted for 1 cycle, data must be picked up at that very cycle
// to avoid wrong values
// works with POSITIVE VALUES only
// -----------------------------------------------
// RESOURCE CONSUMPTION
//  DSP = 0
//  LUT = 70
//   FF = 69
// BRAM = 0
// URAM = 0
// -----------------------------------------------
module divider(
    input  wire [31:0] a, b,
    input  wire        clk, rst,
    output wire [31:0] result,
    output wire        resReady
);

    // timer circuit
    wire [4:0] interconnects;
    wire ands [4:0];
    
    dFF #(.N(1)) resReady_delay (
        .D(ands[4]),
        .clk(clk), .rst(1'b0),
        .Y(resReady)
    );

    generate
        for (genvar i = 0; i < 5; i = i + 1) begin
            if (i == 0) begin
                dFF #(.N(1)) t_ff (
                    .D(~interconnects[i]),
                    .clk(clk), .rst(rst),
                    .Y(interconnects[i])
                );
                assign ands[i] = interconnects[i];
            end else begin
                dFF #(.N(1)) t_ff (
                    .D(interconnects[i] ^ ands[i-1]),
                    .clk(clk), .rst(rst),
                    .Y(interconnects[i])
                );
                assign ands[i] = interconnects[i] & ands[i-1];
            end
        end
    endgenerate

    // division circuit

    wire [31:0] dvdnd_in, dvdnd_out;
    wire [31:0] rem_in, rem_out;
    wire [31:0] diff, rem_s;

    dReg #(.N(32)) dvdnd_res (
        .D(dvdnd_in),
        .clk(clk), .write_en(1'b1),
        .Y(dvdnd_out)
    );

    mux2 #(.N(32)) dvdnd_mux (
        .d0({dvdnd_out[30:0], ~diff[31]}), .d1({a[15:0], 16'b0}),
        .sel(rst),
        .Y(dvdnd_in)
    );

    assign result = dvdnd_out;
    wire [31:0] shifted_rem = {rem_out[30:0], dvdnd_out[31]};

    dReg #(.N(32)) rem_res (
        .D(rem_in),
        .clk(clk), .write_en(1'b1),
        .Y(rem_out)
    );

    mux2 #(.N(32)) rem_mux (
        .d0(rem_s), .d1({16'b0, a[31:16]}),
        .sel(rst),
        .Y(rem_in)
    );

    assign diff = shifted_rem - b;

    mux2 #(.N(32)) shift_mux (
        .d0(diff), .d1(shifted_rem),
        .sel(diff[31]),
        .Y(rem_s)
    );

endmodule