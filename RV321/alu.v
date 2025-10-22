module alu #(
    parameter
            WIDTH = 32
) (
    input                   clk, rst, en,
    input   [WIDTH-1:0]     port_A, port_B,
    input   [WIDTH-16:0]    operation,

    output  [WIDTH-1:0]     data_out
);
    
endmodule