module branch_unit #(
    parameter
        WIDTH = 32
) (
    input               clk, rst, en,
    input   [WIDTH-1:0] data_in_1, data_in_2,

    output  reg [1:0]   branch
);
    // add comparator
    // add branch target adder (branch target = PC + imm)


endmodule